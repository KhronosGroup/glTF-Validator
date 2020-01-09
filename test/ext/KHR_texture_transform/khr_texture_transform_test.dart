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

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';

import '../../utils.dart';

//ignore_for_file: avoid_as

Future main() async {
  await compareReports('test/ext/KHR_texture_transform');

  group('Evaluate valid objects', () {
    test('textureInfo.KHR_texture_transform', () async {
      final gltf = (await read(
              'ext/KHR_texture_transform/data/textureInfo/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final textureTransform = gltf.materials[0].emissiveTexture
          .extensions['KHR_texture_transform'] as KhrTextureTransform;

      expect(textureTransform.offset, [0, 1]);
      expect(textureTransform.scale, [0.5, 0.5]);
      expect(textureTransform.rotation, 1.57079632679);
      expect(textureTransform.texCoord, 1);
      expect(textureTransform.extensions, isEmpty);
    });
  });
}
