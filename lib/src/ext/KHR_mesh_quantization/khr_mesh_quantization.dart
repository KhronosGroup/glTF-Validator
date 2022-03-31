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

library gltf.extensions.khr_mesh_quantization;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/gl.dart' as gl;

const String KHR_MESH_QUANTIZATION = 'KHR_mesh_quantization';

void _init(Context context) {
  context.attributeAccessorFormats[POSITION].addAll(const [
    AccessorFormat(VEC3, gl.BYTE),
    AccessorFormat(VEC3, gl.BYTE, normalized: true),
    AccessorFormat(VEC3, gl.UNSIGNED_BYTE),
    AccessorFormat(VEC3, gl.UNSIGNED_BYTE, normalized: true),
    AccessorFormat(VEC3, gl.SHORT),
    AccessorFormat(VEC3, gl.SHORT, normalized: true),
    AccessorFormat(VEC3, gl.UNSIGNED_SHORT),
    AccessorFormat(VEC3, gl.UNSIGNED_SHORT, normalized: true)
  ]);

  context.attributeAccessorFormats[NORMAL].addAll(const [
    AccessorFormat(VEC3, gl.BYTE, normalized: true),
    AccessorFormat(VEC3, gl.SHORT, normalized: true)
  ]);

  context.attributeAccessorFormats[TANGENT].addAll(const [
    AccessorFormat(VEC4, gl.BYTE, normalized: true),
    AccessorFormat(VEC4, gl.SHORT, normalized: true)
  ]);

  context.attributeAccessorFormats[TEXCOORD_].addAll(const [
    AccessorFormat(VEC2, gl.BYTE),
    AccessorFormat(VEC2, gl.BYTE, normalized: true),
    AccessorFormat(VEC2, gl.UNSIGNED_BYTE),
    AccessorFormat(VEC2, gl.SHORT),
    AccessorFormat(VEC2, gl.SHORT, normalized: true),
    AccessorFormat(VEC2, gl.UNSIGNED_SHORT)
  ]);

  context.morphAttributeAccessorFormats[POSITION].addAll(const [
    AccessorFormat(VEC3, gl.BYTE),
    AccessorFormat(VEC3, gl.BYTE, normalized: true),
    AccessorFormat(VEC3, gl.SHORT),
    AccessorFormat(VEC3, gl.SHORT, normalized: true)
  ]);

  context.morphAttributeAccessorFormats[NORMAL].addAll(const [
    AccessorFormat(VEC3, gl.BYTE, normalized: true),
    AccessorFormat(VEC3, gl.SHORT, normalized: true)
  ]);

  context.morphAttributeAccessorFormats[TANGENT].addAll(const [
    AccessorFormat(VEC3, gl.BYTE, normalized: true),
    AccessorFormat(VEC3, gl.SHORT, normalized: true)
  ]);

  context.morphAttributeAccessorFormats[TEXCOORD_].addAll(
      const [AccessorFormat(VEC2, gl.BYTE), AccessorFormat(VEC2, gl.SHORT)]);
}

const Extension khrMeshQuantizationExtension = Extension(
    KHR_MESH_QUANTIZATION, <Type, ExtensionDescriptor>{},
    init: _init, required: true);
