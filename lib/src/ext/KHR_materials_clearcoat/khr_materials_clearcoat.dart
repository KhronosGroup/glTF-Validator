// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_clearcoat;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String KHR_MATERIALS_CLEARCOAT = 'KHR_materials_clearcoat';

const String CLEARCOAT_FACTOR = 'clearcoatFactor';
const String CLEARCOAT_TEXTURE = 'clearcoatTexture';
const String CLEARCOATROUGHNESS_FACTOR = 'clearcoatRoughnessFactor';
const String CLEARCOATROUGHNESS_TEXTURE = 'clearcoatRoughnessTexture';
const String CLEARCOATNORMAL_TEXTURE = 'clearcoatNormalTexture';

const List<String> KHR_MATERIALS_CLEARCOAT_MEMBERS = <String>[
  CLEARCOAT_FACTOR,
  CLEARCOAT_TEXTURE,
  CLEARCOATROUGHNESS_FACTOR,
  CLEARCOATROUGHNESS_TEXTURE,
  CLEARCOATNORMAL_TEXTURE
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
        map, CLEARCOATROUGHNESS_FACTOR, context,
        min: 0, max: 1, def: 0);
    final clearcoatRoughnessTexture = getObjectFromInnerMap<TextureInfo>(
        map, CLEARCOATROUGHNESS_TEXTURE, context, TextureInfo.fromMap);
    final clearcoatNormalTexture = getObjectFromInnerMap<NormalTextureInfo>(
        map, CLEARCOATNORMAL_TEXTURE, context, NormalTextureInfo.fromMap);

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
      context.path.add(CLEARCOATROUGHNESS_TEXTURE);
      clearcoatRoughnessTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (clearcoatNormalTexture != null) {
      context.path.add(CLEARCOATNORMAL_TEXTURE);
      clearcoatNormalTexture.link(gltf, context);
      context.path.removeLast();
    }
  }
}

const Extension khrMaterialsClearcoatExtension = Extension(
    KHR_MATERIALS_CLEARCOAT, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsClearcoat.fromMap)
});
