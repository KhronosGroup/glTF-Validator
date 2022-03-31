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

library gltf.base.texture;

import 'package:gltf/src/base/gltf_property.dart';

class Texture extends GltfChildOfRootProperty implements ResourceValidatable {
  final int _samplerIndex;
  final int _sourceIndex;

  Sampler _sampler;
  Image _source;

  Texture._(this._samplerIndex, this._sourceIndex, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  Sampler get sampler => _sampler;
  Image get source => _source;

  static Texture fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, TEXTURE_MEMBERS, context);
    }

    return Texture._(
        getIndex(map, SAMPLER, context, req: false),
        getIndex(map, SOURCE, context, req: false),
        getName(map, context),
        getExtensions(map, Texture, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    _source = gltf.images[_sourceIndex];
    _sampler = gltf.samplers[_samplerIndex];

    if (context.validate) {
      if (_sourceIndex != -1) {
        if (_source == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: SOURCE, args: [_sourceIndex]);
        } else {
          _source.markAsUsed();
        }
      }

      if (_samplerIndex != -1) {
        if (_sampler == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: SAMPLER, args: [_samplerIndex]);
        } else {
          _sampler.markAsUsed();
        }
      }
    }
  }

  @override
  void validateResources(Gltf gltf, Context context) {
    // The core spec allows only JPEG and PNG.
    const types = [IMAGE_JPEG, IMAGE_PNG];
    final mimeType = _source?.mimeType ?? _source?.info?.mimeType;
    if (mimeType != null && !types.contains(mimeType)) {
      context.addIssue(LinkError.textureInvalidImageMimeType,
          name: SOURCE, args: [mimeType, types]);
    }
  }
}
