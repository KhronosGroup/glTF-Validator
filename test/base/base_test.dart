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

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:gltf/gltf.dart';
import 'package:gltf/src/data_access/image_decoder.dart';
import 'package:test/test.dart';

import '../utils.dart';

Future main() async {
  await compareReports('test/base');

  group('Evaluate valid objects', () {
    test('Asset', () async {
      final gltf = (await read('base/data/asset/valid.gltf')).gltf;

      expect(gltf.asset.copyright, 'Khronos Group Inc.');
      expect(gltf.asset.generator, 'glTF 2.0 Validator test suite');
      expect(gltf.asset.version, '2.0');
      expect(gltf.asset.majorVersion, 2);
      expect(gltf.asset.minorVersion, 0);
      expect(gltf.asset.minVersion, '2.0');
      expect(gltf.asset.majorMinVersion, 2);
      expect(gltf.asset.minorMinVersion, 0);
      expect(gltf.asset.extensions, isEmpty);
    });

    test('Buffer', () async {
      final gltf =
          (await read('base/data/buffer/valid.gltf', ignoreUnused: true)).gltf;

      final buf0 = gltf.buffers[0];
      expect(buf0.uri.toString(), 'valid.bin');
      expect(buf0.byteLength, 16);
      expect(buf0.data,
          const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
      expect(buf0.extensions, isEmpty);

      final buf1 = gltf.buffers[1];
      expect(buf1.data, [0]);
      expect(buf1.byteLength, 1);
      expect(buf1.extensions, isEmpty);
    });

    test('Buffer View', () async {
      final gltf =
          (await read('base/data/buffer_view/valid.gltf', ignoreUnused: true))
              .gltf;

      final bufferView = gltf.bufferViews[0];
      expect(bufferView.buffer, gltf.buffers[0]);
      expect(bufferView.byteOffset, 0);
      expect(bufferView.byteLength, 4);
      expect(bufferView.byteStride, 4);
      expect(bufferView.target, 34962);
      expect(bufferView.extensions, isEmpty);
    });

    test('Camera', () async {
      final gltf =
          (await read('base/data/camera/valid.gltf', ignoreUnused: true)).gltf;

      final cam0 = gltf.cameras[0];
      expect(cam0.type, 'perspective');
      expect(cam0.extensions, isEmpty);
      expect(cam0.perspective.aspectRatio, 1.0);
      expect(cam0.perspective.yfov, 1.0);
      expect(cam0.perspective.zfar, 10.0);
      expect(cam0.perspective.znear, 1.0);
      expect(cam0.perspective.extensions, isEmpty);

      final cam1 = gltf.cameras[1];
      expect(cam1.type, 'orthographic');
      expect(cam1.extensions, isEmpty);
      expect(cam1.orthographic.xmag, 1.0);
      expect(cam1.orthographic.ymag, 1.0);
      expect(cam1.orthographic.zfar, 10.0);
      expect(cam1.orthographic.znear, 1.0);
      expect(cam1.orthographic.extensions, isEmpty);
    });

    test('Image', () async {
      final gltf =
          (await read('base/data/image/valid.gltf', ignoreUnused: true)).gltf;

      final img0 = gltf.images[0];
      expect(img0.bufferView, isNull);
      expect(img0.uri.toString(), 'magenta.png');
      expect(img0.info.mimeType, 'image/png');
      expect(img0.info.height, 1);
      expect(img0.info.width, 1);
      expect(img0.info.bits, 8);
      expect(img0.info.format, Format.RGB);
      expect(img0.extensions, isEmpty);

      final img1 = gltf.images[1];
      expect(img1.bufferView, isNull);
      expect(img1.data.length, 69);
      expect(img1.mimeType, isNull);
      expect(img1.info.mimeType, 'image/png');
      expect(img1.extensions, isEmpty);

      final img2 = gltf.images[2];
      expect(img2.bufferView, gltf.bufferViews[0]);
      expect(img2.uri, isNull);
      expect(img2.mimeType, 'image/png');
      expect(img2.data.length, 69);
      expect(img2.extensions, isEmpty);

      final img3 = gltf.images[3];
      expect(img3.bufferView, gltf.bufferViews[1]);
      expect(img3.uri, isNull);
      expect(img3.mimeType, 'image/png');
      expect(img3.data.length, 69);
      expect(img3.extensions, isEmpty);

      final img4 = gltf.images[4];
      expect(img4.bufferView, isNull);
      expect(img4.uri.toString(), 'cyan.jpg');
      expect(img4.info.mimeType, 'image/jpeg');
      expect(img4.info.height, 2);
      expect(img4.info.width, 2);
      expect(img4.info.bits, 8);
      expect(img4.info.format, Format.RGB);
      expect(img4.extensions, isEmpty);
    });

    test('Sampler', () async {
      final gltf =
          (await read('base/data/sampler/valid.gltf', ignoreUnused: true)).gltf;

      final sampler = gltf.samplers[0];
      expect(sampler.magFilter, 9728);
      expect(sampler.minFilter, 9987);
      expect(sampler.wrapS, 33071);
      expect(sampler.wrapT, 33648);
      expect(sampler.extensions, isEmpty);
    });

    test('Texture', () async {
      final gltf =
          (await read('base/data/texture/valid.gltf', ignoreUnused: true)).gltf;

      final texture = gltf.textures[0];
      expect(texture.sampler, gltf.samplers[0]);
      expect(texture.source, gltf.images[0]);
      expect(texture.extensions, isEmpty);
    });

    test('Material', () async {
      final gltf =
          (await read('base/data/material/valid.gltf', ignoreUnused: true))
              .gltf;

      final material = gltf.materials[0];

      final pbrMr = material.pbrMetallicRoughness;
      expect(pbrMr.baseColorFactor, [1.0, 0.0, 1.0, 1.0]);
      expect(pbrMr.metallicFactor, 0.7);
      expect(pbrMr.roughnessFactor, 0.3);
      expect(pbrMr.baseColorTexture.texture, gltf.textures[0]);
      expect(pbrMr.baseColorTexture.texCoord, 0);
      expect(pbrMr.baseColorTexture.extensions, isEmpty);
      expect(pbrMr.metallicRoughnessTexture.texture, gltf.textures[1]);
      expect(pbrMr.metallicRoughnessTexture.texCoord, 1);
      expect(pbrMr.metallicRoughnessTexture.extensions, isEmpty);
      expect(pbrMr.extensions, isEmpty);

      expect(material.normalTexture.scale, 2.1);
      expect(material.normalTexture.texture, gltf.textures[2]);
      expect(material.normalTexture.texCoord, 2);
      expect(material.normalTexture.extensions, isEmpty);

      expect(material.occlusionTexture.strength, 0.5);
      expect(material.occlusionTexture.texture, gltf.textures[3]);
      expect(material.occlusionTexture.texCoord, 3);
      expect(material.occlusionTexture.extensions, isEmpty);

      expect(material.emissiveTexture.texture, gltf.textures[4]);
      expect(material.emissiveTexture.texCoord, 4);
      expect(material.emissiveTexture.extensions, isEmpty);

      expect(material.emissiveFactor, [0.0, 1.0, 0.0]);

      expect(material.alphaMode, 'MASK');
      expect(material.alphaCutoff, 0.4);

      expect(material.doubleSided, true);

      expect(material.extensions, isEmpty);
    });

    test('Accessor', () async {
      final gltf =
          (await read('base/data/accessor/valid.gltf', ignoreUnused: true))
              .gltf;

      final accessor = gltf.accessors[0];

      expect(accessor.bufferView, gltf.bufferViews[0]);
      expect(accessor.componentType, 5126);
      expect(accessor.count, 4);
      expect(accessor.type, 'VEC3');
      expect(accessor.normalized, false);
      expect(accessor.max, [1.0, 1.0, 1.0]);
      expect(accessor.min, [0.0, 0.0, 0.0]);
      expect(accessor.sparse.count, 2);
      expect(accessor.sparse.indices.bufferView, gltf.bufferViews[1]);
      expect(accessor.sparse.indices.byteOffset, 24);
      expect(accessor.sparse.indices.componentType, 5121);
      expect(accessor.sparse.indices.extensions, isEmpty);
      expect(accessor.sparse.values.bufferView, gltf.bufferViews[1]);
      expect(accessor.sparse.values.byteOffset, 0);
      expect(accessor.sparse.values.extensions, isEmpty);
      expect(accessor.sparse.extensions, isEmpty);
      expect(accessor.extensions, isEmpty);
    });

    group('Accessor getElements', () {
      Gltf gltf;

      setUpAll(() async {
        gltf = (await read('base/data/accessor_data/get_elements.gltf',
                ignoreUnused: true))
            .gltf;

        // All buffers are loaded
        expect(gltf.buffers.every((buffer) => buffer.data != null), true);
      });

      test('Regular', () async {
        final elements = gltf.accessors[0].getElements();

        expect(elements, orderedEquals(<double>[0, -5, 27, -0, 10.5, 0.5]));
      });

      test('Scalar float & vec2 ushort', () async {
        final elements1 = gltf.accessors[1].getElements();
        final elements2 = gltf.accessors[2].getElements();
        final elements2n = gltf.accessors[2].getElementsNormalized();

        expect(elements1, orderedEquals(<double>[1000, 0.25]));
        expect(elements2, orderedEquals(<int>[50, 45, 12345, 0]));
        expect(
            elements2n,
            orderedEquals(<double>[
              50 * (1 / 65535),
              45 * (1 / 65535),
              12345 * (1 / 65535),
              0
            ]));
      });

      test('vec3 byte & vec4 short', () async {
        final elements1 = gltf.accessors[3].getElements();
        final elements1n = gltf.accessors[3].getElementsNormalized();
        final elements2 = gltf.accessors[4].getElements();
        final elements2n = gltf.accessors[4].getElementsNormalized();

        expect(elements1, orderedEquals(<int>[1, 126, -127, 0, 50, -125]));
        expect(
            elements1n,
            orderedEquals(<double>[
              1 / 127,
              126 * (1 / 127),
              -127 * (1 / 127),
              0,
              50 * (1 / 127),
              -125 * (1 / 127)
            ]));
        expect(elements2,
            orderedEquals(<int>[50, 45, 12345, 0, -1, 45, 12345, 0]));

        expect(
            elements2n,
            orderedEquals(<double>[
              50 * (1 / 32767),
              45 * (1 / 32767),
              12345 * (1 / 32767),
              0,
              -1 * (1 / 32767),
              45 * (1 / 32767),
              12345 * (1 / 32767),
              0 * (1 / 32767)
            ]));
      });
    });

    group('Accessor Matrix getElements', () {
      Gltf gltf;

      setUpAll(() async {
        gltf = (await read('base/data/accessor_data/get_elements_matrix.gltf',
                ignoreUnused: true))
            .gltf;

        // All buffers are loaded
        expect(gltf.buffers.every((buffer) => buffer.data != null), true);
      });

      test('MAT2 BYTE', () async {
        final elements = gltf.accessors[0].getElements();

        expect(elements, orderedEquals(<int>[1, 2, -3, -4, 5, 6, -7, -8]));
      });

      test('MAT2 SHORT', () async {
        final elements = gltf.accessors[1].getElements();

        expect(elements, orderedEquals(<int>[-1, -2, 3, 4, -5, -6, 7, 8]));
      });

      test('MAT3 UBYTE', () async {
        final elements = gltf.accessors[2].getElements();

        expect(
            elements,
            orderedEquals(<int>[
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18
            ]));
      });

      test('MAT3 USHORT', () async {
        final elements = gltf.accessors[3].getElements();

        expect(
            elements,
            orderedEquals(<int>[
              3,
              2,
              1,
              6,
              5,
              4,
              9,
              8,
              7,
              12,
              11,
              10,
              15,
              14,
              13,
              18,
              17,
              16
            ]));
      });
    });

    group('Accessor getElements sparse', () {
      Gltf gltf;

      setUpAll(() async {
        gltf = (await read('base/data/accessor_data/get_elements_sparse.gltf',
                ignoreUnused: true))
            .gltf;

        // All buffers are loaded
        expect(gltf.buffers.every((buffer) => buffer.data != null), true);
      });

      test('Zeros', () async {
        final elements = gltf.accessors[0].getElements().toList();

        expect(elements, orderedEquals(<double>[0, 0]));
      });

      test('Zeros with Sparse', () async {
        final elements = gltf.accessors[1].getElements().toList();

        expect(elements, orderedEquals(<double>[0.125, 1024]));
      });

      test('Partially overridden', () async {
        final elements = gltf.accessors[2].getElements().toList();

        expect(elements, orderedEquals(<int>[70000, 100001, 54321, 200002]));
      });
    });

    test('Mesh', () async {
      final gltf =
          (await read('base/data/mesh/valid.gltf', ignoreUnused: true)).gltf;

      final mesh = gltf.meshes[0];
      final primitive = mesh.primitives[0];
      expect(primitive.attributes['POSITION'], gltf.accessors[1]);
      expect(primitive.attributes['COLOR_0'], gltf.accessors[4]);
      expect(primitive.indices, gltf.accessors[0]);
      expect(primitive.material, gltf.materials[0]);
      expect(primitive.mode, 4);
      expect(primitive.targets[0]['POSITION'], gltf.accessors[2]);
      expect(primitive.targets[1]['POSITION'], gltf.accessors[3]);
      expect(primitive.targets[0]['COLOR_0'], gltf.accessors[5]);
      expect(primitive.targets[1]['COLOR_0'], gltf.accessors[6]);
      expect(primitive.extensions, isEmpty);
      expect(mesh.weights, [0.7, 0.2]);
      expect(mesh.extensions, isEmpty);
    });

    test('Node', () async {
      final gltf =
          (await read('base/data/node/valid.gltf', ignoreUnused: true)).gltf;

      final node0 = gltf.nodes[0];
      expect(node0.camera, gltf.cameras[0]);
      expect(node0.children, [gltf.nodes[1]]);
      expect(node0.skin, gltf.skins[0]);
      expect(node0.mesh, gltf.meshes[0]);
      expect(node0.weights, [0.5]);
      expect(node0.extensions, isEmpty);

      final node1 = gltf.nodes[1];
      expect(node1.camera, isNull);
      expect(node1.children, isNull);
      expect(node1.skin, isNull);
      expect(node1.matrix, isNull);
      expect(node1.mesh, isNull);
      expect(node1.weights, isNull);
      expect(node1.scale.storage, [1.0, 1.0, 1.0]);
      expect(node1.rotation.storage, [0.0, 0.0, 0.0, 1.0]);
      expect(node1.translation.storage, [0.0, 0.0, 0.0]);
      expect(node1.extensions, isEmpty);
    });

    test('Skin', () async {
      final gltf =
          (await read('base/data/skin/valid.gltf', ignoreUnused: true)).gltf;

      final skin = gltf.skins[0];
      expect(skin.joints, [gltf.nodes[1], gltf.nodes[2], gltf.nodes[3]]);
      expect(skin.inverseBindMatrices, gltf.accessors[0]);
      expect(skin.skeleton, gltf.nodes[0]);
      expect(skin.commonRoots, {gltf.nodes[0], gltf.nodes[1]});
      expect(skin.extensions, isEmpty);
    });

    test('Scene', () async {
      final gltf =
          (await read('base/data/scene/valid.gltf', ignoreUnused: true)).gltf;

      final scene = gltf.scenes[0];
      expect(scene.nodes, [gltf.nodes[0]]);
      expect(scene.extensions, isEmpty);

      expect(gltf.scene, scene);
    });

    test('Animation', () async {
      final gltf =
          (await read('base/data/animation/valid.gltf', ignoreUnused: true))
              .gltf;

      final animation = gltf.animations[0];
      expect(animation.channels[0].sampler, animation.samplers[0]);
      expect(animation.channels[0].target.node, gltf.nodes[0]);
      expect(animation.channels[0].target.path, 'scale');
      expect(animation.channels[0].target.extensions, isEmpty);
      expect(animation.channels[0].extensions, isEmpty);
      expect(animation.samplers[0].input, gltf.accessors[0]);
      expect(animation.samplers[0].output, gltf.accessors[1]);
      expect(animation.samplers[0].interpolation, 'LINEAR');
      expect(animation.samplers[0].extensions, isEmpty);
      expect(animation.extensions, isEmpty);
    });

    group('Root object', () {
      test('Valid', () async {
        final gltf =
            (await read('base/data/root/valid.gltf', ignoreUnused: true)).gltf;

        expect(gltf.accessors, isEmpty);
        expect(gltf.animations, isEmpty);
        expect(gltf.buffers, isEmpty);
        expect(gltf.bufferViews, isEmpty);
        expect(gltf.cameras, isEmpty);
        expect(gltf.images, isEmpty);
        expect(gltf.meshes, isEmpty);
        expect(gltf.nodes, isEmpty);
        expect(gltf.samplers, isEmpty);
        expect(gltf.scenes, isEmpty);
        expect(gltf.scene, isNull);
        expect(gltf.skins, isEmpty);
        expect(gltf.textures, isEmpty);
        expect(gltf.extensionsRequired, isEmpty);
        expect(gltf.extensionsUsed, isEmpty);
        expect(gltf.extensions, isEmpty);
      });

      test('Object names', () async {
        final gltf = (await read('base/data/root/named_objects.gltf',
                ignoreUnused: true))
            .gltf;

        expect(gltf.accessors[0].name, 'Accessor name');
        expect(gltf.animations[0].name, 'Animation name');
        expect(gltf.buffers[0].name, 'Buffer name');
        expect(gltf.bufferViews[0].name, 'Buffer view name');
        expect(gltf.cameras[0].name, 'Camera name');
        expect(gltf.images[0].name, 'Image name');
        expect(gltf.meshes[0].name, 'Mesh name');
        expect(gltf.nodes[0].name, 'Node name');
        expect(gltf.samplers[0].name, 'Sampler name');
        expect(gltf.scenes[0].name, 'Scene name');
        expect(gltf.skins[0].name, 'Skin name');
        expect(gltf.textures[0].name, 'Texture name');
      });
    });
  });

  group('GltfReader', () {
    test('File extensions', () {
      final gltfReader = GltfReader.filename(null, '.gltf', null);
      final glbReader = GltfReader.filename(null, '.glb', null);
      final invalidReader = GltfReader.filename(null, '.glb2', null);

      expect(gltfReader, const TypeMatcher<GltfJsonReader>());
      expect(glbReader, const TypeMatcher<GlbReader>());
      expect(invalidReader, isNull);
    });

    group('Stream Errors', () {
      const ERROR_STRING = 'Stream error throwable';
      StreamController<List<int>> controller;

      setUp(() {
        controller = StreamController<List<int>>(onListen: () {
          controller
            ..addError(ERROR_STRING)
            ..close();
        });
      });

      test('glTF Stream error', () {
        expect(GltfJsonReader(controller.stream).read(), throwsA(ERROR_STRING));
      });

      test('GLB Stream Error', () {
        expect(GlbReader(controller.stream).read(), throwsA(ERROR_STRING));
      });
    });

    group('Stream Detection', () {
      test('Empty Stream', () {
        expect(GltfReader.detect(Stream.value(Uint8List(0))),
            throwsA(const TypeMatcher<GltfInvalidFormatException>()));
      });

      test('Invalid Stream', () {
        expect(GltfReader.detect(Stream.value(Uint8List.fromList([99]))),
            throwsA(const TypeMatcher<GltfInvalidFormatException>()));
      });

      test('Valid glTF Stream', () {
        expect(
            GltfReader.detect(
                File('test/base/data/root/valid.gltf').openRead()),
            completion(const TypeMatcher<GltfJsonReader>()));
      });

      test('Valid GLB Stream', () {
        expect(
            GltfReader.detect(File('test/base/data/glb/valid.glb').openRead()),
            completion(const TypeMatcher<GlbReader>()));
      });
    });
  });
}
