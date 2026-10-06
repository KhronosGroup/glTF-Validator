// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_clearcoat;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_CLEARCOAT = 'KHR_materials_clearcoat';

const String CLEARCOAT_FACTOR = 'clearcoatFactor';
const String CLEARCOAT_TEXTURE = 'clearcoatTexture';
const String CLEARCOAT_ROUGHNESS_FACTOR = 'clearcoatRoughnessFactor';
const String CLEARCOAT_ROUGHNESS_TEXTURE = 'clearcoatRoughnessTexture';
const String CLEARCOAT_NORMAL_TEXTURE = 'clearcoatNormalTexture';

const List<String> KHR_MATERIALS_CLEARCOAT_MEMBERS = <String>[
  CLEARCOAT_FACTOR,
  CLEARCOAT_TEXTURE,
  CLEARCOAT_ROUGHNESS_FACTOR,
  CLEARCOAT_ROUGHNESS_TEXTURE,
  CLEARCOAT_NORMAL_TEXTURE
];

class KhrMaterialsClearcoat extends GltfProperty {
  final double clearcoatFactor;
  final TextureInfo clearcoatTexture;

  final double clearcoatRoughnessFactor;
  final TextureInfo clearcoatRoughnessTexture;
  final NormalTextureInfo clearcoatNormalTexture;

  KhrMaterialsClearcoat._(
      this.clearcoatFactor,
      this.clearcoatTexture,
      this.clearcoatRoughnessFactor,
      this.clearcoatRoughnessTexture,
      this.clearcoatNormalTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsClearcoat fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_CLEARCOAT_MEMBERS, context);
    }

    final clearcoatFactor =
        getFloat(map, CLEARCOAT_FACTOR, context, min: 0, max: 1, def: 0);
    final clearcoatTexture = getObjectFromInnerMap<TextureInfo>(
        map, CLEARCOAT_TEXTURE, context, TextureInfo.fromMap);
    final clearcoatRoughnessFactor = getFloat(
        map, CLEARCOAT_ROUGHNESS_FACTOR, context,
        min: 0, max: 1, def: 0);
    final clearcoatRoughnessTexture = getObjectFromInnerMap<TextureInfo>(
        map, CLEARCOAT_ROUGHNESS_TEXTURE, context, TextureInfo.fromMap);
    final clearcoatNormalTexture = getObjectFromInnerMap<NormalTextureInfo>(
        map, CLEARCOAT_NORMAL_TEXTURE, context, NormalTextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsClearcoat, context);

    final clearcoat = KhrMaterialsClearcoat._(
        clearcoatFactor,
        clearcoatTexture,
        clearcoatRoughnessFactor,
        clearcoatRoughnessTexture,
        clearcoatNormalTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(clearcoat, [
      clearcoatTexture,
      clearcoatRoughnessTexture,
      clearcoatNormalTexture,
      ...extensions.values
    ]);

    return clearcoat;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (clearcoatTexture != null) {
      context.path.add(CLEARCOAT_TEXTURE);
      clearcoatTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (clearcoatRoughnessTexture != null) {
      context.path.add(CLEARCOAT_ROUGHNESS_TEXTURE);
      clearcoatRoughnessTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (clearcoatNormalTexture != null) {
      context.path.add(CLEARCOAT_NORMAL_TEXTURE);
      clearcoatNormalTexture.link(gltf, context);

      Object o = this;
      while (o != null) {
        o = context.owners[o];
        if (o is Material) {
          final normalTexture = o.normalTexture;
          if (normalTexture != null &&
              normalTexture.texCoord != clearcoatNormalTexture.texCoord) {
            context.addIssue(SemanticError
                .khrMaterialsClearcoatClearcoatNormalTextureTexCoord);
          }
          break;
        }
      }
      context.path.removeLast();
    }
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_MATERIALS_CLEARCOAT) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_CLEARCOAT)) {
      return PointerValidity.invalid;
    }
    final clearcoatExt =
        mat.extensions[KHR_MATERIALS_CLEARCOAT] as KhrMaterialsClearcoat;
    final subProp = pointer[inPropDepth + 2];
    TextureInfo texInfoCheckTransform;
    switch (subProp) {
      case CLEARCOAT_FACTOR:
      case CLEARCOAT_ROUGHNESS_FACTOR:
        return PointerValidity.validIfScalar;
      case CLEARCOAT_NORMAL_TEXTURE:
        if (clearcoatExt.clearcoatNormalTexture == null) {
          return PointerValidity.invalid;
        }
        if (pointer.length < inPropDepth + 4) {
          return PointerValidity.invalid;
        }
        final texSubProp = pointer[inPropDepth + 3];
        if (texSubProp == SCALE) {
          return PointerValidity.validIfScalar;
        }
        texInfoCheckTransform = clearcoatExt.clearcoatNormalTexture;
        break;
      case CLEARCOAT_TEXTURE:
        if (clearcoatExt.clearcoatTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = clearcoatExt.clearcoatTexture;
        break;
      case CLEARCOAT_ROUGHNESS_TEXTURE:
        if (clearcoatExt.clearcoatRoughnessTexture == null) {
          return PointerValidity.invalid;
        }
        texInfoCheckTransform = clearcoatExt.clearcoatRoughnessTexture;
        break;
    }
    if (texInfoCheckTransform != null) {
      // KHR_materials_clearcoat can be used with KHR_texture_transform.
      return KhrTextureTransform.validateExtensionPointer(
          context, pointer, texInfoCheckTransform, inPropDepth + 3);
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsClearcoatExtension = Extension(
    KHR_MATERIALS_CLEARCOAT,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsClearcoat.fromMap)
    },
    validateExtensionPointer: KhrMaterialsClearcoat.validateExtensionPointer);
