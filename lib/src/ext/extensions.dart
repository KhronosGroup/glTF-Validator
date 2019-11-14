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

import 'package:gltf/src/hash.dart';
import 'package:gltf/src/base/gltf_property.dart';

import 'package:gltf/src/ext/EXT_texture_webp/ext_texture_webp.dart';
import 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
import 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
import 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
import 'package:gltf/src/ext/KHR_mesh_quantization/khr_mesh_quantization.dart';
import 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';
import 'package:meta/meta.dart';

export 'package:gltf/src/ext/EXT_texture_webp/ext_texture_webp.dart';
export 'package:gltf/src/ext/KHR_lights_punctual/khr_lights_punctual.dart';
export 'package:gltf/src/ext/KHR_materials_pbrSpecularGlossiness/khr_materials_pbr_specular_glossiness.dart';
export 'package:gltf/src/ext/KHR_materials_unlit/khr_materials_unlit.dart';
export 'package:gltf/src/ext/KHR_mesh_quantization/khr_mesh_quantization.dart';
export 'package:gltf/src/ext/KHR_texture_transform/khr_texture_transform.dart';

class Extension {
  const Extension(this.name, this.functions,
      {this.init, this.required = false});

  final String name;
  final Map<Type, ExtFuncs> functions;
  final void Function() init;
  final bool required;
}

class ExtFuncs {
  final FromMapFunction<Object> fromMap;
  const ExtFuncs(this.fromMap);
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
  khrMaterialsPbrSpecularGlossinessExtension,
  khrMaterialsUnlitExtension,
  khrMeshQuantizationExtension,
  khrTextureTransformExtension
];

// https://github.com/KhronosGroup/glTF/blob/master/extensions/Prefixes.md
const Set<String> kReservedPrefixes = <String>{
  'KHR',
  'EXT',
  'ADOBE',
  'AGI',
  'AGT',
  'ALI',
  'AMZN',
  'AVR',
  'BLENDER',
  'CESIUM',
  'CVTOOLS',
  'FB',
  'GOOGLE',
  'LLQ',
  'MESHOPT',
  'MOZ',
  'MSFT',
  'NV',
  'OWLII',
  'POLUTROPON',
  'S8S',
  'SI',
  'SKFB',
  'WEB3D'
};
