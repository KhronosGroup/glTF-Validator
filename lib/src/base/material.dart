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

library gltf.base.material;

import 'package:gltf/src/base/gltf_property.dart';

class Material extends GltfChildOfRootProperty {
  final PbrMetallicRoughness pbrMetallicRoughness;
  final NormalTextureInfo normalTexture;
  final OcclusionTextureInfo occlusionTexture;
  final TextureInfo emissiveTexture;
  final List<double> emissiveFactor;
  final String alphaMode;
  final double alphaCutoff;
  final bool doubleSided;

  final Map<String, int> texCoordIndices = <String, int>{};

  Material._(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  static Material fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, MATERIAL_MEMBERS, context);
    }

    final pbrMetallicRoughness = getObjectFromInnerMap<PbrMetallicRoughness>(
        map, PBR_METALLIC_ROUGHNESS, context, PbrMetallicRoughness.fromMap);
    final normalTexture = getObjectFromInnerMap<NormalTextureInfo>(
        map, NORMAL_TEXTURE, context, NormalTextureInfo.fromMap);
    final occlusionTexture = getObjectFromInnerMap<OcclusionTextureInfo>(
        map, OCCLUSION_TEXTURE, context, OcclusionTextureInfo.fromMap);
    final emissiveTexture = getObjectFromInnerMap<TextureInfo>(
        map, EMISSIVE_TEXTURE, context, TextureInfo.fromMap);
    final emissiveFactor = getFloatList(map, EMISSIVE_FACTOR, context,
        lengthsList: const [3], min: 0, max: 1, def: const [0, 0, 0]);
    final alphaMode = getString(map, ALPHA_MODE, context,
        def: OPAQUE, list: MATERIAL_ALPHA_MODES);
    final alphaCutoff = getFloat(map, ALPHA_CUTOFF, context, min: 0, def: 0.5);

    if (context.validate &&
        alphaMode != MASK &&
        map.containsKey(ALPHA_CUTOFF)) {
      context.addIssue(SemanticError.materialAlphaCutoffInvalidMode,
          name: ALPHA_CUTOFF);
    }

    final doubleSided = getBool(map, DOUBLE_SIDED, context);

    final extensions = getExtensions(map, Material, context);

    final material = Material._(
        pbrMetallicRoughness,
        normalTexture,
        occlusionTexture,
        emissiveTexture,
        emissiveFactor,
        alphaMode,
        alphaCutoff,
        doubleSided,
        getName(map, context),
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(material, [
      pbrMetallicRoughness,
      normalTexture,
      occlusionTexture,
      emissiveTexture,
      ...extensions.values
    ]);

    return material;
  }

  @override
  void link(Gltf gltf, Context context) {
    void linkWithPath(GltfProperty property, String name) {
      if (property != null) {
        context.path.add(name);
        property.link(gltf, context);
        context.path.removeLast();
      }
    }

    linkWithPath(pbrMetallicRoughness, PBR_METALLIC_ROUGHNESS);
    linkWithPath(normalTexture, NORMAL_TEXTURE);
    linkWithPath(occlusionTexture, OCCLUSION_TEXTURE);
    linkWithPath(emissiveTexture, EMISSIVE_TEXTURE);
  }
}

class PbrMetallicRoughness extends GltfProperty {
  final List<double> baseColorFactor;
  final TextureInfo baseColorTexture;

  final double metallicFactor;
  final double roughnessFactor;
  final TextureInfo metallicRoughnessTexture;

  PbrMetallicRoughness._(
      this.baseColorFactor,
      this.baseColorTexture,
      this.metallicFactor,
      this.roughnessFactor,
      this.metallicRoughnessTexture,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  static PbrMetallicRoughness fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, PBR_METALLIC_ROUGHNESS_MEMBERS, context);
    }

    final baseColorFactor = getFloatList(map, BASE_COLOR_FACTOR, context,
        lengthsList: const [4], min: 0, max: 1, def: const [1, 1, 1, 1]);
    final baseColorTexture = getObjectFromInnerMap<TextureInfo>(
        map, BASE_COLOR_TEXTURE, context, TextureInfo.fromMap);
    final metallicFactor =
        getFloat(map, METALLIC_FACTOR, context, min: 0, max: 1, def: 1);
    final roughnessFactor =
        getFloat(map, ROUGHNESS_FACTOR, context, min: 0, max: 1, def: 1);
    final metallicRoughnessTexture = getObjectFromInnerMap<TextureInfo>(
        map, METALLIC_ROUGHNESS_TEXTURE, context, TextureInfo.fromMap);

    final extensions = getExtensions(map, PbrMetallicRoughness, context);

    final pbrMr = PbrMetallicRoughness._(
        baseColorFactor,
        baseColorTexture,
        metallicFactor,
        roughnessFactor,
        metallicRoughnessTexture,
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(pbrMr,
        [baseColorTexture, metallicRoughnessTexture, ...extensions.values]);

    return pbrMr;
  }

  @override
  void link(Gltf gltf, Context context) {
    if (baseColorTexture != null) {
      context.path.add(BASE_COLOR_TEXTURE);
      baseColorTexture.link(gltf, context);
      context.path.removeLast();
    }

    if (metallicRoughnessTexture != null) {
      context.path.add(METALLIC_ROUGHNESS_TEXTURE);
      metallicRoughnessTexture.link(gltf, context);
      context.path.removeLast();
    }
  }
}

class OcclusionTextureInfo extends TextureInfo {
  final double strength;

  OcclusionTextureInfo._(int index, int texCoord, this.strength,
      Map<String, Object> extensions, Object extras)
      : super._(index, texCoord, extensions, extras);

  static OcclusionTextureInfo fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OCCLUSION_TEXTURE_INFO_MEMBERS, context);
    }

    final extensions = getExtensions(map, OcclusionTextureInfo, context,
        overriddenType: Material);

    final occlusionTextureInfo = OcclusionTextureInfo._(
        getIndex(map, INDEX, context),
        getUint(map, TEX_COORD, context, def: 0),
        getFloat(map, STRENGTH, context, min: 0, max: 1, def: 1),
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(occlusionTextureInfo, extensions.values);

    return occlusionTextureInfo;
  }
}

class NormalTextureInfo extends TextureInfo {
  final double scale;

  NormalTextureInfo._(int index, int texCoord, this.scale,
      Map<String, Object> extensions, Object extras)
      : super._(index, texCoord, extensions, extras);

  static NormalTextureInfo fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, NORMAL_TEXTURE_INFO_MEMBERS, context);
    }

    final extensions = getExtensions(map, NormalTextureInfo, context,
        overriddenType: Material);

    final normalTextureInfo = NormalTextureInfo._(
        getIndex(map, INDEX, context),
        getUint(map, TEX_COORD, context, def: 0),
        getFloat(map, SCALE, context, def: 1),
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(normalTextureInfo, extensions.values);

    return normalTextureInfo;
  }
}

class TextureInfo extends GltfProperty {
  final int _index;
  final int texCoord;

  Texture _texture;

  TextureInfo._(
      this._index, this.texCoord, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  Texture get texture => _texture;

  static TextureInfo fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, TEXTURE_INFO_MEMBERS, context);
    }

    final extensions =
        getExtensions(map, TextureInfo, context, overriddenType: Material);

    final textureInfo = TextureInfo._(
        getIndex(map, INDEX, context),
        getUint(map, TEX_COORD, context, def: 0),
        extensions,
        getExtras(map, context));

    context.registerObjectsOwner(textureInfo, extensions.values);

    return textureInfo;
  }

  @override
  void link(Gltf gltf, Context context) {
    _texture = gltf.textures[_index];

    if (context.validate && _index != -1) {
      if (_texture == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: INDEX, args: [_index]);
      } else {
        _texture.markAsUsed();
      }
    }

    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is Material) {
        o.texCoordIndices[context.getPointerString()] = texCoord;
        break;
      }
    }
  }
}
