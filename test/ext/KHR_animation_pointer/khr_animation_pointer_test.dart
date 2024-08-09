// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:gltf/gltf.dart';
import 'package:test/test.dart';

import '../../utils.dart';

Future main() async {
  await compareReports('test/ext/KHR_animation_pointer');

  group('Evaluate valid objects', () {
    test('animation.channel.target.KHR_animation_pointer', () async {
      final gltf = (await read(
              'ext/KHR_animation_pointer/data/animation/channel/target/valid.gltf',
              ignoreUnused: true,
              ignoreIncomplete: true))
          .gltf;

      final target0 = gltf.animations[0].channels[0].target;
      expect(target0.node, isNull);
      expect(target0.path, 'pointer');
      final pointer0 =
          target0.extensions['KHR_animation_pointer'] as KhrAnimationPointer;
      expect(pointer0.pointer,
          '/materials/0/pbrMetallicRoughness/baseColorFactor');
      expect(pointer0.extensions, isEmpty);

      final target1 = gltf.animations[0].channels[1].target;
      expect(target1.node, isNull);
      expect(target1.path, 'pointer');
      final pointer1 =
          target1.extensions['KHR_animation_pointer'] as KhrAnimationPointer;
      expect(pointer1.pointer,
          '/materials/0/pbrMetallicRoughness/roughnessFactor');
      expect(pointer1.extensions, isEmpty);
    });
  });
}
