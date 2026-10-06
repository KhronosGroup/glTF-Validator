// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_dispersion;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_DISPERSION = 'KHR_materials_dispersion';

const String DISPERSION = 'dispersion';

const List<String> KHR_MATERIALS_DISPERSION_MEMBERS = <String>[
  DISPERSION,
];

class KhrMaterialsDispersion extends GltfProperty {
  final double dispersion;

  KhrMaterialsDispersion._(
      this.dispersion, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsDispersion fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_DISPERSION_MEMBERS, context);
    }

    final dispersion = getFloat(map, DISPERSION, context, min: 0, def: 0);

    final extensions = getExtensions(map, KhrMaterialsDispersion, context);

    return KhrMaterialsDispersion._(
        dispersion, extensions, getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (!context.validate) {
      return;
    }

    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is Material) {
        // The dispersion extension needs to be combined
        // with KHR_materials_volume.
        if (!o.extensions.containsKey(KHR_MATERIALS_VOLUME)) {
          context.addIssue(SemanticError.khrMaterialsDispersionNoVolume);
        }
        break;
      }
    }
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_MATERIALS_DISPERSION) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_DISPERSION)) {
      return PointerValidity.invalid;
    }
    final subProp = pointer[inPropDepth + 2];
    switch (subProp) {
      case DISPERSION:
        return PointerValidity.validIfScalar;
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsDispersionExtension = Extension(
    KHR_MATERIALS_DISPERSION,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsDispersion.fromMap)
    },
    validateExtensionPointer: KhrMaterialsDispersion.validateExtensionPointer);
