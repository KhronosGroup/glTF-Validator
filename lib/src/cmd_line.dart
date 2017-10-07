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
  final bool printWarnings;

  ValidationOptions(
      {this.validateResources: false,
      this.plainText: false,
      this.printWarnings: false});

  factory ValidationOptions.fromArgs(ArgResults args) => new ValidationOptions(
      validateResources: args[kValidateResources] == true,
      plainText: args[kPlainText] == true,
      printWarnings: args[kWarnings] == true);
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
        abbr: 'w',
        help: 'Print warnings to plain text output.',
        defaultsTo: false);

  try {
    argResult = parser.parse(args);
  } on FormatException catch (_) {}

  if (argResult?.rest?.length != 1) {
    errPipe
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
  final result = await _validate(task.filename,
      validateResources: task.options.validateResources);

  if (result == null) {
    return true;
  }

  final reportPath = '${path.withoutExtension(task.filename)}_report.json';

  // ignore: unawaited_futures
  new File(reportPath).writeAsString(
      const JsonEncoder.withIndent('    ').convert(result.toMap()));

  final errors = result.context.errors.toList(growable: false);

  if (task.options.plainText) {
    void writeIssues(List<Issue> issues, String title) {
      if (issues.isNotEmpty) {
        errPipe.write('\t$title:\n\t\t${issues.join('\n\t\t')}\n\n');
      }
    }

    writeIssues(errors, 'Errors');
    if (task.options.printWarnings) {
      writeIssues(result.context.warnings.toList(growable: false), 'Warnings');
    }
  }

  return errors.isNotEmpty;
}

Future<ValidationResult> _validate(String filename,
    {bool validateResources: false}) async {
  final file = new File(filename);

  final context = new Context();
  final reader = new GltfReader.filename(file.openRead(), filename, context);

  if (reader == null) {
    final ext = path.extension(filename).toLowerCase();
    errPipe
      ..write('Error while loading ${file.path}...\n')
      ..write('Unknown file extension `$ext`.\n');
    return null;
  }

  GltfReaderResult readerResult;
  try {
    readerResult = await reader.read();
  } on FileSystemException catch (e) {
    errPipe.write('Error while loading ${file.path}...\n$e\n');
    return null;
  }

  final validationResult =
      new ValidationResult(new Uri.file(filename), context, readerResult);

  if (readerResult?.gltf != null && validateResources) {
    final resourcesLoader = getFileResourceValidator(
        context, validationResult.absoluteUri, readerResult);
    await resourcesLoader.load();
  }
  errPipe.write('Loaded ${file.path}\n'
      'Errors: ${context.errors.length}, '
      'Warnings: ${context.warnings.length}\n\n');

  return validationResult;
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
