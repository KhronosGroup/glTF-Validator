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
import 'package:yaml/yaml.dart';

const int kErrorCode = 1;

StringSink outPipe = stdout;
StringSink errPipe = stderr;

class ValidatorOptions {
  static const String kAllIssues = 'all-issues';
  static const String kValidateResources = 'validate-resources';
  static const String kPlainText = 'plain-text';

  static const String kConfig = 'config';

  final bool validateResources;
  final bool plainText;
  final bool printNonErrors;

  ValidatorOptions(
      {this.validateResources = false,
      this.plainText = false,
      this.printNonErrors = false});

  factory ValidatorOptions.fromArgs(ArgResults args) => new ValidatorOptions(
      validateResources: args[kValidateResources] == true,
      plainText: args[kPlainText] == true,
      printNonErrors: args[kAllIssues] == true);
}

class ValidationTask {
  final String filename;
  final ValidatorOptions validatorOptions;
  final ValidationOptions validationOptions;

  ValidationTask(this.filename, this.validatorOptions, this.validationOptions);
}

ValidationOptions _getValidationOptionsFromYaml(String fileName) {
  const kMaxIssues = 'max-issues';
  const kIgnore = 'ignore';
  const kOverride = 'override';

  void abort(Object e) {
    stderr.write(e);
    exit(kErrorCode);
  }

  String configYaml;
  try {
    configYaml = new File(fileName).readAsStringSync();
  } on FileSystemException catch (e) {
    abort(e);
  }

  const kYamlError = 'Invalid configuration file format:';

  Object yaml;
  try {
    yaml = loadYaml(configYaml);
  } on YamlException catch (e) {
    abort(e);
  }

  var maxIssues = 0;
  List<String> ignoredIssues;
  Map<String, Severity> severityOverrides;

  if (yaml is Map) {
    final Object yamlMaxIssues = yaml[kMaxIssues];
    if (yamlMaxIssues is int && yamlMaxIssues >= 0) {
      maxIssues = yamlMaxIssues;
    } else if (yamlMaxIssues != null) {
      abort("$kYamlError '$kMaxIssues' must be a non-negative integer.");
    }

    final Object yamlIgnoredIssues = yaml[kIgnore];
    if (yamlIgnoredIssues is List) {
      ignoredIssues = new List.generate(yamlIgnoredIssues.length, (i) {
        final Object entry = yamlIgnoredIssues[i];
        if (entry is String) {
          return entry;
        } else {
          abort("$kYamlError each entry in '$kIgnore' must be a string.");
        }
      }, growable: false);
    } else if (yamlIgnoredIssues != null) {
      abort("$kYamlError 'ignored' must be a sequence.");
    }

    final Object yamlSeveritiesMap = yaml[kOverride];
    if (yamlSeveritiesMap is Map) {
      severityOverrides = <String, Severity>{};

      for (final key in yamlSeveritiesMap.keys) {
        final Object value = yamlSeveritiesMap[key];
        if (key is String && value is int && value >= 0 && value <= 3) {
          severityOverrides[key] = Severity.values[value];
        } else {
          abort("$kYamlError each entry in '$kOverride' must "
              'have a string key and an integer value.');
        }
      }
    } else if (yamlSeveritiesMap != null) {
      abort("$kYamlError '$kOverride' must be a map.");
    }

    return new ValidationOptions(
        maxIssues: maxIssues,
        ignoredIssues: ignoredIssues,
        severityOverrides: severityOverrides);
  } else {
    abort('$kYamlError document must be a map.');
  }
  return null;
}

Future<void> run(List<String> args) async {
  ArgResults argResult;
  final parser = new ArgParser()
    ..addFlag(ValidatorOptions.kValidateResources,
        abbr: 'r',
        help: 'Validate contents of embedded and/or '
            'referenced resources (buffers, images).',
        defaultsTo: false)
    ..addFlag(ValidatorOptions.kPlainText,
        abbr: 'p',
        help: 'Print issues in plain text form to stderr.',
        defaultsTo: false)
    ..addFlag(ValidatorOptions.kAllIssues,
        abbr: 'a',
        help: 'Print all issues to plain text output.',
        defaultsTo: false)
    ..addOption(ValidatorOptions.kConfig,
        abbr: 'c',
        help: 'YAML configuration file with validation options. '
            'See docs/config-example.yaml for details.');

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
    return null;
  }

  final input = argResult.rest[0];
  ValidationOptions validationOptions;
  final validatorOptions = new ValidatorOptions.fromArgs(argResult);

  final Object configFile = argResult[ValidatorOptions.kConfig];
  if (configFile is String) {
    validationOptions = _getValidationOptionsFromYaml(configFile);
  }

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
            .run(
                _processFile,
                new ValidationTask(it.current.absolute.path, validatorOptions,
                    validationOptions))
            .then((hasErrors) {
          if (hasErrors) {
            foundErrors = true;
          }
        }).whenComplete(() {
          spawn();
          if (--activeTasks == 0) {
            watch.stop();
            errPipe.write('Elapsed total: ${watch.elapsedMilliseconds}ms\n');
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
    if (await _processFile(
        new ValidationTask(input, validatorOptions, validationOptions))) {
      exitCode = kErrorCode;
    }
  } else {
    errPipe.write('Can not open $input\n');
    exitCode = kErrorCode;
  }
}

Future<bool> _processFile(ValidationTask task) async {
  final watch = new Stopwatch()..start();

  final file = new File(task.filename);

  final opts = task.validatorOptions;
  final context = new Context(options: task.validationOptions);

  final reader =
      new GltfReader.filename(file.openRead(), task.filename, context);

  if (reader == null) {
    final ext = path.extension(task.filename).toLowerCase();
    errPipe.write('Error while loading ${file.path}...\n'
        'Unknown file extension `$ext`.\n');
    watch.stop();
    return true;
  }

  GltfReaderResult readerResult;
  try {
    readerResult = await reader.read();
  } on FileSystemException catch (e) {
    errPipe.write('Error while loading ${file.path}...\n$e\n');
    watch.stop();
    return true;
  }

  final validationResult =
      new ValidationResult(new Uri.file(task.filename), context, readerResult);

  if (readerResult?.gltf != null && opts.validateResources) {
    final resourcesLoader = getFileResourceValidator(
        context, validationResult.absoluteUri, readerResult);
    await resourcesLoader.load();
  }

  watch.stop();

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
        'Hints: ${hints.length}\n'
        'Time: ${watch.elapsedMilliseconds}ms\n\n');

  if (opts.plainText) {
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
    if (opts.printNonErrors) {
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
