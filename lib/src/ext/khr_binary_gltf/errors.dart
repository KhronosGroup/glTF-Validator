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

library gltf.extensions.khr_binary_gltf.glb.errors;

import 'package:gltf/src/errors.dart';

enum Severity { Error, Warning }

abstract class GlbWarning {
  static const SUB_OPTIMAL_SCENELENGTH = "SUB_OPTIMAL_SCENELENGTH";

  static final messages = <String, ErrorFunction>{
    SUB_OPTIMAL_SCENELENGTH: (List args) =>
        "Sub-optimal (% 4 != 0) scene length: ${args[0]}."
  };
}

abstract class GlbError {
  static const INVALID_MAGIC = "INVALID_MAGIC";
  static const INVALID_VERSION = "INVALID_VERSION";
  static const INVALID_SCENEFORMAT = "INVALID_SCENEFORMAT";
  static const FILE_TOO_SHORT = "FILE_TOO_SHORT";
  static const UNEXPECTED_END_OF_HEADER = "UNEXPECTED_END_OF_HEADER";
  static const UNEXPECTED_END_OF_SCENE = "UNEXPECTED_END_OF_SCENE";
  static const UNEXPECTED_END_OF_FILE = "UNEXPECTED_END_OF_FILE";

  static final messages = <String, ErrorFunction>{
    INVALID_MAGIC: (List args) => "Invalid glTF magic value (${args[0]}).",
    INVALID_VERSION: (List args) => "Invalid glTF version value (${args[0]}).",
    INVALID_SCENEFORMAT: (List args) =>
        "Invalid glTF sceneFormat value (${args[0]}).",
    FILE_TOO_SHORT: (List args) =>
        "File length less than headerLength + sceneLength",
    UNEXPECTED_END_OF_HEADER: (List args) => "Unexpected end of header.",
    UNEXPECTED_END_OF_SCENE: (List args) => "Unexpected end of `scene`.",
    UNEXPECTED_END_OF_FILE: (List args) => "Unexpected end of file."
  };
}
