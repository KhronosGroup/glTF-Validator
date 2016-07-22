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
  final bool premultipliedAlpha;
  final AssetProfile profile;
  final String version;

  Asset._(this.copyright, this.generator, this.premultipliedAlpha, this.profile,
      this.version, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({
        COPYRIGHT: copyright,
        GENERATOR: generator,
        PREMULTIPLIED_ALPHA: premultipliedAlpha,
        PROFILE: profile,
        VERSION: version
      });

  static Asset fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ASSET_MEMBERS, context);

    context.path.add(PROFILE);
    final profile =
        AssetProfile.fromMap(getMap(map, PROFILE, context), context);
    context.path.removeLast();

    return new Asset._(
        getString(map, COPYRIGHT, context),
        getString(map, GENERATOR, context),
        getBool(map, PREMULTIPLIED_ALPHA, context),
        profile,
        getString(map, VERSION, context, req: true),
        getExtensions(map, Asset, context),
        getExtras(map));
  }
}

class AssetProfile extends GltfProperty {
  static const String WEBGL = "WebGL";
  static const String V1_0_3 = "1.0.3";

  final String api;
  final String version;

  AssetProfile._(
      this.api, this.version, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({API: api, VERSION: version});

  static AssetProfile fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ASSET_PROFILE_MEMBERS, context);

    return new AssetProfile._(
        getString(map, API, context, def: WEBGL),
        getString(map, VERSION, context, def: V1_0_3),
        getExtensions(map, AssetProfile, context),
        getExtras(map));
  }
}
