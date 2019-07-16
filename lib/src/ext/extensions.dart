/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
 * # Copyright (c) 2016 Alexey Knyazev
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

import 'package:gltf/src/hash.dart';
import 'package:gltf/src/base/gltf_property.dart';

//import 'package:gltf/src/ext/EXT_lights_image_based/ext_lights_image_based.dart';
import 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
import 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
import 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
import 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';
import 'package:gltf/src/ext/cesium_rtc/cesium_rtc.dart';
import 'package:gltf/src/ext/web3d_quantized_attributes/web3d_quantized_attributes.dart';

export 'package:gltf/src/ext/cesium_rtc/cesium_rtc.dart';
export 'package:gltf/src/ext/web3d_quantized_attributes/web3d_quantized_attributes.dart';
//export 'package:gltf/src/ext/EXT_lights_image_based/ext_lights_image_based.dart';
export 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
export 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
export 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
export 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';

class Extension {
  const Extension(this.name, this.functions);

  final String name;
  final Map<Type, ExtFuncs> functions;
}

class ExtFuncs {
  final FromMapFunction<Object> fromMap;
  const ExtFuncs(this.fromMap);
}

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

const List<Extension> kDefaultExtensions = <Extension>[
  khrLightsPunctualExtension,
  khrMaterialsPbrSpecularGlossinessExtension,
  khrMaterialsUnlitExtension,
  khrTextureTransformExtension,
  cesiumRtcExtension,
  web3dQuantizedAttributesExtension
];

// https://github.com/KhronosGroup/glTF/blob/master/extensions/Prefixes.md
const List<String> kReservedPrefixes = <String>[
  'KHR_',
  'EXT_',
  'ADOBE_',
  'AGI_',
  'ALI_',
  'AMZN_',
  'AVR_',
  'BLENDER_',
  'CESIUM_',
  'CVTOOLS_',
  'FB_',
  'GOOGLE_',
  'LLQ_',
  'MESHOPT_',
  'MOZ_',
  'MSFT_',
  'NV_',
  'OWLII_',
  'POLUTROPON_',
  'S8S_',
  'SI_',
  'SKFB_',
  'WEB3D_'
];
