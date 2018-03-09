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

library gltf.gltf_reader;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:gltf/src/base/gltf.dart';
import 'package:gltf/src/glb_reader.dart';
import 'package:gltf/src/context.dart';
import 'package:gltf/src/errors.dart';

export 'package:gltf/src/base/gltf.dart';
export 'package:gltf/src/context.dart';

class GltfReaderResult {
  final String mimeType;
  final Gltf gltf;
  final Uint8List buffer;

  GltfReaderResult(this.mimeType, this.gltf, this.buffer);
}

abstract class GltfReader {
  factory GltfReader.filename(Stream<List<int>> stream, String filename,
      [Context context]) {
    if (filename.toLowerCase().endsWith('.glb')) {
      return new GlbReader(stream, context);
    }

    if (filename.toLowerCase().endsWith('.gltf')) {
      return new GltfJsonReader(stream, context);
    }

    return null;
  }

  static Future<GltfReader> detect(Stream<List<int>> stream,
      [Context context]) {
    final completer = new Completer<GltfReader>();

    var formatDetected = false;
    StreamSubscription<List<int>> subscription;
    final controller = new StreamController<List<int>>();

    subscription = stream.listen((data) {
      if (!formatDetected) {
        final byte = data[0];
        if (byte == 0x67) {
          completer.complete(new GlbReader(controller.stream, context));
          formatDetected = true;
        } else if (byte == 0x20 ||
            byte == 0x09 ||
            byte == 0x0A ||
            byte == 0x0D ||
            byte == 0x7B) {
          completer.complete(new GltfJsonReader(controller.stream, context));
          formatDetected = true;
        } else {
          subscription.cancel();
          controller.close();
          completer.completeError(const GltfDataInvalid());
          return;
        }
      }
      controller.add(data);
    }, onDone: controller.close);

    return completer.future;
  }

  Future<GltfReaderResult> read();

  Context get context;
  String get mimeType;
}

class GltfJsonReader implements GltfReader {
  @override
  final String mimeType = 'model/gltf+json';

  final Stream<List<int>> stream;
  StreamSubscription<List<int>> _subscription;
  final Completer<GltfReaderResult> _completer =
      new Completer<GltfReaderResult>();

  ByteConversionSink _byteSink;

  Context _context;

  GltfJsonReader(this.stream, [Context context]) {
    _context = context ?? new Context();
  }

  @override
  Context get context => _context;

  @override
  Future<GltfReaderResult> read() {
    final outSink =
        new ChunkedConversionSink<Object>.withCallback((jsonResult) {
      final result = jsonResult[0];
      if (result is Map<String, Object>) {
        try {
          final root = new Gltf.fromMap(result, _context);
          _completer.complete(new GltfReaderResult(mimeType, root, null));
        } on IssuesLimitExceededException catch (_) {
          _abort();
        }
      } else {
        _context.addIssue(SchemaError.typeMismatch, args: [result, 'object']);
        _abort();
      }
    });

    _byteSink = json.decoder.startChunkedConversion(outSink).asUtf8Sink(false);
    _subscription = stream.listen(_onData, onError: _onError, onDone: _onDone);
    return _completer.future;
  }

  void _onData(List<int> data) {
    _subscription.pause();
    try {
      _byteSink.addSlice(data, 0, data.length, false);
      _subscription.resume();
    } on FormatException catch (e) {
      context.addIssue(SchemaError.invalidJson, args: [e]);
      _abort();
    }
  }

  void _onError(Object error) {
    _subscription.cancel();
    if (!_completer.isCompleted) {
      _completer.completeError(error);
    }
  }

  void _onDone() {
    try {
      _byteSink.close();
    } on FormatException catch (e) {
      context.addIssue(SchemaError.invalidJson, args: [e]);
      _abort();
    }
  }

  void _abort() {
    _subscription.cancel();
    _completer.complete();
  }

  static GltfReaderResult readFromJsonString(
      String jsonString, Context context) {
    Object parsedJson;
    try {
      parsedJson = json.decode(jsonString);
    } on FormatException catch (e) {
      context.addIssue(SchemaError.invalidJson, args: [e]);
    }
    if (parsedJson is Map<String, Object>) {
      try {
        final root = new Gltf.fromMap(parsedJson, context);
        return new GltfReaderResult('model/gltf+json', root, null);
      } on IssuesLimitExceededException catch (_) {
        return null;
      }
    } else {
      context.addIssue(SchemaError.typeMismatch, args: [parsedJson, 'object']);
      return null;
    }
  }
}

class GltfDataInvalid implements Exception {
  const GltfDataInvalid();

  @override
  String toString() => 'Invalid data: could not detect glTF format.';
}
