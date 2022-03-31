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

library gltf.data_access.resources_loader;

import 'dart:async';
import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/data_access/image_decoder.dart';
import 'package:gltf/src/data_access/validate_accessors.dart';
import 'package:meta/meta.dart';

typedef SequentialFetchFunction = Stream<List<int>> Function(Uri uri);
typedef BytesFetchFunction = FutureOr<Uint8List> Function([Uri uri]);

enum _Storage { DataUri, BufferView, GLB, External }

class ResourceInfo {
  final String pointer;
  String mimeType;
  _Storage storage;
  int byteLength;
  String uri;
  ImageInfo image;

  ResourceInfo(this.pointer);

  Map<String, Object> toMap() {
    assert(pointer != null);
    const storageString = <String>[
      'data-uri',
      'buffer-view',
      'glb',
      'external'
    ];

    final map = <String, Object>{
      'pointer': pointer,
      if (mimeType != null) 'mimeType': mimeType,
      if (storage != null) 'storage': storageString[storage.index]
    };

    addToMapIfNotNull(map, 'uri', uri);
    addToMapIfNotNull(map, 'byteLength', byteLength);
    addToMapIfNotNull(map, 'image', image?.toMap());

    return map;
  }
}

class ResourcesLoader {
  final Gltf gltf;
  final Context context;

  final BytesFetchFunction externalBytesFetch;
  final SequentialFetchFunction externalStreamFetch;

  ResourcesLoader(this.context, this.gltf,
      {@required this.externalBytesFetch, @required this.externalStreamFetch});

  Future<void> load({bool validateAccessorData = true}) async {
    try {
      await _loadBuffers();
      await _loadImages();
      if (context.validate) {
        if (validateAccessorData) {
          validateAccessorsData(gltf, context);
        }

        gltf.validateResources(context);
      }
    } on IssuesLimitExceededException catch (_) {
      return;
    }
  }

  Future<void> _loadBuffers() async {
    context.path
      ..clear()
      ..add(BUFFERS);

    for (var i = 0; i < gltf.buffers.length; i++) {
      final buffer = gltf.buffers[i];
      if (buffer == null) {
        continue;
      }

      context.path.add(i.toString());

      final info = ResourceInfo(context.getPointerString())
        ..mimeType = APPLICATION_GLTF_BUFFER;

      FutureOr<Uint8List> _fetchBuffer(Buffer buffer) {
        // Ignore buffers with invalid byte length
        if (buffer.byteLength == -1) {
          return null;
        }
        if (buffer.uri != null) {
          // External fetch
          info
            ..storage = _Storage.External
            ..uri = buffer.uri.toString();
          return externalBytesFetch(buffer.uri);
        } else if (buffer.data != null) {
          // Data URI
          info.storage = _Storage.DataUri;
          return buffer.data;
        } else if (context.isGlb && i == 0 && !buffer.hasUri) {
          // GLB Buffer
          info.storage = _Storage.GLB;
          final data = externalBytesFetch();
          if (context.validate && data == null) {
            context.addIssue(LinkError.bufferMissingGlbData);
          }
          return data;
        }
        return null;
      }

      Uint8List data;
      try {
        data = await _fetchBuffer(buffer);
      } on Exception catch (e) {
        // likely IO error
        context.addIssue(IoError.ioError, args: [e], name: URI);
      }

      if (data != null) {
        info.byteLength = data.length;
        if (data.length < buffer.byteLength) {
          context.addIssue(DataError.bufferByteLengthMismatch,
              args: [data.length, buffer.byteLength]);
        } else {
          if (context.isGlb && i == 0 && !buffer.hasUri) {
            final paddedLength = padLength(buffer.byteLength);
            if (data.length > paddedLength) {
              context.addIssue(DataError.bufferGlbChunkTooBig,
                  args: [data.length - paddedLength]);
            }
          }
          buffer.data ??= data;
        }
      }
      context.addResource(info.toMap());
      context.path.removeLast();
    }
  }

  Future<void> _loadImages() async {
    context.path
      ..clear()
      ..add(IMAGES);

    for (var i = 0; i < gltf.images.length; i++) {
      final image = gltf.images[i];
      if (image == null) {
        continue;
      }

      context.path.add(i.toString());

      final resourceInfo = ResourceInfo(context.getPointerString());

      Stream<List<int>> _fetchImageData(Image image) {
        if (image.extensions.isEmpty) {
          if (image.uri != null) {
            // External fetch
            resourceInfo
              ..storage = _Storage.External
              ..uri = image.uri.toString();
            return externalStreamFetch(image.uri);
          } else if (image.data != null) {
            // Data URI, preloaded on phase 2 of GltfLoader
            resourceInfo.storage = _Storage.DataUri;
            return Stream.fromIterable([image.data]);
          } else if (image.bufferView != null) {
            // BufferView
            resourceInfo.storage = _Storage.BufferView;
            image.tryLoadFromBufferView();
            if (image.data != null) {
              return Stream.fromIterable([image.data]);
            }
          }
        }
        return null;
      }

      Stream<List<int>> imageDataStream;
      try {
        imageDataStream = _fetchImageData(image);
      } on Exception catch (e) {
        // likely IO error
        context.addIssue(IoError.ioError, args: [e], name: URI);
      }

      ImageInfo imageInfo;
      if (imageDataStream != null) {
        try {
          imageInfo = await ImageInfo.parseStreamAsync(imageDataStream);
          if (context.validate &&
              !context.imageMimeTypes.contains(imageInfo.mimeType)) {
            context.addIssue(DataError.imageNonEnabledMimeType,
                args: [imageInfo.mimeType]);
          }
        } on UnsupportedImageFormatException catch (_) {
          context.addIssue(DataError.imageUnrecognizedFormat);
        } on UnexpectedEndOfStreamException catch (_) {
          context.addIssue(DataError.imageUnexpectedEos);
        } on InvalidDataFormatException catch (e) {
          context.addIssue(DataError.imageDataInvalid, args: [e]);
        } on Exception catch (e) {
          // TODO: refactor npm wrapper to remove this
          context.addIssue(IoError.ioError, args: [e], name: URI);
        }
        if (imageInfo != null) {
          resourceInfo.mimeType = imageInfo.mimeType;

          if (context.validate) {
            if (image.mimeType != null &&
                image.mimeType != imageInfo.mimeType) {
              context.addIssue(DataError.imageMimeTypeInvalid,
                  args: [imageInfo.mimeType, image.mimeType],
                  name: resourceInfo.storage == _Storage.BufferView
                      ? BUFFER_VIEW
                      : URI);
            }

            if (!isPot(imageInfo.width) || !isPot(imageInfo.height)) {
              context.addIssue(DataError.imageNonPowerOfTwoDimensions,
                  args: [imageInfo.width, imageInfo.height]);
            }

            if (imageInfo.hasCustomColorInfo ||
                imageInfo.hasAnimation ||
                imageInfo.hasNonSquarePixels) {
              context.addIssue(DataError.imageFeaturesUnsupported);
            }
          }

          // Store image metadata in glTF image object
          image.info = imageInfo;

          // Store image metadata in ResourceInfo
          resourceInfo.image = imageInfo;
        }
      }
      context.addResource(resourceInfo.toMap());
      context.path.removeLast();
    }
  }
}
