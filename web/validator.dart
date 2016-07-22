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

  dropZone.onDrop.listen((MouseEvent e) async {
    e.preventDefault();
    dropZone.classes.remove('hover');
    dropZone.classes.add('drop');

    for (final file in e.dataTransfer.files) {
      final controller = new StreamController<List<int>>();
      GltfReader reader;
      if (file.name.endsWith(".glb")) {
        write("<strong>Loading ${file.name}...</strong>");
        reader = new GlbReader(controller.stream);
      } else if (file.name.endsWith(".gltf")) {
        write("<strong>Loading ${file.name}...</strong>");
        reader = new GltfReader(controller.stream);
      } else {
        write("<strong>Unknown file format: ${file.name}</strong><br>");
        continue;
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
        await reader.root;
        write(reader.context);
      } on Context catch (e) {
        // Failed before Gltf.fromMap call
        write(e);
      }

      write("<strong>${file.name} done</strong><br>");
    }
    dropZone.classes.remove('drop');
  });
}
