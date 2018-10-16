/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
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

library gltf.base.gltf;

import 'package:gltf/src/base/accessor.dart';
import 'package:gltf/src/base/animation.dart';
import 'package:gltf/src/base/asset.dart';
import 'package:gltf/src/base/buffer.dart';
import 'package:gltf/src/base/buffer_view.dart';
import 'package:gltf/src/base/camera.dart';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/base/image.dart';
import 'package:gltf/src/base/material.dart';
import 'package:gltf/src/base/mesh.dart';
import 'package:gltf/src/base/node.dart';
import 'package:gltf/src/base/sampler.dart';
import 'package:gltf/src/base/scene.dart';
import 'package:gltf/src/base/skin.dart';
import 'package:gltf/src/base/texture.dart';

export 'package:gltf/src/base/accessor.dart';
export 'package:gltf/src/base/animation.dart';
export 'package:gltf/src/base/asset.dart';
export 'package:gltf/src/base/buffer.dart';
export 'package:gltf/src/base/buffer_view.dart';
export 'package:gltf/src/base/camera.dart';
export 'package:gltf/src/base/image.dart';
export 'package:gltf/src/base/material.dart';
export 'package:gltf/src/base/mesh.dart';
export 'package:gltf/src/base/node.dart';
export 'package:gltf/src/base/sampler.dart';
export 'package:gltf/src/base/scene.dart';
export 'package:gltf/src/base/skin.dart';
export 'package:gltf/src/base/texture.dart';

class Gltf extends GltfProperty {
  final List<String> extensionsUsed;
  final List<String> extensionsRequired;
  final SafeList<Accessor> accessors;
  final SafeList<Animation> animations;
  final Asset asset;
  final SafeList<Buffer> buffers;
  final SafeList<BufferView> bufferViews;
  final SafeList<Camera> cameras;
  final SafeList<Image> images;
  final SafeList<Material> materials;
  final SafeList<Mesh> meshes;
  final SafeList<Node> nodes;
  final SafeList<Sampler> samplers;
  final int _sceneIndex;
  final Scene scene;
  final SafeList<Scene> scenes;
  final SafeList<Skin> skins;
  final SafeList<Texture> textures;

  Gltf._(
      this.extensionsUsed,
      this.extensionsRequired,
      this.accessors,
      this.animations,
      this.asset,
      this.buffers,
      this.bufferViews,
      this.cameras,
      this.images,
      this.materials,
      this.meshes,
      this.nodes,
      this.samplers,
      this._sceneIndex,
      this.scene,
      this.scenes,
      this.skins,
      this.textures,
      Map<String, Object> extensions,
      Object extras)
      : super(extensions, extras);

  factory Gltf.fromMap(Map<String, Object> map, Context context) {
    void resetPath() => context.path.clear();

    resetPath();
    if (context.validate) {
      checkMembers(map, GLTF_MEMBERS, context);

      // See https://github.com/KhronosGroup/glTF/pull/1025
      if (map.containsKey(EXTENSIONS_REQUIRED) &&
          !map.containsKey(EXTENSIONS_USED)) {
        context.addIssue(SchemaError.unsatisfiedDependency,
            name: EXTENSIONS_REQUIRED, args: [EXTENSIONS_USED]);
      }
    }

    final extensionsUsed =
        getStringList(map, EXTENSIONS_USED, context) ?? <String>[];

    final extensionsRequired =
        getStringList(map, EXTENSIONS_REQUIRED, context) ?? <String>[];

    context.initExtensions(extensionsUsed, extensionsRequired);

    // Helper function for converting JSON array to List of proper glTF objects
    SafeList<T> toSafeList<T>(String name, FromMapFunction<T> fromMap) {
      if (!map.containsKey(name)) {
        return SafeList<T>.empty(name);
      }

      resetPath();

      final itemsList = map[name];
      if (itemsList is List<Object>) {
        if (itemsList.isNotEmpty) {
          final items = SafeList<T>(itemsList.length, name);
          context.path.add(name);
          for (var i = 0; i < itemsList.length; i++) {
            final itemMap = itemsList[i];
            if (itemMap is Map<String, Object>) {
              // JSON mandates all keys to be string
              context.path.add(i.toString());
              items[i] = fromMap(itemMap, context);
              context.path.removeLast();
            } else {
              context.addIssue(SchemaError.typeMismatch,
                  index: i, args: [itemMap, 'object']);
            }
          }
          return items;
        } else {
          context.addIssue(SchemaError.emptyEntity, name: name);
          return SafeList<T>.empty(name);
        }
      } else {
        context.addIssue(SchemaError.typeMismatch,
            name: name, args: [itemsList, 'array']);
        return SafeList<T>.empty(name);
      }
    }

    // Helper function for converting JSON dictionary to proper glTF object
    T toValue<T>(String name, FromMapFunction<T> fromMap, {bool req = false}) {
      resetPath();
      final item = getMap(map, name, context, req: req);
      if (item == null) {
        return null;
      }
      context.path.add(name);
      return fromMap(item, context);
    }

    final asset = toValue<Asset>(ASSET, Asset.fromMap, req: true);

    if (asset == null) {
      return null;
    } else if (asset.majorVersion != 2) {
      context.addIssue(SemanticError.unknownAssetMajorVersion,
          args: [asset?.majorVersion]);
      return null;
    } else if (asset.minorVersion > 0) {
      context.addIssue(SemanticError.unknownAssetMinorVersion,
          args: [asset?.minorVersion]);
    }

    final accessors = toSafeList<Accessor>(ACCESSORS, Accessor.fromMap);

    final animations = toSafeList<Animation>(ANIMATIONS, Animation.fromMap);

    final buffers = toSafeList<Buffer>(BUFFERS, Buffer.fromMap);

    final bufferViews =
        toSafeList<BufferView>(BUFFER_VIEWS, BufferView.fromMap);

    final cameras = toSafeList<Camera>(CAMERAS, Camera.fromMap);

    final images = toSafeList<Image>(IMAGES, Image.fromMap);

    final materials = toSafeList<Material>(MATERIALS, Material.fromMap);

    final meshes = toSafeList<Mesh>(MESHES, Mesh.fromMap);

    final nodes = toSafeList<Node>(NODES, Node.fromMap);

    final samplers = toSafeList<Sampler>(SAMPLERS, Sampler.fromMap);

    final scenes = toSafeList<Scene>(SCENES, Scene.fromMap);

    resetPath();
    final sceneIndex = getIndex(map, SCENE, context, req: false);
    final scene = scenes[sceneIndex];

    if (context.validate && sceneIndex != -1 && scene == null) {
      context.addIssue(LinkError.unresolvedReference,
          name: SCENE, args: [sceneIndex]);
    }

    final skins = toSafeList<Skin>(SKINS, Skin.fromMap);

    final textures = toSafeList<Texture>(TEXTURES, Texture.fromMap);

    resetPath();

    final gltf = Gltf._(
        extensionsUsed,
        extensionsRequired,
        accessors,
        animations,
        asset,
        buffers,
        bufferViews,
        cameras,
        images,
        materials,
        meshes,
        nodes,
        samplers,
        sceneIndex,
        scene,
        scenes,
        skins,
        textures,
        getExtensions(map, Gltf, context),
        getExtras(map, context));

    // Step 2: linking IDs
    void linkCollection(SafeList<GltfProperty> list, Type type) {
      context.path.add(list.name);
      list.forEachWithIndices((i, item) {
        context.path.add(i.toString());
        item.link(gltf, context);
        context.path.removeLast();
      });

      final extensions = context.linkableExtensions[type];
      if (extensions != null) {
        final oldPath = context.path.toList(growable: false);
        for (final entry in extensions) {
          context.path
            ..clear()
            ..addAll(entry.path);
          entry.object.link(gltf, context);
        }
        context.path
          ..clear()
          ..addAll(oldPath);
      }

      context.path.removeLast();
    }

    // Fixed order
    linkCollection(bufferViews, BufferView);

    linkCollection(accessors, Accessor);

    linkCollection(images, Image);
    linkCollection(textures, Texture);
    linkCollection(materials, Material);

    linkCollection(meshes, Mesh);

    linkCollection(nodes, Node);
    linkCollection(skins, Skin);

    linkCollection(animations, Animation);
    linkCollection(scenes, Scene);

    // Check node tree loops and orphaned objects
    if (context.validate) {
      context.path.add(NODES);
      final seenNodes = Set<Node>();
      gltf.nodes.forEachWithIndices((i, node) {
        if (!node.isJoint &&
            node.children == null &&
            node.mesh == null &&
            node.camera == null &&
            node.extensions.isEmpty &&
            node.extras == null) {
          context.addIssue(SemanticError.nodeEmpty, index: i);
        }

        if (node.parent == null) {
          return;
        }
        seenNodes.clear();
        var temp = node;
        while (temp.parent != null) {
          if (seenNodes.add(temp)) {
            temp = temp.parent;
          } else {
            if (temp == node) {
              context.addIssue(LinkError.nodeLoop, index: i);
            }
            break;
          }
        }
      });
      context.path.removeLast();

      // Checking unused objects
      final collections = <SafeList<GltfProperty>>[
        accessors,
        buffers,
        bufferViews,
        cameras,
        images,
        materials,
        meshes,
        nodes,
        samplers,
        skins,
        textures
      ];

      for (final collection in collections) {
        if (collection.isEmpty) {
          continue;
        }

        context.path.add(collection.name);
        for (var i = 0; i < collection.length; ++i) {
          if (collection[i]?.isUsed == false) {
            context.addIssue(LinkError.unusedObject, index: i);
          }
        }
        context.path.removeLast();
      }
    }

    return gltf;
  }

  @override
  String toString([_]) => super.toString({
        ASSET: asset,
        ACCESSORS: accessors,
        ANIMATIONS: animations,
        BUFFERS: buffers,
        BUFFER_VIEWS: bufferViews,
        CAMERAS: cameras,
        IMAGES: images,
        MATERIALS: materials,
        MESHES: meshes,
        NODES: nodes,
        SAMPLERS: samplers,
        SCENES: scenes,
        SCENE: _sceneIndex,
        SKINS: skins,
        TEXTURES: textures,
        EXTENSIONS_REQUIRED: extensionsRequired,
        EXTENSIONS_USED: extensionsUsed
      });
}
