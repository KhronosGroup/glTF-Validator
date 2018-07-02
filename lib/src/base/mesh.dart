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

library gltf.base.mesh;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

class Mesh extends GltfChildOfRootProperty {
  final SafeList<MeshPrimitive> primitives;
  final List<double> weights;

  Mesh._(this.primitives, this.weights, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  @override
  String toString([_]) =>
      super.toString({PRIMITIVES: primitives, WEIGHTS: weights});

  static Mesh fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, MESH_MEMBERS, context);
    }

    final weights = getFloatList(map, WEIGHTS, context);

    final primitivesMaps = getMapList(map, PRIMITIVES, context);

    SafeList<MeshPrimitive> primitives;
    if (primitivesMaps != null) {
      primitives = SafeList<MeshPrimitive>(primitivesMaps.length, PRIMITIVES);

      context.path.add(PRIMITIVES);
      int targetsCount;
      var jointsCount = -1;
      for (var i = 0; i < primitivesMaps.length; i++) {
        context.path.add(i.toString());
        final primitive = MeshPrimitive.fromMap(primitivesMaps[i], context);
        if (context.validate) {
          if (targetsCount == null) {
            targetsCount = primitive._targetsIndices?.length;
          } else if (targetsCount != primitive._targetsIndices?.length) {
            context.addIssue(SemanticError.meshPrimitivesUnequalTargetsCount,
                name: TARGETS);
          }

          if (jointsCount == -1) {
            jointsCount = primitive.jointsCount;
          } else if (jointsCount != primitive.jointsCount) {
            context.addIssue(SemanticError.meshPrimitivesUnequalJointsCount,
                name: ATTRIBUTES);
          }
        }
        primitives[i] = primitive;
        context.path.removeLast();
      }
      context.path.removeLast();

      if (context.validate &&
          targetsCount != null &&
          weights != null &&
          targetsCount != weights.length) {
        context.addIssue(SemanticError.meshInvalidWeightsCount,
            name: WEIGHTS, args: [weights.length, targetsCount]);
      }
    }

    return Mesh._(primitives, weights, getName(map, context),
        getExtensions(map, Mesh, context), getExtras(map));
  }

  @override
  void link(Gltf gltf, Context context) {
    context.path.add(PRIMITIVES);
    primitives?.forEachWithIndices((i, primitive) {
      context.path.add(i.toString());
      primitive.link(gltf, context);
      context.path.removeLast();
    });
    context.path.removeLast();
  }
}

class MeshPrimitive extends GltfProperty {
  final Map<String, int> _attributesIndices;
  final int _indicesIndex;
  final int _materialIndex;
  final int mode;
  final List<Map<String, int>> _targetsIndices;

  final bool hasPosition;
  final bool hasNormal;
  final bool hasTangent;
  final int colorCount;
  final int jointsCount;
  final int weigthsCount;
  final int texcoordCount;

  final Map<String, Accessor> attributes = <String, Accessor>{};

  int _count = -1;
  int _vertexCount = -1;
  List<Map<String, Accessor>> _targets;
  Accessor _indices;
  Material _material;

  MeshPrimitive._(
      this._attributesIndices,
      this._indicesIndex,
      this._materialIndex,
      this.mode,
      this._targetsIndices,
      this.hasPosition,
      this.hasNormal,
      this.hasTangent,
      this.colorCount,
      this.jointsCount,
      this.weigthsCount,
      this.texcoordCount,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  factory MeshPrimitive.fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, MESH_PRIMITIVE_MEMBERS, context);
    }

    var hasPosition = false;
    var hasNormal = false;
    var hasTangent = false;

    var colorCount = 0;
    var maxColor = -1;
    var jointsCount = 0;
    var maxJoints = -1;
    var weightsCount = 0;
    var maxWeights = -1;
    var texcoordCount = 0;
    var maxTexcoord = -1;

    void checkAttributeSemanticName(String semantic) {
      // Skip on custom semantics
      if (semantic.isNotEmpty && semantic.codeUnitAt(0) == 95 /*underscore*/) {
        return;
      }

      switch (semantic) {
        case POSITION:
          hasPosition = true;
          break;
        case NORMAL:
          hasNormal = true;
          break;
        case TANGENT:
          hasTangent = true;
          break;
        default:
          final semParts = semantic.split('_');
          final arraySemantic = semParts[0];

          if (!ATTRIBUTE_SEMANTIC_ARRAY_MEMBERS.contains(arraySemantic) ||
              semParts.length != 2 ||
              semParts[1].length != 1 ||
              semParts[1].codeUnitAt(0) < 48 /* 0 */ ||
              semParts[1].codeUnitAt(0) > 57) /* 9 */ {
            context.addIssue(SemanticError.meshPrimitiveInvalidAttribute,
                args: [semantic]);
          } else {
            final index = semParts[1].codeUnitAt(0) - 48;
            switch (arraySemantic) {
              case COLOR_:
                colorCount++;
                maxColor = index > maxColor ? index : maxColor;
                break;
              case JOINTS_:
                jointsCount++;
                maxJoints = index > maxJoints ? index : maxJoints;
                break;
              case TEXCOORD_:
                texcoordCount++;
                maxTexcoord = index > maxTexcoord ? index : maxTexcoord;
                break;
              case WEIGHTS_:
                weightsCount++;
                maxWeights = index > maxWeights ? index : maxWeights;
                break;
            }
          }
      }
    }

    final mode = getUint(map, MODE, context,
        min: gl.POINTS, max: gl.TRIANGLE_FAN, def: gl.TRIANGLES);

    final attributes =
        getIndicesMap(map, ATTRIBUTES, context, checkAttributeSemanticName);

    if (attributes != null) {
      context.path.add(ATTRIBUTES);
      if (!hasPosition) {
        context.addIssue(SemanticError.meshPrimitiveNoPosition);
      }

      if (!hasNormal && hasTangent) {
        context.addIssue(SemanticError.meshPrimitiveTangentWithoutNormal);
      }

      if (hasTangent && mode == gl.POINTS) {
        context.addIssue(SemanticError.meshPrimitiveTangentPoints);
      }

      if (jointsCount != weightsCount) {
        context.addIssue(SemanticError.meshPrimitiveJointsWeightsMismatch);
      }

      void checkContinuity(int maxIndex, int count, String name) {
        if (maxIndex + 1 != count) {
          context.addIssue(SemanticError.meshPrimitiveIndexedSemanticContinuity,
              args: [name]);
        }
      }

      checkContinuity(maxColor, colorCount, COLOR_);
      checkContinuity(maxJoints, jointsCount, JOINTS_);
      checkContinuity(maxWeights, weightsCount, WEIGHTS_);
      checkContinuity(maxTexcoord, texcoordCount, TEXCOORD_);

      context.path.removeLast();
    }

    final targets =
        getIndicesMapsList(map, TARGETS, context, checkAttributeSemanticName);

    return MeshPrimitive._(
        attributes,
        getIndex(map, INDICES, context, req: false),
        getIndex(map, MATERIAL, context, req: false),
        mode,
        targets,
        hasPosition,
        hasNormal,
        hasTangent,
        colorCount,
        jointsCount,
        weightsCount,
        texcoordCount,
        getExtensions(map, MeshPrimitive, context),
        getExtras(map));
  }

  int get count => _count;
  int get vertexCount => _vertexCount;
  List<Map<String, Accessor>> get targets => _targets;
  Accessor get indices => _indices;
  Material get material => _material;

  @override
  String toString([_]) => super.toString({
        ATTRIBUTES: _attributesIndices,
        INDICES: _indicesIndex,
        MATERIAL: _materialIndex,
        MODE: mode,
        TARGETS: _targetsIndices
      });

  @override
  void link(Gltf gltf, Context context) {
    if (_attributesIndices != null) {
      context.path.add(ATTRIBUTES);
      _attributesIndices.forEach((semantic, accessorIndex) {
        if (accessorIndex == -1) {
          return;
        }

        final accessor = gltf.accessors[accessorIndex];

        if (accessor == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: semantic, args: [accessorIndex]);
          return;
        }

        attributes[semantic] = accessor;

        accessor.setUsage(AccessorUsage.VertexAttribute, semantic, context);
        accessor.bufferView
            ?.setUsage(BufferViewUsage.VertexBuffer, semantic, context);

        if (semantic == NORMAL) {
          accessor.setUnit();
        } else if (semantic == TANGENT) {
          accessor
            ..setUnit()
            ..setXyzSign();
        }

        if (context.validate) {
          if (semantic == POSITION &&
              (accessor.min == null || accessor.max == null)) {
            context.addIssue(
                LinkError.meshPrimitivePositionAccessorWithoutBounds,
                name: POSITION);
          }

          final format = AccessorFormat.fromAccessor(accessor);
          final validFormats = ATTRIBUTES_ACCESSORS[semantic.split('_')[0]];
          if (validFormats != null && !validFormats.contains(format)) {
            context.addIssue(
                LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
                name: semantic,
                args: [format, validFormats]);
          }

          if ((accessor.byteOffset != -1 &&
                  accessor.byteOffset.remainder(4) != 0) ||
              (accessor.elementLength.remainder(4) != 0 &&
                  accessor.bufferView != null &&
                  accessor.bufferView.byteStride == -1)) {
            context.addIssue(LinkError.meshPrimitiveAccessorUnaligned,
                name: semantic);
          }
        }

        // Mandatory checks even with disabled
        // validation to always set `effectiveByteStride` and `count`

        if (_vertexCount == -1) {
          _vertexCount = accessor.count;
          _count = _vertexCount;
        } else if (_vertexCount != accessor.count) {
          context.addIssue(LinkError.meshPrimitiveUnequalAccessorsCount,
              name: semantic);
        }

        if (accessor.bufferView != null &&
            accessor.bufferView.byteStride == -1) {
          if (accessor.bufferView.effectiveByteStride == -1) {
            accessor.bufferView.effectiveByteStride = accessor.elementLength;
          }

          accessor.bufferView.checkAccessorRefs(accessor, semantic, context);
        }
      });
      context.path.removeLast();
    }

    if (_indicesIndex != -1) {
      _indices = gltf.accessors[_indicesIndex];

      if (indices == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: INDICES, args: [_indicesIndex]);
      } else {
        _count = indices.count;

        indices.setUsage(AccessorUsage.PrimitiveIndices, INDICES, context);
        indices.bufferView
            ?.setUsage(BufferViewUsage.IndexBuffer, INDICES, context);

        if (context.validate) {
          if (indices.bufferView != null &&
              indices.bufferView.byteStride != -1) {
            context.addIssue(
                LinkError.meshPrimitiveIndicesAccessorWithByteStride,
                name: INDICES);
          }

          final format = AccessorFormat.fromAccessor(indices);
          if (!MESH_PRIMITIVE_INDICES_FORMATS.contains(format)) {
            context.addIssue(
                LinkError.meshPrimitiveIndicesAccessorInvalidFormat,
                name: INDICES,
                args: [format, MESH_PRIMITIVE_INDICES_FORMATS]);
          }
        }
      }
    }

    /*
    LINES = 1;
    LINE_LOOP = 2;
    LINE_STRIP = 3;
    TRIANGLES = 4;
    TRIANGLE_STRIP = 5
    TRIANGLE_FAN = 6;
    */

    if ((context.validate && _count != -1) &&
        ((mode == 1 && _count.remainder(2) != 0) ||
            ((mode == 2 || mode == 3) && _count < 2) ||
            (mode == 4 && _count.remainder(3) != 0) ||
            ((mode == 5 || mode == 6) && _count < 3))) {
      context.addIssue(LinkError.meshPrimitiveIncompatibleMode,
          args: [_count, gl.MODES_NAMES[mode]]);
    }

    _material = gltf.materials[_materialIndex];

    if (context.validate && _materialIndex != -1) {
      if (_material == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: MATERIAL, args: [_materialIndex]);
      } else {
        _material.markAsUsed();

        final unusedTexCoords =
            List<int>.generate(texcoordCount, (i) => i, growable: false);

        _material.texCoordIndices.forEach((pointer, texCoord) {
          if (texCoord != -1) {
            if (texCoord + 1 > texcoordCount) {
              context.addIssue(LinkError.meshPrimitiveTooFewTexcoords,
                  name: MATERIAL, args: [pointer, texCoord]);
            } else {
              // mark as used
              unusedTexCoords[texCoord] = -1;
            }
          }
        });

        if (unusedTexCoords.any((i) => i != -1)) {
          context.addIssue(LinkError.meshPrimitiveUnusedTexcoord,
              name: MATERIAL,
              args: [null, unusedTexCoords.where((i) => i != -1)]);
        }
      }
    }

    if (_targetsIndices != null) {
      context.path.add(TARGETS);
      _targets = List<Map<String, Accessor>>(_targetsIndices.length);

      for (var i = 0; i < _targetsIndices.length; i++) {
        final targetIndices = _targetsIndices[i];
        _targets[i] = <String, Accessor>{};

        context.path.add(i.toString());
        targetIndices.forEach((semantic, accessorIndex) {
          if (accessorIndex == -1) {
            return;
          }

          final accessor = gltf.accessors[accessorIndex];

          if (accessor == null) {
            context.addIssue(LinkError.unresolvedReference,
                name: semantic, args: [accessorIndex]);
          } else {
            if (context.validate) {
              accessor.setUsage(
                  AccessorUsage.VertexAttribute, semantic, context);

              final baseAccessor = attributes[semantic];

              if (baseAccessor == null) {
                context.addIssue(
                    LinkError.meshPrimitiveMorphTargetNoBaseAccessor,
                    name: semantic);
              } else {
                if (baseAccessor.count != accessor.count) {
                  context.addIssue(
                      LinkError.meshPrimitiveMorphTargetInvalidAttributeCount,
                      name: semantic);
                }
              }

              if (semantic == POSITION &&
                  ((accessor.min == null) || accessor.max == null)) {
                context.addIssue(
                    LinkError.meshPrimitivePositionAccessorWithoutBounds,
                    name: POSITION);
              }

              final format = AccessorFormat.fromAccessor(accessor);
              final validFormats = MORPH_ATTRIBUTES_ACCESSORS[semantic];

              if (validFormats != null && !validFormats.contains(format)) {
                context.addIssue(
                    LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
                    name: semantic,
                    args: [format, validFormats]);
              }

              if ((accessor.byteOffset != -1 &&
                      accessor.byteOffset.remainder(4) != 0) ||
                  (accessor.elementLength.remainder(4) != 0 &&
                      accessor.bufferView != null &&
                      accessor.bufferView.byteStride == -1)) {
                context.addIssue(LinkError.meshPrimitiveAccessorUnaligned,
                    name: semantic);
              }
            }

            // Mandatory checks even with disabled
            // validation to always set `effectiveByteStride`

            if (accessor.bufferView != null &&
                accessor.bufferView.byteStride == -1) {
              if (accessor.bufferView.effectiveByteStride == -1) {
                accessor.bufferView.effectiveByteStride =
                    accessor.elementLength;
              }

              accessor.bufferView
                  .checkAccessorRefs(accessor, semantic, context);
            }
          }

          _targets[i][semantic] = accessor;
        });
        context.path.removeLast();
      }
      context.path.removeLast();
    }
  }
}
