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
import 'dart:html' show querySelector, InputElement, File, FileReader;
import 'dart:js';
import 'dart:math';

import 'dart:typed_data';
import 'package:gltf/gltf.dart';

const _kChunkSize = 1024 * 1024;
const _kMaxReportLength = 512 * 1024;
const _kMaxIssuesCount = 16 * 1024;
const _kJsonEncoder = const JsonEncoder.withIndent('    ');

final _dropZone = querySelector('#dropZone');
final _output = querySelector('#output');
final InputElement _input = querySelector('#input');
final _inputLink = querySelector('#inputLink');
final _truncatedWarning = querySelector('#truncatedWarning');

final _sw = new Stopwatch();

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
    _dropZone.classes.remove('hover');
    _validate(e.dataTransfer.files);
  });

  _inputLink.onClick.listen((e) {
    e.preventDefault();
    _input.value = '';
    _input.click();
  });

  _input.onChange.listen((e) {
    e.preventDefault();
    if (_input.files.isNotEmpty) {
      _validate(_input.files);
    }
  });
}

void _validate(List<File> files) {
  _output.text = '';
  _truncatedWarning.style.display = 'none';
  _dropZone.classes.add('drop');
  _doValidate(files).then((isTruncated) {
    _dropZone.classes.remove('drop');
    if (isTruncated) {
      _truncatedWarning.style.display = 'block';
    }
  });
}

Future<bool> _doValidate(List<File> files) async {
  _sw
    ..reset()
    ..start();
  File gltfFile;
  GltfReader reader;

  final context =
      new Context(options: new ValidationOptions(maxIssues: _kMaxIssuesCount));

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
    return false;
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

  _sw.stop();
  print('Validation: ${_sw.elapsedMilliseconds}ms.');
  _sw
    ..reset()
    ..start();
  _writeMap(validationResult.toMap());
  _sw.stop();
  print('Writing report: ${_sw.elapsedMilliseconds}ms.');

  return context.isTruncated;
}

File _getFileByUri(List<File> files, Uri uri) {
  final fileName = Uri.decodeComponent(uri.path);
  return files.firstWhere((file) => file.name == fileName, orElse: () => null);
}

Stream<Uint8List> _getFileStream(File file) {
  var isCanceled = false;
  final controller = new StreamController<Uint8List>(onCancel: () {
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
        final length = min(_kChunkSize, file.size - index);
        fileReader.readAsArrayBuffer(file.slice(index, index += length));
      } else {
        controller.close();
      }
    });

    final length = min(_kChunkSize, file.size);
    fileReader.readAsArrayBuffer(file.slice(0, index += length));
  };

  return controller.stream;
}

Future<Uint8List> _getFile(File file) async {
  final fileReader = new FileReader()..readAsArrayBuffer(file);
  await fileReader.onLoadEnd.first;
  final result = fileReader.result;
  if (result is Uint8List) {
    return result;
  }
  return null;
}

void _writeMap(Map<String, Object> jsonMap) {
  final report = _kJsonEncoder.convert(jsonMap);
  _output.text = report;
  if (report.length < _kMaxReportLength) {
    context['Prism'].callMethod('highlightAll', [true]);
  } else {
    print('Report is too big: ${report.length} bytes. '
        'Syntax highlighting disabled.');
  }
}
