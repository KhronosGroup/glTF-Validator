// Copyright 2026 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_retroreflection;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_RETROREFLECTION = 'KHR_materials_retroreflection';

const String RETROREFLECTION_FACTOR = 'retroreflectionFactor';
const String RETROREFLECTION_TEXTURE = 'retroreflectionTexture';

const List<String> KHR_MATERIALS_RETROREFLECTION_MEMBERS = <String>[
  RETROREFLECTION_FACTOR,
  RETROREFLECTION_TEXTURE,
];

class KhrMaterialsRetroreflection extends GltfProperty {
  final double retroreflectionFactor;
  final TextureInfo retroreflectionTexture;

  KhrMaterialsRetroreflection._(
      this.retroreflectionFactor,
      this.retroreflectionTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsRetroreflection fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_RETROREFLECTION_MEMBERS, context);
    }

    final retroreflectionFactor =
        getFloat(map, RETROREFLECTION_FACTOR, context, min: 0, max: 1, def: 0);
    final retroreflectionTexture = getObjectFromInnerMap<TextureInfo>(
        map, RETROREFLECTION_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsRetroreflection, context);

    final retroreflection = KhrMaterialsRetroreflection._(retroreflectionFactor,
        retroreflectionTexture, extensions, getExtras(map, context));

    context.registerObjectsOwner(
        retroreflection, [retroreflectionTexture, ...extensions.values]);

    return retroreflection;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (retroreflectionTexture != null) {
      context.path.add(RETROREFLECTION_TEXTURE);
      retroreflectionTexture.link(gltf, context);
      context.path.removeLast();
    }
  }
}

const Extension khrMaterialsRetroreflectionExtension = Extension(
    KHR_MATERIALS_RETROREFLECTION, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsRetroreflection.fromMap)
});
