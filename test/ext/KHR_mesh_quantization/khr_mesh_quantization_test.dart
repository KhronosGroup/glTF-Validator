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

import 'dart:async';

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_mesh_quantization');

  group('Evaluate valid objects', () {
    test('mesh.primitive', () async {
      final gltf = (await read(
              'ext/KHR_mesh_quantization/data/primitive/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final attributes = gltf.meshes[0].primitives[0].attributes;
      expect(AccessorFormat.fromAccessor(attributes['POSITION']),
          const AccessorFormat('VEC3', gl.UNSIGNED_BYTE, normalized: true));
    });
  });
}
