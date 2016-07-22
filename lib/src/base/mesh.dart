/*
 * # Copyright (c) 2016 The Khronos Group Inc.
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

library gltf.core.mesh;

import 'gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

class Mesh extends GltfChildOfRootProperty implements Linkable {
  final List<MeshPrimitive> primitives;

  Mesh._(this.primitives, String name, Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  String toString([_]) => super.toString({PRIMITIVES: primitives});

  static Mesh fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, MESH_MEMBERS, context);

    var i = 0;
    final primitives =
        getMapList(map, PRIMITIVES, context, req: true, minItems: 1)
            ?.map((Map<String, Object> p) {
      context.path.add((i++).toString());
      final primitive = new MeshPrimitive.fromMap(p, context);
      context.path.removeLast();
      return primitive;
    })?.toList();

    return new Mesh._(primitives, getName(map, context),
        getExtensions(map, Mesh, context), getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    if (primitives == null) return;

    context.path.add(PRIMITIVES);
    for (var i = 0; i < primitives.length; i++) {
      context.path.add(i.toString());
      primitives[i].link(gltf, context);
      context.path.removeLast();
    }
    context.path.removeLast();
  }
}

class MeshPrimitive extends GltfProperty implements Linkable {
  final Map<String, String> _attributesIds;
  final String _indicesId;
  final String _materialId;
  final int mode;

  final Map<String, Accessor> attributes = <String, Accessor>{};
  Accessor indices;
  Material material;

  MeshPrimitive._(this._attributesIds, this._indicesId, this._materialId,
      this.mode, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({
        ATTRIBUTES: _attributesIds,
        INDICES: _indicesId,
        MATERIAL: _materialId,
        MODE: mode
      });

  factory MeshPrimitive.fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, MESH_PRIMITIVE_MEMBERS, context);

    const List<int> modesEnum = const <int>[
      gl.POINTS,
      gl.LINES,
      gl.LINE_LOOP,
      gl.LINE_STRIP,
      gl.TRIANGLES,
      gl.TRIANGLE_STRIP,
      gl.TRIANGLE_FAN
    ];

    final attributes = getMap(map, ATTRIBUTES, context, req: true);
    if (context.validate && attributes.isNotEmpty) {
      context.path.add(ATTRIBUTES);
      for (final semantic in attributes.keys) {
        if (!ATTRIBUTE_SEMANTIC_MEMBERS.contains(semantic) &&
            !semantic.startsWith("_")) {
          final semParts = semantic.split("_");
          if (!(ATTRIBUTE_SEMANTIC_ARRAY_MEMBERS.contains(semParts[0]) &&
              semParts.length == 2 &&
              int.parse(semParts[1], onError: (_) => -1) != -1)) {
            context.addIssue(GltfError.TECHNIQUE_INVALID_SEMANTIC,
                name: semantic);
          }
        }
      }
      context.path.removeLast();
    }

    return new MeshPrimitive._(
        attributes,
        getId(map, INDICES, context, req: false),
        getId(map, MATERIAL, context),
        getInt(map, MODE, context, list: modesEnum, def: gl.TRIANGLES),
        getExtensions(map, MeshPrimitive, context),
        getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    material = gltf.materials[_materialId];

    if (context.validate && material == null && _materialId != null) {
      context.addIssue(GltfError.UNRESOLVED_REFERENCE,
          name: MATERIAL, args: [_materialId]);
    }

    // TODO: refactor similar code

    if (material == null ||
        (material.technique == null && material.extensions.isEmpty)) {
      //  Assuming default material

      var foundPosition = false;
      context.path.add(ATTRIBUTES);
      _attributesIds.forEach((semantic, accessorId) {
        if (semantic == POSITION) {
          foundPosition = true;
        } else {
          context.addIssue(GltfWarning.UNEXPECTED_ATTRIBUTE, args: [semantic]);
        }

        final accessor = gltf.accessors[accessorId];

        if (context.validate) {
          if (accessor == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: semantic, args: [accessorId]);
          } else {
            if (semantic == POSITION &&
                (accessor.type != VEC3 || accessor.componentType != gl.FLOAT)) {
              context.addIssue(GltfError.MESH_INVALID_ACCESSOR_TYPE,
                  name: semantic);
            }

            if (accessor.componentType == gl.UNSIGNED_INT) {
              context.addIssue(GltfError.MESH_UINT_ATTRIBUTE_ACCESSOR,
                  name: semantic);
            }

            if (accessor.bufferView?.target != gl.ARRAY_BUFFER) {
              context.addIssue(GltfError.MESH_INVALID_ACCESSOR_BUFFERVIEW,
                  name: semantic);
            }
          }
        }

        attributes[semantic] = accessor;
      });
      if (!foundPosition) context.addIssue(GltfError.MESH_DEFAULT_NO_POSITION);
      context.path.removeLast();
    } else if (material.extensions.isEmpty) {
      // assume material.technique defined

      int count;

      context.path.add(ATTRIBUTES);
      _attributesIds.forEach((semantic, accessorId) {
        final accessor = gltf.accessors[accessorId];

        if (context.validate) {
          final parameter = material.technique.attributes.values.firstWhere(
              (parameter) => parameter.semantic == semantic,
              orElse: () => null);

          if (parameter == null)
            context.addIssue(GltfWarning.UNEXPECTED_ATTRIBUTE,
                args: [semantic, material.techniqueId]);

          if (accessor == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: semantic, args: [accessorId]);
          } else {
            if (accessor.bufferView?.target != gl.ARRAY_BUFFER) {
              context.addIssue(GltfError.MESH_INVALID_ACCESSOR_BUFFERVIEW,
                  name: semantic);
            }

            if (accessor.componentType == gl.UNSIGNED_INT) {
              context.addIssue(GltfError.MESH_UINT_ATTRIBUTE_ACCESSOR,
                  name: semantic);
            }

            if (count == null) {
              count = accessor.count;
            } else if (count != accessor.count) {
              context.addIssue(GltfError.MESH_UNEQUAL_ACCESSOR_COUNT,
                  name: semantic);
            }

            if (parameter != null) {
              if (accessor.type != ATTRIBUTE_TYPES[parameter.type])
                context.addIssue(GltfError.INVALID_ACCESSOR_TYPE,
                    name: semantic);
            }
          }
        }

        attributes[semantic] = accessor;
      });
      context.path.removeLast();
    } else {
      // assume material.extensions not empty

      int count;

      context.path.add(ATTRIBUTES);
      _attributesIds.forEach((semantic, accessorId) {
        final accessor = gltf.accessors[accessorId];

        if (context.validate) {
          final parameter =
              context.extensionsAttributeParameterSemantics[semantic];

          if (parameter == null)
            context.addIssue(GltfWarning.UNEXPECTED_ATTRIBUTE,
                args: [semantic, context.extensionsLoaded]);

          if (accessor == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: semantic, args: [accessorId]);
          } else {
            if (accessor.bufferView?.target != gl.ARRAY_BUFFER) {
              context.addIssue(GltfError.MESH_INVALID_ACCESSOR_BUFFERVIEW,
                  name: semantic);
            }

            if (accessor.componentType == gl.UNSIGNED_INT) {
              context.addIssue(GltfError.MESH_UINT_ATTRIBUTE_ACCESSOR,
                  name: semantic);
            }

            if (count == null) {
              count = accessor.count;
            } else if (count != accessor.count) {
              context.addIssue(GltfError.MESH_UNEQUAL_ACCESSOR_COUNT,
                  name: semantic);
            }

            if (parameter != null) {
              if (accessor.type != ATTRIBUTE_TYPES[parameter.type])
                context.addIssue(GltfError.INVALID_ACCESSOR_TYPE,
                    name: semantic);
            }
          }
        }

        attributes[semantic] = accessor;
      });
      context.path.removeLast();
    }

    if (_indicesId != null) {
      indices = gltf.accessors[_indicesId];
      if (context.validate) {
        if (indices == null) {
          context.addIssue(GltfError.UNRESOLVED_REFERENCE,
              name: INDICES, args: [_indicesId]);
        } else {
          if (indices.bufferView?.target != gl.ELEMENT_ARRAY_BUFFER) {
            context.addIssue(GltfError.MESH_INVALID_ACCESSOR_BUFFERVIEW,
                name: INDICES);
          }
        }
      }
    }
  }
}
