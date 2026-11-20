library gltf.extensions.khr_node_hoverability;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_NODE_HOVERABILITY = 'KHR_node_hoverability';
const String HOVERABLE = 'hoverable';

const List<String> KHR_NODE_HOVERABILITY_MEMBERS = <String>[
  HOVERABLE,
];

class KhrNodeHoverability extends GltfProperty {
  final bool hoverable;

  KhrNodeHoverability._(
      this.hoverable, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrNodeHoverability fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_NODE_HOVERABILITY_MEMBERS, context);
    }
    return KhrNodeHoverability._(
        getBool(map, HOVERABLE, context, def: true),
        getExtensions(map, KhrNodeHoverability, context),
        getExtras(map, context));
  }
}

const Extension khrNodeHoverabilityExtension =
    Extension(KHR_NODE_HOVERABILITY, <Type, ExtensionDescriptor>{
  Node: ExtensionDescriptor(KhrNodeHoverability.fromMap),
});
