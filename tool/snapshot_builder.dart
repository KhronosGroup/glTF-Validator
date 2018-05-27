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
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

Builder snapshotBuilder(BuilderOptions options) => new SnapshotBuilder(options);

class SnapshotBuilder extends Builder {
  final BuilderOptions options;
  SnapshotBuilder(this.options);

  @override
  Future build(BuildStep buildStep) async {
    final dart = Platform.resolvedExecutable;
    final tempDir = Directory.systemTemp.path;
    final snapshot =
        p.setExtension(p.basename(buildStep.inputId.path), '.snapshot');
    final snapshotPath = p.join(tempDir, snapshot);

    final args = ['--snapshot=$snapshotPath'];
    if (options.config['snapshot_kind'] == 'app-jit') {
      args.add('--snapshot-kind=app-jit');
    }
    args.add(buildStep.inputId.path);

    await Process.run(dart, args);

    final file = new File(snapshotPath);
    final data = await file.readAsBytes();
    await file.delete();

    final snapshotAsset = new AssetId(buildStep.inputId.package,
        p.join(p.dirname(buildStep.inputId.path), snapshot));

    await buildStep.writeAsBytes(snapshotAsset, data);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': const ['.snapshot']
      };
}
