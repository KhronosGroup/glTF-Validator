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

library gltf.extensions.khr_materials_unlit;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String KHR_MATERIALS_UNLIT = 'KHR_materials_unlit';

const List<String> KHR_MATERIALS_UNLIT_MEMBERS = <String>[];

class KhrMaterialsUnlit extends GltfProperty {
  KhrMaterialsUnlit._(Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsUnlit fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_UNLIT_MEMBERS, context);
    }

    final extensions = getExtensions(map, KhrMaterialsUnlit, context);

    return KhrMaterialsUnlit._(extensions, getExtras(map, context));
  }
}

const Extension khrMaterialsUnlitExtension = Extension(
    KHR_MATERIALS_UNLIT, <Type, ExtensionDescriptor>{
  Material: ExtensionDescriptor(KhrMaterialsUnlit.fromMap, standalone: true)
});
