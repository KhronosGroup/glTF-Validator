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

library gltf.extensions.khr_texture_transform;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

// EXT_texture_transform
const String KHR_TEXTURE_TRANSFORM = 'KHR_texture_transform';
const String OFFSET = 'offset';

const List<String> KHR_TEXTURE_TRANSFORM_MEMBERS = <String>[
  OFFSET,
  ROTATION,
  SCALE,
  TEX_COORD
];

class KhrTextureTransform extends GltfProperty {
  final List<double> offset;
  final double rotation;
  final List<double> scale;
  final int texCoord;

  KhrTextureTransform._(this.offset, this.rotation, this.scale, this.texCoord,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrTextureTransform fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_TEXTURE_TRANSFORM_MEMBERS, context);
    }

    return KhrTextureTransform._(
        getFloatList(map, OFFSET, context,
            def: const [0.0, 0.0], lengthsList: const [2]),
        getFloat(map, ROTATION, context, def: 0),
        getFloatList(map, SCALE, context,
            def: const [1.0, 1.0], lengthsList: const [2]),
        getUint(map, TEX_COORD, context),
        getExtensions(map, KhrTextureTransform, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is Material) {
        o.texCoordIndices[context.getPointerString()] = texCoord;
        break;
      }
    }
  }
}

const Extension khrTextureTransformExtension =
    Extension(KHR_TEXTURE_TRANSFORM, <Type, ExtensionDescriptor>{
  TextureInfo: ExtensionDescriptor(KhrTextureTransform.fromMap),
  NormalTextureInfo: ExtensionDescriptor(KhrTextureTransform.fromMap),
  OcclusionTextureInfo: ExtensionDescriptor(KhrTextureTransform.fromMap),
});
