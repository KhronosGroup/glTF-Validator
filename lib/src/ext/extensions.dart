/*
 * # Copyright (c) 2016-2019 The Khronos Group Inc.
 * #
 * # Licensed under the Apache License, Version 2.0 (the "License");
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an "AS IS" BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

library gltf.extensions;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/EXT_texture_webp/ext_texture_webp.dart';
import 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
import 'package:gltf/src/ext/KHR_materials_clearcoat/khr_materials_clearcoat.dart';
import 'package:gltf/src/ext/KHR_materials_emissive_strength/khr_materials_emissive_strength.dart';
import 'package:gltf/src/ext/KHR_materials_ior/khr_materials_ior.dart';
import 'package:gltf/src/ext/KHR_materials_iridescence/khr_materials_iridescence.dart';
import 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
import 'package:gltf/src/ext/KHR_materials_sheen/khr_materials_sheen.dart';
import 'package:gltf/src/ext/KHR_materials_specular/khr_materials_specular.dart';
import 'package:gltf/src/ext/KHR_materials_transmission/khr_materials_transmission.dart';
import 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
import 'package:gltf/src/ext/KHR_materials_variants/KHR_materials_variants.dart';
import 'package:gltf/src/ext/KHR_materials_volume/khr_materials_volume.dart';
import 'package:gltf/src/ext/KHR_mesh_quantization/khr_mesh_quantization.dart';
import 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';
import 'package:gltf/src/ext/OMI_collider/omi_collider.dart';
import 'package:gltf/src/ext/OMI_physics_body/omi_physics_body.dart';
import 'package:gltf/src/hash.dart';
import 'package:meta/meta.dart';

export 'package:gltf/src/ext/EXT_texture_webp/ext_texture_webp.dart';
export 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
export 'package:gltf/src/ext/KHR_materials_clearcoat/khr_materials_clearcoat.dart';
export 'package:gltf/src/ext/KHR_materials_emissive_strength/khr_materials_emissive_strength.dart';
export 'package:gltf/src/ext/KHR_materials_ior/khr_materials_ior.dart';
export 'package:gltf/src/ext/KHR_materials_iridescence/khr_materials_iridescence.dart';
export 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
export 'package:gltf/src/ext/KHR_materials_sheen/khr_materials_sheen.dart';
export 'package:gltf/src/ext/KHR_materials_specular/khr_materials_specular.dart'
    hide SPECULAR_FACTOR;
export 'package:gltf/src/ext/KHR_materials_transmission/khr_materials_transmission.dart';
export 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
export 'package:gltf/src/ext/KHR_materials_variants/KHR_materials_variants.dart';
export 'package:gltf/src/ext/KHR_materials_volume/khr_materials_volume.dart';
export 'package:gltf/src/ext/KHR_mesh_quantization/khr_mesh_quantization.dart';
export 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';
export 'package:gltf/src/ext/OMI_collider/omi_collider.dart';
export 'package:gltf/src/ext/OMI_physics_body/omi_physics_body.dart';

class Extension {
  const Extension(this.name, this.functions,
      {this.init, this.required = false});

  final String name;
  final Map<Type, ExtensionDescriptor> functions;
  final void Function(Context) init;
  final bool required;
}

class ExtensionDescriptor {
  final FromMapFunction<Object> fromMap;
  const ExtensionDescriptor(this.fromMap,
      {this.standalone = false, this.localLink = false});
  final bool standalone;
  final bool localLink;
}

@immutable
class ExtensionTuple {
  final Type type;
  final String name;
  const ExtensionTuple(this.type, this.name);

  @override
  int get hashCode => hash2(type.hashCode, name.hashCode);

  @override
  bool operator ==(Object other) =>
      other is ExtensionTuple && name == other.name && type == other.type;
}

class LinkableExtensionEntry {
  final Linkable object;
  final List<String> path;
  LinkableExtensionEntry(this.object, this.path);
}

class ResourceValidatableExtensionEntry {
  final ResourceValidatable object;
  final List<String> path;
  ResourceValidatableExtensionEntry(this.object, this.path);
}

const List<Extension> kDefaultExtensions = <Extension>[
  extTextureWebPExtension,
  khrLightsPunctualExtension,
  khrMaterialsClearcoatExtension,
  khrMaterialsEmissiveStrengthExtension,
  khrMaterialsIorExtension,
  khrMaterialsIridescenceExtension,
  khrMaterialsPbrSpecularGlossinessExtension,
  khrMaterialsSheenExtension,
  khrMaterialsSpecularExtension,
  khrMaterialsTransmissionExtension,
  khrMaterialsUnlitExtension,
  khrMaterialsVariantsExtension,
  khrMaterialsVolumeExtension,
  khrMeshQuantizationExtension,
  khrTextureTransformExtension,
  omiColliderExtension,
  omiPhysicsBodyExtension
];

// https://github.com/KhronosGroup/glTF/blob/main/extensions/Prefixes.md
const Set<String> kReservedPrefixes = <String>{
  'KHR',
  'EXT',
  'ADOBE',
  'AGI',
  'AGT',
  'ALCM',
  'ALI',
  'AMZN',
  'ANIMECH',
  'ASOBO',
  'AVR',
  'BLENDER',
  'CAPTURE',
  'CESIUM',
  'CITRUS',
  'CLO',
  'CVTOOLS',
  'DOTV',
  'EMBARK',
  'EPIC',
  'ESSILORLUXOTTICA',
  'F8',
  'FB',
  'FOXIT',
  'GOOGLE',
  'GRIFFEL',
  'HEVOLUS',
  'INTEL',
  'KDAB',
  'LLQ',
  'MAXAR',
  'MESHOPT',
  'MOZ',
  'MPEG',
  'MSFT',
  'MTTR',
  'MX',
  'NEEDLE',
  'NTAR',
  'NV',
  'OFT',
  'OMI',
  'OTOY',
  'OWLII',
  'PANDA3D',
  'POLUTROPON',
  'PTC',
  'S8S',
  'SE',
  'SEIN',
  'SHAPEDIVER',
  'SI',
  'SKFB',
  'SKYLINE',
  'SNAP',
  'SPECTRUM',
  'TENCENT',
  'TRYON',
  'UNITY',
  'USSF',
  'UX3D',
  'VRMC',
  'VSEKAI',
  'WEB3D'
};
