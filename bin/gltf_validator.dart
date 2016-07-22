/*
 * # Copyright (c) 2016 The Khronos Group Inc.
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

library gltf.validator;

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:gltf/gltf.dart';

void main(List<String> args) {
  final parser = new ArgParser();

  parser.addOption('output-format',
      abbr: 'o',
      defaultsTo: 'json',
      help: 'Validation output format.',
      allowed: ['json', 'text']);

  var argResult;
  try {
    argResult = parser.parse(args);
  } on FormatException catch (_) {}

  if (argResult?.rest?.length != 1) {
    stderr.writeln("Usage: gltf_validator [<options>] <asset-file>");
    stderr.writeln(parser.usage);
  } else {
    _load(argResult.rest[0]);
  }
}

Future _load(String filename) async {
  stderr.writeln("Loading $filename...");

  final fileStream = new File(filename).openRead();

  GltfReader reader;
  if (filename.endsWith(".gltf")) {
    reader = new GltfReader(fileStream);
  } else if (filename.endsWith(".glb")) {
    reader = new GlbReader(fileStream);
  } else {
    stderr.writeln("Unknown file format.");
    return;
  }

  try {
    await reader.root;
    stdout.writeln(reader.context);
  } on Context catch (e) {
    // Failed before Gltf.fromMap call
    stdout.writeln(e);
  } on FileSystemException catch (e) {
    stderr.writeln(e);
  }
}
