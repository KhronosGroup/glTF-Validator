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

void main() {
  group('Asset', () {
    test('Empty', () async {
      final reader =
          GltfJsonReader(File('test/base/data/asset/empty.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SchemaError.undefinedProperty, args: ['version'])
        ..addIssue(SemanticError.unknownAssetMajorVersion, args: [0]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unknown major version', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/1_0_version.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SemanticError.unknownAssetMajorVersion, args: [1]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unknown minor version', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/2_1_version.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SemanticError.unknownAssetMinorVersion, args: [1]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Invalid version string', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/invalid_version.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SchemaError.patternMismatch,
            name: 'version', args: ['1.0.1-dev', r'^([0-9]+)\.([0-9]+)$'])
        ..addIssue(SemanticError.unknownAssetMajorVersion, args: [0]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/custom_property.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/valid_full.gltf').openRead());

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(
          result.gltf.asset.toString(),
          //ignore: lines_longer_than_80_chars
          '{copyright: Khronos Group Inc., generator: glTF 2.0 Validator test suite, version: 2.0, minVersion: 2.0, extensions: {}}');
    });

    test('Valid minVersion', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/min_version_valid.gltf').openRead());

      final context = Context()
        ..addIssue(SemanticError.unknownAssetMinorVersion,
            name: 'asset', args: [1]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Invalid minVersion', () async {
      final reader = GltfJsonReader(
          File('test/base/data/asset/min_version_invalid.gltf').openRead());

      final context = Context()
        ..path.add('asset')
        ..addIssue(SemanticError.minVersionGreaterThanVersion,
            name: 'minVersion', args: ['2.1', '2.0']);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });
  });
}
