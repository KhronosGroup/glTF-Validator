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
  group('KHR_materials_unlit', () {
    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_materials_unlit/data/custom_property.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('materials')
        ..path.add('0')
        ..path.add('extensions')
        ..path.add('KHR_materials_unlit')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unexpected extension object', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_materials_unlit/data/unexpected_extension_object.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('samplers')
        ..path.add('0')
        ..path.add('extensions')
        ..path.add('KHR_materials_unlit')
        ..addIssue(LinkError.unexpectedExtensionObject);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_materials_unlit/data/valid_full.gltf')
              .openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(
          result.gltf.materials.toString(),
          //ignore: lines_longer_than_80_chars
          '[{emissiveFactor: [0.0, 0.0, 0.0], alphaMode: OPAQUE, alphaCutoff: 0.5, doubleSided: false, extensions: {KHR_materials_unlit: {extensions: {}}}}]');
    });
  });
}
