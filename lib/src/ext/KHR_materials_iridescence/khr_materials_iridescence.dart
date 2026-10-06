// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_iridescence;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_IRIDESCENCE = 'KHR_materials_iridescence';

const String IRIDESCENCE_FACTOR = 'iridescenceFactor';
const String IRIDESCENCE_TEXTURE = 'iridescenceTexture';
const String IRIDESCENCE_IOR = 'iridescenceIor';
const String IRIDESCENCE_THICKNESS_MINIMUM = 'iridescenceThicknessMinimum';
const String IRIDESCENCE_THICKNESS_MAXIMUM = 'iridescenceThicknessMaximum';
const String IRIDESCENCE_THICKNESS_TEXTURE = 'iridescenceThicknessTexture';

const List<String> KHR_MATERIALS_IRIDESCENCE_MEMBERS = <String>[
  IRIDESCENCE_FACTOR,
  IRIDESCENCE_TEXTURE,
  IRIDESCENCE_IOR,
  IRIDESCENCE_THICKNESS_MINIMUM,
  IRIDESCENCE_THICKNESS_MAXIMUM,
  IRIDESCENCE_THICKNESS_TEXTURE
];

class KhrMaterialsIridescence extends GltfProperty {
  final double iridescenceFactor;
  final TextureInfo iridescenceTexture;

  final double iridescenceIor;
  final double iridescenceThicknessMinimum;
  final double iridescenceThicknessMaximum;
  final TextureInfo iridescenceThicknessTexture;

  KhrMaterialsIridescence._(
      this.iridescenceFactor,
      this.iridescenceTexture,
      this.iridescenceIor,
      this.iridescenceThicknessMinimum,
      this.iridescenceThicknessMaximum,
      this.iridescenceThicknessTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsIridescence fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_IRIDESCENCE_MEMBERS, context);
    }

    final iridescenceFactor =
        getFloat(map, IRIDESCENCE_FACTOR, context, min: 0, max: 1, def: 0);
    final iridescenceTexture = getObjectFromInnerMap<TextureInfo>(
        map, IRIDESCENCE_TEXTURE, context, TextureInfo.fromMap);
    final iridescenceIor =
        getFloat(map, IRIDESCENCE_IOR, context, min: 1, def: 1.3);
    final iridescenceThicknessMinimum =
        getFloat(map, IRIDESCENCE_THICKNESS_MINIMUM, context, min: 0, def: 100);
    final iridescenceThicknessMaximum =
        getFloat(map, IRIDESCENCE_THICKNESS_MAXIMUM, context, min: 0, def: 400);
    final iridescenceThicknessTexture = getObjectFromInnerMap<TextureInfo>(
        map, IRIDESCENCE_THICKNESS_TEXTURE, context, TextureInfo.fromMap);

    if (context.validate) {
      if (iridescenceThicknessTexture != null) {
        if (iridescenceThicknessMinimum == iridescenceThicknessMaximum) {
          context.addIssue(
              SemanticError.khrMaterialsIridescenceThicknessTextureUnused,
              name: IRIDESCENCE_THICKNESS_TEXTURE);
        }
      } else {
        if (!iridescenceThicknessMinimum.isNaN &&
            map.containsKey(IRIDESCENCE_THICKNESS_MINIMUM)) {
          context.addIssue(
              SemanticError.khrMaterialsIridescenceThicknessRangeWithoutTexture,
              name: IRIDESCENCE_THICKNESS_MINIMUM);
        }
      }
    }

    final extensions = getExtensions(map, KhrMaterialsIridescence, context);

    final iridescence = KhrMaterialsIridescence._(
        iridescenceFactor,
        iridescenceTexture,
        iridescenceIor,
        iridescenceThicknessMinimum,
        iridescenceThicknessMaximum,
        iridescenceThicknessTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(iridescence, [
      iridescenceTexture,
      iridescenceThicknessTexture,
      ...extensions.values
    ]);

    return iridescence;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (iridescenceTexture != null) {
      context.path.add(IRIDESCENCE_TEXTURE);
      iridescenceTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (iridescenceThicknessTexture != null) {
      context.path.add(IRIDESCENCE_THICKNESS_TEXTURE);
      iridescenceThicknessTexture.link(gltf, context);
      context.path.removeLast();
    }
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_MATERIALS_IRIDESCENCE) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_IRIDESCENCE)) {
      return PointerValidity.invalid;
    }
    final iridescenceExt =
        mat.extensions[KHR_MATERIALS_IRIDESCENCE] as KhrMaterialsIridescence;
    final subProp = pointer[inPropDepth + 2];
    TextureInfo texInfoCheckTransform;
    switch (subProp) {
      case IRIDESCENCE_FACTOR:
      case IRIDESCENCE_IOR:
      case IRIDESCENCE_THICKNESS_MINIMUM:
      case IRIDESCENCE_THICKNESS_MAXIMUM:
        return PointerValidity.validIfScalar;
      case IRIDESCENCE_TEXTURE:
        if (iridescenceExt.iridescenceTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = iridescenceExt.iridescenceTexture;
        break;
      case IRIDESCENCE_THICKNESS_TEXTURE:
        if (iridescenceExt.iridescenceThicknessTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = iridescenceExt.iridescenceThicknessTexture;
        break;
    }
    if (texInfoCheckTransform != null) {
      // KHR_materials_iridescence can be used with KHR_texture_transform.
      return KhrTextureTransform.validateExtensionPointer(
          context, pointer, texInfoCheckTransform, inPropDepth + 3);
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsIridescenceExtension = Extension(
    KHR_MATERIALS_IRIDESCENCE,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsIridescence.fromMap)
    },
    validateExtensionPointer: KhrMaterialsIridescence.validateExtensionPointer);
