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

library gltf.base.skin;

import 'package:gltf/src/base/gltf_property.dart';

class Skin extends GltfChildOfRootProperty {
  final int _inverseBindMatricesIndex;
  final int _skeletonIndex;
  final List<int> _jointsIndices;

  Accessor _inverseBindMatrices;
  List<Node> _joints;
  Node _skeleton;
  final Set<Node> _commonRoots = <Node>{};

  Iterable<Node> get commonRoots => _commonRoots;

  Skin._(
      this._inverseBindMatricesIndex,
      this._skeletonIndex,
      this._jointsIndices,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  Accessor get inverseBindMatrices => _inverseBindMatrices;
  List<Node> get joints => _joints;
  Node get skeleton => _skeleton;

  static Skin fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, SKIN_MEMBERS, context);
    }

    return Skin._(
        getIndex(map, INVERSE_BIND_MATRICES, context, req: false),
        getIndex(map, SKELETON, context, req: false),
        getIndicesList(map, JOINTS, context, req: true),
        getName(map, context),
        getExtensions(map, Skin, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    _inverseBindMatrices = gltf.accessors[_inverseBindMatricesIndex];

    _skeleton = gltf.nodes[_skeletonIndex];

    if (_jointsIndices != null) {
      _joints = List<Node>(_jointsIndices.length);

      resolveNodeList(_jointsIndices, _joints, gltf.nodes, JOINTS, context,
          (node, nodeIndex, index) {
        node.isJoint = true;

        final parents = <Node>{};

        var temp = node;
        while (temp != null && parents.add(temp)) {
          temp = temp.parent;
        }

        if (_commonRoots.isEmpty) {
          _commonRoots.addAll(parents);
        } else {
          _commonRoots.retainWhere(parents.contains);
        }
      });

      if (_commonRoots.isEmpty) {
        context.addIssue(SemanticError.skinNoCommonRoot, name: JOINTS);
      }
    }

    if (_inverseBindMatricesIndex != -1) {
      if (_inverseBindMatrices == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: INVERSE_BIND_MATRICES, args: [_inverseBindMatricesIndex]);
      } else {
        _inverseBindMatrices.setUsage(
            AccessorUsage.IBM, INVERSE_BIND_MATRICES, context);
        _inverseBindMatrices.bufferView
            ?.setUsage(BufferViewUsage.IBM, INVERSE_BIND_MATRICES, context);

        if (context.validate) {
          context.path.add(INVERSE_BIND_MATRICES);

          final format = AccessorFormat.fromAccessor(_inverseBindMatrices);
          if (format != SKIN_IBM_FORMAT) {
            context.addIssue(LinkError.skinIbmInvalidFormat, args: [
              format,
              [SKIN_IBM_FORMAT]
            ]);
          } else {
            context.addElementChecker(_inverseBindMatrices,
                IbmMatrixFloatChecker(context.getPointerString()));
          }

          if (_joints != null && _inverseBindMatrices.count != _joints.length) {
            context.addIssue(LinkError.invalidIbmAccessorCount,
                args: [_joints.length, _inverseBindMatrices.count]);
          }
          context.path.removeLast();
        }
      }
    }

    if (context.validate && _skeletonIndex != -1) {
      if (_skeleton == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: SKELETON, args: [_skeletonIndex]);
      } else if (!_commonRoots.contains(_skeleton)) {
        context.addIssue(SemanticError.skinSkeletonInvalid, name: SKELETON);
      }
    }
  }
}

class IbmMatrixFloatChecker extends ElementChecker<double> {
  IbmMatrixFloatChecker(this.path);

  @override
  final String path;

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    assert(componentIndex < 16);
    if (3 == componentIndex && 0 != value ||
        7 == componentIndex && 0 != value ||
        11 == componentIndex && 0 != value ||
        15 == componentIndex && 1 != value) {
      context.addIssue(DataError.accessorInvalidInverseBindMatrix,
          name: path, args: [index, componentIndex, value]);
    }

    return true;
  }
}
