// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_clearcoat');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_clearcoat', () async {
      final gltf = (await read(
              'ext/KHR_materials_clearcoat/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final clearcoat = gltf.materials[0].extensions['KHR_materials_clearcoat']
          as KhrMaterialsClearcoat;
      expect(clearcoat.clearcoatFactor, 0.5);
      expect(clearcoat.clearcoatTexture.texture, gltf.textures[0]);
      expect(clearcoat.clearcoatRoughnessFactor, 1.0);
      expect(clearcoat.clearcoatRoughnessTexture.texture, gltf.textures[1]);
      expect(clearcoat.clearcoatNormalTexture.texture, gltf.textures[2]);
      expect(clearcoat.clearcoatNormalTexture.scale, 1.5);
      expect(clearcoat.extensions, isEmpty);
    });
  });
}
