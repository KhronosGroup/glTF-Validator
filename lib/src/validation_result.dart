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
library gltf.validation_result;

import 'dart:math';
import 'package:gltf/gltf.dart' show kGltfValidatorVersion;
import 'package:gltf/src/base/members.dart';
import 'package:gltf/src/errors.dart';
import 'package:gltf/src/gltf_reader.dart';
import 'package:gltf/src/utils.dart';

class ValidationResult {
  final Uri uri;
  final Context context;
  final GltfReaderResult readerResult;
  final bool writeTimestamp;

  ValidationResult(this.uri, this.context, this.readerResult,
      {this.writeTimestamp = true});

  Map<String, Object> toMap() {
    final map = <String, Object>{
      if (uri != null) 'uri': uri.toString(),
      if (readerResult?.mimeType != null) 'mimeType': readerResult?.mimeType,
      'validatorVersion': kGltfValidatorVersion,
      if (writeTimestamp)
        'validatedAt': DateTime.now().toUtc().toIso8601String()
    };

    final issues = context.issues;
    final issuesMap = <String, Object>{};
    final numIssues = [0, 0, 0, 0];

    final messages = List<Map<String, Object>>.generate(issues.length, (i) {
      final issue = issues[i];
      ++numIssues[issue.severity.index];
      return issue.toMap();
    }, growable: false);

    issuesMap['numErrors'] = numIssues[Severity.Error.index];
    issuesMap['numWarnings'] = numIssues[Severity.Warning.index];
    issuesMap['numInfos'] = numIssues[Severity.Information.index];
    issuesMap['numHints'] = numIssues[Severity.Hint.index];
    issuesMap['messages'] = messages;
    issuesMap['truncated'] = context.isTruncated;

    map['issues'] = issuesMap;

    addToMapIfNotNull(map, 'info', _getGltfInfoMap());

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
      map[EXTENSIONS_USED] =
          root.extensionsUsed.toSet().toList(growable: false);
    }

    if (root.extensionsRequired.isNotEmpty) {
      map[EXTENSIONS_REQUIRED] =
          root.extensionsRequired.toSet().toList(growable: false);
    }

    if (context.resources.isNotEmpty) {
      map['resources'] = context.resources;
    }

    map['animationCount'] = root.animations.length;
    map['materialCount'] = root.materials.length;
    map['hasMorphTargets'] = root.meshes.any((mesh) =>
        mesh.primitives != null &&
        mesh.primitives.any((primitive) => primitive.targets != null));
    map['hasSkins'] = root.skins.isNotEmpty;
    map['hasTextures'] = root.textures.isNotEmpty;
    map['hasDefaultScene'] = root.scene != null;

    var drawCallCount = 0;
    var maxAttributes = 0;
    var maxUVs = 0;
    var maxInfluences = 0;
    var totalVertexCount = 0;
    var totalTriangleCount = 0;
    for (final mesh in root.meshes) {
      if (mesh.primitives != null) {
        drawCallCount += mesh.primitives.length;
        for (final primitive in mesh.primitives) {
          if (primitive.vertexCount != -1) {
            totalVertexCount += primitive.vertexCount;
          }
          totalTriangleCount += primitive.trianglesCount;
          maxAttributes = max(maxAttributes, primitive.attributes.length);
          maxUVs = max(maxUVs, primitive.texCoordCount);
          maxInfluences = max(maxInfluences, primitive.jointsCount * 4);
        }
      }
    }
    map['drawCallCount'] = drawCallCount;
    map['totalVertexCount'] = totalVertexCount;
    map['totalTriangleCount'] = totalTriangleCount;
    map['maxUVs'] = maxUVs;
    map['maxInfluences'] = maxInfluences;
    map['maxAttributes'] = maxAttributes;

    return map;
  }
}
