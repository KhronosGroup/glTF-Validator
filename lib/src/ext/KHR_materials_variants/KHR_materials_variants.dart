// Copyright 2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_materials_variants;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:meta/meta.dart';

const Extension khrMaterialsVariantsExtension =
    Extension('KHR_materials_variants', <Type, ExtensionDescriptor>{
  Gltf: ExtensionDescriptor(KhrMaterialsVariantsGltf.fromMap),
  MeshPrimitive: ExtensionDescriptor(KhrMaterialsVariantsMeshPrimitive.fromMap,
      localLink: true),
});

const String VARIANTS = 'variants';
const String MAPPINGS = 'mappings';

const List<String> KHR_MATERIALS_VARIANTS_GLTF_MEMBERS = <String>[VARIANTS];

const List<String> KHR_MATERIALS_VARIANTS_VARIANT_MEMBERS = <String>[NAME];

const List<String> KHR_MATERIALS_VARIANTS_MESH_PRIMITIVE_MEMBERS = <String>[
  MAPPINGS
];

const List<String> KHR_MATERIALS_VARIANTS_MAPPING_MEMBERS = <String>[
  VARIANTS,
  MATERIAL,
  NAME
];

class KhrMaterialsVariantsGltf extends GltfProperty {
  final SafeList<KhrMaterialsVariantsVariant> variants;

  KhrMaterialsVariantsGltf._(
      this.variants, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsVariantsGltf fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_VARIANTS_GLTF_MEMBERS, context);
    }

    SafeList<KhrMaterialsVariantsVariant> variants;
    final variantMaps = getMapList(map, VARIANTS, context);
    if (variantMaps != null) {
      variants =
          SafeList<KhrMaterialsVariantsVariant>(variantMaps.length, VARIANTS);
      context.path.add(VARIANTS);
      for (var i = 0; i < variantMaps.length; i++) {
        final variantMap = variantMaps[i];
        context.path.add(i.toString());
        variants[i] = KhrMaterialsVariantsVariant.fromMap(variantMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      variants = SafeList<KhrMaterialsVariantsVariant>.empty(VARIANTS);
    }

    return KhrMaterialsVariantsGltf._(
        variants,
        getExtensions(map, KhrMaterialsVariantsGltf, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    context.path.add(VARIANTS);
    context.extensionCollections[variants] =
        context.path.toList(growable: false);
    variants.forEachWithIndices((i, variant) {
      context.path.add(i.toString());
      variant.link(gltf, context);
      context.path.removeLast();
    });
    context.path.removeLast();
  }
}

class KhrMaterialsVariantsVariant extends GltfChildOfRootProperty {
  KhrMaterialsVariantsVariant._(
      String name, Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static KhrMaterialsVariantsVariant fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_VARIANTS_VARIANT_MEMBERS, context);
    }

    return KhrMaterialsVariantsVariant._(
        getName(map, context, req: true),
        getExtensions(map, KhrMaterialsVariantsVariant, context),
        getExtras(map, context));
  }
}

class KhrMaterialsVariantsMeshPrimitive extends GltfProperty {
  final SafeList<KhrMaterialsVariantsMapping> mappings;

  KhrMaterialsVariantsMeshPrimitive._(
      this.mappings, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsVariantsMeshPrimitive fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_VARIANTS_MESH_PRIMITIVE_MEMBERS, context);
    }

    SafeList<KhrMaterialsVariantsMapping> mappings;
    final mappingMaps = getMapList(map, MAPPINGS, context);
    if (mappingMaps != null) {
      mappings =
          SafeList<KhrMaterialsVariantsMapping>(mappingMaps.length, MAPPINGS);
      context.path.add(MAPPINGS);
      for (var i = 0; i < mappingMaps.length; i++) {
        final mappingMap = mappingMaps[i];
        context.path.add(i.toString());
        mappings[i] = KhrMaterialsVariantsMapping.fromMap(mappingMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      mappings = SafeList<KhrMaterialsVariantsMapping>.empty(MAPPINGS);
    }

    final variants = KhrMaterialsVariantsMeshPrimitive._(
        mappings,
        getExtensions(map, KhrMaterialsVariantsMeshPrimitive, context),
        getExtras(map, context));

    context.registerObjectsOwner(variants, [...mappings]);

    return variants;
  }

  @override
  void link(Gltf gltf, Context context) {
    context.path.add(MAPPINGS);

    final uniqueVariants = <int>{};
    mappings.forEachWithIndices((i, mapping) {
      context.path.add(i.toString());
      mapping.link(gltf, context, uniqueIndices: uniqueVariants);
      context.path.removeLast();
    });

    context.path.removeLast();
  }
}

class KhrMaterialsVariantsMapping extends GltfProperty {
  final List<int> _variantIndices;
  final int _materialIndex;
  final String name;

  Material _material;
  Material get material => _material;

  List<KhrMaterialsVariantsVariant> _variants;
  List<KhrMaterialsVariantsVariant> get variants => _variants;

  KhrMaterialsVariantsMapping._(this._variantIndices, this._materialIndex,
      this.name, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrMaterialsVariantsMapping fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_MATERIALS_VARIANTS_MAPPING_MEMBERS, context);
    }

    return KhrMaterialsVariantsMapping._(
        getIndicesList(map, VARIANTS, context, req: true),
        getIndex(map, MATERIAL, context),
        getName(map, context),
        getExtensions(map, KhrMaterialsVariantsMapping, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context, {@required Set<int> uniqueIndices}) {
    final khrMaterialsVariantsGltf =
        gltf.extensions[khrMaterialsVariantsExtension.name];
    if (khrMaterialsVariantsGltf is KhrMaterialsVariantsGltf) {
      if (_variantIndices != null) {
        context.path.add(VARIANTS);
        _variants = List.generate(_variantIndices.length, (i) {
          final _variantIndex = _variantIndices[i];
          final _variant = khrMaterialsVariantsGltf.variants[_variantIndex];
          if (context.validate && _variantIndex != -1) {
            if (!uniqueIndices.add(_variantIndex)) {
              context.addIssue(LinkError.khrMaterialsVariantsNonUniqueVariant,
                  index: i);
            }
            if (_variant == null) {
              context.addIssue(LinkError.unresolvedReference,
                  index: i, args: [_variantIndex]);
            } else {
              _variant.markAsUsed();
            }
          }
          return _variant;
        }, growable: false);
        context.path.removeLast();
      }

      _material = gltf.materials[_materialIndex];
      if (context.validate && _materialIndex != -1) {
        if (_material == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: MATERIAL, args: [_materialIndex]);
        } else {
          _material.markAsUsed();

          // Find the mesh primitive
          Object o = this;
          while (o != null) {
            o = context.owners[o];
            if (o is MeshPrimitive) {
              final primitive = o;

              _material.texCoordIndices.forEach((pointer, texCoord) {
                if (texCoord != -1) {
                  if (texCoord + 1 > primitive.texCoordCount) {
                    context.addIssue(LinkError.meshPrimitiveTooFewTexcoords,
                        name: MATERIAL, args: [pointer, texCoord]);
                  } else {
                    // mark as used
                    primitive.markUsedTexCoord(texCoord);
                  }
                }
              });

              break;
            }
          }
        }
      }
    } else if (context.validate) {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${khrMaterialsVariantsExtension.name}']);
    }
  }
}
