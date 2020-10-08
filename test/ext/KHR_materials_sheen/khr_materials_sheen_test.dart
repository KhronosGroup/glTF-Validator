// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

//ignore_for_file: avoid_as

Future main() async {
  await compareReports('test/ext/KHR_materials_sheen');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_sheen', () async {
      final gltf = (await read(
              'ext/KHR_materials_sheen/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final sheen = gltf.materials[0].extensions['KHR_materials_sheen']
          as KhrMaterialsSheen;
      expect(sheen.sheenColorFactor, [0.5, 0.0, 1.0]);
      expect(sheen.sheenColorTexture.texture, gltf.textures[0]);
      expect(sheen.sheenRoughnessFactor, 1.0);
      expect(sheen.sheenRoughnessTexture.texture, gltf.textures[1]);
      expect(sheen.extensions, isEmpty);
    });
  });
}
