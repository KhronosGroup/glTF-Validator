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

const _CHUNK_SIZE = 1024 * 1024;
const _kJsonEncoder = const JsonEncoder.withIndent('    ');

final _dropZone = querySelector('#dropZone');
final _output = querySelector('#output');
final InputElement _input = querySelector('#input');
final _inputLink = querySelector('#inputLink');

void main() {
  _dropZone.onDragOver.listen((e) {
    _dropZone.classes.add('hover');
    e.preventDefault();
  });

  _dropZone.onDragLeave.listen((e) {
    _dropZone.classes.remove('hover');
    e.preventDefault();
  });

  _dropZone.onDrop.listen((e) {
    e.preventDefault();
    _output.text = "";
    _dropZone.classes
      ..remove('hover')
      ..add('drop');

    _validate(e.dataTransfer.files).then((_) {
      _dropZone.classes.remove('drop');
    });
  });

  _inputLink.onClick.listen((e) {
    e.preventDefault();
    _input.click();
  });

  _input.onChange.listen((e) {
    e.preventDefault();
    _validate(_input.files);
  });
}

Future<Null> _validate(List<File> files) async {
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
        final length = min(_CHUNK_SIZE, file.size - index);
        fileReader.readAsArrayBuffer(file.slice(index, index += length));
      } else {
        controller.close();
      }
    });

    final length = min(_CHUNK_SIZE, file.size);
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
  _output.text = _kJsonEncoder.convert(json);
  context['Prism'].callMethod('highlightAll', [true]);
}
