// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_materials_variants');

  group('Evaluate valid objects', () {
    test('KHR_materials_variants', () async {
      final gltf = (await read(
              'ext/KHR_materials_variants/data/variant/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final khrMaterialsVariants =
          gltf.extensions['KHR_materials_variants'] as KhrMaterialsVariantsGltf;
      expect(khrMaterialsVariants.extensions, isEmpty);

      final variants = khrMaterialsVariants.variants;
      expect(variants, hasLength(2));
      expect(variants[0].name, 'variant0');
      expect(variants[0].extensions, isEmpty);
      expect(variants[1].name, 'variant1');
      expect(variants[1].extensions, isEmpty);
    });

    test('primitive.KHR_materials_variants', () async {
      final gltf = (await read(
              'ext/KHR_materials_variants/data/primitive/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final khrMaterialsVariants =
          gltf.extensions['KHR_materials_variants'] as KhrMaterialsVariantsGltf;
      expect(khrMaterialsVariants.extensions, isEmpty);

      final variants = khrMaterialsVariants.variants;
      expect(variants, hasLength(2));
      expect(variants[0].name, 'variant0');
      expect(variants[0].extensions, isEmpty);
      expect(variants[0].extras, {'id': 5});
      expect(variants[1].name, 'variant1');
      expect(variants[1].extensions, isEmpty);
      expect(variants[1].extras, {'id': 3});

      final khrMaterialsVariantsPrimitive =
          gltf.meshes[0].primitives[0].extensions['KHR_materials_variants']
              as KhrMaterialsVariantsMeshPrimitive;
      expect(khrMaterialsVariantsPrimitive.extensions, isEmpty);

      final mappings = khrMaterialsVariantsPrimitive.mappings;
      expect(mappings, hasLength(2));
      expect(mappings[0].material, gltf.materials[0]);
      expect(mappings[0].variants[0], variants[1]);
      expect(mappings[0].extras, {'theme': 'regular'});
      expect(mappings[1].material, gltf.materials[1]);
      expect(mappings[1].variants[0], variants[0]);
      expect(mappings[1].extras, {'theme': 'sheen'});
    });
  });
}
