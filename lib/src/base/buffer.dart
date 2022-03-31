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

library gltf.base.buffer;

import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';

class Buffer extends GltfChildOfRootProperty {
  final Uri uri;
  final int byteLength;

  /// Users of this class need a way of distinguishing between
  /// a buffer with broken URI and a buffer without URI.
  /// The [Buffer.uri] field will be `null` in both cases.
  final bool hasUri;

  Uint8List data;

  Buffer._(this.uri, this.data, this.byteLength, this.hasUri, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static Buffer fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, BUFFER_MEMBERS, context);
    }

    var byteLength = getUint(map, BYTE_LENGTH, context, min: 1, req: true);

    Uri uri;
    Uint8List data;
    final hasUri = map.containsKey(URI);

    if (hasUri) {
      final uriString = getString(map, URI, context);

      if (uriString != null) {
        if (context.isGlb) {
          context.addIssue(DataError.uriGlb, name: URI);
        }

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

          if (uriData.mimeType == APPLICATION_OCTET_STREAM ||
              uriData.mimeType == APPLICATION_GLTF_BUFFER) {
            data = uriData.contentAsBytes();
          } else {
            context.addIssue(SemanticError.bufferDataUriMimeTypeInvalid,
                name: URI, args: [uriData.mimeType]);
          }
        }
        if (data != null && byteLength != -1 && data.length != byteLength) {
          context.addIssue(DataError.bufferEmbeddedBytelengthMismatch,
              args: [data.length, byteLength], name: BYTE_LENGTH);
          byteLength = data.length;
        }
      }
    }

    return Buffer._(uri, data, byteLength, hasUri, getName(map, context),
        getExtensions(map, Buffer, context), getExtras(map, context));
  }
}
