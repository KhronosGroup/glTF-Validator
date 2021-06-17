// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_ior;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String KHR_MATERIALS_IOR = 'KHR_materials_ior';

const String IOR = 'ior';

const List<String> KHR_MATERIALS_IOR_MEMBERS = <String>[
  IOR,
];

class KhrMaterialsIor extends GltfProperty {
  final double ior;

  KhrMaterialsIor._(this.ior, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsIor fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_IOR_MEMBERS, context);
    }

    final ior = getFloat(map, IOR, context, min: 1, def: 1.5, standalone: 0);

    final extensions = getExtensions(map, KhrMaterialsIor, context);

    return KhrMaterialsIor._(ior, extensions, getExtras(map, context));
  }
}

const Extension khrMaterialsIorExtension = Extension(
    KHR_MATERIALS_IOR, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsIor.fromMap)
});
