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

// ignore_for_file: avoid_dynamic_calls

// @dart=2.9

@JS()
library gltf_validator_npm;

import 'dart:async';
import 'dart:typed_data';

import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

typedef ExternalResourceFunction = Promise<Object> Function(String filename);

@JS()
class Promise<T> {
  external Promise(
      void Function(void Function(T result) resolve, Function reject) executor);

  external Promise then(void Function(T result) onFulfilled,
      [Function onRejected]);
}

@JS()
@anonymous
abstract class Exports {
  // ignore: avoid_setters_without_getters
  external set validateBytes(
      Promise Function(Uint8List data, _JSValidationOptions options) v);

  // ignore: avoid_setters_without_getters
  external set validateString(
      Promise Function(String json, _JSValidationOptions options) v);

  // ignore: avoid_setters_without_getters
  external set version(String Function() v);

  // ignore: avoid_setters_without_getters
  external set supportedExtensions(Object Function() v);
}

@JS()
@anonymous
abstract class _JSValidationOptions {
  external Object get uri;

  external Object get format;

  external ExternalResourceFunction get externalResourceFunction;

  external bool get writeTimestamp;

  external int get maxIssues;

  external List get ignoredIssues;

  external List get onlyIssues;

  external Object get severityOverrides;
}

@JS()
external Exports get exports;

@JS('Object.keys')
external List _getKeys(Object value);

void main() {
  const kDebug =
      bool.fromEnvironment('GLTF_VALIDATOR_DEBUG', defaultValue: false);

  void onError(Object e, StackTrace st, Function reject) => kDebug
      ? reject((st.toString().isEmpty ? e : st).toString())
      : reject(e.toString());

  exports.validateBytes = allowInterop((Uint8List data, Object options) =>
      Promise<Object>(allowInterop((resolve, reject) {
        validateBytes(data, options).then((result) {
          resolve(jsify(result));
        }, onError: (Object e, StackTrace st) => onError(e, st, reject));
      })));

  exports.validateString = allowInterop((String json, Object options) =>
      Promise<Object>(allowInterop((resolve, reject) {
        validateString(json, options).then((result) {
          resolve(jsify(result));
        }, onError: (Object e, StackTrace st) => onError(e, st, reject));
      })));

  exports.version = allowInterop(() => kGltfValidatorVersion);

  exports.supportedExtensions =
      allowInterop(() => jsify(Context.defaultExtensionNames));
}

Future<Map<String, Object>> validateBytes(
    Uint8List data, Object options) async {
  if (data is! Uint8List) {
    throw ArgumentError('data: Argument must be a Uint8Array.');
  }
  final _options = _checkOptionsObject(options);
  final context = _getContextFromOptions(_options);

  GltfReader reader;
  switch ((_options?.format as String)?.toLowerCase()) {
    case 'glb':
      reader = GlbReader(Stream.value(data), context);
      break;
    case 'gltf':
      reader = GltfJsonReader(Stream.value(data), context);
      break;
    default:
      try {
        reader = await GltfReader.detect(Stream.value(data), context);
      } on GltfInvalidFormatException {
        rethrow;
      }
  }
  final readerResult = await reader.read();

  return _validateResourcesAndGetReport(_options, context, readerResult);
}

Future<Map<String, Object>> validateString(String json, Object options) async {
  if (json is! String) {
    throw ArgumentError('json: Argument must be a string.');
  }
  final _options = _checkOptionsObject(options);
  final context = _getContextFromOptions(_options);

  final readerResult = GltfJsonReader.readFromJsonString(json, context);

  return _validateResourcesAndGetReport(_options, context, readerResult);
}

_JSValidationOptions _checkOptionsObject(Object options) {
  if (options != null &&
      (options is num ||
          options is bool ||
          options is String ||
          options is List)) {
    throw ArgumentError('options: Value must be an object.');
  }
  return options as _JSValidationOptions;
}

Future<Map<String, Object>> _validateResourcesAndGetReport(
    _JSValidationOptions options,
    Context context,
    GltfReaderResult result) async {
  Uri uri;
  ExternalResourceFunction externalResourceFunction;

  if (options != null) {
    uri = _getUri(options.uri);

    if (options.externalResourceFunction != null &&
        options.externalResourceFunction is! Function) {
      throw ArgumentError(
          'options.externalResourceFunction: Value must be a function.');
    } else {
      externalResourceFunction = options.externalResourceFunction;
    }

    if (options.writeTimestamp != null && options.writeTimestamp is! bool) {
      throw ArgumentError('options.writeTimestamp: Value must be a boolean.');
    }
  }

  if (result?.gltf != null) {
    final loader =
        _getResourcesLoader(context, result, externalResourceFunction);
    await loader.load();
  }
  return ValidationResult(uri, context, result,
          writeTimestamp: options?.writeTimestamp ?? true)
      .toMap();
}

Uri _getUri(Object uri) {
  if (uri != null) {
    if (uri is String) {
      try {
        return Uri.parse(uri);
      } on FormatException catch (e) {
        throw ArgumentError('options.uri: $e.');
      }
    } else {
      throw ArgumentError('options.uri: Value must be a string.');
    }
  }
  return null;
}

Context _getContextFromOptions(_JSValidationOptions options) {
  ValidationOptions validationOptions;
  Map<String, Severity> severityOverrides;
  List<String> ignoredIssues;
  List<String> onlyIssues;

  if (options != null) {
    if (options.format != null && options.format is! String) {
      throw ArgumentError('options.format: Value must be a string.');
    }

    if (options.maxIssues != null &&
        (options.maxIssues is! int || options.maxIssues < 0)) {
      throw ArgumentError(
          'options.maxIssues: Value must be a non-negative integer.');
    }

    if (options.onlyIssues != null && options.ignoredIssues != null) {
      throw ArgumentError('options.onlyIssues cannot be used '
          'along with options.ignoredIssues.');
    }

    if (options.onlyIssues != null) {
      if (options.onlyIssues is! List) {
        throw ArgumentError('options.onlyIssues: Value must be an array.');
      }

      onlyIssues = <String>[];
      for (var i = 0; i < options.onlyIssues.length; ++i) {
        final Object entry = options.onlyIssues[i];
        if (entry is String && entry.isNotEmpty) {
          onlyIssues.add(entry);
        } else {
          throw ArgumentError(
              'options.onlyIssues[$i]: Value must be a non-empty String.');
        }
      }
    }

    if (options.ignoredIssues != null) {
      if (options.ignoredIssues is! List) {
        throw ArgumentError('options.ignoredIssues: Value must be an array.');
      }

      ignoredIssues = <String>[];
      for (var i = 0; i < options.ignoredIssues.length; ++i) {
        final Object entry = options.ignoredIssues[i];
        if (entry is String && entry.isNotEmpty) {
          ignoredIssues.add(entry);
        } else {
          throw ArgumentError(
              'options.ignoredIssues[$i]: Value must be a non-empty String.');
        }
      }
    }

    if (options.severityOverrides != null) {
      if (options.severityOverrides is num ||
          options.severityOverrides is bool ||
          options.severityOverrides is String ||
          options.severityOverrides is List) {
        throw ArgumentError(
            'options.severityOverrides: Value must be an object.');
      }

      severityOverrides = <String, Severity>{};

      for (final key in _getKeys(options.severityOverrides).cast<String>()) {
        final Object value = getProperty(options.severityOverrides, key);
        if (value is int && value >= 0 && value <= 3) {
          severityOverrides[key] = Severity.values[value];
        } else {
          throw ArgumentError('options.severityOverrides["$key"]: '
              'Value must be one of [0, 1, 2, 3].');
        }
      }
    }

    validationOptions = ValidationOptions(
        maxIssues: options.maxIssues,
        ignoredIssues: ignoredIssues,
        onlyIssues: onlyIssues,
        severityOverrides: severityOverrides);
  }

  return Context(options: validationOptions);
}

ResourcesLoader _getResourcesLoader(Context context,
    GltfReaderResult readerResult, ExternalResourceFunction getResource) {
  Future<Uint8List> getBytes(Uri uri) {
    final completer = Completer<Uint8List>();
    final promise = getResource(uri.toString());
    if (promise?.then == null) {
      completer.completeError(ArgumentError(
          'options.externalResourceFunction: Function must return a Promise.'));
    } else {
      promise.then(allowInterop((Object o) {
        if (o is Uint8List) {
          completer.complete(o);
        } else {
          completer
              .completeError(ArgumentError('options.externalResourceFunction: '
                  'Promise must be fulfilled with Uint8Array or rejected.'));
        }
      }),
          allowInterop((Object e) =>
              completer.completeError(NodeException(e.toString()))));
    }
    return completer.future;
  }

  final missingFunctionException = Exception('options.externalResourceFunction '
      'is required to load this resource.');

  return ResourcesLoader(context, readerResult.gltf,
      externalBytesFetch: ([uri]) {
        if (context.isGlb && uri == null) {
          // GLB-stored buffer
          return readerResult.buffer;
        }
        return getResource != null
            ? getBytes(uri)
            : Future.error(missingFunctionException);
      },
      externalStreamFetch: (uri) => getResource != null
          ? getBytes(uri).asStream()
          : Stream.error(missingFunctionException));
}

class NodeException implements Exception {
  final String message;

  const NodeException(this.message);

  @override
  String toString() => 'Node Exception: $message';
}
