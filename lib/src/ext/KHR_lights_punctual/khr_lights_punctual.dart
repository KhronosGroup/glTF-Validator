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

library gltf.extensions.khr_lights_punctual;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const Extension khrLightsPunctualExtension =
    Extension('KHR_lights_punctual', <Type, ExtensionDescriptor>{
  Gltf: ExtensionDescriptor(KhrLightsPunctualGltf.fromMap),
  Node: ExtensionDescriptor(KhrLightsPunctualNode.fromMap)
});

const String LIGHTS = 'lights';
const String LIGHT = 'light';
const String COLOR = 'color';
const String INTENSITY = 'intensity';
const String SPOT = 'spot';
const String DIRECTIONAL = 'directional';
const String POINT = 'point';
const String RANGE = 'range';
const String INNER_CONE_ANGLE = 'innerConeAngle';
const String OUTER_CONE_ANGLE = 'outerConeAngle';

const List<String> KHR_LIGHTS_PUNCTUAL_GLTF_MEMBERS = <String>[LIGHTS];

const List<String> KHR_LIGHTS_PUNCTUAL_NODE_MEMBERS = <String>[LIGHT];

const List<String> KHR_LIGHTS_PUNCTUAL_LIGHT_MEMBERS = <String>[
  COLOR,
  INTENSITY,
  SPOT,
  TYPE,
  RANGE,
  NAME
];

const List<String> KHR_LIGHTS_PUNCTUAL_LIGHT_TYPES = <String>[
  DIRECTIONAL,
  POINT,
  SPOT
];

const List<String> KHR_LIGHTS_PUNCTUAL_LIGHT_SPOT_MEMBERS = <String>[
  INNER_CONE_ANGLE,
  OUTER_CONE_ANGLE
];

class KhrLightsPunctualGltf extends GltfProperty {
  final SafeList<KhrLightsPunctualLight> lights;

  KhrLightsPunctualGltf._(
      this.lights, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrLightsPunctualGltf fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_LIGHTS_PUNCTUAL_GLTF_MEMBERS, context);
    }

    SafeList<KhrLightsPunctualLight> lights;
    final lightMaps = getMapList(map, LIGHTS, context);
    if (lightMaps != null) {
      lights = SafeList<KhrLightsPunctualLight>(lightMaps.length, LIGHTS);
      context.path.add(LIGHTS);
      for (var i = 0; i < lightMaps.length; i++) {
        final lightMap = lightMaps[i];
        context.path.add(i.toString());
        lights[i] = KhrLightsPunctualLight.fromMap(lightMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      lights = SafeList<KhrLightsPunctualLight>.empty(LIGHTS);
    }

    return KhrLightsPunctualGltf._(
        lights,
        getExtensions(map, KhrLightsPunctualGltf, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (lights != null) {
      context.path.add(LIGHTS);
      context.extensionCollections[lights] =
          context.path.toList(growable: false);
      lights.forEachWithIndices((i, light) {
        context.path.add(i.toString());
        light.link(gltf, context);
        context.path.removeLast();
      });
      context.path.removeLast();
    }
  }
}

class KhrLightsPunctualLight extends GltfChildOfRootProperty {
  final List<double> color;
  final double intensity;
  final KhrLightsPunctualLightSpot spot;
  final String type;
  final double range;

  KhrLightsPunctualLight._(this.color, this.intensity, this.spot, this.type,
      this.range, String name, Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static KhrLightsPunctualLight fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_LIGHTS_PUNCTUAL_LIGHT_MEMBERS, context);
    }

    final color = getFloatList(map, COLOR, context,
        min: 0, max: 1, lengthsList: const [3], def: const [1.0, 1.0, 1.0]);

    final intensity = getFloat(map, INTENSITY, context, def: 1, min: 0);

    final type = getString(map, TYPE, context,
        list: KHR_LIGHTS_PUNCTUAL_LIGHT_TYPES, req: true);

    KhrLightsPunctualLightSpot spot;
    if (type == SPOT) {
      spot = getObjectFromInnerMap(
          map, SPOT, context, KhrLightsPunctualLightSpot.fromMap,
          req: true);
    } else if (context.validate && map.containsKey(SPOT)) {
      context.addIssue(SemanticError.extraProperty, name: SPOT);
    }

    final range = getFloat(map, RANGE, context, exclMin: 0);

    if (context.validate && type == DIRECTIONAL && !range.isNaN) {
      context.addIssue(SemanticError.extraProperty, name: RANGE);
    }

    return KhrLightsPunctualLight._(
        color,
        intensity,
        spot,
        type,
        range,
        getName(map, context),
        getExtensions(map, KhrLightsPunctualLight, context),
        getExtras(map, context));
  }
}

class KhrLightsPunctualLightSpot extends GltfProperty {
  final double innerConeAngle;
  final double outerConeAngle;

  KhrLightsPunctualLightSpot._(this.innerConeAngle, this.outerConeAngle,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrLightsPunctualLightSpot fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_LIGHTS_PUNCTUAL_LIGHT_SPOT_MEMBERS, context);
    }

    final innerConeAngle = getFloat(map, INNER_CONE_ANGLE, context,
        def: 0, min: 0, exclMax: 1.5707963267948966);

    final outerConeAngle = getFloat(map, OUTER_CONE_ANGLE, context,
        def: 0.7853981633974483, exclMin: 0, max: 1.5707963267948966);

    if (context.validate &&
        !outerConeAngle.isNaN &&
        !innerConeAngle.isNaN &&
        outerConeAngle <= innerConeAngle) {
      context.addIssue(SemanticError.khrLightsPunctualLightSpotAngles,
          name: OUTER_CONE_ANGLE, args: [innerConeAngle, outerConeAngle]);
    }

    return KhrLightsPunctualLightSpot._(
        innerConeAngle,
        outerConeAngle,
        getExtensions(map, KhrLightsPunctualLightSpot, context),
        getExtras(map, context));
  }
}

class KhrLightsPunctualNode extends GltfProperty {
  final int _lightIndex;

  KhrLightsPunctualLight _light;

  KhrLightsPunctualNode._(
      this._lightIndex, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static KhrLightsPunctualNode fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_LIGHTS_PUNCTUAL_NODE_MEMBERS, context);
    }

    return KhrLightsPunctualNode._(
        getIndex(map, LIGHT, context),
        getExtensions(map, KhrLightsPunctualNode, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    final lightsExtension = gltf.extensions[khrLightsPunctualExtension.name];
    if (lightsExtension is KhrLightsPunctualGltf) {
      _light = lightsExtension.lights[_lightIndex];

      if (context.validate && _lightIndex != -1) {
        if (_light == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: LIGHT, args: [_lightIndex]);
        } else {
          _light.markAsUsed();
        }
      }
    } else if (context.validate) {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${khrLightsPunctualExtension.name}']);
    }
  }

  KhrLightsPunctualLight get light => _light;
}
