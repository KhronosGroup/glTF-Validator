// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_volume');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_volume', () async {
      final gltf = (await read(
              'ext/KHR_materials_volume/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final volume0 = gltf.materials[0].extensions['KHR_materials_volume']
          as KhrMaterialsVolume;
      expect(volume0.attenuationColor, const [1, 1, 1]);
      expect(volume0.attenuationDistance, isNaN);
      expect(volume0.thicknessFactor, isZero);
      expect(volume0.thicknessTexture, isNull);
      expect(volume0.extensions, isEmpty);

      final volume1 = gltf.materials[1].extensions['KHR_materials_volume']
          as KhrMaterialsVolume;
      expect(volume1.attenuationColor, const [0, 0.5, 0]);
      expect(volume1.attenuationDistance, 10);
      expect(volume1.thicknessFactor, 3.0);
      expect(volume1.thicknessTexture.texture, gltf.textures[0]);
      expect(volume1.extensions, isEmpty);
    });
  });
}
