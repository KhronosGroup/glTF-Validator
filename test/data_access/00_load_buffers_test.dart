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
import 'package:gltf/src/errors.dart';
import 'package:gltf/cmd_line.dart';

import '../utils.dart';

Future<ValidationResult> getValidationResult(String filename) async {
  final file = new File(filename);
  final context = ignoreUnusedContext;
  final reader = new GltfReader.filename(file.openRead(), filename, context);

  final readerResult = await reader.read();

  final validationResult =
      new ValidationResult(file.absolute.uri, reader.context, readerResult);

  final resourcesLoader = getFileResourceValidator(
      context, validationResult.absoluteUri, readerResult);
  await resourcesLoader.load();

  return validationResult;
}

void main() {
  group('Load Buffers', () {
    test('File not found', () async {
      final validationResult =
          await getValidationResult('test/data_access/buffer/not_found.gltf');

      expect(validationResult.context.issues, hasLength(1));
      expect(validationResult.context.issues.first.type.code, 'FILE_NOT_FOUND');
    });

    test('Data URI', () async {
      final validationResult =
          await getValidationResult('test/data_access/buffer/data_uri.gltf');

      expect(validationResult.context.issues, isEmpty);
    });

    test('GLB & Wrong length', () async {
      final validationResult =
          await getValidationResult('test/data_access/buffer/wrong_length.glb');

      final context = new Context()
        ..path.add('buffers')
        ..path.add('0')
        ..addIssue(DataError.bufferExternalBytelengthMismatch, args: [16, 17]);

      expect(validationResult.context.issues, unorderedMatches(context.issues));
    });

    test('GLB & Extra Padding', () async {
      final validationResult = await getValidationResult(
          'test/data_access/buffer/extra_padding.glb');

      final context = new Context()
        ..path.add('buffers')
        ..path.add('0')
        ..addIssue(DataError.bufferGlbChunkTooBig, args: [4]);

      expect(validationResult.context.issues, unorderedMatches(context.issues));
    });

    test('External file', () async {
      final validationResult = await getValidationResult(
          'test/data_access/buffer/valid_external.gltf');

      expect(validationResult.context.issues, isEmpty);

      expect(
          validationResult.readerResult.gltf.buffers.first.data,
          orderedEquals(
              <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]));
    });

    test('Non first buffer refers to GLB', () async {
      final validationResult = await getValidationResult(
          'test/data_access/buffer/non_first_buffer.glb');

      final context = new Context()
        ..path.add('buffers')
        ..path.add('1')
        ..addIssue(LinkError.bufferNonFirstGlb);

      expect(validationResult.context.issues, unorderedMatches(context.issues));
    });

    test('Missing BIN chunk', () async {
      final validationResult = await getValidationResult(
          'test/data_access/buffer/json_missing_bin.glb');

      final context = new Context()
        ..path.add('buffers')
        ..path.add('0')
        ..addIssue(LinkError.bufferMissingGlbData);

      expect(validationResult.context.issues, unorderedMatches(context.issues));
    });

    test('Broken URI', () async {
      final validationResult =
          await getValidationResult('test/data_access/buffer/broken_uri.gltf');

      final context = new Context()
        ..path.add('buffers')
        ..path.add('0')
        ..addIssue(SchemaError.invalidUri,
            name: 'uri',
            args: ['data:', "FormatException: Expecting '='\ndata:"]);

      expect(validationResult.context.issues, unorderedMatches(context.issues));
    });
  });
}
