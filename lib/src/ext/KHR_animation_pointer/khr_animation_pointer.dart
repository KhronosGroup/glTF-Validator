// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_animation_pointer;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_ANIMATION_POINTER = 'KHR_animation_pointer';

const String POINTER = 'pointer';

const List<String> KHR_ANIMATION_POINTER_MEMBERS = <String>[
  POINTER,
];

class KhrAnimationPointer extends GltfProperty {
  final String pointer;

  KhrAnimationPointer._(
      this.pointer, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static final RegExp _pointerRegExp = RegExp(r'^(?:\/(?:[^/~]|~0|~1)*)*$');

  static KhrAnimationPointer fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_ANIMATION_POINTER_MEMBERS, context);
    }

    final pointer =
        getString(map, POINTER, context, req: true, regexp: _pointerRegExp);

    final extensions = getExtensions(map, KhrAnimationPointer, context);

    return KhrAnimationPointer._(pointer, extensions, getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    // TODO:
    // * pointer existence
    // * channel target uniqueness
    // * output accessor compatibility
    context.addIssue(LinkError.incompleteExtensionSupport);

    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is AnimationChannelTarget) {
        if (o.node != null) {
          context.addIssue(
              SemanticError.khrAnimationPointerAnimationChannelTargetNode);
        }
        if (o.path != POINTER) {
          context.addIssue(
              SemanticError.khrAnimationPointerAnimationChannelTargetPath,
              args: [o.path]);
        }
        break;
      }
    }
  }
}

const Extension khrAnimationPointerExtension = Extension(
    KHR_ANIMATION_POINTER,
    <Type, ExtensionDescriptor>{
      AnimationChannelTarget: ExtensionDescriptor(KhrAnimationPointer.fromMap)
    },
    init: _init);

void _init(Context context) {
  context.animationChannelTargetPaths.add(POINTER);
}
