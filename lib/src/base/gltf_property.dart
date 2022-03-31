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

library gltf.base.gltf_property;

import 'package:gltf/src/base/gltf.dart';
import 'package:gltf/src/context.dart';

export 'package:gltf/src/base/gltf.dart';
export 'package:gltf/src/base/members.dart';
export 'package:gltf/src/context.dart';
export 'package:gltf/src/errors.dart';
export 'package:gltf/src/utils.dart';

typedef FromMapFunction<T> = T Function(
    Map<String, Object> map, Context context);

// ignore: one_member_abstracts
abstract class Linkable {
  void link(Gltf gltf, Context context);
}

mixin Usable {
  bool _isUsed = false;

  bool get isUsed => _isUsed;

  void markAsUsed() {
    _isUsed = true;
  }
}

// ignore: one_member_abstracts
abstract class ResourceValidatable {
  void validateResources(Gltf gltf, Context context);
}

abstract class GltfProperty with Usable implements Linkable {
  final Map<String, Object> extensions;
  final Object extras;

  GltfProperty(this.extensions, this.extras);

  @override
  void link(Gltf gltf, Context context) {}
}

abstract class GltfChildOfRootProperty extends GltfProperty {
  final String name;
  GltfChildOfRootProperty(
      this.name, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);
}

abstract class GltfResource implements GltfProperty {
  String get uriString;
  Uri get uri;
}
