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

library gltf.core.node;

import 'gltf_property.dart';

class Node extends GltfChildOfRootProperty implements Linkable {
  final String _cameraId;
  final Iterable<String> _childrenIds;
  final Iterable<String> _skeletonsIds;
  final String _skinId;
  final String jointName;
  final List<num> matrix;
  final Iterable<String> _meshesIds;
  final List<num> rotation;
  final List<num> scale;
  final List<num> translation;

  Camera camera;
  final List<Node> children = <Node>[];
  final List<Node> skeletons = <Node>[];
  Skin skin;
  final List<Mesh> meshes = <Mesh>[];

  Node._(
      this._cameraId,
      this._childrenIds,
      this._skeletonsIds,
      this._skinId,
      this.jointName,
      this.matrix,
      this._meshesIds,
      this.rotation,
      this.scale,
      this.translation,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  String toString([_]) => super.toString({
        CAMERA: _cameraId,
        CHILDREN: _childrenIds,
        SKELETONS: _skeletonsIds,
        SKIN: _skinId,
        JOINT_NAME: jointName,
        MATRIX: matrix,
        MESHES: _meshesIds,
        ROTATION: rotation,
        SCALE: scale,
        TRANSLATION: translation
      });

  static Node fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, NODE_MEMBERS, context);

    final childrenIds = getStringList(map, CHILDREN, context, def: <String>[]);
    final skeletonsIds = getStringList(map, SKELETONS, context);
    final meshesIds = getStringList(map, MESHES, context);

    final defMat = <num>[
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0
    ];
    final defRot = <num>[0.0, 0.0, 0.0, 1.0];
    final defScale = <num>[1.0, 1.0, 1.0];
    final defTrans = <num>[0.0, 0.0, 0.0];

    return new Node._(
        getId(map, CAMERA, context, req: false),
        childrenIds?.toSet(),
        skeletonsIds?.toSet(),
        getId(map, SKIN, context, req: false),
        getId(map, JOINT_NAME, context, req: false),
        getNumList(map, MATRIX, context,
            minItems: 16, maxItems: 16, def: defMat),
        meshesIds?.toSet(),
        getNumList(map, ROTATION, context,
            minItems: 4, maxItems: 4, def: defRot),
        getNumList(map, SCALE, context,
            minItems: 3, maxItems: 3, def: defScale),
        getNumList(map, TRANSLATION, context,
            minItems: 3, maxItems: 3, def: defTrans),
        getName(map, context),
        getExtensions(map, Node, context),
        getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    // TODO: proper node hierarchy validation

    camera = gltf.cameras[_cameraId];

    if (context.validate && _cameraId != null && camera == null)
      context.addIssue(GltfError.UNRESOLVED_REFERENCE,
          name: CAMERA, args: [_cameraId]);

    if (_childrenIds != null) {
      for (final id in _childrenIds) {
        final child = gltf.nodes[id];
        if (child != null)
          children.add(child);
        else
          context.addIssue(GltfError.UNRESOLVED_REFERENCE,
              name: CHILDREN, args: [id]);
      }
    }

    if (_skeletonsIds != null) {
      for (final id in _skeletonsIds) {
        final skeleton = gltf.nodes[id];
        if (skeleton != null)
          skeletons.add(skeleton);
        else
          context.addIssue(GltfError.UNRESOLVED_REFERENCE,
              name: SKELETONS, args: [id]);
      }
    }

    if (_skinId != null) {
      final skin = gltf.skins[_skinId];
      if (skin != null)
        this.skin = skin;
      else
        context.addIssue(GltfError.UNRESOLVED_REFERENCE,
            name: SKINS, args: [_skinId]);
    }

    if (_meshesIds != null) {
      for (final id in _meshesIds) {
        final mesh = gltf.meshes[id];
        if (mesh != null)
          meshes.add(mesh);
        else
          context.addIssue(GltfError.UNRESOLVED_REFERENCE,
              name: MESHES, args: [id]);
      }
    }

    //if (jointName != null) gltf.joints[jointName] = this;
  }
}
