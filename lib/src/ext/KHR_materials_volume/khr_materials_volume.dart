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

        if (o.doubleSided && thicknessFactor > 0) {
          context.addIssue(SemanticError.khrMaterialsVolumeDoubleSided);
        }
        break;
      }
    }
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_MATERIALS_VOLUME) {
      return PointerValidity.unknown;
    }
    final mat = prop as Material;
    if (mat == null) {
      return PointerValidity.invalid;
    }
    if (mat.extensions == null ||
        !mat.extensions.containsKey(KHR_MATERIALS_VOLUME)) {
      return PointerValidity.invalid;
    }
    final volumeExt =
        mat.extensions[KHR_MATERIALS_VOLUME] as KhrMaterialsVolume;
    final subProp = pointer[inPropDepth + 2];
    switch (subProp) {
      case THICKNESS_FACTOR:
      case ATTENUATION_DISTANCE:
        return PointerValidity.validIfScalar;
      case ATTENUATION_COLOR:
        if (volumeExt.attenuationColor == null ||
            volumeExt.attenuationColor.length != 3) {
          return PointerValidity.invalid;
        }
        return PointerValidity.validIfVec3;
      case THICKNESS_TEXTURE:
        if (volumeExt.thicknessTexture == null) {
          return PointerValidity.invalid;
        }
        // KHR_materials_volume can be used with KHR_texture_transform.
        return KhrTextureTransform.validateExtensionPointer(
            context, pointer, volumeExt.thicknessTexture, inPropDepth + 3);
    }
    return PointerValidity.unknown;
  }
}

const Extension khrMaterialsVolumeExtension = Extension(
    KHR_MATERIALS_VOLUME,
    <Type, ExtensionDescriptor>{
      Material: ExtensionDescriptor(KhrMaterialsVolume.fromMap)
    },
    validateExtensionPointer: KhrMaterialsVolume.validateExtensionPointer);
