// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:gltf/src/errors.dart';
import 'package:grinder/grinder.dart';
import 'package:node_preamble/preamble.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final _version =
    loadYaml(File('pubspec.yaml').readAsStringSync())['version'] as String;

Future<void> main(List<String> args) => grind(args);

@Depends(npm, exe, web)
@DefaultTask('Build all')
void all() {}

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

    final args = ['`%1`', '`%2`', '`%3`', '`%4`', '`%5`'];
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
      } on TypeError catch (_) {
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

@Task('Build native executable.')
void exe() {
  final output = p.join(_getTarget(_binSource),
      'gltf_validator${Platform.isWindows ? '.exe' : ''}');

  final targetDir = Directory(_getTarget(_binSource));
  delete(targetDir);
  targetDir.createSync(recursive: true);

  final outputDebug = p.join(_getTarget(_binSource), 'symbols.elf');

  run(Platform.resolvedExecutable, arguments: [
    'compile',
    'exe',
    'bin/gltf_validator.dart',
    '--save-debugging-info=$outputDebug',
    '-o',
    output
  ]);
}

@Depends(exe)
@Task('Package native executable.')
void exeArchive() {
  final targetDir = Directory(_getTarget(_binSource));
  copy(File('LICENSE'), targetDir);
  copy(File('NOTICES'), targetDir);

  final docsDir = Directory(p.join(targetDir.path, 'docs'))..createSync();
  copy(File(p.join('docs', 'config-example.yaml')), docsDir);
  copy(File(p.join('docs', 'validation.schema.json')), docsDir);

  if (Platform.isLinux || Platform.isMacOS) {
    final filename =
        'gltf_validator-$_version-${Platform.operatingSystem}64.tar.xz';
    run('tar',
        arguments: [
          '--create',
          '--${Platform.isLinux ? 'owner' : 'uid'}=0',
          '--${Platform.isLinux ? 'group' : 'gid'}=0',
          '--xz',
          '--file=$filename',
          'gltf_validator',
          'LICENSE',
          'NOTICES',
          'docs'
        ],
        workingDirectory: _getTarget(_binSource));
  } else if (Platform.isWindows) {
    final psCommand = 'Compress-Archive '
        '-Path gltf_validator.exe, LICENSE, NOTICES, docs '
        '-DestinationPath gltf_validator-$_version-win64.zip';

    run('powershell',
        arguments: ['-Command', psCommand],
        workingDirectory: _getTarget(_binSource));
  } else {
    log('Ignoring exe-archive command '
        'for an unsupported platform: ${Platform.operatingSystem}.');
  }
}

@Task('Build web drag-n-drop version.')
void web() {
  _runBuild(_webSource);
}

@Depends(web)
@Task('Package web build.')
void webArchive() {
  final targetDir = Directory(_getTarget(_webSource));
  copy(File('LICENSE'), targetDir);
  copy(File('NOTICES'), targetDir);

  final filename = 'gltf_validator-$_version-web.zip';
  if (Platform.isLinux || Platform.isMacOS) {
    run('zip',
        arguments: ['-r', filename, '.'],
        workingDirectory: _getTarget(_webSource));
  } else if (Platform.isWindows) {
    final psCommand = 'Compress-Archive '
        '-Path ./* '
        '-DestinationPath $filename';

    run('powershell',
        arguments: ['-Command', psCommand],
        workingDirectory: _getTarget(_webSource));
  } else {
    log('Ignoring web-archive command '
        'for an unsupported platform: ${Platform.operatingSystem}.');
  }
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

  {
    // Do not redefine require to avoid webpack complaints
    final preamble =
        getPreamble(minified: true).replaceFirst('self.require=require,', '');
    final file = File(p.join(_nodeTarget, 'gltf_validator.dart.js'));
    file.writeAsStringSync(preamble + file.readAsStringSync());
  }

  const packageJson = 'package.json';
  final jsonMap =
      json.decode(File(p.join(_nodeSource, packageJson)).readAsStringSync())
          as Map<String, Object>;
  jsonMap['version'] = _version;
  jsonMap
    ..remove('devDependencies')
    ..remove('scripts');

  log('copying updated $packageJson to $_nodeTarget');
  File(p.join(_nodeTarget, packageJson))
      .writeAsStringSync(const JsonEncoder.withIndent('    ').convert(jsonMap));

  copy(File(p.join(_nodeSource, 'index.js')), _nodeTargetDir);
  copy(File(p.join(_nodeSource, 'module.mjs')), _nodeTargetDir);
  delete(Directory(p.join(_nodeTarget, 'node_modules')));
}

@Depends(issues, npmRelease)
@Task('Build an npm package.')
void npm() {
  copy(File('ISSUES.md'), _nodeTargetDir);
  copy(File('LICENSE'), _nodeTargetDir);
  copy(File('NOTICES'), _nodeTargetDir);
  copy(File(p.join('docs', 'validation.schema.json')), _nodeTargetDir);

  log('Building npm README...');
  copy(File(p.join(_nodeSource, 'README.md')), _nodeTargetDir);
  run(npmExecutable, arguments: ['install'], workingDirectory: _nodeSource);
  run(npmExecutable, arguments: ['run', 'docs'], workingDirectory: _nodeSource);
}

@Depends(npm)
@Task('Publish package to npm.')
void npmPublish() {
  run(npmExecutable, arguments: ['publish'], workingDirectory: _nodeTarget);
}

void _runBuild(String dir, {bool release = true, String defineOption}) {
  final target = _getTarget(dir);
  delete(Directory(target));

  Pub.run('build_runner', arguments: [
    'build',
    '--delete-conflicting-outputs',
    '--output',
    _getOutput(dir),
    if (release) '--release',
    if (defineOption != null) ...['--define', defineOption]
  ]);

  delete(File(p.join(target, '.build.manifest')));
  delete(File(p.join(target, '.packages')));
  delete(Directory(p.join(target, 'packages')));
  delete(Directory(p.join(target, '.dart_tool')));
}

String get npmExecutable => Platform.isWindows ? 'npm.cmd' : 'npm';

String _getOutput(String dir) => '$dir:${_getTarget(dir)}';

String _getTarget(String dir) => p.join('build', dir);
