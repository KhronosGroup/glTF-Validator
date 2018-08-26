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

// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:gltf/src/errors.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final String _version =
    loadYaml(File('pubspec.yaml').readAsStringSync())['version'];

Future<void> main(List<String> args) => grind(args);

@Task('Generate ISSUES.md')
void issues() {
  final sb = StringBuffer('# glTF 2.0 Validation Issues\n');

  String severityToMdString(Severity severity) =>
      const ['Error', 'Warning', 'Information', 'Hint'][severity.index];

  var total = 0;
  void processErrorClass(Type type) {
    final errorClassMirror = reflectClass(type);
    sb
      ..writeln('## ${errorClassMirror.reflectedType}')
      ..writeln('| Code | Message | Severity |')
      ..writeln('|------|---------|----------|');

    final args = ['`%1`', '`%2`', '`%3`', '`%4`'];
    final argsWithArray = [
      '`%1`',
      ['`%a`', '`%b`', '`%c`'],
      '`%3`',
      '`%4`'
    ];

    final issuesList = errorClassMirror.staticMembers.keys
        .map<Object>((symbol) => errorClassMirror.getField(symbol).reflectee)
        .whereType<IssueType>()
        .toList(growable: false)
          ..sort((a, b) => a.code.compareTo(b.code));

    for (final issueType in issuesList) {
      String message;
      try {
        message = issueType.message(args);
        // ignore: avoid_catching_errors
      } on CastError catch (_) {
        message = issueType.message(argsWithArray);
      }
      sb.writeln('|${issueType.code}|$message|'
          '${severityToMdString(issueType.severity)}|');
    }
    total += issuesList.length;
  }

  processErrorClass(IoError);
  processErrorClass(SchemaError);
  processErrorClass(SemanticError);
  processErrorClass(LinkError);
  processErrorClass(DataError);
  processErrorClass(GlbError);

  File('ISSUES.md').writeAsStringSync(sb.toString(), flush: true);
  log('Total number of issues: $total');
}

const _nodeSource = 'node';
const _binSource = 'bin';
const _webSource = 'web';

@Task('Build Dart source snapshot.')
void snapshot() {
  // Use `release` for setting snapshot kind until
  // https://github.com/dart-lang/build/issues/1127
  _runBuild(_binSource, release: false);
  delete(File(p.join(_getTarget(_binSource), 'gltf_validator.dart')));
}

@Task('Build Dart application snapshot.')
void snapshotApp() {
  _runBuild(_binSource);
}

@Task('Build web drag-n-drop version.')
void web() {
  _runBuild(_webSource);
}

@Task('Build non-minified npm package with preserved call-stacks.')
void npmDebug() {
  _npmBuild(release: false);
}

@Task('Build minified npm package.')
void npmRelease() {
  _npmBuild();
}

final _nodeTarget = _getTarget(_nodeSource);
final _nodeTargetDir = Directory(_nodeTarget);

void _npmBuild({bool release = true}) {
  delete(_nodeTargetDir);
  _runBuild(_nodeSource, release: release);

  const packageJson = 'package.json';
  final Map<String, Object> jsonMap =
      json.decode(File(p.join(_nodeSource, packageJson)).readAsStringSync());
  jsonMap['version'] = _version;

  log('copying updated $packageJson to $_nodeTarget');
  File(p.join(_nodeTarget, packageJson))
      .writeAsStringSync(const JsonEncoder.withIndent('    ').convert(jsonMap));

  copy(File(p.join(_nodeSource, 'index.js')), _nodeTargetDir);
  copy(File(p.join(_nodeSource, 'module.mjs')), _nodeTargetDir);
}

@Depends(issues, npmRelease)
@Task('Build an npm package.')
void npm() {
  copy(File('ISSUES.md'), _nodeTargetDir);
  copy(File('LICENSE'), _nodeTargetDir);
  copy(File('3RD_PARTY'), _nodeTargetDir);
  copy(File(p.join('docs', 'validation.schema.json')), _nodeTargetDir);

  log('Building npm README...');
  copy(File(p.join(_nodeSource, 'README.md')), _nodeTargetDir);
  run(npmExecutable, arguments: ['install'], workingDirectory: _nodeSource);
  run(npmExecutable, arguments: ['run', 'docs'], workingDirectory: _nodeSource);
}

@Depends(npm)
@Task('Publish package to npm.')
void npmPublish() {
  run(npmExecutable, arguments: ['publish', '--loglevel=verbose'], workingDirectory: _nodeTarget);
}

final _args = ['build', '--delete-conflicting-outputs', '--output'];

void _runBuild(String dir, {bool release = true, String defineOption}) {
  final target = _getTarget(dir);
  delete(Directory(target));

  _args.add(_getOutput(dir));

  if (release) {
    _args.add('--release');
  }

  if (defineOption != null) {
    _args..add('--define')..add(defineOption);
  }

  Pub.run('build_runner', arguments: _args);

  delete(File(p.join(target, '.build.manifest')));
  delete(File(p.join(target, '.packages')));
  delete(Directory(p.join(target, 'packages')));
}

String get npmExecutable => Platform.isWindows ? 'npm.cmd' : 'npm';

String _getOutput(String dir) => '$dir:${_getTarget(dir)}';

String _getTarget(String dir) => p.join('build', dir);
