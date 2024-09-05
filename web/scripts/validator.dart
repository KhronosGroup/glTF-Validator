// Copyright 2016-2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: avoid_print
// ignore_for_file: avoid_dynamic_calls

// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:html'
    show
        querySelector,
        DataTransferItemList,
        DirectoryEntry,
        Entry,
        InputElement,
        File,
        FileEntry,
        FileReader,
        window;
import 'dart:js';
import 'dart:math';

import 'dart:typed_data';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/utils.dart';

const _kChunkSize = 1024 * 1024;
const _kMaxReportLength = 512 * 1024;
const _kMaxIssuesCount = 16 * 1024;
const _kJsonEncoder = JsonEncoder.withIndent('    ');

final _dropZone = querySelector('#dropZone');
final _output = querySelector('#output');
final _input = querySelector('#input') as InputElement;
final _inputLink = querySelector('#inputLink');
final _fileWarning = querySelector('#fileWarning');
final _truncatedWarning = querySelector('#truncatedWarning');
final _validityLabel = querySelector('#validityLabel');

final _isFileUri = window.location.protocol == 'file:';
final _assetPattern = RegExp(r'^[^\/]*\.gl(?:tf|b)$', caseSensitive: false);

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
    // File and Directory Entries API may not work
    // when the page is opened from a local path.
    if (_isFileUri) {
      _validateFiles(e.dataTransfer.files);
    } else {
      _validateItems(e.dataTransfer.items);
    }
  });

  _inputLink.onClick.listen((e) {
    e.preventDefault();
    _input.value = '';
    _input.click();
  });

  _input.onChange.listen((e) {
    e.preventDefault();
    if (_input.files.isNotEmpty) {
      _validateFiles(_input.files);
    }
  });

  print('glTF Validator ver. $kGltfValidatorVersion.');
  print('Supported extensions: ${Context.defaultExtensionNames.join(', ')}');
}

void _preValidate() {
  _output.text = '';
  _fileWarning.style.display = 'none';
  _truncatedWarning.style.display = 'none';
  _validityLabel.text = 'Validating...';
  _dropZone.classes
    ..clear()
    ..add('drop');
}

void _postValidate(ValidationResult result) {
  _dropZone.classes.remove('drop');
  if (result != null) {
    if (_isFileUri) {
      _fileWarning.style.display = 'block';
    }

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
    _validityLabel.text =
        'No glTF asset was found or a file access error has occurred.';
  }
}

void _validateFiles(List<File> files) {
  _preValidate();
  final filesMap = <String, File>{for (final file in files) file.name: file};
  _doValidate(filesMap).then(_postValidate);
}

void _validateItems(DataTransferItemList items) {
  _preValidate();
  _getFilesMapFromItems(items)
      .then(_doValidate, onError: (Object _) => null)
      .then(_postValidate);
}

Future<Map<String, File>> _getFilesMapFromItems(DataTransferItemList items) {
  final entries = List.generate(items.length, (i) => items[i].getAsEntry(),
      growable: false);
  return _traverseDirectory(entries, <String, File>{});
}

Future<Map<String, File>> _traverseDirectory(
    List<Entry> entries, Map<String, File> result) async {
  for (final entry in entries) {
    if (entry.isFile) {
      final fileEntry = entry as FileEntry;
      result[fileEntry.fullPath.substring(1)] = await fileEntry.file();
    } else if (entry.isDirectory) {
      final directoryEntry = entry as DirectoryEntry;
      await _traverseDirectory(
          await directoryEntry.createReader().readEntries(), result);
    }
  }
  return result;
}

Future<ValidationResult> _doValidate(Map<String, File> files) async {
  _sw
    ..reset()
    ..start();
  GltfReader reader;

  final context =
      Context(options: ValidationOptions(maxIssues: _kMaxIssuesCount));

  final assetFilename =
      files.keys.firstWhere(_assetPattern.hasMatch, orElse: () => null);
  if (assetFilename == null) {
    return null;
  }

  if (assetFilename.toLowerCase().endsWith('.gltf')) {
    reader = GltfJsonReader(_getFileStream(files[assetFilename]), context);
  } else {
    reader = GlbReader(_getFileStream(files[assetFilename]), context);
  }

  final readerResult = await reader.read();

  if (readerResult?.gltf != null) {
    final resourcesLoader = ResourcesLoader(context, readerResult.gltf,
        externalBytesFetch: ([uri]) {
      if (uri != null) {
        if (uri.isNonRelative) {
          return null;
        }
        final file = _getFileByUri(files, uri);
        if (file != null) {
          return _getFileBytes(file);
        } else {
          throw GltfExternalResourceNotFoundException(uri.toString());
        }
      } else {
        return readerResult.buffer;
      }
    }, externalStreamFetch: (uri) {
      if (uri != null) {
        if (uri.isNonRelative) {
          return null;
        }
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
      ValidationResult(Uri.parse(assetFilename), context, readerResult);

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

File _getFileByUri(Map<String, File> files, Uri uri) =>
    files[Uri.decodeComponent(uri.path)];

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

Future<Uint8List> _getFileBytes(File file) async {
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
    context['Prism'].callMethod('highlightAll', [!_isFileUri]);
  } else {
    print('Report is too big: ${report.length} bytes. '
        'Syntax highlighting disabled.');
  }
}
