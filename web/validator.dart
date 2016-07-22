/*
 * # Copyright (c) 2016 The Khronos Group Inc.
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
import 'dart:html';
import 'dart:math';

import 'package:gltf/gltf.dart';

const int CHUNK_SIZE = 1024 * 1024;

final dropZone = querySelector('#dropZone');
final output = querySelector('#output');

void write(Object text) {
  output.appendHtml("$text\n");
}

void main() {
  dropZone.onDragOver.listen((MouseEvent e) {
    dropZone.classes.add('hover');
    e.preventDefault();
  });

  dropZone.onDragLeave.listen((MouseEvent e) {
    dropZone.classes.remove('hover');
    e.preventDefault();
  });

  dropZone.onDrop.listen((MouseEvent e) {
    e.preventDefault();
    output.text = "";
    dropZone.classes.remove('hover');
    dropZone.classes.add('drop');

    // Workaround for dart-sdk#26945
    final iterator = e.dataTransfer.files.iterator;

    void handleFile(File file) {
      final controller = new StreamController<List<int>>();
      GltfReader reader;
      if (file.name.endsWith(".glb")) {
        write("<strong>Loading ${file.name}...</strong>");
        reader = new GlbReader(controller.stream);
      } else if (file.name.endsWith(".gltf")) {
        write("<strong>Loading ${file.name}...</strong>");
        reader = new GltfReader(controller.stream);
      } else {
        write("<strong>${file.name}: Unknown file extension.</strong><br>");
        if (iterator.moveNext()) handleFile(iterator.current);
      }

      int index = 0;

      void handleNextChunk(File file) {
        final reader = new FileReader();
        reader.onLoadEnd.listen((ProgressEvent event) {
          // ignore: STRONG_MODE_DOWN_CAST_COMPOSITE
          controller.add(reader.result);
          if (index < file.size)
            handleNextChunk(file);
          else
            controller.close();
        });
        final length = min(CHUNK_SIZE, file.size - index);
        reader.readAsArrayBuffer(file.slice(index, index += length));
      }

      handleNextChunk(file);

      try {
        reader.root.then((_) {
          write(reader.context);
          if (iterator.moveNext()) handleFile(iterator.current);
        });
      } on Context catch (e) {
        // Failed before Gltf.fromMap call
        write(e);
        if (iterator.moveNext()) handleFile(iterator.current);
      }
    }

    if (iterator.moveNext()) handleFile(iterator.current);
    dropZone.classes.remove('drop');
  });
}
