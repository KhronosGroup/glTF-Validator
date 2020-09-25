// Copyright 2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_transmission;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String KHR_MATERIALS_TRANSMISSION = 'KHR_materials_transmission';

const String TRANSMISSION_FACTOR = 'transmissionFactor';
const String TRANSMISSION_TEXTURE = 'transmissionTexture';

const List<String> KHR_MATERIALS_TRANSMISSION_MEMBERS = <String>[
  TRANSMISSION_FACTOR,
  TRANSMISSION_TEXTURE,
];

class KhrMaterialsTransmission extends GltfProperty {
  final double transmissionFactor;
  final TextureInfo transmissionTexture;

  KhrMaterialsTransmission._(this.transmissionFactor, this.transmissionTexture,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsTransmission fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_TRANSMISSION_MEMBERS, context);
    }

    final transmissionFactor =
        getFloat(map, TRANSMISSION_FACTOR, context, min: 0, max: 1, def: 0);
    final transmissionTexture = getObjectFromInnerMap<TextureInfo>(
        map, TRANSMISSION_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsTransmission, context);

    final transmission = KhrMaterialsTransmission._(transmissionFactor,
        transmissionTexture, extensions, getExtras(map, context));

    context.registerObjectsOwner(
        transmission, [transmissionTexture, ...extensions.values]);

    return transmission;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (transmissionTexture != null) {
      context.path.add(TRANSMISSION_TEXTURE);
      transmissionTexture.link(gltf, context);
      context.path.removeLast();
    }
  }
}

const Extension khrMaterialsTransmissionExtension = Extension(
    KHR_MATERIALS_TRANSMISSION, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsTransmission.fromMap)
});
