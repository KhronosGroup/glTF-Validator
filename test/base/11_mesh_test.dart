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
  group('Mesh', () {
    test('Empty array', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/empty.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..addIssue(SchemaError.emptyEntity);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Empty object', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/empty_object.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..addIssue(SchemaError.undefinedProperty, args: ['primitives'])
        ..path.removeLast()
        ..path.add('1')
        ..addIssue(SchemaError.typeMismatch,
            name: 'primitives', args: [<Object, Object>{}, 'array'])
        ..path.removeLast()
        ..path.add('2')
        ..addIssue(SchemaError.emptyEntity, name: 'primitives')
        ..path.removeLast()
        ..path.add('3')
        ..addIssue(SchemaError.arrayTypeMismatch,
            name: 'primitives', args: [<Object>[], 'object'])
        ..path.removeLast()
        ..path.add('4')
        ..path.add('primitives')
        ..path.add('0')
        ..addIssue(SchemaError.undefinedProperty, args: ['attributes'])
        ..path.removeLast()
        ..path.add('1')
        ..addIssue(SchemaError.typeMismatch,
            name: 'attributes', args: [<Object>[], 'object'])
        ..addIssue(SchemaError.typeMismatch,
            name: 'targets', args: [<Object, Object>{}, 'array'])
        ..path.removeLast()
        ..path.add('2')
        ..addIssue(SchemaError.emptyEntity, name: 'attributes')
        ..addIssue(SchemaError.emptyEntity, name: 'targets')
        ..path.removeLast()
        ..path.add('3')
        ..addIssue(SchemaError.emptyEntity, name: 'attributes')
        ..addIssue(SchemaError.arrayTypeMismatch,
            name: 'targets', args: [<Object>[], 'object'])
        ..path.removeLast()
        ..path.add('4')
        ..addIssue(SchemaError.emptyEntity, name: 'attributes')
        ..path.add('targets')
        ..addIssue(SchemaError.emptyEntity, index: 0);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Skins', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/skins.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('1')
        ..path.add('primitives')
        ..path.add('1')
        ..addIssue(SemanticError.meshPrimitivesUnequalJointsCount,
            name: 'attributes');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Custom Property', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/custom_property.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Unresolved references', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/unresolved_references.gltf')
              .openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..path.add('primitives')
        ..path.add('0')
        ..addIssue(LinkError.unresolvedReference, name: 'material', args: [0])
        ..addIssue(LinkError.unresolvedReference, name: 'indices', args: [1])
        ..path.add('attributes')
        ..addIssue(LinkError.unresolvedReference, name: 'POSITION', args: [0])
        ..path.removeLast()
        ..path.add('targets')
        ..path.add('0')
        ..addIssue(LinkError.unresolvedReference, name: 'POSITION', args: [2]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Misc', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/misc.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..addIssue(SemanticError.meshInvalidWeightsCount,
            name: 'weights', args: [2, 1])
        ..path.add('primitives')
        ..path.add('1')
        ..addIssue(SemanticError.meshPrimitivesUnequalTargetsCount,
            name: 'targets')
        ..path.add('attributes')
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            args: ['INVALID'])
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            args: ['INVALID_'])
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            args: ['INVALID_1_1'])
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            args: ['INVALID_11'])
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            args: ['INVALID_D'])
        ..addIssue(SemanticError.meshPrimitiveInvalidAttribute, args: [''])
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.add('1')
        ..path.add('primitives')
        ..path.add('0')
        ..path.add('attributes')
        ..addIssue(SemanticError.meshPrimitiveNoPosition)
        ..addIssue(LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
            name: 'NORMAL',
            args: [
              '{VEC2, FLOAT}',
              ['{VEC3, FLOAT}']
            ])
        ..addIssue(LinkError.meshPrimitiveAccessorUnaligned, name: 'TEXCOORD_0')
        ..addIssue(LinkError.meshPrimitiveUnequalAccessorsCount,
            name: 'TEXCOORD_0')
        ..addIssue(LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
            name: 'TEXCOORD_0',
            args: [
              '{VEC2, UNSIGNED_SHORT}',
              [
                '{VEC2, FLOAT}',
                '{VEC2, UNSIGNED_BYTE normalized}',
                '{VEC2, UNSIGNED_SHORT normalized}'
              ]
            ])
        ..addIssue(LinkError.meshPrimitiveAccessorUnaligned, name: 'TEXCOORD_1')
        ..addIssue(LinkError.meshPrimitiveAccessorWithoutByteStride,
            name: 'TEXCOORD_1')
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.add('2')
        ..path.add('primitives')
        ..path.add('0')
        ..path.add('attributes')
        ..addIssue(SemanticError.meshPrimitiveTangentWithoutNormal)
        ..addIssue(SemanticError.meshPrimitiveTangentPoints)
        ..addIssue(SemanticError.meshPrimitiveJointsWeightsMismatch)
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.add('3')
        ..path.add('primitives')
        ..path.add('0')
        ..path.add('attributes')
        ..addIssue(LinkError.meshPrimitiveAccessorWithoutByteStride,
            name: 'NORMAL');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Indices', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/indices.gltf').openRead());

      final result = await reader.read();

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..path.add('primitives')
        ..path.add('0')
        ..addIssue(LinkError.meshPrimitiveIncompatibleMode,
            args: [4, 'TRIANGLES'])
        ..path.removeLast()
        ..path.add('1')
        ..addIssue(LinkError.bufferViewTargetOverride,
            name: 'indices', args: ['VertexBuffer', 'IndexBuffer'])
        ..addIssue(LinkError.meshPrimitiveIndicesAccessorWithByteStride,
            name: 'indices')
        ..addIssue(LinkError.meshPrimitiveIndicesAccessorInvalidFormat,
            name: 'indices',
            args: [
              '{SCALAR, FLOAT}',
              [
                '{SCALAR, UNSIGNED_BYTE}',
                '{SCALAR, UNSIGNED_SHORT}',
                '{SCALAR, UNSIGNED_INT}'
              ]
            ]);

      expect(reader.context.issues, unorderedMatches(context.issues));
      expect(result.gltf.meshes.first.primitives[0].count, 4);
      expect(result.gltf.meshes.first.primitives[1].count, 6);
    });

    test('Morphs', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/morphs.gltf').openRead());

      await reader.read();

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..path.add('primitives')
        ..path.add('0')
        ..path.add('attributes')
        ..addIssue(LinkError.meshPrimitivePositionAccessorWithoutBounds,
            name: 'POSITION')
        ..path.removeLast()
        ..path.add('targets')
        ..path.add('0')
        ..addIssue(LinkError.meshPrimitivePositionAccessorWithoutBounds,
            name: 'POSITION')
        ..addIssue(LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
            name: 'POSITION',
            args: [
              '{VEC4, FLOAT}',
              ['{VEC3, FLOAT}']
            ])
        ..path.removeLast()
        ..path.removeLast()
        ..path.removeLast()
        ..path.add('1')
        ..path.add('targets')
        ..path.add('0')
        ..addIssue(LinkError.meshPrimitiveMorphTargetNoBaseAccessor,
            name: 'NORMAL')
        ..addIssue(LinkError.meshPrimitiveMorphTargetInvalidAttributeCount,
            name: 'POSITION');

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('UV Bindings', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/uv.gltf').openRead());

      final context = new Context()
        ..path.add('meshes')
        ..path.add('0')
        ..path.add('primitives')
        ..path.add('1')
        ..addIssue(SemanticError.meshPrimitiveIndexedSemanticContinuity,
            name: 'attributes', args: ['TEXCOORD'])
        ..path.removeLast()
        ..path.add('0')
        ..path.add('material')
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords,
            args: ['/materials/0/pbrMetallicRoughness/baseColorTexture', 1])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords, args: [
          '/materials/0/pbrMetallicRoughness/metallicRoughnessTexture',
          1
        ])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords,
            args: ['/materials/0/normalTexture', 1])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords,
            args: ['/materials/0/occlusionTexture', 1])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords,
            args: ['/materials/0/emissiveTexture', 1])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords, args: [
          '/materials/0/extensions/KHR_materials_pbrSpecularGlossiness/diffuseTexture',
          1
        ])
        ..addIssue(LinkError.meshPrimitiveTooFewTexcoords, args: [
          '/materials/0/extensions/KHR_materials_pbrSpecularGlossiness/specularGlossinessTexture',
          1
        ]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = new GltfJsonReader(
          new File('test/base/data/mesh/valid_full.gltf').openRead());

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(result.gltf.meshes.toString(),
          '[{primitives: [{attributes: {POSITION: 1}, indices: 0, material: 0, mode: 4, targets: [{POSITION: 2}, {POSITION: 3}], extensions: {}}], weights: [0.7, 0.2], extensions: {}}]');
    });
  });
}
