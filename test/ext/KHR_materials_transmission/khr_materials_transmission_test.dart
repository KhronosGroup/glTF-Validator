// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_transmission');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_transmission', () async {
      final gltf = (await read(
              'ext/KHR_materials_transmission/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final transmission = gltf.materials[0]
          .extensions['KHR_materials_transmission'] as KhrMaterialsTransmission;
      expect(transmission.transmissionFactor, 0.5);
      expect(transmission.transmissionTexture.texture, gltf.textures[0]);
      expect(transmission.extensions, isEmpty);
    });
  });
}
