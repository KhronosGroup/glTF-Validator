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

//ignore_for_file: avoid_as
//ignore_for_file: lines_longer_than_80_chars

void main() {
  group('KHR_lights_punctual', () {
    test('Broken lights', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_lights_punctual/data/broken_lights.gltf')
              .openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('scenes/0/extensions')
        ..addIssue(LinkError.unexpectedExtensionObject,
            name: 'KHR_lights_punctual')
        ..path.removeLast()
        ..path.add('extensions/KHR_lights_punctual/lights')
        ..addIssue(SchemaError.unexpectedProperty, name: '0/customProperty')
        ..addIssue(SchemaError.undefinedProperty, name: '0', args: ['type'])
        ..addIssue(SchemaError.valueNotInList, name: '1/type', args: [
          'spherical',
          ['directional', 'point', 'spot']
        ])
        ..addIssue(SemanticError.extraProperty, name: '2/spot')
        ..addIssue(SchemaError.undefinedProperty, name: '3', args: ['spot'])
        ..addIssue(SemanticError.extraProperty, name: '4/range')
        ..addIssue(SemanticError.khrLightsPunctualLightSpotAngles,
            name: '5/spot/outerConeAngle', args: [0.2, 0.1]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/ext/'
                  'KHR_lights_punctual/data/valid_full.gltf')
              .openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(result.gltf.extensions['KHR_lights_punctual'].toString(),
          '{lights: [{color: [0.75, 0.3, 1.0], intensity: 2.45, spot: {innerConeAngle: 0.2, outerConeAngle: 1.0, extensions: {}}, type: spot, range: 10.0, extensions: {}}], extensions: {}}');
    });
  });
}
