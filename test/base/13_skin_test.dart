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
  group('Skin', () {
    test('Empty array', () async {
      final reader =
          GltfJsonReader(File('test/base/data/skin/empty.gltf').openRead());

      final context = Context()
        ..path.add('skins')
        ..addIssue(SchemaError.emptyEntity);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/base/data/skin/custom_property.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('skins')
        ..path.add('0')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty')
        ..addIssue(SchemaError.undefinedProperty, args: ['joints']);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unresolved references', () async {
      final reader = GltfJsonReader(
          File('test/base/data/skin/unresolved_references.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('skins')
        ..path.add('0')
        ..addIssue(LinkError.unresolvedReference,
            name: 'inverseBindMatrices', args: [0])
        ..addIssue(LinkError.unresolvedReference, name: 'skeleton', args: [0])
        ..path.add('joints')
        ..addIssue(LinkError.unresolvedReference, index: 0, args: [0]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Misc', () async {
      final reader = GltfJsonReader(
          File('test/base/data/skin/misc.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('skins')
        ..path.add('0')
        ..addIssue(LinkError.skinIbmInvalidFormat,
            name: 'inverseBindMatrices',
            args: [
              '{MAT3, FLOAT}',
              ['{MAT4, FLOAT}']
            ])
        ..addIssue(LinkError.invalidIbmAccessorCount,
            name: 'inverseBindMatrices', args: [2, 3]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/base/data/skin/valid_full.gltf').openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(
          result.gltf.skins.toString(),
          //ignore: lines_longer_than_80_chars
          '[{inverseBindMatrices: 0, skeleton: 0, joints: [0, 1], extensions: {}}]');
    });
  });
}
