// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_specular;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String KHR_MATERIALS_SPECULAR = 'KHR_materials_specular';

const String SPECULAR_FACTOR = 'specularFactor';
const String SPECULAR_TEXTURE = 'specularTexture';
const String SPECULAR_COLOR_FACTOR = 'specularColorFactor';
const String SPECULAR_COLOR_TEXTURE = 'specularColorTexture';

const List<String> KHR_MATERIALS_SPECULAR_MEMBERS = <String>[
  SPECULAR_FACTOR,
  SPECULAR_TEXTURE,
  SPECULAR_COLOR_FACTOR,
  SPECULAR_COLOR_TEXTURE
];

class KhrMaterialsSpecular extends GltfProperty {
  final double specularFactor;
  final TextureInfo specularTexture;

  final List<double> specularColorFactor;
  final TextureInfo specularColorTexture;

  KhrMaterialsSpecular._(
      this.specularFactor,
      this.specularTexture,
      this.specularColorFactor,
      this.specularColorTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsSpecular fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_SPECULAR_MEMBERS, context);
    }

    final specularFactor =
        getFloat(map, SPECULAR_FACTOR, context, min: 0, max: 1, def: 1);
    final specularTexture = getObjectFromInnerMap<TextureInfo>(
        map, SPECULAR_TEXTURE, context, TextureInfo.fromMap);

    final specularColorFactor = getFloatList(
        map, SPECULAR_COLOR_FACTOR, context,
        lengthsList: const [3], min: 0, def: const [1, 1, 1]);
    final specularColorTexture = getObjectFromInnerMap<TextureInfo>(
        map, SPECULAR_COLOR_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsSpecular, context);

    final specular = KhrMaterialsSpecular._(
        specularFactor,
        specularTexture,
        specularColorFactor,
        specularColorTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(specular,
        [specularTexture, specularColorTexture, ...extensions.values]);

    return specular;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (specularTexture != null) {
      context.path.add(SPECULAR_TEXTURE);
      specularTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (specularColorTexture != null) {
      context.path.add(SPECULAR_COLOR_TEXTURE);
      specularColorTexture.link(gltf, context);
      context.path.removeLast();
    }
  }
}

const Extension khrMaterialsSpecularExtension = Extension(
    KHR_MATERIALS_SPECULAR, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsSpecular.fromMap)
});
