/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
 * # Copyright (c) 2016 Alexey Knyazev
 * #
 * # Licensed under the Apache License, Version 2.0 (the "License");
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an "AS IS" BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

library gltf.cmd_line;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';
import 'package:gltf/src/utils.dart';
import 'package:isolate/load_balancer.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:path/path.dart' as path;

StringSink outPipe = stdout;
StringSink errPipe = stderr;

class ValidationOptions {
  static const String kWarnings = 'warnings';
  static const String kValidateResources = 'validate-resources';
  static const String kPlainText = 'plain-text';

  final bool validateResources;
  final bool plainText;
  final bool printNonErrors;

  ValidationOptions(
      {this.validateResources: false,
      this.plainText: false,
      this.printNonErrors: false});

  factory ValidationOptions.fromArgs(ArgResults args) => new ValidationOptions(
      validateResources: args[kValidateResources] == true,
      plainText: args[kPlainText] == true,
      printNonErrors: args[kWarnings] == true);
}

class ValidationTask {
  final String filename;
  final ValidationOptions options;

  ValidationTask(this.filename, this.options);
}

Future<Null> run(List<String> args) async {
  const kErrorCode = 1;

  ArgResults argResult;
  final parser = new ArgParser()
    ..addFlag(ValidationOptions.kValidateResources,
        abbr: 'r',
        help: 'Validate contents of embedded and/or '
            'referenced resources (buffers, images).',
        defaultsTo: false)
    ..addFlag(ValidationOptions.kPlainText,
        abbr: 'p',
        help: 'Print issues in plain text form to stderr.',
        defaultsTo: false)
    ..addFlag(ValidationOptions.kWarnings,
        abbr: 'a',
        help: 'Print all issues to plain text output.',
        defaultsTo: false);

  try {
    argResult = parser.parse(args);
  } on FormatException catch (_) {}

  if (argResult?.rest?.length != 1) {
    errPipe
      ..write('glTF 2.0 Validator, version $kGltfValidatorVersion\n')
      ..write('Usage: gltf_validator [<options>] <input>\n\n'
          'Validation report will be written to '
          '`<asset_filename>_report.json`.\n'
          'If <input> is a directory, '
          'validation reports will be recursively created for each glTF asset.\n\n'
          'Validation log will be printed to stderr.\n\n'
          'Shell return code will be non-zero '
          'if at least one error was found.\n')
      ..writeln(parser.usage);
    exitCode = kErrorCode;
    return;
  }

  final input = argResult.rest[0];
  final options = new ValidationOptions.fromArgs(argResult);

  if (FileSystemEntity.isDirectorySync(input)) {
    final balancer = await LoadBalancer.create(
        Platform.numberOfProcessors, IsolateRunner.spawn);

    var activeTasks = 0;
    var foundErrors = false;
    final watch = new Stopwatch()..start();

    final it = new Directory(input).listSync(recursive: true).where((entry) {
      if (entry is File) {
        final ext = path.extension(entry.path);
        return (ext == '.gltf') || (ext == '.glb');
      }
      return false;
    }).iterator;

    void spawn() {
      if (it.moveNext()) {
        ++activeTasks;
        balancer
            .run(_processFile,
                new ValidationTask(it.current.absolute.path, options))
            .then((hasErrors) {
          if (hasErrors) {
            foundErrors = true;
          }
        }).whenComplete(() {
          spawn();
          if (--activeTasks == 0) {
            watch.stop();
            errPipe.write('Elapsed: ${watch.elapsedMilliseconds}ms\n');
            if (foundErrors) {
              exitCode = kErrorCode;
            }
          }
        });
      }
    }

    for (var i = 0; i < balancer.length; ++i) {
      spawn();
    }
  } else if (FileSystemEntity.isFileSync(input)) {
    if (await _processFile(new ValidationTask(input, options))) {
      exitCode = kErrorCode;
    }
  } else {
    errPipe.write('Can not open $input\n');
    exitCode = kErrorCode;
  }
}

Future<bool> _processFile(ValidationTask task) async {
  final file = new File(task.filename);

  final context = new Context();
  final reader =
      new GltfReader.filename(file.openRead(), task.filename, context);

  if (reader == null) {
    final ext = path.extension(task.filename).toLowerCase();
    errPipe.write('Error while loading ${file.path}...\n'
        'Unknown file extension `$ext`.\n');
    return true;
  }

  GltfReaderResult readerResult;
  try {
    readerResult = await reader.read();
  } on FileSystemException catch (e) {
    errPipe.write('Error while loading ${file.path}...\n$e\n');
    return true;
  }

  final validationResult =
      new ValidationResult(new Uri.file(task.filename), context, readerResult);

  if (readerResult?.gltf != null && task.options.validateResources) {
    final resourcesLoader = getFileResourceValidator(
        context, validationResult.absoluteUri, readerResult);
    await resourcesLoader.load();
  }

  final reportPath = '${path.withoutExtension(task.filename)}_report.json';

  // ignore: unawaited_futures
  new File(reportPath).writeAsString(
      const JsonEncoder.withIndent('    ').convert(validationResult.toMap()));

  final errors = validationResult.context.getErrors();
  final warnings = validationResult.context.getWarnings();
  final infos = validationResult.context.getInfos();
  final hints = validationResult.context.getHints();

  final sb = new StringBuffer()
    ..write('Loaded ${file.path}\n'
        'Errors: ${errors.length}, '
        'Warnings: ${warnings.length}, '
        'Infos: ${infos.length}, '
        'Hints: ${hints.length}\n\n');

  if (task.options.plainText) {
    void writeIssues(List<Issue> issues, String title) {
      if (issues.isEmpty) {
        return;
      }
      sb.write('\t$title:\n\t\t${issues[0]}\n');
      for (var i = 1; i < issues.length; i++) {
        sb.write('\t\t${issues[i]}\n');
      }
      sb.write('\n');
    }

    writeIssues(errors, 'Errors');
    if (task.options.printNonErrors) {
      writeIssues(warnings, 'Warnings');
      writeIssues(infos, 'Infos');
      writeIssues(hints, 'Hints');
    }
  }
  errPipe.write(sb.toString());

  return errors.isNotEmpty;
}

ResourcesLoader getFileResourceValidator(
        Context context, Uri absoluteUri, GltfReaderResult readerResult) =>
    new ResourcesLoader(context, readerResult.gltf, externalBytesFetch: (uri) {
      if (uri == null) {
        // GLB-stored buffer
        return readerResult.buffer;
      }
      if (isNonRelativeUri(uri)) {
        return null;
      }
      return new File.fromUri(absoluteUri.resolveUri(uri)).readAsBytes();
    }, externalStreamFetch: (uri) {
      if (isNonRelativeUri(uri)) {
        return null;
      }
      return new File.fromUri(absoluteUri.resolveUri(uri)).openRead();
    });
