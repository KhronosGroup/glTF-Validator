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

library gltf.base.camera;

import 'dart:math' as math;
import 'package:gltf/src/base/gltf_property.dart';

class Camera extends GltfChildOfRootProperty {
  final String type;
  final CameraOrthographic orthographic;
  final CameraPerspective perspective;

  Camera._(this.type, this.orthographic, this.perspective, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static Camera fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, CAMERA_MEMBERS, context);
    }

    if (context.validate &&
        map.containsKey(CAMERA_TYPES[0]) &&
        map.containsKey(CAMERA_TYPES[1])) {
      context.addIssue(SchemaError.oneOfMismatch, args: CAMERA_TYPES);
    }

    final type = getString(map, TYPE, context, req: true, list: CAMERA_TYPES);

    CameraOrthographic orthographic;
    CameraPerspective perspective;

    switch (type) {
      case ORTHOGRAPHIC:
        orthographic = getObjectFromInnerMap(
            map, ORTHOGRAPHIC, context, CameraOrthographic.fromMap,
            req: true);
        break;
      case PERSPECTIVE:
        perspective = getObjectFromInnerMap(
            map, PERSPECTIVE, context, CameraPerspective.fromMap,
            req: true);
        break;
    }

    return Camera._(type, orthographic, perspective, getName(map, context),
        getExtensions(map, Camera, context), getExtras(map, context));
  }
}

class CameraOrthographic extends GltfProperty {
  final double xmag;
  final double ymag;
  final double zfar;
  final double znear;

  CameraOrthographic._(this.xmag, this.ymag, this.zfar, this.znear,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static CameraOrthographic fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, CAMERA_ORTHOGRAPHIC_MEMBERS, context);
    }

    final xmag = getFloat(map, XMAG, context, req: true);
    final ymag = getFloat(map, YMAG, context, req: true);

    final zfar = getFloat(map, ZFAR, context, req: true, exclMin: 0);
    final znear = getFloat(map, ZNEAR, context, req: true, min: 0);

    if (context.validate) {
      if (zfar <= znear) {
        context.addIssue(SemanticError.cameraZfarLequalZnear);
      }

      if (xmag == 0.0) {
        context.addIssue(SemanticError.cameraXmagYmagZero, name: XMAG);
      } else if (xmag < 0.0) {
        context.addIssue(SemanticError.cameraXmagYmagNegative, name: XMAG);
      }

      if (ymag == 0.0) {
        context.addIssue(SemanticError.cameraXmagYmagZero, name: YMAG);
      } else if (ymag < 0.0) {
        context.addIssue(SemanticError.cameraXmagYmagNegative, name: YMAG);
      }
    }

    return CameraOrthographic._(
        xmag,
        ymag,
        zfar,
        znear,
        getExtensions(map, CameraOrthographic, context),
        getExtras(map, context));
  }
}

class CameraPerspective extends GltfProperty {
  final double aspectRatio;
  final double yfov;
  final double zfar;
  final double znear;

  CameraPerspective._(this.aspectRatio, this.yfov, this.zfar, this.znear,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static CameraPerspective fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, CAMERA_PERSPECTIVE_MEMBERS, context);
    }

    final yfov = getFloat(map, YFOV, context, req: true, exclMin: 0);

    if (context.validate && yfov >= math.pi) {
      context.addIssue(SemanticError.cameraYFovGequalPi);
    }

    final zfar = getFloat(map, ZFAR, context, exclMin: 0);
    final znear = getFloat(map, ZNEAR, context, req: true, exclMin: 0);

    if (context.validate && zfar <= znear) {
      context.addIssue(SemanticError.cameraZfarLequalZnear);
    }

    return CameraPerspective._(
        getFloat(map, ASPECT_RATIO, context, exclMin: 0),
        yfov,
        zfar,
        znear,
        getExtensions(map, CameraPerspective, context),
        getExtras(map, context));
  }
}
