// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_ior');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_ior', () async {
      final gltf = (await read('ext/KHR_materials_ior/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final ior0 =
          gltf.materials[0].extensions['KHR_materials_ior'] as KhrMaterialsIor;
      expect(ior0.ior, 2.0);
      expect(ior0.extensions, isEmpty);

      final ior1 =
          gltf.materials[1].extensions['KHR_materials_ior'] as KhrMaterialsIor;
      expect(ior1.ior, 1.5);
      expect(ior1.extensions, isEmpty);

      final ior2 =
          gltf.materials[2].extensions['KHR_materials_ior'] as KhrMaterialsIor;
      expect(ior2.ior, 0);
      expect(ior2.extensions, isEmpty);
    });
  });
}
