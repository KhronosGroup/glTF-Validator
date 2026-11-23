// Copyright 2026 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_node_selectability');

  group('Evaluate valid objects', () {
    test('node.KHR_node_selectability', () async {
      final gltf = (await read(
              'ext/KHR_node_selectability/data/node/valid.gltf',
              ignoreUnused: true))
          .gltf;

      final nonSelectableNodeSelectability = gltf.nodes[0]
          .extensions['KHR_node_selectability'] as KhrNodeSelectability;
      expect(nonSelectableNodeSelectability.selectable, isFalse);

      final selectableNodeSelectability = gltf.nodes[1]
          .extensions['KHR_node_selectability'] as KhrNodeSelectability;
      expect(selectableNodeSelectability.selectable, isTrue);

      final emptyExtensionObject = gltf.nodes[2]
          .extensions['KHR_node_selectability'] as KhrNodeSelectability;
      expect(emptyExtensionObject.selectable, isTrue);
    });
  });
}
