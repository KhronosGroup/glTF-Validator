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

@JS()
library gltf_validator_npm;

import 'dart:async';
import 'dart:typed_data';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'package:gltf/gltf.dart';

typedef void ResolveCallback(dynamic report);
typedef void RejectCallback(String error);

typedef Promise GetResourceCallback(String uri);

typedef Promise ValidateFunction(
    String filename, Uint8List data, GetResourceCallback getResourceCallback);

typedef void PromiseFunction(ResolveCallback resolve, RejectCallback reject);

@JS()
abstract class Promise {
  external factory Promise(PromiseFunction function);
  external Promise then(Function onFulfilled, [Function onRejected]);
}

@JS()
@anonymous
abstract class Exports {
  external set validate(ValidateFunction v);
}

@JS()
external Exports get exports;

void main() {
  exports.validate = allowInterop<ValidateFunction>(
      (String filename, Uint8List data, GetResourceCallback getResource) =>
          new Promise(allowInterop<PromiseFunction>((resolve, reject) {
            validate(filename, data, getResource).then((result) {
              resolve(jsify(result));
            }, onError: reject);
          })));
}

Future<Map<String, dynamic>> validate(
    String filename, Uint8List data, GetResourceCallback getResource) async {
  final context = new Context();

  GltfReaderResult readerResult;
  try {
    final reader =
        await GltfReader.detect(new Stream.fromIterable([data]), context);
    readerResult = await reader.read();
  } on GltfDataInvalid {
    rethrow;
  }

  final validationResult =
      new ValidationResult(new Uri(path: filename), context, readerResult);

  if (readerResult?.gltf != null) {
    await getResourcesLoader(context, readerResult, getResource).load();
  }

  return validationResult.toJson();
}

ResourcesLoader getResourcesLoader(Context context,
    GltfReaderResult readerResult, GetResourceCallback getResource) {
  Future<List<int>> getBytes(Uri uri) {
    final completer = new Completer<List<int>>();
    getResource(uri.toString()).then(
        allowInterop(completer.complete),
        allowInterop((Object e) =>
            completer.completeError(new NodeException(e.toString()))));

    return completer.future;
  }

  return new ResourcesLoader(context, readerResult.gltf,
      externalBytesFetch: (uri) {
        if (uri == null) {
          // GLB-stored buffer
          return readerResult.buffer;
        }
        return getBytes(uri);
      },
      externalStreamFetch: (uri) => new Stream.fromFuture(getBytes(uri)));
}

class NodeException implements Exception {
  final String message;
  const NodeException(this.message);
  @override
  String toString() => 'Node Exception: $message';
}
