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

import '../../utils.dart';

void main() {
  group('KHR_texture_transform', () {
    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_texture_transform/data/custom_property.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('materials')
        ..path.add('0')
        ..path.add('emissiveTexture')
        ..path.add('extensions')
        ..path.add('KHR_texture_transform')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unexpected extension object', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_texture_transform/data/unexpected_extension_object.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('textures')
        ..path.add('0')
        ..path.add('extensions')
        ..path.add('KHR_texture_transform')
        ..addIssue(LinkError.unexpectedExtensionObject);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('UV bindings', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_texture_transform/data/uv_sets.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('meshes')
        ..path.add('0')
        ..path.add('primitives')
        ..path.add('0')
        ..path.add('material')
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords, args: [
          '/materials/0/emissiveTexture/extensions/KHR_texture_transform',
          2
        ]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_texture_transform/data/valid_full.gltf')
              .openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(
          result.gltf.materials.first.emissiveTexture.toString(),
          //ignore: lines_longer_than_80_chars
          '{index: 0, texCoord: 0, extensions: {KHR_texture_transform: {offset: [0.0, 1.0], rotation: 1.57079632679, scale: [0.5, 0.5], texCoord: 1, extensions: {}}}}');
    });
  });
}
