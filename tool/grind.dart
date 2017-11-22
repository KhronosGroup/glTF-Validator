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
import 'package:node_preamble/preamble.dart' as preamble;
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final String _version =
    loadYaml(new File('pubspec.yaml').readAsStringSync())['version'];

Future main(List<String> args) => grind(args);

void _replaceVersion() {
  final f = new File('lib/gltf.dart');
  f.writeAsStringSync(
      f.readAsStringSync().replaceAll('GLTF_VALIDATOR_VERSION', _version));
}

void _restoreVersion() {
  final f = new File('lib/gltf.dart');
  f.writeAsStringSync(
      f.readAsStringSync().replaceAll(_version, 'GLTF_VALIDATOR_VERSION'));
}

@Task('Generate ISSUES.md')
void issues() {
  final sb = new StringBuffer('# glTF 2.0 Validation Issues\n');

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

    final issuesList = new List<IssueType>.from(
        errorClassMirror.staticMembers.keys
            .map<Object>(
                (symbol) => errorClassMirror.getField(symbol).reflectee)
            .where((reflectee) => reflectee is IssueType),
        growable: false)
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

  new File('ISSUES.md').writeAsStringSync(sb.toString(), flush: true);
  log('Total number of issues: $total');
}

@Task('Build Dart snapshot.')
void snapshot() {
  _ensureBuild();

  _replaceVersion();
  Dart.run('bin/gltf_validator.dart',
      vmArgs: ['--snapshot=build/gltf_validator.snapshot']);
  _restoreVersion();
}

@Task('Build web drag-n-drop version.')
void web() {
  _replaceVersion();
  Pub.build();
  _restoreVersion();
}

final _dart2jsArgs = [
  '--minify',
  '--no-source-maps',
  '--trust-primitives',
  '--trust-type-annotations'
];

@Task('Build non-minified npm package with source map.')
void npmDebug() {
  _dart2jsArgs
    ..clear()
    ..add('-DGLTF_VALIDATOR_DEBUG=true');
  npmRelease();
}

@Task('Build minified npm package.')
void npmRelease() {
  _ensureBuild();
  final destDir = 'build/npm/';
  final sourceDir = 'tool/npm_template';

  final dir = new Directory(destDir);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
  dir.createSync(recursive: true);

  final destination = new File(p.join(destDir, 'gltf_validator.dart.js'));

  _replaceVersion();

  Dart2js.compile(new File(p.join(sourceDir, 'node_wrapper.dart')),
      outFile: destination, extraArgs: _dart2jsArgs);

  _restoreVersion();

  final compiledJs = destination.readAsStringSync();

  // Node.js detector adopted from https://github.com/iliakan/detect-node
  const kDetector =
      "let _isNode=false;try{_isNode=Object.prototype.toString.call(global.process)==='[object process]'}catch(_){}";
  final preambleJs =
      '${kDetector}if(_isNode){${preamble.getPreamble(minified: true)}}else{var self=global.self;self.exports=exports}';

  destination.writeAsStringSync('$preambleJs\n$compiledJs');

  delete(new File(p.join(destDir, 'gltf_validator.dart.js.deps')));

  final Map<String, dynamic> json = JSON
      .decode(new File(p.join(sourceDir, 'package.json')).readAsStringSync());
  json['version'] = _version;

  log("copying package.json to $destDir");
  new File(p.join(destDir, 'package.json'))
      .writeAsStringSync((const JsonEncoder.withIndent('    ')).convert(json));

  copy(new File(p.join(sourceDir, 'index.js')), dir);
  copy(new File(p.join(sourceDir, 'README.md')), dir);
  copy(new File('ISSUES.md'), dir);
  copy(new File('LICENSE'), dir);
  copy(new File('3RD_PARTY'), dir);
  copy(new File(p.join('docs', 'validation.schema.json')), dir);
}

@Depends(issues, npmRelease)
@Task('Build an npm package.')
void npm() {
  log("Trying to generate npm docs...");
  run(npmExecutable, arguments: ['install'], workingDirectory: 'build/npm');
  run(npmExecutable, arguments: ['run', 'docs'], workingDirectory: 'build/npm');
}

@Depends(npm)
@Task('Publish package to npm.')
void npmPublish() {
  run(npmExecutable, arguments: ['publish'], workingDirectory: 'build/npm');
}

/// Ensure that the `build/` directory exists.
void _ensureBuild() {
  new Directory('build').createSync(recursive: true);
}

String get npmExecutable => Platform.isWindows ? 'npm.cmd' : 'npm';
