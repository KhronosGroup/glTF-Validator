library gltf.extensions.khr_node_selectability;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_NODE_SELECTABILITY = 'KHR_node_selectability';
const String SELECTABLE = 'selectable';

const List<String> KHR_NODE_SELECTABILITY_MEMBERS = <String>[
  SELECTABLE,
];

class KhrNodeSelectability extends GltfProperty {
  final bool selectable;

  KhrNodeSelectability._(
      this.selectable, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrNodeSelectability fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_NODE_SELECTABILITY_MEMBERS, context);
    }
    return KhrNodeSelectability._(
        getBool(map, SELECTABLE, context, def: true),
        getExtensions(map, KhrNodeSelectability, context),
        getExtras(map, context));
  }
}

const Extension khrNodeSelectabilityExtension =
    Extension(KHR_NODE_SELECTABILITY, <Type, ExtensionDescriptor>{
  Node: ExtensionDescriptor(KhrNodeSelectability.fromMap),
});
