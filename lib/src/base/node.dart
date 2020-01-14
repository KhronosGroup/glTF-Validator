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

library gltf.base.node;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:vector_math/vector_math.dart';

class Node extends GltfChildOfRootProperty {
  final int _cameraIndex;
  final List<int> _childrenIndices;
  final int _skinIndex;
  final Matrix4 matrix;
  final int _meshIndex;
  final Vector3 translation;
  final Quaternion rotation;
  final Vector3 scale;
  final List<double> weights;
  final Set<Scene> _scenes = <Scene>{};

  Camera _camera;
  List<Node> _children;
  Mesh _mesh;
  Node _parent;
  Skin _skin;

  bool isJoint = false;

  Node._(
      this._cameraIndex,
      this._childrenIndices,
      this._skinIndex,
      this.matrix,
      this._meshIndex,
      this.translation,
      this.rotation,
      this.scale,
      this.weights,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  static Node fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, NODE_MEMBERS, context);
    }

    Matrix4 matrix;
    if (map.containsKey(MATRIX)) {
      final matrixList =
          getFloatList(map, MATRIX, context, lengthsList: const [16]);
      if (matrixList != null) {
        matrix = Matrix4.fromList(matrixList);
      }
    }

    Vector3 translation;
    if (map.containsKey(TRANSLATION)) {
      final translationList =
          getFloatList(map, TRANSLATION, context, lengthsList: const [3]);
      if (translationList != null) {
        translation = Vector3.array(translationList);
      }
    }

    Quaternion rotation;
    if (map.containsKey(ROTATION)) {
      final rotationList = getFloatList(map, ROTATION, context,
          lengthsList: const [4], min: -1, max: 1);
      if (rotationList != null) {
        rotation = Quaternion(
            rotationList[0], rotationList[1], rotationList[2], rotationList[3]);
        if (context.validate &&
            (1.0 - rotation.length).abs() > unitLengthThresholdVec4) {
          context.addIssue(SemanticError.rotationNonUnit, name: ROTATION);
        }
      }
    }

    Vector3 scale;
    if (map.containsKey(SCALE)) {
      final scaleList =
          getFloatList(map, SCALE, context, lengthsList: const [3]);
      if (scaleList != null) {
        scale = Vector3.array(scaleList);
      }
    }

    final cameraIndex = getIndex(map, CAMERA, context, req: false);
    final childrenIndices = getIndicesList(map, CHILDREN, context);
    final meshIndex = getIndex(map, MESH, context, req: false);
    final skinIndex = getIndex(map, SKIN, context, req: false);
    final weightsList = getFloatList(map, WEIGHTS, context);

    if (context.validate) {
      if (meshIndex == -1) {
        if (skinIndex != -1) {
          context.addIssue(SchemaError.unsatisfiedDependency,
              name: SKIN, args: [MESH]);
        }

        if (weightsList != null) {
          context.addIssue(SchemaError.unsatisfiedDependency,
              name: WEIGHTS, args: [MESH]);
        }
      }

      if (matrix != null) {
        if (translation != null || rotation != null || scale != null) {
          context.addIssue(SemanticError.nodeMatrixTrs, name: MATRIX);
        }

        if (matrix.isIdentity()) {
          context.addIssue(SemanticError.nodeDefaultMatrix, name: MATRIX);
        } else if (!isTrsDecomposable(matrix)) {
          context.addIssue(SemanticError.nodeNonTrsMatrix, name: MATRIX);
        }
      }
    }

    return Node._(
        cameraIndex,
        childrenIndices,
        skinIndex,
        matrix,
        meshIndex,
        translation,
        rotation,
        scale,
        weightsList,
        getName(map, context),
        getExtensions(map, Node, context),
        getExtras(map, context));
  }

  Camera get camera => _camera;
  List<Node> get children => _children;
  Mesh get mesh => _mesh;
  Node get parent => _parent;
  Skin get skin => _skin;
  Iterable<Scene> get scenes => _scenes;

  bool get hasTransform => !((matrix == null || matrix.isIdentity()) &&
      (translation == null || translation.isZero) &&
      (rotation == null || rotation.isDefault) &&
      (scale == null || scale.isOne));

  @override
  void link(Gltf gltf, Context context) {
    _camera = gltf.cameras[_cameraIndex];
    _skin = gltf.skins[_skinIndex];
    _mesh = gltf.meshes[_meshIndex];

    if (context.validate) {
      if (_cameraIndex != -1) {
        if (_camera == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: CAMERA, args: [_cameraIndex]);
        } else {
          _camera.markAsUsed();
        }
      }

      if (_skinIndex != -1) {
        if (_skin == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: SKIN, args: [_skinIndex]);
        } else {
          _skin.markAsUsed();
        }
      }

      if (_meshIndex != -1) {
        if (_mesh == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: MESH, args: [_meshIndex]);
        } else {
          _mesh.markAsUsed();
          if (_mesh.primitives != null) {
            if (weights != null &&
                _mesh.primitives[0].targets?.length != weights.length) {
              context.addIssue(LinkError.nodeWeightsInvalid,
                  name: WEIGHTS,
                  args: [weights.length, _mesh.primitives[0].targets?.length]);
            }

            if (_skin != null) {
              if (_mesh.primitives
                  .every((primitive) => primitive.jointsCount == 0)) {
                context.addIssue(LinkError.nodeSkinWithNonSkinnedMesh);
              }
            } else {
              if (_mesh.primitives
                  .any((primitive) => primitive.jointsCount != 0)) {
                context.addIssue(LinkError.nodeSkinnedMeshWithoutSkin);
              }
            }
          }
        }
      }
    }

    if (_childrenIndices != null) {
      _children = List<Node>(_childrenIndices.length);

      resolveNodeList(
          _childrenIndices, _children, gltf.nodes, CHILDREN, context,
          (node, nodeIndex, index) {
        if (node._parent != null) {
          context.addIssue(LinkError.nodeParentOverride,
              index: index, args: [nodeIndex]);
        }
        node._parent = this;
      });
    }
  }

  void addScene(Scene scene) {
    _scenes.add(scene);
    if (children != null) {
      for (final node in children) {
        node?.addScene(scene);
      }
    }
  }
}
