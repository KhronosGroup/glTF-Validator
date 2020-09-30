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

// ignore_for_file: avoid_print

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
const _kJsonEncoder = JsonEncoder.withIndent('    ');

final _dropZone = querySelector('#dropZone');
final _output = querySelector('#output');
final _input = querySelector('#input') as InputElement; // ignore: avoid_as
final _inputLink = querySelector('#inputLink');
final _truncatedWarning = querySelector('#truncatedWarning');
final _validityLabel = querySelector('#validityLabel');

final _sw = Stopwatch();

void main() {
  // Needed to prevent flickering while dragging over text.
  var cnt = 0;

  _dropZone.onDragEnter.listen((e) {
    _dropZone.classes.add('hover');
    ++cnt;
  });

  _dropZone.onDragOver.listen((e) {
    e.preventDefault();
  });

  _dropZone.onDragLeave.listen((e) {
    if (--cnt == 0) {
      _dropZone.classes.remove('hover');
    }
  });

  _dropZone.onDrop.listen((e) {
    e.preventDefault();
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

  print('glTF Validator ver. $kGltfValidatorVersion.');
  print('Supported extensions: ${Context.defaultExtensionNames.join(', ')}');
}

void _validate(List<File> files) {
  _output.text = '';
  _truncatedWarning.style.display = 'none';
  _validityLabel.text = 'Validating...';
  _dropZone.classes
    ..clear()
    ..add('drop');

  _doValidate(files).then((result) {
    _dropZone.classes.remove('drop');
    if (result != null) {
      if (result.context.isTruncated) {
        _truncatedWarning.style.display = 'block';
      }

      if (result.context.errors.isEmpty) {
        _dropZone.classes.add('valid');
        _validityLabel.text = 'The asset is valid.';
      } else {
        _dropZone.classes.add('invalid');
        _validityLabel.text = 'The asset contains errors.';
      }
    } else {
      _validityLabel.text = 'No glTF asset provided.';
    }
  });
}

Future<ValidationResult> _doValidate(List<File> files) async {
  _sw
    ..reset()
    ..start();
  File gltfFile;
  GltfReader reader;

  final context =
      Context(options: ValidationOptions(maxIssues: _kMaxIssuesCount));

  for (gltfFile in files) {
    final lowerCaseName = gltfFile.name.toLowerCase();
    if (lowerCaseName.endsWith('.gltf')) {
      reader = GltfJsonReader(_getFileStream(gltfFile), context);
      break;
    }
    if (lowerCaseName.endsWith('.glb')) {
      reader = GlbReader(_getFileStream(gltfFile), context);
      break;
    }
  }

  if (reader == null) {
    return null;
  }

  final readerResult = await reader.read();

  if (readerResult?.gltf != null) {
    final resourcesLoader = ResourcesLoader(context, readerResult.gltf,
        externalBytesFetch: ([uri]) {
      if (uri != null) {
        final file = _getFileByUri(files, uri);
        if (file != null) {
          return _getFile(file);
        } else {
          throw GltfExternalResourceNotFoundException(uri.toString());
        }
      } else {
        return readerResult.buffer;
      }
    }, externalStreamFetch: (uri) {
      if (uri != null) {
        final file = _getFileByUri(files, uri);
        if (file != null) {
          return _getFileStream(file);
        } else {
          throw GltfExternalResourceNotFoundException(uri.toString());
        }
      }
      return null;
    });

    await resourcesLoader.load();
  }
  final validationResult =
      ValidationResult(Uri.parse(gltfFile.name), context, readerResult);

  _sw.stop();
  print('Validation: ${_sw.elapsedMilliseconds}ms.');
  _sw
    ..reset()
    ..start();
  _writeMap(validationResult.toMap());
  _sw.stop();
  print('Writing report: ${_sw.elapsedMilliseconds}ms.');

  return validationResult;
}

File _getFileByUri(List<File> files, Uri uri) {
  final fileName = Uri.decodeComponent(uri.path);
  return files.firstWhere((file) => file.name == fileName, orElse: () => null);
}

Stream<Uint8List> _getFileStream(File file) {
  var isCanceled = false;
  final controller = StreamController<Uint8List>(onCancel: () {
    isCanceled = true;
  });

  controller.onListen = () {
    var index = 0;
    final fileReader = FileReader();
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
  final fileReader = FileReader()..readAsArrayBuffer(file);
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
