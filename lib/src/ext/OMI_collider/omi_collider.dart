// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.omi_collider;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String OMI_COLLIDER = 'OMI_collider';

const String IS_TRIGGER = 'isTrigger';
const String SIZE = 'size';
const String RADIUS = 'radius';
const String HEIGHT = 'height';
const String MESH = 'mesh';

const String BOX = 'box';
const String SPHERE = 'sphere';
const String CAPSULE = 'capsule';
const String CYLINDER = 'cylinder';
const String HULL = 'hull';
const String TRIMESH = 'trimesh';

const String COLLIDER = 'collider';
const String COLLIDERS = 'colliders';

const List<String> OMI_COLLIDER_GLTF_MEMBERS = <String>[COLLIDERS];
const List<String> OMI_COLLIDER_NODE_MEMBERS = <String>[COLLIDER];

const List<String> OMI_COLLIDER_COLLIDER_MEMBERS = <String>[
  TYPE,
  IS_TRIGGER,
  SIZE,
  RADIUS,
  HEIGHT,
  MESH
];

const List<String> OMI_COLLIDER_COLLIDER_TYPES = <String>[
  BOX,
  SPHERE,
  CAPSULE,
  CYLINDER,
  HULL,
  TRIMESH
];

const Extension omiColliderExtension =
    Extension(OMI_COLLIDER, <Type, ExtensionDescriptor>{
  Gltf: ExtensionDescriptor(OmiColliderGltf.fromMap),
  Node: ExtensionDescriptor(OmiColliderNode.fromMap)
});

// The document-level extension that holds a list of colliders.
class OmiColliderGltf extends GltfProperty {
  final SafeList<OmiColliderCollider> colliders;

  OmiColliderGltf._(
      this.colliders, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiColliderGltf fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_COLLIDER_GLTF_MEMBERS, context);
    }

    SafeList<OmiColliderCollider> colliders;
    final colliderMaps = getMapList(map, COLLIDERS, context);
    if (colliderMaps != null) {
      colliders = SafeList<OmiColliderCollider>(colliderMaps.length, COLLIDERS);
      context.path.add(COLLIDERS);
      for (var i = 0; i < colliderMaps.length; i++) {
        final colliderMap = colliderMaps[i];
        context.path.add(i.toString());
        colliders[i] = OmiColliderCollider.fromMap(colliderMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      colliders = SafeList<OmiColliderCollider>.empty(COLLIDERS);
    }

    return OmiColliderGltf._(
        colliders,
        getExtensions(map, OmiColliderGltf, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (colliders != null) {
      context.path.add(COLLIDERS);
      final extCollectionList = context.path.toList(growable: false);
      context.extensionCollections[colliders] = extCollectionList;
      colliders.forEachWithIndices((i, collider) {
        context.path.add(i.toString());
        collider.link(gltf, context);
        context.path.removeLast();
      });
      context.path.removeLast();
    }
  }
}

// The main data structure that stores collider data.
class OmiColliderCollider extends GltfChildOfRootProperty {
  final String type;
  final bool isTrigger;
  final List<double> size;
  final double radius;
  final double height;
  final int mesh;

  OmiColliderCollider._(this.type, this.isTrigger, this.size, this.radius,
      this.height, this.mesh, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static OmiColliderCollider fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_COLLIDER_COLLIDER_MEMBERS, context);
    }

    final type = getString(map, TYPE, context,
        list: OMI_COLLIDER_COLLIDER_TYPES, req: true);

    final isTrigger = getBool(map, IS_TRIGGER, context);

    final size = getFloatList(map, SIZE, context,
        lengthsList: const [3], min: 0, def: const [1.0, 1.0, 1.0]);

    final radius = getFloat(map, RADIUS, context, min: 0, def: 0.5);
    final height = getFloat(map, HEIGHT, context, min: 0, def: 2);

    final mesh = getIndex(map, MESH, context, req: false);

    if (context.validate) {
      if (map.containsKey(SIZE) && type != BOX) {
        context.addIssue(SemanticError.extraProperty, name: SIZE);
      }
      if (type != CAPSULE && type != CYLINDER) {
        if (map.containsKey(HEIGHT)) {
          context.addIssue(SemanticError.extraProperty, name: HEIGHT);
        }
        if (type != SPHERE) {
          if (map.containsKey(RADIUS)) {
            context.addIssue(SemanticError.extraProperty, name: RADIUS);
          }
        }
      }
      if (type == CAPSULE && height < radius * 2) {
        context.addIssue(SemanticError.omiColliderInvalidCapsuleHeight,
            name: HEIGHT);
      }
      if (map.containsKey(MESH) && type != TRIMESH && type != HULL) {
        context.addIssue(SemanticError.extraProperty, name: MESH);
      }
      if (type == TRIMESH && isTrigger) {
        context.addIssue(SemanticError.omiColliderTrimeshTrigger,
            name: IS_TRIGGER);
      }
    }

    return OmiColliderCollider._(
        type,
        isTrigger,
        size,
        radius,
        height,
        mesh,
        getName(map, context),
        getExtensions(map, OmiColliderCollider, context),
        getExtras(map, context));
  }
}

// The node-level extension that references a document-level collider by index.
class OmiColliderNode extends GltfProperty {
  final int _colliderIndex;

  OmiColliderCollider _collider;

  OmiColliderNode._(
      this._colliderIndex, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiColliderNode fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_COLLIDER_NODE_MEMBERS, context);
    }

    return OmiColliderNode._(
        getIndex(map, COLLIDER, context),
        getExtensions(map, OmiColliderNode, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (!context.validate) {
      return;
    }
    final collidersExtension = gltf.extensions[omiColliderExtension.name];
    if (collidersExtension is OmiColliderGltf) {
      // Mark the collider that this node references as used.
      if (_colliderIndex != -1) {
        _collider = collidersExtension.colliders[_colliderIndex];
        if (_collider == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: COLLIDER, args: [_colliderIndex]);
        } else {
          _collider.markAsUsed();
          // If this is a trimesh, we also need to mark the mesh as used.
          final meshIndex = _collider.mesh;
          if (meshIndex != -1) {
            if (meshIndex >= gltf.meshes.length) {
              context.addIssue(LinkError.unresolvedReference,
                  name: MESH, args: [meshIndex]);
            } else {
              gltf.meshes[meshIndex].markAsUsed();
            }
          }
        }
      }
      // Get the glTF node that this collider is attached to.
      final path = context.path;
      if (path.length < 2 || path[0] != 'nodes') {
        return;
      }
      final nodeIndex = int.tryParse(path[1]);
      if (nodeIndex == null) {
        return;
      }
      final node = gltf.nodes[nodeIndex];
      // Ensure that the collider is not on the same node as a mesh or camera.
      if (node.mesh != null) {
        context.addIssue(SemanticError.sharesNodeWith,
            args: ['A collider', 'a mesh']);
      }
      if (node.camera != null) {
        context.addIssue(SemanticError.sharesNodeWith,
            args: ['A collider', 'a camera']);
      }
    } else {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${omiColliderExtension.name}']);
    }
  }

  OmiColliderCollider get collider => _collider;
}
