// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_anisotropy');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_anisotropy', () async {
      final gltf = (await read(
              'ext/KHR_materials_anisotropy/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final anisotropy0 = gltf.materials[0]
          .extensions['KHR_materials_anisotropy'] as KhrMaterialsAnisotropy;
      expect(anisotropy0.anisotropyStrength, 0);
      expect(anisotropy0.anisotropyRotation, 0);
      expect(anisotropy0.anisotropyTexture, isNull);
      expect(anisotropy0.extensions, isEmpty);

      final anisotropy1 = gltf.materials[1]
          .extensions['KHR_materials_anisotropy'] as KhrMaterialsAnisotropy;
      expect(anisotropy1.anisotropyStrength, 0.5);
      expect(anisotropy1.anisotropyRotation, 1.5);
      expect(anisotropy1.anisotropyTexture.texture, gltf.textures[0]);
    });
  });
}
