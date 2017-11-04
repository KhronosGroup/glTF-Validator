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
import 'package:gltf/src/errors.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'package:gltf/gltf.dart';

typedef Promise<Uint8List> GetResourceCallback(String filename);

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));

  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

@JS()
@anonymous
abstract class Exports {
  // ignore: avoid_setters_without_getters
  external set validateBytes(
      Promise v(
          String filename,
          Uint8List data,
          GetResourceCallback getResourceCallback,
          JSValidationOptions options));

  // ignore: avoid_setters_without_getters
  external set validateString(
      Promise v(
          String filename,
          String json,
          GetResourceCallback getResourceCallback,
          JSValidationOptions options));
}

@JS()
@anonymous
abstract class JSValidationOptions {
  external int get maxIssues;
  external List<String> get ignoredIssues;
  external Object get severityOverrides;
}

@JS()
external Exports get exports;

@JS("Object.keys")
external List<String> getKeys(Object value);

void main() {
  exports.validateBytes = allowInterop((String filename, Uint8List data,
          GetResourceCallback getResource, JSValidationOptions options) =>
      new Promise<Object>(allowInterop((resolve, reject) {
        validateBytes(filename, data, getResource, options).then((result) {
          resolve(jsify(result));
        }, onError: reject);
      })));

  exports.validateString = allowInterop((String filename, String json,
          GetResourceCallback getResource, JSValidationOptions options) =>
      new Promise<Object>(allowInterop((resolve, reject) {
        validateString(filename, json, getResource, options).then((result) {
          resolve(jsify(result));
        }, onError: reject);
      })));
}

Future<Map<String, dynamic>> validateBytes(String filename, Uint8List data,
    GetResourceCallback getResource, JSValidationOptions options) async {
  final context = _getContextFromOptions(options);
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
    await _getResourcesLoader(context, readerResult, getResource).load();
  }

  return validationResult.toMap();
}

Future<Map<String, dynamic>> validateString(String filename, String json,
    GetResourceCallback getResource, JSValidationOptions options) async {
  final context = _getContextFromOptions(options);

  final readerResult = GltfJsonReader.readFromJsonString(json, context);

  final validationResult =
      new ValidationResult(new Uri(path: filename), context, readerResult);

  if (readerResult?.gltf != null) {
    await _getResourcesLoader(context, readerResult, getResource).load();
  }

  return validationResult.toMap();
}

Context _getContextFromOptions(JSValidationOptions options) => new Context(
    options: new ValidationOptions(
        maxIssues: options.maxIssues,
        ignoredIssues: options.ignoredIssues,
        severityOverrides: _getSeverityMap(options.severityOverrides)));

Map<String, Severity> _getSeverityMap(Object severityOverrides) {
  if (severityOverrides == null) {
    return null;
  }

  final map = <String, Severity>{};

  for (var key in getKeys(severityOverrides)) {
    final Object value = getProperty(severityOverrides, key);
    if (value is int && value >= 0 && value <= 3) {
      map[key] = Severity.values[value];
    }
  }

  return map;
}

ResourcesLoader _getResourcesLoader(Context context,
    GltfReaderResult readerResult, GetResourceCallback getResource) {
  Future<List<int>> getBytes(Uri uri) {
    final completer = new Completer<Uint8List>();
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
