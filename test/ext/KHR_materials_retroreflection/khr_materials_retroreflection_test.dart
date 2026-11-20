// Copyright 2026 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_retroreflection');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_retroreflection', () async {
      final gltf = (await read(
              'ext/KHR_materials_retroreflection/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final retroreflection0 =
          gltf.materials[0].extensions['KHR_materials_retroreflection']
              as KhrMaterialsRetroreflection;
      expect(retroreflection0.retroreflectionFactor, 0.0);
      expect(retroreflection0.retroreflectionTexture, isNull);
      expect(retroreflection0.extensions, isEmpty);

      final retroreflection1 =
          gltf.materials[1].extensions['KHR_materials_retroreflection']
              as KhrMaterialsRetroreflection;
      expect(retroreflection1.retroreflectionFactor, 0.5);
      expect(retroreflection1.retroreflectionTexture.texture, gltf.textures[0]);
      expect(retroreflection1.extensions, isEmpty);
    });
  });
}
