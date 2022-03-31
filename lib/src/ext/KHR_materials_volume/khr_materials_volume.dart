// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_volume;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_MATERIALS_VOLUME = 'KHR_materials_volume';

const String ATTENUATION_COLOR = 'attenuationColor';
const String ATTENUATION_DISTANCE = 'attenuationDistance';
const String THICKNESS_FACTOR = 'thicknessFactor';
const String THICKNESS_TEXTURE = 'thicknessTexture';

const List<String> KHR_MATERIALS_VOLUME_MEMBERS = <String>[
  ATTENUATION_COLOR,
  ATTENUATION_DISTANCE,
  THICKNESS_FACTOR,
  THICKNESS_TEXTURE,
];

class KhrMaterialsVolume extends GltfProperty {
  final List<double> attenuationColor;
  final double attenuationDistance;
  final double thicknessFactor;
  final TextureInfo thicknessTexture;

  KhrMaterialsVolume._(
      this.attenuationColor,
      this.attenuationDistance,
      this.thicknessFactor,
      this.thicknessTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static KhrMaterialsVolume fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_VOLUME_MEMBERS, context);
    }

    final attenuationColor = getFloatList(map, ATTENUATION_COLOR, context,
        lengthsList: const [3], min: 0, max: 1, def: const [1, 1, 1]);

    final attenuationDistance =
        getFloat(map, ATTENUATION_DISTANCE, context, exclMin: 0);

    final thicknessFactor =
        getFloat(map, THICKNESS_FACTOR, context, min: 0, def: 0);

    final thicknessTexture = getObjectFromInnerMap<TextureInfo>(
        map, THICKNESS_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, KhrMaterialsVolume, context);

    final volume = KhrMaterialsVolume._(attenuationColor, attenuationDistance,
        thicknessFactor, thicknessTexture, extensions, getExtras(map, context));

    context
        .registerObjectsOwner(volume, [thicknessTexture, ...extensions.values]);

    return volume;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (thicknessTexture != null) {
      context.path.add(THICKNESS_TEXTURE);
      thicknessTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (!context.validate) {
      return;
    }

    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is Material) {
        // The volume extension needs to be combined with an extension
        // that allows light to transmit through the surface.
        // Also suppress the warning when an unknown extension is present.
        if (!o.extensions.containsKey(KHR_MATERIALS_TRANSMISSION) &&
            !o.extensions.values.any((e) => e is Map)) {
          context.addIssue(SemanticError.khrMaterialsVolumeNoTransmission);
        }
        break;
      }
    }
  }
}

const Extension khrMaterialsVolumeExtension = Extension(
    KHR_MATERIALS_VOLUME, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsVolume.fromMap)
});
