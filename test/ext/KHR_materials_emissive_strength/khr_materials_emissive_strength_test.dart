// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_emissive_strength');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_emissive_strength', () async {
      final gltf = (await read(
              'ext/KHR_materials_emissive_strength/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final es0 =
          gltf.materials[0].extensions['KHR_materials_emissive_strength']
              as KhrMaterialsEmissiveStrength;
      expect(es0.emissiveStrength, 2.0);
      expect(es0.extensions, isEmpty);

      final es1 =
          gltf.materials[1].extensions['KHR_materials_emissive_strength']
              as KhrMaterialsEmissiveStrength;
      expect(es1.emissiveStrength, 1);
      expect(es1.extensions, isEmpty);

      final es2 =
          gltf.materials[2].extensions['KHR_materials_emissive_strength']
              as KhrMaterialsEmissiveStrength;
      expect(es2.emissiveStrength, 0);
      expect(es2.extensions, isEmpty);
    });
  });
}
