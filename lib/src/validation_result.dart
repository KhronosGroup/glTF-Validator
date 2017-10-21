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
library gltf.validation_result;

import 'dart:math';
import 'package:gltf/src/base/members.dart';
import 'package:gltf/src/context.dart';
import 'package:gltf/gltf.dart' show kGltfValidatorVersion;
import 'package:gltf/src/errors.dart';
import 'package:gltf/src/gltf_reader.dart';
import 'package:gltf/src/utils.dart';

class ValidationResult {
  final Uri absoluteUri;
  final Context context;
  final GltfReaderResult readerResult;

  ValidationResult(this.absoluteUri, this.context, this.readerResult);

  Map<String, Object> toMap() {
    final map = <String, Object>{
      'uri': absoluteUri.toString(),
      'mimeType': readerResult?.mimeType,
      'validatorVersion': kGltfValidatorVersion,
      'validatedAt': new DateTime.now().toUtc().toIso8601String()
    };

    final issues = context.issues;
    final issuesMap = <String, Object>{};
    final numIssues = [0, 0, 0, 0];

    final messages = new List<Map<String, Object>>(issues.length);
    for (var i = 0; i < messages.length; ++i) {
      final issue = issues[i];
      ++numIssues[issue.severity.index];
      messages[i] = issue.toMap();
    }

    issuesMap['numErrors'] = numIssues[Severity.Error.index];
    issuesMap['numWarnings'] = numIssues[Severity.Warning.index];
    issuesMap['numInfos'] = numIssues[Severity.Information.index];
    issuesMap['numHints'] = numIssues[Severity.Hint.index];
    issuesMap['messages'] = messages;
    issuesMap['truncated'] = context.isTruncated;

    map['issues'] = issuesMap;

    map['info'] = _getGltfInfoMap();

    return map;
  }

  Map<String, Object> _getGltfInfoMap() {
    final root = readerResult?.gltf;
    if (root?.asset?.version == null) {
      return null;
    }

    final map = <String, Object>{};

    map[VERSION] = root.asset.version;

    addToMapIfNotNull(map, MIN_VERSION, root.asset.minVersion);

    addToMapIfNotNull(map, GENERATOR, root.asset.generator);

    if (root.extensionsUsed.isNotEmpty) {
      map[EXTENSIONS_USED] = root.extensionsUsed;
    }

    if (root.extensionsRequired.isNotEmpty) {
      map[EXTENSIONS_REQUIRED] = root.extensionsRequired;
    }

    if (context.resources.isNotEmpty) {
      map['resources'] = context.resources;
    }

    map['hasAnimations'] = root.animations.isNotEmpty;
    map['hasMaterials'] = root.materials.isNotEmpty;
    map['hasMorphTargets'] = root.meshes.any((mesh) =>
        mesh.primitives != null &&
        mesh.primitives.any((primitive) => primitive.targets != null));
    map['hasSkins'] = root.skins.isNotEmpty;
    map['hasTextures'] = root.textures.isNotEmpty;
    map['hasDefaultScene'] = root.scene != null;

    var primitivesCount = 0;
    var maxAttributesUsed = 0;
    for (final mesh in root.meshes) {
      if (mesh.primitives != null) {
        primitivesCount += mesh.primitives.length;
        for (final primitive in mesh.primitives) {
          maxAttributesUsed =
              max(maxAttributesUsed, primitive.attributes.length);
        }
      }
    }
    map['primitivesCount'] = primitivesCount;
    map['maxAttributesUsed'] = maxAttributesUsed;

    return map;
  }
}
