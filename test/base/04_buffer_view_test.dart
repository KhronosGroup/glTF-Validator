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

import 'dart:io';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';

import '../utils.dart';

void main() {
  group('BufferView', () {
    test('Empty array', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/empty.gltf').openRead());

      final context = Context()
        ..path.add('bufferViews')
        ..addIssue(SchemaError.emptyEntity);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Empty object & zero byteLength', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/empty_object.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('bufferViews')
        ..path.add('0')
        ..addIssue(SchemaError.undefinedProperty, args: ['byteLength'])
        ..addIssue(SchemaError.undefinedProperty, args: ['buffer'])
        ..path.removeLast()
        ..path.add('1')
        ..addIssue(SchemaError.valueNotInRange, name: 'byteLength', args: [0])
        ..addIssue(SchemaError.undefinedProperty, args: ['buffer']);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/custom_property.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('bufferViews')
        ..path.add('0')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Invalid byteStride', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/invalid_stride.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('bufferViews')
        ..path.add('0')
        ..addIssue(SemanticError.bufferViewTooBigByteStride,
            name: 'byteStride', args: [5, 1])
        ..addIssue(SchemaError.valueMultipleOf,
            name: 'byteStride', args: [5, 4])
        ..addIssue(SemanticError.bufferViewInvalidByteStride,
            name: 'byteStride');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/valid_full.gltf').openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(
          result.gltf.bufferViews.toString(),
          //ignore: lines_longer_than_80_chars
          '[{buffer: 0, byteOffset: 0, byteLength: 4, byteStride: 4, target: 34962, extensions: {}}]');
    });

    test('Link errors', () async {
      final reader = GltfJsonReader(
          File('test/base/data/buffer_view/link_errors.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('bufferViews')
        ..path.add('0')
        ..addIssue(LinkError.unresolvedReference, name: 'buffer', args: [1])
        ..path.removeLast()
        ..path.add('1')
        ..addIssue(LinkError.bufferViewTooLong,
            name: 'byteLength', args: [0, 4])
        ..path.removeLast()
        ..path.add('2')
        ..addIssue(LinkError.bufferViewTooLong,
            name: 'byteOffset', args: [0, 4]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });
  });
}
