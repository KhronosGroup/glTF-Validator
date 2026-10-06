// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_anisotropy;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_ANISOTROPY = 'KHR_materials_anisotropy';

const String ANISOTROPY_STRENGTH = 'anisotropyStrength';
const String ANISOTROPY_ROTATION = 'anisotropyRotation';
const String ANISOTROPY_TEXTURE = 'anisotropyTexture';

const List<String> KHR_MATERIALS_ANISOTROPY_MEMBERS = <String>[
  ANISOTROPY_STRENGTH,
  ANISOTROPY_ROTATION,
  ANISOTROPY_TEXTURE
];

class KhrMaterialsAnisotropy extends GltfProperty {
  final double anisotropyStrength;
  final double anisotropyRotation;
  final TextureInfo anisotropyTexture;

  KhrMaterialsAnisotropy._(this.anisotropyStrength, this.anisotropyRotation,
      this.anisotropyTexture, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsAnisotropy fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_ANISOTROPY_MEMBERS, context);
    }

    final anisotropyStrength =
        getFloat(map, ANISOTROPY_STRENGTH, context, min: 0, max: 1, def: 0);
    final anisotropyRotation =
        getFloat(map, ANISOTROPY_ROTATION, context, def: 0);
    final anisotropyTexture = getObjectFromInnerMap<TextureInfo>(
        map, ANISOTROPY_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsAnisotropy, context);

    final anisotropy = KhrMaterialsAnisotropy._(
        anisotropyStrength,
        anisotropyRotation,
        anisotropyTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(
        anisotropy, [anisotropyTexture, ...extensions.values]);

    return anisotropy;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (anisotropyTexture != null) {
      context.path.add(ANISOTROPY_TEXTURE);
      anisotropyTexture.link(gltf, context);

      Object o = this;
      while (o != null) {
        o = context.owners[o];
        if (o is Material) {
          o.needsTangent = true;
          final normalTexture = o.normalTexture;
          if (normalTexture != null &&
              normalTexture.texCoord != anisotropyTexture.texCoord) {
            context.addIssue(
                SemanticError.khrMaterialsAnisotropyAnisotropyTextureTexCoord);
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
        pointer[inPropDepth + 1] != KHR_MATERIALS_ANISOTROPY) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_ANISOTROPY)) {
      return PointerValidity.invalid;
    }
    final anisoExt =
        mat.extensions[KHR_MATERIALS_ANISOTROPY] as KhrMaterialsAnisotropy;
    final subProp = pointer[inPropDepth + 2];
    switch (subProp) {
      case ANISOTROPY_STRENGTH:
      case ANISOTROPY_ROTATION:
        return PointerValidity.validIfScalar;
      case ANISOTROPY_TEXTURE:
        if (anisoExt.anisotropyTexture == null) {
          return PointerValidity.invalid;
        }
        if (pointer.length < inPropDepth + 6) {
          return PointerValidity.unknown;
        }
        // KHR_materials_anisotropy can be used with KHR_texture_transform.
        return KhrTextureTransform.validateExtensionPointer(
            context, pointer, anisoExt.anisotropyTexture, inPropDepth + 3);
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsAnisotropyExtension = Extension(
    KHR_MATERIALS_ANISOTROPY,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsAnisotropy.fromMap)
    },
    validateExtensionPointer: KhrMaterialsAnisotropy.validateExtensionPointer);
