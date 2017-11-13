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

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'dart:math';

import 'dart:typed_data';
import 'package:gltf/gltf.dart';

const int CHUNK_SIZE = 1024 * 1024;
const JsonEncoder kJsonEncoder = const JsonEncoder.withIndent('    ');

final Element dropZone = querySelector('#dropZone');
final Element output = querySelector('#output');

void main() {
  dropZone.onDragOver.listen((e) {
    dropZone.classes.add('hover');
    e.preventDefault();
  });

  dropZone.onDragLeave.listen((e) {
    dropZone.classes.remove('hover');
    e.preventDefault();
  });

  dropZone.onDrop.listen((e) async {
    e.preventDefault();
    output.text = "";
    dropZone.classes
      ..remove('hover')
      ..add('drop');

    final files = e.dataTransfer.files;

    File gltfFile;
    GltfReader reader;

    final context = new Context();

    for (gltfFile in files) {
      final lowerCaseName = gltfFile.name.toLowerCase();
      if (lowerCaseName.endsWith('.gltf')) {
        reader = new GltfJsonReader(_getFileStream(gltfFile), context);
        break;
      }
      if (lowerCaseName.endsWith('.glb')) {
        reader = new GlbReader(_getFileStream(gltfFile), context);
        break;
      }
    }

    if (reader == null) {
      dropZone.classes.remove('drop');
      return;
    }

    final readerResult = await reader.read();

    if (readerResult?.gltf != null) {
      final resourcesLoader = new ResourcesLoader(context, readerResult.gltf,
          externalBytesFetch: (uri) {
        if (uri != null) {
          final file = _getFileByUri(files, uri);
          if (file != null) {
            return _getFile(file);
          }
          return null;
        } else {
          return readerResult.buffer;
        }
      }, externalStreamFetch: (uri) {
        if (uri != null) {
          final file = _getFileByUri(files, uri);
          if (file != null) {
            return _getFileStream(file);
          }
          return null;
        }
      });

      await resourcesLoader.load();
    }
    final validationResult =
        new ValidationResult(Uri.parse(gltfFile.name), context, readerResult);
    _writeMap(validationResult.toMap());
    dropZone.classes.remove('drop');
  });
}

File _getFileByUri(List<File> files, Uri uri) =>
    files.firstWhere((file) => file.name == uri.path, orElse: () => null);

Stream<List<int>> _getFileStream(File file) {
  var isCanceled = false;
  final controller = new StreamController<List<int>>(onCancel: () {
    isCanceled = true;
  });

  controller.onListen = () {
    var index = 0;
    final fileReader = new FileReader();
    fileReader.onLoadEnd.listen((_) {
      if (isCanceled) {
        return;
      }

      final result = fileReader.result;
      if (result is Uint8List) {
        controller.add(result);
      }

      if (index < file.size) {
        final length = min(CHUNK_SIZE, file.size - index);
        fileReader.readAsArrayBuffer(file.slice(index, index += length));
      } else {
        controller.close();
      }
    });

    final length = min(CHUNK_SIZE, file.size);
    fileReader.readAsArrayBuffer(file.slice(0, index += length));
  };

  return controller.stream;
}

Future<List<int>> _getFile(File file) async {
  final fileReader = new FileReader()..readAsArrayBuffer(file);
  await fileReader.onLoadEnd.first;
  final result = fileReader.result;
  if (result is Uint8List) {
    return result;
  }
  return null;
}

void _writeMap(Map<String, Object> json) {
  output.text = kJsonEncoder.convert(json);
  context['Prism'].callMethod('highlightAll', [true]);
}
