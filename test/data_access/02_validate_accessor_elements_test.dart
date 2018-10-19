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

import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/cmd_line.dart';

import '../utils.dart';

Future<ValidationResult> getValidationResult(String filename) async {
  final file = File(filename);
  final context = ignoreUnusedContext;
  final reader = GltfReader.filename(file.openRead(), filename, context);

  final readerResult = await reader.read();

  final validationResult =
      ValidationResult(file.absolute.uri, reader.context, readerResult);

  final resourcesLoader = getFileResourceValidator(
      context, validationResult.absoluteUri, readerResult);
  await resourcesLoader.load();

  return validationResult;
}

void main() {
  group('Issues', () {
    test('#99', () async {
      final result =
          await getValidationResult('test/data_access/accessor/issue_99.gltf');

      expect(result.context.issues, isEmpty);
    });
  });
}
