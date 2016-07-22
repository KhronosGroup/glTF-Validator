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

library gltf.core.material;

import 'gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

class Material extends GltfChildOfRootProperty implements Linkable {
  final String techniqueId;
  final Map<String, Object> values;

  Technique technique;

  Material._(this.techniqueId, this.values, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  String toString([_]) =>
      super.toString({TECHNIQUE: techniqueId, VALUES: values});

  static Material fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, MATERIAL_MEMBERS, context);

    final techniqueId = getId(map, TECHNIQUE, context, req: false);

    if (techniqueId == null && map.containsKey(VALUES)) {
      context.addIssue(GltfWarning.MATERIALS_VALUES_WITHOUT_TECHNIQUE);
    }

    return new Material._(
        techniqueId,
        getMap(map, VALUES, context),
        getName(map, context),
        getExtensions(map, Material, context),
        getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    technique = gltf.techniques[techniqueId];

    if (!context.validate) return;

    if (technique != null) {
      if (values.isNotEmpty) {
        context.path.add(VALUES);
        values.forEach((id, value) {
          if (technique.attributes.containsValue(id)) {
            context.addIssue(GltfError.MATERIAL_NO_ATTRIBUTES, name: id);
            return;
          }

          final parameter = technique.parameters[id];
          if (parameter == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE, args: [id]);
            return;
          }

          if (parameter.type != null)
            checkGlType(value, parameter.type, parameter.count, context, id);

          if (context.validate &&
              parameter.type == gl.SAMPLER_2D &&
              gltf.textures[value] == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: id, args: [value]);
          }
        });
        context.path.removeLast();
      }
    } else if (techniqueId != null) {
      context.addIssue(GltfError.UNRESOLVED_REFERENCE,
          name: TECHNIQUE, args: [techniqueId]);
    }
  }
}
