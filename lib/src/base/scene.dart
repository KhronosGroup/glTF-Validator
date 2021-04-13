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

library gltf.base.scene;

import 'package:gltf/src/base/gltf_property.dart';

class Scene extends GltfChildOfRootProperty {
  final List<int> _nodesIndices;
  List<Node> nodes;

  Scene._(this._nodesIndices, String name, Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  static Scene fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, SCENE_MEMBERS, context);
    }

    final nodesIndices = getIndicesList(map, NODES, context);

    return Scene._(nodesIndices, getName(map, context),
        getExtensions(map, Scene, context), getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (_nodesIndices == null) {
      return;
    }

    nodes = List<Node>.filled(_nodesIndices.length, null);

    resolveNodeList(_nodesIndices, nodes, gltf.nodes, NODES, context,
        (node, nodeIndex, index) {
      if (node.parent != null) {
        context.addIssue(LinkError.sceneNonRootNode,
            index: index, args: [nodeIndex]);
      }

      node.addScene(this);
    });
  }
}
