// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_iridescence');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_iridescence', () async {
      final gltf = (await read(
              'ext/KHR_materials_iridescence/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      {
        final iridescence = gltf.materials[0]
            .extensions['KHR_materials_iridescence'] as KhrMaterialsIridescence;
        expect(iridescence.iridescenceFactor, 0);
        expect(iridescence.iridescenceTexture, isNull);
        expect(iridescence.iridescenceIor, 1.3);
        expect(iridescence.iridescenceThicknessMinimum, 100);
        expect(iridescence.iridescenceThicknessMaximum, 400);
        expect(iridescence.iridescenceThicknessTexture, isNull);
        expect(iridescence.extensions, isEmpty);
      }

      {
        final iridescence = gltf.materials[1]
            .extensions['KHR_materials_iridescence'] as KhrMaterialsIridescence;
        expect(iridescence.iridescenceFactor, 0.5);
        expect(iridescence.iridescenceTexture.texture, gltf.textures[0]);
        expect(iridescence.iridescenceIor, 2);
        expect(iridescence.iridescenceThicknessMinimum, 150);
        expect(iridescence.iridescenceThicknessMaximum, 450);
        expect(
            iridescence.iridescenceThicknessTexture.texture, gltf.textures[1]);
        expect(iridescence.extensions, isEmpty);
      }
    });
  });
}
