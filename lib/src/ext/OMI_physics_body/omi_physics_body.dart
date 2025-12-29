// Copyright 2022 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.omi_physics_body;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String OMI_PHYSICS_BODY = 'OMI_physics_body';

const String MASS = 'mass';
const String LINEAR_VELOCITY = 'linearVelocity';
const String ANGULAR_VELOCITY = 'angularVelocity';
const String INERTIA_TENSOR = 'inertiaTensor';

const String STATIC = 'static';
const String KINEMATIC = 'kinematic';
const String CHARACTER = 'character';
const String RIGID = 'rigid';
const String VEHICLE = 'vehicle';
const String TRIGGER = 'trigger';

const List<String> OMI_PHYSICS_BODY_MEMBERS = <String>[
  TYPE,
  MASS,
  LINEAR_VELOCITY,
  ANGULAR_VELOCITY,
  INERTIA_TENSOR
];

const List<String> OMI_PHYSICS_BODY_TYPES = <String>[
  STATIC,
  KINEMATIC,
  CHARACTER,
  RIGID,
  VEHICLE,
  TRIGGER
];

class OmiPhysicsBody extends GltfProperty {
  final String type;
  final double mass;
  final List<double> linearVelocity;
  final List<double> angularVelocity;
  final List<double> inertiaTensor;

  OmiPhysicsBody._(this.type, this.mass, this.linearVelocity,
      this.angularVelocity, this.inertiaTensor,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiPhysicsBody fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_PHYSICS_BODY_MEMBERS, context);
    }

    final type = getString(map, TYPE, context,
        list: OMI_PHYSICS_BODY_TYPES, req: true);

    final mass = getFloat(map, MASS, context, def: 1);

    final linearVelocity = getFloatList(map, LINEAR_VELOCITY, context,
        lengthsList: const [3], def: const [0.0, 0.0, 0.0]);

    final angularVelocity = getFloatList(map, ANGULAR_VELOCITY, context,
        lengthsList: const [3], def: const [0.0, 0.0, 0.0]);

    final inertiaTensor = getFloatList(map, INERTIA_TENSOR, context,
        lengthsList: const [9], def: const
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]);

    return OmiPhysicsBody._(
        type,
        mass,
        linearVelocity,
        angularVelocity,
        inertiaTensor,
        getExtensions(map, OmiPhysicsBody, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (!context.validate) {
      return;
    }
    // Get the glTF node that this physics body is attached to.
    final path = context.path;
    if (path.length < 2 || path[0] != 'nodes') {
      return;
    }
    final nodeIndex = int.tryParse(path[1]);
    if (nodeIndex == null) {
      return;
    }
    final node = gltf.nodes[nodeIndex];
    // Ensure that the physics body is not on the same node as a mesh or camera.
    if (node.mesh != null) {
      context.addIssue(SemanticError.sharesNodeWith,
          args: ['A physics body', 'a mesh']);
    }
    if (node.camera != null) {
      context.addIssue(SemanticError.sharesNodeWith,
          args: ['A physics body', 'a camera']);
    }
    if (node.extensions.containsKey('OMI_collider')) {
      context.addIssue(SemanticError.sharesNodeWith,
          args: ['A physics body', 'a collider', 'collider']);
    }
    // Check that the physics body has at least one collider.
    var hasCollider = false;
    if (node.children != null) {
      for (final child in node.children) {
        if (child.extensions != null &&
            child.extensions.containsKey(OMI_COLLIDER)) {
          hasCollider = true;
          break;
        }
      }
    }
    if (!hasCollider) {
      context.addIssue(SemanticError.omiPhysicsBodyMissingCollider,
          name: OMI_PHYSICS_BODY);
    }
    // Ensure that the inertia tensor is a symmetric matrix.
    if (inertiaTensor[1] != inertiaTensor[3] ||
        inertiaTensor[2] != inertiaTensor[6] ||
        inertiaTensor[5] != inertiaTensor[7]) {
      context.addIssue(SemanticError.omiPhysicsBodyInvalidInertiaTensor,
          name: INERTIA_TENSOR);
    }
  }
}

const Extension omiPhysicsBodyExtension = Extension(
    OMI_PHYSICS_BODY, <Type, ExtensionDescriptor>{
  Node: ExtensionDescriptor(OmiPhysicsBody.fromMap)
});
