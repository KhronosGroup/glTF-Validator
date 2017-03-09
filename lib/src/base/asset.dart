/*
 * # Copyright (c) 2016 The Khronos Group Inc.
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

library gltf.core.asset;

import 'gltf_property.dart';

class Asset extends GltfProperty {
  final String copyright;
  final String generator;
  final String version;

  Asset._(this.copyright, this.generator,
      this.version, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({
        COPYRIGHT: copyright,
        GENERATOR: generator,
        VERSION: version
      });

  static Asset fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ASSET_MEMBERS, context);

    return new Asset._(
        getString(map, COPYRIGHT, context),
        getString(map, GENERATOR, context),
        getString(map, VERSION, context, req: true, list: ["2.0"]),
        getExtensions(map, Asset, context),
        getExtras(map));
  }
}
