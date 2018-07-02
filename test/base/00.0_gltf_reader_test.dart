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

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';

void main() {
  group('GltfReader', () {
    test('File extensions', () async {
      final gltfReader = GltfReader.filename(null, '.gltf', null);
      final glbReader = GltfReader.filename(null, '.glb', null);
      final invalidReader = GltfReader.filename(null, '.glb2', null);

      expect(gltfReader, const TypeMatcher<GltfJsonReader>());
      expect(glbReader, const TypeMatcher<GlbReader>());
      expect(invalidReader, isNull);
    });

    test('Stream error', () async {
      const ERROR_STRING = 'Stream error throwable';

      StreamController<List<int>> controller;
      controller = StreamController<List<int>>(onListen: () {
        controller
          ..addError(ERROR_STRING)
          ..close();
      });

      final reader = GltfJsonReader(controller.stream);

      expect(reader.read(), throwsA(ERROR_STRING));
    });

    test('Empty stream', () async {
      final reader = GltfJsonReader(Stream<List<int>>.fromIterable([<int>[]]));

      final context = Context()
        ..addIssue(SchemaError.invalidJson,
            args: ['FormatException: Unexpected end of input (at offset 0)']);

      await reader.read();
      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Invalid stream', () async {
      final reader =
          GltfJsonReader(Stream<List<int>>.fromIterable(['{]'.codeUnits]));

      final context = Context()
        ..addIssue(SchemaError.invalidJson,
            args: ['FormatException: Unexpected character (at offset 1)']);

      await reader.read();
      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Invalid root type', () async {
      final reader =
          GltfJsonReader(Stream<List<int>>.fromIterable(['[]'.codeUnits]));

      final context = Context()
        ..addIssue(SchemaError.typeMismatch, args: [<Object>[], 'object']);

      await reader.read();
      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Empty root object', () async {
      final reader =
          GltfJsonReader(Stream<List<int>>.fromIterable(['{}'.codeUnits]));

      final context = Context()
        ..addIssue(SchemaError.undefinedProperty, args: ['asset']);

      await reader.read();
      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid glTF, but starting with BOM', () async {
      final reader = GltfJsonReader(Stream<List<int>>.fromIterable([
        [
          0xEF,
          0xBB,
          0xBF,
        ],
        '{"asset":{"version":"2.0"}}'.codeUnits
      ]));

      final result = await reader.read();

      final context = Context()
        ..addIssue(SchemaError.invalidJson,
            args: ['BOM found at the beginning of UTF-8 stream.']);

      expect(reader.context.issues, context.issues);

      expect(result.mimeType, 'model/gltf+json');
      expect(result.gltf, const TypeMatcher<Gltf>());
    });

    test('Smallest possible asset', () async {
      final reader = GltfJsonReader(Stream<List<int>>.fromIterable(
          ['{"asset":{"version":"2.0"}}'.codeUnits]));

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(result.mimeType, 'model/gltf+json');
      expect(result.gltf, const TypeMatcher<Gltf>());
    });
  });
}
