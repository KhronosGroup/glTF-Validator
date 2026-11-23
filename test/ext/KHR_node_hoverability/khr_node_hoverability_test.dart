// Copyright 2026 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_node_hoverability');

  group('Evaluate valid objects', () {
    test('node.KHR_node_hoverability', () async {
      final gltf = (await read('ext/KHR_node_hoverability/data/node/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final nonHoverableNodeHoverability = gltf
          .nodes[0].extensions['KHR_node_hoverability'] as KhrNodeHoverability;
      expect(nonHoverableNodeHoverability.hoverable, isFalse);

      final hoverableNodeHoverability = gltf
          .nodes[1].extensions['KHR_node_hoverability'] as KhrNodeHoverability;
      expect(hoverableNodeHoverability.hoverable, isTrue);

      final emptyExtensionObject = gltf
          .nodes[2].extensions['KHR_node_hoverability'] as KhrNodeHoverability;
      expect(emptyExtensionObject.hoverable, isTrue);
    });
  });
}
