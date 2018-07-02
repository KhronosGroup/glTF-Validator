/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
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

import 'dart:io';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';

import '../utils.dart';

void main() {
  group('Scene', () {
    test('Empty array', () async {
      final reader =
          GltfJsonReader(File('test/base/data/scene/empty.gltf').openRead());

      final context = Context()
        ..path.add('scenes')
        ..addIssue(SchemaError.emptyEntity);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/base/data/scene/custom_property.gltf').openRead());

      final context = Context()
        ..path.add('scenes')
        ..path.add('0')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unresolved references', () async {
      final reader = GltfJsonReader(
          File('test/base/data/scene/unresolved_references.gltf').openRead());

      final context = Context()
        ..addIssue(LinkError.unresolvedReference, name: 'scene', args: [1])
        ..path.add('scenes')
        ..path.add('0')
        ..path.add('nodes')
        ..addIssue(LinkError.unresolvedReference, index: 0, args: [0]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Misc', () async {
      final reader = GltfJsonReader(
          File('test/base/data/scene/misc.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('scenes')
        ..path.add('0')
        ..addIssue(SchemaError.emptyEntity, name: 'nodes')
        ..path.removeLast()
        ..path.add('1')
        ..path.add('nodes')
        ..addIssue(LinkError.sceneNonRootNode, index: 0, args: [1])
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.add('nodes')
        ..addIssue(SemanticError.nodeEmpty, index: 1);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/base/data/scene/valid_full.gltf').openRead());

      final result = await reader.read();

      final context = Context()
        ..path.add('nodes')
        ..path.add('0')
        ..addIssue(SemanticError.nodeEmpty);

      expect(reader.context.issues, unorderedMatches(context.issues));

      expect(result.gltf.scenes.toString(), '[{nodes: [0], extensions: {}}]');
    });
  });
}
