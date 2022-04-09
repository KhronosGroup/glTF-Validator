// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_emissive_strength;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_EMISSIVE_STRENGTH =
    'KHR_materials_emissive_strength';

const String EMISSIVE_STRENGTH = 'emissiveStrength';

const List<String> KHR_MATERIALS_EMISSIVE_STRENGTH_MEMBERS = <String>[
  EMISSIVE_STRENGTH,
];

class KhrMaterialsEmissiveStrength extends GltfProperty {
  final double emissiveStrength;

  KhrMaterialsEmissiveStrength._(
      this.emissiveStrength, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsEmissiveStrength fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_EMISSIVE_STRENGTH_MEMBERS, context);
    }

    final emissiveStrength =
        getFloat(map, EMISSIVE_STRENGTH, context, min: 0, def: 1);

    final extensions =
        getExtensions(map, KhrMaterialsEmissiveStrength, context);

    return KhrMaterialsEmissiveStrength._(
        emissiveStrength, extensions, getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (!context.validate || emissiveStrength.isNaN || emissiveStrength == 1) {
      return;
    }
    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is Material) {
        final factor = o.emissiveFactor;
        if (factor != null &&
            factor[0] == 0 &&
            factor[1] == 0 &&
            factor[2] == 0) {
          context
              .addIssue(SemanticError.khrMaterialsEmissiveStrengthZeroFactor);
        }
        break;
      }
    }
  }
}

const Extension khrMaterialsEmissiveStrengthExtension = Extension(
    KHR_MATERIALS_EMISSIVE_STRENGTH, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsEmissiveStrength.fromMap)
});
