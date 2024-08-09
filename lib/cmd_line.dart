/*
 * # Copyright (c) 2016-2019 The Khronos Group Inc.
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
import 'dart:math';

import 'package:args/args.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';
import 'package:gltf/src/utils.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/load_balancer.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

const int kErrorCode = 1;

StringSink outPipe = stdout;
StringSink errPipe = stderr;

final _cwd = Directory.current.path;

class ValidatorOptions {
  static const String kAll = 'all';
  static const String kValidateResources = 'validate-resources';
  static const String kWriteTimestamp = 'write-timestamp';
  static const String kAbsolutePath = 'absolute-path';
  static const String kMessages = 'messages';
  static const String kStdout = 'stdout';
  static const String kThreads = 'threads';

  static const String kConfig = 'config';

  final bool validateResources;
  final bool writeTimestamp;
  final bool absolutePath;
  final bool messages;
  final bool printAll;
  final bool stdoutReport;
  final int threads;

  ValidatorOptions(
      {this.validateResources = false,
      this.writeTimestamp = false,
      this.absolutePath = false,
      this.messages = false,
      this.printAll = false,
      this.stdoutReport = false,
      this.threads = 0});

  factory ValidatorOptions.fromArgs(ArgResults args) => ValidatorOptions(
      validateResources: args[kValidateResources] == true,
      messages: args[kMessages] == true,
      writeTimestamp: args[kWriteTimestamp] == true,
      absolutePath: args[kAbsolutePath] == true,
      printAll: args[kAll] == true,
      stdoutReport: args[kStdout] == true,
      threads: max(int.tryParse((args[kThreads] ?? '') as String) ?? 0, 0));
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
    configYaml = File(fileName).readAsStringSync();
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
      ignoredIssues = List.generate(yamlIgnoredIssues.length, (i) {
        final Object entry = yamlIgnoredIssues[i];
        if (entry is String) {
          return entry;
        } else {
          abort("$kYamlError each entry in '$kIgnore' must be a string.");
          return null;
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

    return ValidationOptions(
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
  final parser = ArgParser()
    ..addFlag(ValidatorOptions.kStdout,
        abbr: 'o',
        help: 'Print JSON report to stdout instead of writing it to a file. '
            'This option cannot be used with directory input.')
    ..addFlag(ValidatorOptions.kValidateResources,
        abbr: 'r',
        help: 'Validate contents of embedded and/or '
            'referenced resources (buffers, images).',
        defaultsTo: true)
    ..addFlag(ValidatorOptions.kWriteTimestamp,
        abbr: 't',
        help: 'Write UTC timestamp to the validation report.',
        defaultsTo: false)
    ..addFlag(ValidatorOptions.kAbsolutePath,
        abbr: 'p',
        help: 'Write absolute asset path to the validation report.',
        defaultsTo: false)
    ..addFlag(ValidatorOptions.kMessages,
        abbr: 'm',
        help: 'Print issue messages to stderr. '
            'Otherwise, only total number of issues will be printed.',
        defaultsTo: false)
    ..addFlag(ValidatorOptions.kAll,
        abbr: 'a',
        help: 'Print all issue messages to stderr. '
            'Otherwise, only errors will be printed. Implies --messages.',
        defaultsTo: false)
    ..addOption(ValidatorOptions.kConfig,
        abbr: 'c',
        help: 'YAML configuration file with validation options. '
            'See docs/config-example.yaml for details.')
    ..addOption(ValidatorOptions.kThreads,
        abbr: 'h',
        help: 'The number of threads for directory validation. '
            'Set to 0 (default) for auto selection.');

  try {
    argResult = parser.parse(args);
  } on FormatException catch (_) {}

  if (argResult?.rest?.length != 1) {
    errPipe
      ..write('glTF 2.0 Validator, version $kGltfValidatorVersion\n')
      ..write('Supported extensions:\n\t')
      ..write(Context.defaultExtensionNames.join('\n\t'))
      ..write('\n\n')
      ..write('Usage: gltf_validator [<options>] <input>\n\n'
          'Validation report will be written to '
          '`<asset_filename>.report.json`.\n'
          'If <input> is a directory, validation reports will be recursively '
          'created for each *.gltf or *.glb asset.\n\n'
          'Validation log will be printed to stderr.\n\n'
          'Shell return code will be non-zero '
          'if at least one error was found.\n')
      ..writeln(parser.usage);
    exitCode = kErrorCode;
    return;
  }

  final input = p.normalize(p.absolute(argResult.rest[0]));
  ValidationOptions validationOptions;
  final validatorOptions = ValidatorOptions.fromArgs(argResult);

  final Object configFile = argResult[ValidatorOptions.kConfig];
  if (configFile is String) {
    validationOptions = _getValidationOptionsFromYaml(configFile);
  }

  if (FileSystemEntity.isDirectorySync(input) &&
      Directory(input).statSync().type == FileSystemEntityType.directory) {
    if (validatorOptions.stdoutReport) {
      errPipe.write('Directory input cannot be used with '
          '--${ValidatorOptions.kStdout}.\n\n');
      exitCode = kErrorCode;
      return;
    }

    final threads = 0 == validatorOptions.threads
        ? Platform.numberOfProcessors
        : validatorOptions.threads;
    final balancer = await LoadBalancer.create(threads, IsolateRunner.spawn);
    errPipe.write('Using $threads thread(s).\n\n');

    var activeTasks = 0;
    final assetsWithErrors = <String>[];
    final watch = Stopwatch()..start();

    final it = Directory(input).listSync(recursive: true).where((entry) {
      if (entry is File) {
        final ext = p.extension(entry.path);
        return (ext == '.gltf') || (ext == '.glb');
      }
      return false;
    }).iterator;

    void spawn() {
      if (it.moveNext()) {
        ++activeTasks;
        final assetPath = it.current.path;
        balancer
            .run(_processFileZoned,
                ValidationTask(assetPath, validatorOptions, validationOptions))
            .then((hasErrors) {
          if (hasErrors) {
            assetsWithErrors.add(assetPath);
          }
        }).whenComplete(() {
          spawn();
          if (--activeTasks == 0) {
            watch.stop();
            errPipe.write('Elapsed total: ${watch.elapsedMilliseconds}ms\n');
            if (assetsWithErrors.isNotEmpty) {
              errPipe
                ..write('\nAssets with errors:\n')
                ..writeAll(assetsWithErrors.map<String>((a) => '\t$a\n'));
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
    if (await _processFileZoned(
        ValidationTask(input, validatorOptions, validationOptions))) {
      exitCode = kErrorCode;
    }
  } else {
    errPipe.write('$input is neither a file nor a directory.\n');
    exitCode = kErrorCode;
  }
}

Future<bool> _processFileZoned(ValidationTask task) {
  // Run validation task in a separate zone catching
  // all uncaught runtime errors.
  final resultCompleter = Completer<bool>();
  runZonedGuarded(() {
    _processFile(task).then(resultCompleter.complete);
  }, (Object error, StackTrace stackTrace) {
    errPipe.write('${task.filename} '
        'caused an uncaught runtime error:\n$error\n$stackTrace\n');
    resultCompleter.complete(false);
  });
  return resultCompleter.future;
}

Future<bool> _processFile(ValidationTask task) async {
  final file = File(task.filename);
  if (file.statSync().type != FileSystemEntityType.file) {
    errPipe.write('${task.filename} cannot be loaded - check permissions.\n\n');
    return false;
  }

  final opts = task.validatorOptions;
  final context = Context(options: task.validationOptions);

  final reader = GltfReader.filename(file.openRead(), task.filename, context);

  if (reader == null) {
    errPipe
        .write('${task.filename} cannot be loaded - unknown file extension.\n');
    return true;
  }

  final watch = Stopwatch()..start();
  final readerResult = await reader.read();
  watch.stop();
  final validationResult = ValidationResult(
      Uri.file(opts.absolutePath
          ? task.filename
          : p.relative(task.filename, from: _cwd)),
      context,
      readerResult,
      writeTimestamp: opts.writeTimestamp);

  if (readerResult?.gltf != null && opts.validateResources) {
    final resourcesLoader =
        getFileResourceValidator(context, validationResult.uri, readerResult);
    watch.start();
    await resourcesLoader.load();
    watch.stop();
  }

  final errors = validationResult.context.errors.toList(growable: false);
  final warnings = validationResult.context.warnings.toList(growable: false);
  final infos = validationResult.context.infos.toList(growable: false);
  final hints = validationResult.context.hints.toList(growable: false);

  final sb = StringBuffer()
    ..write('${file.path}\n'
        'Errors: ${errors.length}, '
        'Warnings: ${warnings.length}, '
        'Infos: ${infos.length}, '
        'Hints: ${hints.length}\n'
        'Time: ${watch.elapsedMilliseconds}ms\n\n');

  if (opts.messages || opts.printAll) {
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
    if (opts.printAll) {
      writeIssues(warnings, 'Warnings');
      writeIssues(infos, 'Infos');
      writeIssues(hints, 'Hints');
    }
  }
  errPipe.write(sb.toString());

  final reportString =
      const JsonEncoder.withIndent('    ').convert(validationResult.toMap());

  if (task.validatorOptions.stdoutReport) {
    outPipe.writeln(reportString);
  } else {
    await File('${task.filename}.report.json')
        .writeAsString(reportString, flush: true);
  }

  return errors.isNotEmpty;
}

ResourcesLoader getFileResourceValidator(
    Context context, Uri absoluteUri, GltfReaderResult readerResult) {
  // Check file stat to not bother with FileSystem exceptions
  File fileGuarded(Uri uri) {
    final f = File(p.fromUri(absoluteUri.resolveUri(uri)));
    if (f.statSync().type == FileSystemEntityType.file) {
      return f;
    } else {
      throw GltfExternalResourceNotFoundException(uri.toString());
    }
  }

  return ResourcesLoader(context, readerResult.gltf,
      externalBytesFetch: ([uri]) {
    if (uri == null) {
      // GLB-stored buffer
      return readerResult.buffer;
    }
    if (uri.isNonRelative) {
      return null;
    }
    return fileGuarded(uri).readAsBytes();
  }, externalStreamFetch: (uri) {
    if (uri.isNonRelative) {
      return null;
    }
    return fileGuarded(uri).openRead();
  });
}
