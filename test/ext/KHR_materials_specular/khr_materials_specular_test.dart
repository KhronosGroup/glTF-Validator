// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_specular');

  group('Evaluate valid objects', () {
    test('material.KHR_materials_specular', () async {
      final gltf = (await read(
              'ext/KHR_materials_specular/data/material/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final specular0 = gltf.materials[0].extensions['KHR_materials_specular']
          as KhrMaterialsSpecular;
      expect(specular0.specularFactor, 1.0);
      expect(specular0.specularTexture, isNull);
      expect(specular0.specularColorFactor, const [1, 1, 1]);
      expect(specular0.specularColorTexture, isNull);
      expect(specular0.extensions, isEmpty);

      final specular1 = gltf.materials[1].extensions['KHR_materials_specular']
          as KhrMaterialsSpecular;
      expect(specular1.specularFactor, 0.5);
      expect(specular1.specularTexture.texture, gltf.textures[0]);
      expect(specular1.specularColorFactor, const [1.5, 0, 0.5]);
      expect(specular1.specularColorTexture.texture, gltf.textures[1]);
      expect(specular1.extensions, isEmpty);
    });
  });
}
