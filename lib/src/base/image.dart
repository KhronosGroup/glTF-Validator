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

library gltf.base.image;

import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/data_access/image_decoder.dart';

class Image extends GltfChildOfRootProperty {
  final int _bufferViewIndex;
  final String mimeType;
  final Uri uri;

  Uint8List data;
  BufferView _bufferView;

  ImageInfo info;

  Image._(this._bufferViewIndex, this.uri, this.mimeType, this.data,
      String name, Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  BufferView get bufferView => _bufferView;

  static Image fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, IMAGE_MEMBERS, context);
    }

    final bufferViewIndex = getIndex(map, BUFFER_VIEW, context, req: false);
    var mimeType =
        getString(map, MIME_TYPE, context, list: context.imageMimeTypes);
    final uriString = getString(map, URI, context, req: false);

    if (context.validate) {
      if (bufferViewIndex != -1 && mimeType == null) {
        context.addIssue(SchemaError.unsatisfiedDependency,
            name: BUFFER_VIEW, args: [MIME_TYPE]);
      }

      if (((bufferViewIndex != -1) && (uriString != null)) ||
          ((bufferViewIndex == -1) && (uriString == null))) {
        context.addIssue(SchemaError.oneOfMismatch, args: [BUFFER_VIEW, URI]);
      }
    }

    Uri uri;
    Uint8List data;

    if (uriString != null) {
      UriData uriData;
      try {
        uriData = UriData.parse(uriString);
      } on FormatException catch (_) {
        uri = getUri(uriString, context);
      }

      if (uriData != null) {
        if (context.isGlb) {
          context.addIssue(DataError.dataUriGlb, name: URI);
        }

        data = uriData.contentAsBytes();

        // Re-assign `mimeType` only if it wasn't set in JSON
        if (mimeType == null) {
          if (context.validate &&
              !context.imageMimeTypes.contains(uriData.mimeType)) {
            context.addIssue(SchemaError.valueNotInList,
                name: URI, args: [uriData.mimeType, context.imageMimeTypes]);
          }
          mimeType = uriData.mimeType;
        }
      }
    }

    return Image._(bufferViewIndex, uri, mimeType, data, getName(map, context),
        getExtensions(map, Image, context), getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (_bufferViewIndex != -1) {
      _bufferView = gltf.bufferViews[_bufferViewIndex];

      if (_bufferView == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: BUFFER_VIEW, args: [_bufferViewIndex]);
      } else {
        _bufferView.setUsage(BufferViewUsage.Image, BUFFER_VIEW, context);
        if (_bufferView.byteStride != -1) {
          context.addIssue(LinkError.imageBufferViewWithByteStride,
              name: BUFFER_VIEW);
        }
      }
    }
  }

  void tryLoadFromBufferView() {
    if (_bufferView?.buffer?.data != null) {
      /// in the worst case, `data` will remain `null`
      try {
        data = Uint8List.view(_bufferView.buffer.data.buffer,
            _bufferView.byteOffset, _bufferView.byteLength);
        // ignore: avoid_catching_errors
      } on ArgumentError catch (_) {}
    }
  }
}
