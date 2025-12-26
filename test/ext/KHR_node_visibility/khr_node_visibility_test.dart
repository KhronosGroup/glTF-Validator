/*
 * # Copyright (c) 2016-2026 The Khronos Group Inc.
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

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_node_visibility');

  group('Evaluate valid objects', () {
    test('node.KHR_node_visibility', () async {
      final gltf = (await read('ext/KHR_node_visibility/data/node/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final invisibleNodeVisibility =
          gltf.nodes[0].extensions['KHR_node_visibility'] as KhrNodeVisibility;
      expect(invisibleNodeVisibility.visible, isFalse);

      final visibleNodeVisibility =
          gltf.nodes[1].extensions['KHR_node_visibility'] as KhrNodeVisibility;
      expect(visibleNodeVisibility.visible, isTrue);

      final emptyExtensionObject =
          gltf.nodes[2].extensions['KHR_node_visibility'] as KhrNodeVisibility;
      expect(emptyExtensionObject.visible, isTrue);
    });
  });
}
