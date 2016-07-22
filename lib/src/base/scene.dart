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

library gltf.core.scene;

import 'gltf_property.dart';

class Scene extends GltfChildOfRootProperty implements Linkable {
  final Iterable<String> _nodesIds;
  final List<Node> nodes = <Node>[];

  Scene._(this._nodesIds, String name, Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  String toString([_]) => super.toString({NODES: _nodesIds});

  static Scene fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, SCENE_MEMBERS, context);

    final nodesIds =
        getStringList(map, NODES, context, def: <String>[]).toSet();

    return new Scene._(nodesIds, getName(map, context),
        getExtensions(map, Scene, context), getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    if (_nodesIds != null) {
      for (final id in _nodesIds) {
        final node = gltf.nodes[id];
        if (node != null)
          nodes.add(node);
        else
          context.addIssue(GltfError.UNRESOLVED_REFERENCE,
              name: NODES, args: [id]);
      }
    }
  }
}
