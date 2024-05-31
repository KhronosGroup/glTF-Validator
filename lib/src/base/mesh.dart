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

library gltf.base.mesh;

import 'dart:typed_data';

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;
import 'package:meta/meta.dart';

class Mesh extends GltfChildOfRootProperty {
  final SafeList<MeshPrimitive> primitives;
  final List<double> weights;

  bool _weightsUsed = false;

  bool get areWeightsUsed => _weightsUsed;

  Mesh._(this.primitives, this.weights, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

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
      var targetCount = 0;
      for (var i = 0; i < primitivesMaps.length; i++) {
        context.path.add(i.toString());
        final primitive = MeshPrimitive.fromMap(primitivesMaps[i], context);
        if (context.validate) {
          final primitiveTargetCount = primitive._targetsIndices?.length ?? 0;
          if (i == 0) {
            targetCount = primitiveTargetCount;
          } else if (targetCount != primitiveTargetCount) {
            context.addIssue(SemanticError.meshPrimitivesUnequalTargetsCount,
                name: primitiveTargetCount > 0 ? TARGETS : null);
          }
        }
        primitives[i] = primitive;
        context.path.removeLast();
      }
      context.path.removeLast();

      if (context.validate &&
          weights != null &&
          targetCount != weights.length) {
        context.addIssue(SemanticError.meshInvalidWeightsCount,
            name: WEIGHTS, args: [weights.length, targetCount]);
      }
    }

    return Mesh._(primitives, weights, getName(map, context),
        getExtensions(map, Mesh, context), getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    context.path.add(PRIMITIVES);
    primitives?.forEachWithIndices((i, primitive) {
      context.path.add(i.toString());

      context.path.add(EXTENSIONS);
      primitive.extensions.forEach((key, value) {
        if (value is Linkable) {
          context.path.add(key);
          value.link(gltf, context);
          context.path.removeLast();
        }
      });
      context.path.removeLast();

      primitive.link(gltf, context);
      context.path.removeLast();
    });
    context.path.removeLast();
  }

  void markWeightsAsUsed() {
    _weightsUsed = true;
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
  final int weightsCount;
  final int texCoordCount;

  final Map<String, Accessor> attributes = <String, Accessor>{};

  int _count = -1;
  int _vertexCount = -1;
  List<Map<String, Accessor>> _targets;
  Accessor _indices;
  Material _material;

  final List<int> _unusedTexCoords;

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
      this.weightsCount,
      this.texCoordCount,
      Map<String, Object> extensions,
      Object extras)
      : _unusedTexCoords =
            List<int>.generate(texCoordCount, (i) => i, growable: false),
        super(extensions, extras);

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
    var texCoordCount = 0;
    var maxTexcoord = -1;

    int parseAttributeSemanticIndex(List<int> codeUnits) {
      if (codeUnits.isEmpty || codeUnits.length > 1 && codeUnits[0] == 0x30) {
        return -1;
      }

      var index = 0;
      for (var i = 0; i < codeUnits.length; ++i) {
        final digit = codeUnits[i] - 0x30;
        if (digit > 9 || digit < 0) {
          return -1;
        }
        index = 10 * index + digit;
      }
      return index;
    }

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
              semParts.length != 2) {
            context.addIssue(SemanticError.meshPrimitiveInvalidAttribute,
                name: semantic);
            break;
          }

          final index = parseAttributeSemanticIndex(semParts[1].codeUnits);
          if (index != -1) {
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
                texCoordCount++;
                maxTexcoord = index > maxTexcoord ? index : maxTexcoord;
                break;
              case WEIGHTS_:
                weightsCount++;
                maxWeights = index > maxWeights ? index : maxWeights;
                break;
            }
          } else {
            context.addIssue(SemanticError.meshPrimitiveInvalidAttribute,
                name: semantic);
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
        context.addIssue(SemanticError.meshPrimitiveTangentWithoutNormal,
            name: TANGENT);
      }

      /// Check for indexed semantics continuity -
      /// they must start with zero and do not have gaps.
      /// Otherwise, the semantic will be completely ignored.
      int checkContinuity(int maxIndex, int count, String name) {
        if (maxIndex + 1 != count) {
          context.addIssue(SemanticError.meshPrimitiveIndexedSemanticContinuity,
              args: [name, maxIndex + 1, count]);
          return 0;
        }
        return count;
      }

      colorCount = checkContinuity(maxColor, colorCount, COLOR_);
      jointsCount = checkContinuity(maxJoints, jointsCount, JOINTS_);
      weightsCount = checkContinuity(maxWeights, weightsCount, WEIGHTS_);
      texCoordCount = checkContinuity(maxTexcoord, texCoordCount, TEXCOORD_);

      if (jointsCount != weightsCount) {
        context.addIssue(SemanticError.meshPrimitiveJointsWeightsMismatch,
            args: [jointsCount, weightsCount]);

        // Block joints data from further processing
        jointsCount = 0;
        weightsCount = 0;
      }

      context.path.removeLast();
    }

    void checkMorphTargetAttributeSemanticName(String semantic) {
      // Skip custom semantics
      if (semantic.isNotEmpty && semantic.codeUnitAt(0) == 95 /*underscore*/) {
        return;
      }

      if (ATTRIBUTE_SEMANTIC_MEMBERS.contains(semantic)) {
        return;
      }

      final semParts = semantic.split('_');
      if (!ATTRIBUTE_SEMANTIC_MORPH_TARGET_ARRAY_MEMBERS
              .contains(semParts[0]) ||
          semParts.length != 2 ||
          parseAttributeSemanticIndex(semParts[1].codeUnits) == -1) {
        context.addIssue(SemanticError.meshPrimitiveInvalidAttribute,
            name: semantic);
      }
    }

    final targets = getIndicesMapsList(
        map, TARGETS, context, checkMorphTargetAttributeSemanticName);

    final primitive = MeshPrimitive._(
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
        texCoordCount,
        getExtensions(map, MeshPrimitive, context),
        getExtras(map, context));

    context.registerObjectsOwner(primitive, primitive.extensions.values);

    return primitive;
  }

  int get count => _count;
  int get vertexCount => _vertexCount;
  List<Map<String, Accessor>> get targets => _targets;
  Accessor get indices => _indices;
  Material get material => _material;

  int get trianglesCount {
    switch (mode) {
      case gl.TRIANGLES:
        return count ~/ 3;
      case gl.TRIANGLE_STRIP:
      case gl.TRIANGLE_FAN:
        return count > 2 ? count - 2 : 0;
      default:
        return 0;
    }
  }

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

        if (context.validate) {
          if (semantic == POSITION &&
              (accessor.min == null || accessor.max == null)) {
            context.addIssue(
                LinkError.meshPrimitivePositionAccessorWithoutBounds,
                name: POSITION);
          }

          final format = AccessorFormat.fromAccessor(accessor);
          final validFormats =
              context.attributeAccessorFormats[semantic.split('_')[0]];
          if (validFormats != null) {
            if (!validFormats.contains(format)) {
              context.addIssue(
                  LinkError.meshPrimitiveAttributesAccessorInvalidFormat,
                  name: semantic,
                  args: [format, validFormats]);
            } else {
              if (semantic == NORMAL) {
                accessor.setUnit();
                context.path.add(NORMAL);
                context.addElementChecker(
                    accessor,
                    UnitVec3FloatChecker(context.getPointerString(),
                        accessor.isFloat ? null : accessor.normalizeValue));
                context.path.removeLast();
              } else if (semantic == TANGENT) {
                accessor
                  ..setUnit()
                  ..setXyzSign();
                context.path.add(TANGENT);
                context.addElementChecker(
                    accessor,
                    UnitVec3SignFloatChecker(context.getPointerString(),
                        accessor.isFloat ? null : accessor.normalizeValue));
                context.path.removeLast();
              } else if (semantic == '${COLOR_}_0' &&
                  gl.FLOAT == accessor.componentType) {
                accessor.setClamped();
                context.path.add(semantic);
                context.addElementChecker(accessor,
                    ClampedRangeFloatChecker(context.getPointerString()));
                context.path.removeLast();
              }
            }
          } else if (accessor.componentType == gl.UNSIGNED_INT) {
            context.addIssue(
                LinkError.meshPrimitiveAttributesAccessorUnsignedInt,
                name: semantic);
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

          _checkAccessorRefs(accessor, semantic, context);
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
          context.path.add(INDICES);
          if (indices.bufferView != null &&
              indices.bufferView.byteStride != -1) {
            context
                .addIssue(LinkError.meshPrimitiveIndicesAccessorWithByteStride);
          }

          final format = AccessorFormat.fromAccessor(indices);
          if (!MESH_PRIMITIVE_INDICES_FORMATS.contains(format)) {
            context.addIssue(
                LinkError.meshPrimitiveIndicesAccessorInvalidFormat,
                args: [format, MESH_PRIMITIVE_INDICES_FORMATS]);
          } else {
            final maxVertexIndex = vertexCount != -1 ? vertexCount - 1 : -1;
            final modesMask = mode != -1 ? 1 << mode : -1;

            if (modesMask != 0 && maxVertexIndex >= -1) {
              context.addElementChecker(
                  indices,
                  IndexBufferIntegerChecker(
                      path: context.getPointerString(),
                      maxVertexIndex: maxVertexIndex,
                      totalTriangles: _count ~/ 3,
                      modesMask: modesMask,
                      componentType: indices.componentType));
            }
          }
          context.path.removeLast();
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

    if (context.validate) {
      if (_materialIndex != -1) {
        if (_material == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: MATERIAL, args: [_materialIndex]);
        } else {
          _material.markAsUsed();

          _material.texCoordIndices.forEach((pointer, texCoord) {
            if (texCoord != -1) {
              if (texCoord + 1 > texCoordCount) {
                context.addIssue(LinkError.meshPrimitiveTooFewTexcoords,
                    name: MATERIAL, args: [pointer, texCoord]);
              } else {
                markUsedTexCoord(texCoord);
              }
            }
          });
        }
      }

      if (hasTangent && (_material == null || !_material.needsTangent)) {
        context
          ..path.add(ATTRIBUTES)
          ..addIssue(LinkError.unusedMeshTangent, name: TANGENT)
          ..path.removeLast();
      }

      for (final unusedIndex in _unusedTexCoords.where((i) => i != -1)) {
        context
          ..path.add(ATTRIBUTES)
          ..addIssue(LinkError.unusedObject, name: '${TEXCOORD_}_$unusedIndex')
          ..path.removeLast();
      }
    }

    if (_targetsIndices != null) {
      context.path.add(TARGETS);
      _targets = List<Map<String, Accessor>>.generate(
          _targetsIndices.length, (_) => <String, Accessor>{},
          growable: false);

      for (var i = 0; i < _targetsIndices.length; i++) {
        final targetIndices = _targetsIndices[i];

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
              accessor.bufferView
                  ?.setUsage(BufferViewUsage.VertexBuffer, semantic, context);

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
              final validFormats =
                  context.morphAttributeAccessorFormats[semantic.split('_')[0]];

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

              _checkAccessorRefs(accessor, semantic, context);
            }
          }

          _targets[i][semantic] = accessor;
        });
        context.path.removeLast();
      }
      context.path.removeLast();
    }
  }

  void markUsedTexCoord(int texCoord) {
    assert(texCoord < texCoordCount);
    _unusedTexCoords[texCoord] = -1;
  }

  void _checkAccessorRefs(Accessor accessor, String semantic, Context context) {
    if (accessor.bufferView.byteStride == -1) {
      final accessors = context.bufferViewAccessors
          .putIfAbsent(accessor.bufferView, () => <Accessor>{});
      if (accessors.add(accessor) && accessors.length > 1) {
        context.addIssue(LinkError.meshPrimitiveAccessorWithoutByteStride,
            name: semantic);
      }
    }
  }
}

class IndexBufferIntegerChecker extends ElementChecker<int> {
  /*
  TODO
  points - warn on duplicates
  lines - degenerate (v(2n)=v(2n+1)), duplicates (incl. reversed)
  line_loop, line_stripe - degenerate (v(n)=v(n+1)),
  triangles - degenerate (v1=v2 | v2=v3 | v1=v3), duplicates (order-aware)
  triangle_strip - degenerate (v1=v2=v3), duplicates (order-aware)
  triangle_fan - ???
 */

  final int maxVertexIndex;
  final int totalTriangles;
  final int primitiveRestartIndex;

  final bool isPoints;
  final bool isLines;
  final bool isLineLoop;
  final bool isLineStrip;
  final bool isTriangles;
  final bool isTriangleStrip;
  final bool isTriangleFan;

  int _vertexIndex = 0;
  int _degenerateTriangles = 0;

  final _triangle = Uint32List(3);

  @override
  final String path;

  IndexBufferIntegerChecker(
      {@required this.path,
      @required this.maxVertexIndex,
      @required this.totalTriangles,
      @required int componentType,
      @required int modesMask})
      : primitiveRestartIndex = gl.typeMax(componentType),
        isPoints = 1 == 1 & modesMask,
        isLines = 2 == 2 & modesMask,
        isLineLoop = 4 == 4 & modesMask,
        isLineStrip = 8 == 8 & modesMask,
        isTriangles = 16 == 16 & modesMask,
        isTriangleStrip = 32 == 32 & modesMask,
        isTriangleFan = 64 == 64 & modesMask;

  @override
  bool check(Context context, int index, int componentIndex, int value) {
    assert(componentIndex == 0);
    if (value > maxVertexIndex) {
      context.addIssue(DataError.accessorIndexOob,
          name: path, args: [index, value, maxVertexIndex]);
    }

    if (value == primitiveRestartIndex) {
      context.addIssue(DataError.accessorIndexPrimitiveRestart,
          name: path, args: [value, index]);
    }

    if (isTriangles) {
      _triangle[_vertexIndex] = value;
      if (++_vertexIndex == 3) {
        _vertexIndex = 0;
        if (_triangle[0] == _triangle[1] ||
            _triangle[1] == _triangle[2] ||
            _triangle[2] == _triangle[0]) {
          ++_degenerateTriangles;
        }
      }
    }

    return true;
  }

  @override
  bool done(Context context) {
    if (_degenerateTriangles > 0) {
      context.addIssue(DataError.accessorIndexTriangleDegenerate,
          name: path, args: [_degenerateTriangles, totalTriangles]);
    }

    return true;
  }
}
