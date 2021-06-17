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

Future main() async {
  await compareReports('test/ext/KHR_materials_unlit');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_unlit', () async {
      final gltf = (await read(
              'ext/KHR_materials_unlit/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final unlit = gltf.materials[0].extensions['KHR_materials_unlit']
          as KhrMaterialsUnlit;

      expect(unlit.extensions, isEmpty);
    });
  });
}
