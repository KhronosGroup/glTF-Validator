// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_dispersion');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_dispersion', () async {
      final gltf = (await read(
              'ext/KHR_materials_dispersion/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final dispersion0 = gltf.materials[0]
          .extensions['KHR_materials_dispersion'] as KhrMaterialsDispersion;
      expect(dispersion0.dispersion, 1.0);
      expect(dispersion0.extensions, isEmpty);

      final dispersion1 = gltf.materials[1]
          .extensions['KHR_materials_dispersion'] as KhrMaterialsDispersion;
      expect(dispersion1.dispersion, 0);
      expect(dispersion1.extensions, isEmpty);

      final dispersion2 = gltf.materials[2]
          .extensions['KHR_materials_dispersion'] as KhrMaterialsDispersion;
      expect(dispersion2.dispersion, 0);
      expect(dispersion2.extensions, isEmpty);
    });
  });
}
