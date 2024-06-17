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
}

const Extension khrMaterialsAnisotropyExtension = Extension(
    KHR_MATERIALS_ANISOTROPY, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsAnisotropy.fromMap)
});
