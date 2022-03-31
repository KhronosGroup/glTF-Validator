/*
 * # Copyright (c) 2016-2019 The Khronos Group Inc.
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

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_lights_punctual');

  group('Evaluate valid objects', () {
    test('light.KHR_lights_punctual', () async {
      final gltf = (await read('ext/KHR_lights_punctual/data/light/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final lightsPunctual =
          gltf.extensions['KHR_lights_punctual'] as KhrLightsPunctualGltf;
      final light = lightsPunctual.lights[0];
      expect(light.type, 'spot');
      expect(light.intensity, 2.45);
      expect(light.color, const [0.75, 0.3, 1.0]);
      expect(light.range, 10);
      expect(light.spot.innerConeAngle, 0.2);
      expect(light.spot.outerConeAngle, 1.0);
      expect(light.spot.extensions, isEmpty);
      expect(light.extensions, isEmpty);
    });

    test('node.KHR_lights_punctual', () async {
      final gltf = (await read('ext/KHR_lights_punctual/data/node/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final lightsPunctual =
          gltf.extensions['KHR_lights_punctual'] as KhrLightsPunctualGltf;

      final lightsPunctualNode = gltf.nodes[0].extensions['KHR_lights_punctual']
          as KhrLightsPunctualNode;

      expect(lightsPunctualNode.light, lightsPunctual.lights[0]);
      expect(lightsPunctualNode.extensions, isEmpty);
    });
  });
}
