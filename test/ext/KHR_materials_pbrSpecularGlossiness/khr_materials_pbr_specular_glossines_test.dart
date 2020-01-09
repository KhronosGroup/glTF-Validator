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

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

//ignore_for_file: avoid_as

Future main() async {
  await compareReports('test/ext/KHR_materials_pbrSpecularGlossiness');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_pbrSpecularGlossiness', () async {
      final gltf = (await read(
              'ext/KHR_materials_pbrSpecularGlossiness/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final specGloss =
          gltf.materials[0].extensions['KHR_materials_pbrSpecularGlossiness']
              as KhrMaterialsPbrSpecularGlossiness;
      expect(specGloss.diffuseFactor, const [0.1, 0.2, 0.3, 0.4]);
      expect(specGloss.diffuseTexture.texture, gltf.textures[0]);
      expect(specGloss.specularFactor, const [0.5, 0.6, 0.7]);
      expect(specGloss.glossinessFactor, 0.8);
      expect(specGloss.specularGlossinessTexture.texture, gltf.textures[1]);
      expect(specGloss.extensions, isEmpty);
    });
  });
}
