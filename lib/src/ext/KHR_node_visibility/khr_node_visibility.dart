library gltf.extensions.khr_node_visibility;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_NODE_VISIBILITY = 'KHR_node_visibility';
const String VISIBLE = 'visible';

const List<String> KHR_NODE_VISIBILITY_MEMBERS = <String>[
  VISIBLE,
];

class KhrNodeVisibility extends GltfProperty {
  final bool visible;

  KhrNodeVisibility._(
      this.visible, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrNodeVisibility fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_NODE_VISIBILITY_MEMBERS, context);
    }
    return KhrNodeVisibility._(
        getBool(map, VISIBLE, context, def: true),
        getExtensions(map, KhrNodeVisibility, context),
        getExtras(map, context));
  }

  static PointerValidity validateExtensionPointer(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer[inPropDepth] != EXTENSIONS ||
        pointer[inPropDepth + 1] != KHR_NODE_VISIBILITY) {
      return PointerValidity.unknown;
    }
    final node = prop as Node;
    if (node == null) {
      return PointerValidity.invalid;
    }
    if (node.extensions == null ||
        !node.extensions.containsKey(KHR_NODE_VISIBILITY)) {
      return PointerValidity.invalid;
    }
    final subProp = pointer[inPropDepth + 2];
    switch (subProp) {
      case VISIBLE:
        return PointerValidity.validIfBool;
      case EXTENSIONS:
      case EXTRAS:
        return PointerValidity.unknown;
      default:
        return PointerValidity.invalid;
    }
  }
}

const Extension khrNodeVisibilityExtension = Extension(
    KHR_NODE_VISIBILITY,
    <Type, ExtensionDescriptor>{
      Node: ExtensionDescriptor(KhrNodeVisibility.fromMap),
    },
    validateExtensionPointer: KhrNodeVisibility.validateExtensionPointer);
