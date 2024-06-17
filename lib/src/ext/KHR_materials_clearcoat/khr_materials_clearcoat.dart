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
}

const Extension khrMaterialsClearcoatExtension = Extension(
    KHR_MATERIALS_CLEARCOAT, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsClearcoat.fromMap)
});
