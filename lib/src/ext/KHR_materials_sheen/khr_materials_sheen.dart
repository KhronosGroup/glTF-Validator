// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_sheen;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_SHEEN = 'KHR_materials_sheen';

const String SHEEN_COLOR_FACTOR = 'sheenColorFactor';
const String SHEEN_COLOR_TEXTURE = 'sheenColorTexture';
const String SHEEN_ROUGHNESS_FACTOR = 'sheenRoughnessFactor';
const String SHEEN_ROUGHNESS_TEXTURE = 'sheenRoughnessTexture';

const List<String> KHR_MATERIALS_SHEEN_MEMBERS = <String>[
  SHEEN_COLOR_FACTOR,
  SHEEN_COLOR_TEXTURE,
  SHEEN_ROUGHNESS_FACTOR,
  SHEEN_ROUGHNESS_TEXTURE
];

class KhrMaterialsSheen extends GltfProperty {
  final List<double> sheenColorFactor;
  final TextureInfo sheenColorTexture;

  final double sheenRoughnessFactor;
  final TextureInfo sheenRoughnessTexture;

  KhrMaterialsSheen._(
      this.sheenColorFactor,
      this.sheenColorTexture,
      this.sheenRoughnessFactor,
      this.sheenRoughnessTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsSheen fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_SHEEN_MEMBERS, context);
    }

    final sheenColorFactor = getFloatList(map, SHEEN_COLOR_FACTOR, context,
        min: 0, max: 1, def: const [0, 0, 0], lengthsList: const [3]);
    final sheenColorTexture = getObjectFromInnerMap<TextureInfo>(
        map, SHEEN_COLOR_TEXTURE, context, TextureInfo.fromMap);
    final sheenRoughnessFactor =
        getFloat(map, SHEEN_ROUGHNESS_FACTOR, context, min: 0, max: 1, def: 0);
    final sheenRoughnessTexture = getObjectFromInnerMap<TextureInfo>(
        map, SHEEN_ROUGHNESS_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsSheen, context);

    final sheen = KhrMaterialsSheen._(
        sheenColorFactor,
        sheenColorTexture,
        sheenRoughnessFactor,
        sheenRoughnessTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(sheen,
        [sheenColorTexture, sheenRoughnessTexture, ...extensions.values]);

    return sheen;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (sheenColorTexture != null) {
      context.path.add(SHEEN_COLOR_TEXTURE);
      sheenColorTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (sheenRoughnessTexture != null) {
      context.path.add(SHEEN_ROUGHNESS_TEXTURE);
      sheenRoughnessTexture.link(gltf, context);
      context.path.removeLast();
    }
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_MATERIALS_SHEEN) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_SHEEN)) {
      return PointerValidity.invalid;
    }
    final sheenExt = mat.extensions[KHR_MATERIALS_SHEEN] as KhrMaterialsSheen;
    final subProp = pointer[inPropDepth + 2];
    TextureInfo texInfoCheckTransform;
    switch (subProp) {
      case SHEEN_COLOR_FACTOR:
        if (sheenExt.sheenColorFactor == null ||
            sheenExt.sheenColorFactor.length != 3) {
          return PointerValidity.invalid;
        }
        return PointerValidity.validIfVec3;
      case SHEEN_ROUGHNESS_FACTOR:
        return PointerValidity.validIfScalar;
      case SHEEN_COLOR_TEXTURE:
        if (sheenExt.sheenColorTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = sheenExt.sheenColorTexture;
        break;
      case SHEEN_ROUGHNESS_TEXTURE:
        if (sheenExt.sheenRoughnessTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = sheenExt.sheenRoughnessTexture;
        break;
    }
    if (texInfoCheckTransform != null) {
      // KHR_materials_sheen can be used with KHR_texture_transform.
      return KhrTextureTransform.validateExtensionPointer(
          context, pointer, texInfoCheckTransform, inPropDepth + 3);
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsSheenExtension = Extension(
    KHR_MATERIALS_SHEEN,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsSheen.fromMap)
    },
    validateExtensionPointer: KhrMaterialsSheen.validateExtensionPointer);
