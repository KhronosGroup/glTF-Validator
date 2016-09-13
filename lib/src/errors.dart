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

library gltf.error;

enum Severity { Error, Warning }

abstract class GltfWarning {
  static const BUFFER_EMBEDDED_BYTELENGTH_MISMATCH =
      "BUFFER_EMBEDDED_BYTELENGTH_MISMATCH";
  static const DUPLICATE_ITEMS = "DUPLICATE_ITEMS";
  static const MATERIALS_VALUES_WITHOUT_TECHNIQUE =
      "MATERIALS_VALUES_WITHOUT_TECHNIQUE";
  static const NORMALIZED_FLOAT = "NORMALIZED_FLOAT";
  static const NORMALIZED_NON_ARRAY = "NORMALIZED_NON_ARRAY";
  static const ANIMATION_ACCESSOR_WRONG_BUFFERVIEW_TARGET =
      "ANIMATION_ACCESSOR_WRONG_BUFFERVIEW_TARGET";
  static const UNEXPECTED_ATTRIBUTE = "UNEXPECTED_ATTRIBUTE";
  static const UNEXPECTED_PROPERTY = "UNEXPECTED_PROPERTY";
  static const UNSUPPORTED_EXTENSION = "UNSUPPORTED_EXTENSION";

  static final messages = <String, ErrorFunction>{
    BUFFER_EMBEDDED_BYTELENGTH_MISMATCH: (List args) =>
        "Value (${args[0]}) is not equal to the embedded data length (${args[1]})",
    DUPLICATE_ITEMS: (List args) => "Array contains duplicate items",
    MATERIALS_VALUES_WITHOUT_TECHNIQUE: (List args) =>
        "When technique is undefined, values must be undefined too",
    NORMALIZED_FLOAT: (List args) =>
        "Only non-float attributes can be normalized",
    NORMALIZED_NON_ARRAY: (List args) =>
        "Only vertex array buffer data can be normalized",
    ANIMATION_ACCESSOR_WRONG_BUFFERVIEW_TARGET: (List args) =>
        "bufferView.target must be undefined for animation accessor (`${args[0]}`)",
    UNEXPECTED_ATTRIBUTE: (List args) =>
        "Unexpected attribute `${args[0]}` for "
        "${args.length == 1 ? "the default material" : "`${args[1]}`"}",
    UNEXPECTED_PROPERTY: (List args) => "Unexpected property",
    UNSUPPORTED_EXTENSION: (List args) => "Unsupported extension `${args[0]}`"
  };
}

abstract class GltfError {
  static const INVALID_JSON = "INVALID_JSON";
  static const INVALID_JSON_ROOT_OBJECT = "INVALID_JSON_ROOT_OBJECT";

  // Generic errors
  static const ARRAY_LENGTH_NOT_IN_LIST = "ARRAY_LENGTH_NOT_IN_LIST";
  static const ARRAY_LENGTH_OUT_OF_RANGE = "ARRAY_LENGTH_OUT_OF_RANGE";
  static const ARRAY_TYPE_MISMATCH = "ARRAY_TYPE_MISMATCH";
  static const EMPTY_ID = "EMPTY_ID";
  static const INVALID_ACCESSOR_TYPE = "INVALID_ACCESSOR_TYPE";
  static const INVALID_GL_VALUE = "INVALID_GL_VALUE";
  static const INVALID_GL_VALUE_LENGTH = "INVALID_GL_VALUE_LENGTH";
  static const INVALID_URI = "INVALID_URI";
  static const INVALID_DATAURI = "INVALID_DATAURI";
  static const INVALID_DATAURI_MIME = "INVALID_DATAURI_MIME";
  static const TYPE_MISMATCH = "TYPE_MISMATCH";
  static const PATTERN_MISMATCH = "PATTERN_MISMATCH";
  static const VALUE_NOT_IN_LIST = "VALUE_NOT_IN_LIST";
  static const VALUE_OUT_OF_RANGE = "VALUE_OUT_OF_RANGE";
  static const UNDECLARED_EXTENSION = "UNDECLARED_EXTENSION";
  static const UNDEFINED_PROPERTY = "UNDEFINED_PROPERTY";
  static const UNEXPECTED_EXTENSION = "UNEXPECTED_EXTENSION";

  static const UNRESOLVED_REFERENCE = "UNRESOLVED_REFERENCE";

  static const ROOT_DICTIONARY_EMPTY = "ROOT_DICTIONARY_EMPTY";

  // Specific
  static const ACCESSOR_INVALID_ELEMENT_ARRAY_TYPE =
      "ACCESSOR_INVALID_ELEMENT_ARRAY_TYPE";
  static const ACCESSOR_MULTIPLE_COMPONENT_TYPE =
      "ACCESSOR_MULTIPLE_COMPONENT_TYPE";
  static const ACCESSOR_TOTAL_MULTIPLE_COMPONENT_TYPE =
      "ACCESSOR_TOTAL_MULTIPLE_COMPONENT_TYPE";
  static const ACCESSOR_SMALL_BYTESTRIDE = "ACCESSOR_SMALL_BYTESTRIDE";
  static const ACCESSOR_TOO_LONG = "ACCESSOR_TOO_LONG";
  static const ACCESSOR_UINT_NO_EXT = "ACCESSOR_UINT_NO_EXT";
  static const ACCESSOR_UINT_NO_ELEMENT_ARRAY =
      "ACCESSOR_UINT_NO_ELEMENT_ARRAY";
  static const ACCESSOR_UINT_NO_SCALAR = "ACCESSOR_UINT_NO_SCALAR";

  static const ANIMATION_ACCESSOR_INVALID = "ANIMATION_ACCESSOR_INVALID";

  static const BUFFERVIEW_TOO_LONG = "BUFFERVIEW_TOO_LONG";

  static const CAMERA_ZFAR_ZNEAR = "CAMERA_ZFAR_ZNEAR";

  static const MATERIAL_NO_ATTRIBUTES = "MATERIAL_NO_ATTRIBUTES";

  static const MESH_DEFAULT_NO_POSITION = "MESH_DEFAULT_NO_POSITION";
  static const MESH_INVALID_ACCESSOR_BUFFERVIEW =
      "MESH_INVALID_ACCESSOR_BUFFERVIEW";
  static const MESH_INVALID_ACCESSOR_TYPE = "MESH_INVALID_ACCESSOR_TYPE";
  static const MESH_UINT_ATTRIBUTE_ACCESSOR = "MESH_UINT_ATTRIBUTE_ACCESSOR";
  static const MESH_UNEQUAL_ACCESSOR_COUNT = "MESH_UNEQUAL_ACCESSOR_COUNT";

  static const TEXTURE_FORMAT_INTERNALFORMAT = "TEXTURE_FORMAT_INTERNALFORMAT";
  static const TEXTURE_FORMAT_TYPE = "TEXTURE_FORMAT_TYPE";

  static const SKIN_INVALID_ACCESSOR_COUNT = "SKIN_INVALID_ACCESSOR_COUNT";

  static const TECHNIQUE_AMBIGUOUS_PARAMETER = "TECHNIQUE_AMBIGUOUS_PARAMETER";

  static const TECHNIQUE_ATTRIBUTE_COUNT = "TECHNIQUE_ATTRIBUTE_COUNT";
  static const TECHNIQUE_ATTRIBUTE_NODE = "TECHNIQUE_ATTRIBUTE_NODE";
  static const TECHNIQUE_ATTRIBUTE_VALUE = "TECHNIQUE_ATTRIBUTE_VALUE";
  static const TECHNIQUE_ATTRIBUTE_INVALID_TYPE =
      "TECHNIQUE_ATTRIBUTE_INVALID_TYPE";
  static const TECHNIQUE_ATTRIBUTE_TYPE_OVERRIDE =
      "TECHNIQUE_ATTRIBUTE_TYPE_OVERRIDE";

  static const TECHNIQUE_INVALID_SEMANTIC = "TECHNIQUE_INVALID_SEMANTIC";

  static const TECHNIQUE_UNIFORM_NODE_TYPE = "TECHNIQUE_UNIFORM_NODE_TYPE";
  static const TECHNIQUE_UNIFORM_SEMANTIC_TYPE =
      "TECHNIQUE_UNIFORM_SEMANTIC_TYPE";
  static const TECHNIQUE_UNIFORM_SEMANTIC_COUNT =
      "TECHNIQUE_UNIFORM_SEMANTIC_COUNT";
  static const TECHNIQUE_UNIFORM_SEMANTIC_NO_COUNT =
      "TECHNIQUE_UNIFORM_SEMANTIC_NO_COUNT";

  static const TECHNIQUE_UNUSED_PARAMETER = "TECHNIQUE_UNUSED_PARAMETER";

  static final messages = <String, ErrorFunction>{
    INVALID_JSON: (List args) => "Invalid JSON data. Parser output: ${args[0]}",
    INVALID_JSON_ROOT_OBJECT: (List args) => "JSON root must be an object",
    ARRAY_LENGTH_NOT_IN_LIST: (List args) =>
        "Wrong array length (${args[0]}). Valid lengths are: ${args[1]}",
    ARRAY_LENGTH_OUT_OF_RANGE: (List args) =>
        "Array length (${args[0]}) out of range",
    ARRAY_TYPE_MISMATCH: (List args) =>
        "Type mismatch. Member (`${args[0]}`) isn't a `${args[1]}`",
    EMPTY_ID: (List args) => "ID can't be an empty string",
    INVALID_ACCESSOR_TYPE: (List args) =>
        "Accessor with incompatible `type` (${args[0]}) referenced",
    INVALID_GL_VALUE: (List args) =>
        "Invalid value (${args[0]}) for GL type `${args[1]}`",
    INVALID_GL_VALUE_LENGTH: (List args) =>
        "Invalid array length (${args[0]}) for GL type `${args[1]} x ${args[2]}`",
    INVALID_URI: (List args) => "Invalid URI (`${args[0]}`): ${args[1]}",
    INVALID_DATAURI: (List args) => "Invalid Data URI: ${args[0]}",
    INVALID_DATAURI_MIME: (List args) => "Invalid MIME type (`${args[0]}`)",
    TYPE_MISMATCH: (List args) =>
        "Type mismatch. Property value (`${args[0]}`) isn't a `${args[1]}`",
    PATTERN_MISMATCH: (List args) =>
        "Value (`${args[0]}`) doesn't match pattern `${args[1]}`",
    VALUE_NOT_IN_LIST: (List args) =>
        "Wrong value (${args[0]}). Valid values are ${args[1]}",
    VALUE_OUT_OF_RANGE: (List args) => "Value (${args[0]}) out of range",
    UNDECLARED_EXTENSION: (List args) =>
        "Extension wasn't declared in `extensionsUsed`",
    UNDEFINED_PROPERTY: (List args) => "Property must be defined",
    UNEXPECTED_EXTENSION: (List args) => "Extension unexpected",
    UNRESOLVED_REFERENCE: (List args) => "Unresolved reference: `${args[0]}`",
    ROOT_DICTIONARY_EMPTY: (List args) => "Dictionary mustn't be empty",
    ACCESSOR_INVALID_ELEMENT_ARRAY_TYPE: (List args) =>
        "Invalid value (${args[0]}) for bufferView with ELEMENT_ARRAY_BUFFER target",
    ACCESSOR_MULTIPLE_COMPONENT_TYPE: (List args) =>
        "Value (${args[0]}) isn't a multiple of a componentType length (${args[1]})",
    ACCESSOR_TOTAL_MULTIPLE_COMPONENT_TYPE: (List args) =>
        "Accessor's total byteOffset (${args[0]}) isn't a multiple of a componentType length (${args[1]})",
    ACCESSOR_SMALL_BYTESTRIDE: (List args) =>
        "Value (${args[0]}) is less than an attribute length (${args[1]})",
    ACCESSOR_TOO_LONG: (List args) =>
        "Value (${args[0]}) exceeds referenced bufferView (`${args[1]}`) length (${args[2]})",
    ACCESSOR_UINT_NO_EXT: (List args) =>
        "5125 (UNSIGNED_INT) is only allowed when the `OES_element_index_uint` GL extension used",
    ACCESSOR_UINT_NO_ELEMENT_ARRAY: (List args) =>
        "5125 (UNSIGNED_INT) is only allowed when the accessor references bufferView with `ELEMENT_ARRAY_BUFFER` target",
    ACCESSOR_UINT_NO_SCALAR: (List args) =>
        "5125 (UNSIGNED_INT) is only allowed when the `type` is `SCALAR`",
    ANIMATION_ACCESSOR_INVALID: (List args) =>
        "Incompatible animation accessor (`${args[0]}`)",
    BUFFERVIEW_TOO_LONG: (List args) =>
        "BufferView doesn't fit buffer (`${args[0]}`) byteLength (${args[1]})",
    CAMERA_ZFAR_ZNEAR: (List args) => "`zfar` mustn't be equal to `znear`",
    MATERIAL_NO_ATTRIBUTES: (List args) =>
        "Material can't refer attribute parameters",
    MESH_DEFAULT_NO_POSITION: (List args) => "No POSITION attribute found",
    MESH_INVALID_ACCESSOR_BUFFERVIEW: (List args) =>
        "Incompatible accessor referenced: bufferView is null or has wrong target",
    MESH_INVALID_ACCESSOR_TYPE: (List args) =>
        "Incompatible accessor referenced: wrong type and/or componentType",
    MESH_UINT_ATTRIBUTE_ACCESSOR: (List args) =>
        "5125 (UNSIGNED_INT) accessors aren't allowed for attributes",
    MESH_UNEQUAL_ACCESSOR_COUNT: (List args) =>
        "All accessors of the same primitive must have the same count",
    TEXTURE_FORMAT_INTERNALFORMAT: (List args) =>
        "When defined, `format` must match `internalformat`",
    TEXTURE_FORMAT_TYPE: (List args) =>
        "Invalid combination of `type` and `format`",
    SKIN_INVALID_ACCESSOR_COUNT: (List args) =>
        "Accessor with incompatible `count` (${args[0]}) referenced",
    TECHNIQUE_AMBIGUOUS_PARAMETER: (List args) =>
        "Parameter can't be uniform and attribute at the same time",
    TECHNIQUE_ATTRIBUTE_COUNT: (List args) =>
        "Attribute parameter can't have `count` property",
    TECHNIQUE_ATTRIBUTE_NODE: (List args) =>
        "Attribute parameter can't have `node` property",
    TECHNIQUE_ATTRIBUTE_VALUE: (List args) =>
        "Attribute parameter can't have `value` property",
    TECHNIQUE_ATTRIBUTE_INVALID_TYPE: (List args) =>
        "Invalid type (${args[0]}) for attribute parameter",
    TECHNIQUE_ATTRIBUTE_TYPE_OVERRIDE: (List args) =>
        "Invalid type override for semantic `${args[0]}`",
    TECHNIQUE_INVALID_SEMANTIC: (List args) =>
        "Invalid `semantic` value (`${args[0]}`)",
    TECHNIQUE_UNIFORM_NODE_TYPE: (List args) =>
        "When node is defined, type must be FLOAT_MAT4",
    TECHNIQUE_UNIFORM_SEMANTIC_TYPE: (List args) =>
        "Unexpected type ${args[0]} for semantic ${args[1]}",
    TECHNIQUE_UNIFORM_SEMANTIC_COUNT: (List args) =>
        "${args[0]} can't have `count` property",
    TECHNIQUE_UNIFORM_SEMANTIC_NO_COUNT: (List args) =>
        "${args[0]} must have `count` property",
    TECHNIQUE_UNUSED_PARAMETER: (List args) => "Unused parameter",
  };
}

typedef String ErrorFunction(List args);

class GltfIssue {
  final Severity severity;
  final String path;
  final String type;

  final ErrorFunction _message;
  final List _args;

  String get message {
    if (_message == null)
      return (type);
    else
      return _message(_args);
  }

  factory GltfIssue(String type, String path, List args) {
    if (GltfError.messages.containsKey(type)) {
      return new GltfIssue._(
          Severity.Error, type, path, GltfError.messages[type], args);
    } else if (GltfWarning.messages.containsKey(type)) {
      return new GltfIssue._(
          Severity.Warning, type, path, GltfWarning.messages[type], args);
    } else {
      throw new ArgumentError.value(type, "type");
    }
  }

  String toString() {
    if (path.isNotEmpty)
      return "$path: $message";
    else
      return message;
  }

  Map<String, String> toMap() {
    final map = <String, String>{};
    map["type"] = type;
    if (path.isNotEmpty) map["path"] = path;
    if (_message != null) map["message"] = message;
    return map;
  }

  GltfIssue._(this.severity, this.type, this.path, this._message, this._args);

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(dynamic o) => o is GltfIssue && o.toString() == toString();
}
