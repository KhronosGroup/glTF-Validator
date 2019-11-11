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

library gltf.extensions.khr_quantized_geometry;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/gl.dart';

const String KHR_QUANTIZED_GEOMETRY = 'KHR_quantized_geometry';

void _init() {
  attributeAccessorFormats[POSITION].addAll(const [
    AccessorFormat(VEC3, BYTE),
    AccessorFormat(VEC3, BYTE, normalized: true),
    AccessorFormat(VEC3, UNSIGNED_BYTE),
    AccessorFormat(VEC3, UNSIGNED_BYTE, normalized: true),
    AccessorFormat(VEC3, SHORT),
    AccessorFormat(VEC3, SHORT, normalized: true),
    AccessorFormat(VEC3, UNSIGNED_SHORT),
    AccessorFormat(VEC3, UNSIGNED_SHORT, normalized: true)
  ]);

  attributeAccessorFormats[NORMAL].addAll(const [
    AccessorFormat(VEC3, BYTE, normalized: true),
    AccessorFormat(VEC3, SHORT, normalized: true)
  ]);

  attributeAccessorFormats[TANGENT].addAll(const [
    AccessorFormat(VEC4, BYTE, normalized: true),
    AccessorFormat(VEC4, SHORT, normalized: true)
  ]);

  attributeAccessorFormats[TEXCOORD_].addAll(const [
    AccessorFormat(VEC2, BYTE),
    AccessorFormat(VEC2, BYTE, normalized: true),
    AccessorFormat(VEC2, UNSIGNED_BYTE),
    AccessorFormat(VEC2, SHORT),
    AccessorFormat(VEC2, SHORT, normalized: true),
    AccessorFormat(VEC2, UNSIGNED_SHORT)
  ]);
}

const Extension khrQuantizedGeometryExtension = Extension(
    KHR_QUANTIZED_GEOMETRY, <Type, ExtFuncs>{},
    init: _init, required: true);
