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

library gltf.utils;

import 'gl.dart' as gl;
import 'base/gltf_property.dart';
import 'ext/extensions.dart';

String getId(Map<String, Object> map, String name, Context context,
    {bool req: true}) {
  final value = map[name];
  if (value is String) {
    if (value.isNotEmpty) return value;
    context.addIssue(GltfError.EMPTY_ID, name: name);
  } else if (value == null) {
    if (req) context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else {
    context
        .addIssue(GltfError.TYPE_MISMATCH, name: name, args: [value, "string"]);
  }
  return null;
}

bool getBool(Map<String, Object> map, String name, Context context,
    {bool req: false, bool def}) {
  final value = map[name];
  if (value is bool) return value;
  if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "boolean"]);
  return null;
}

int getInt(Map<String, Object> map, String name, Context context,
    {bool req: false, int min, int max, int def, Iterable<int> list}) {
  final value = map[name];
  if (value is int) {
    if (list != null)
      return checkEnum(name, value, list, context) ? value : null;
    else if ((min != null && value < min) || (max != null && value > max))
      context.addIssue(GltfError.VALUE_OUT_OF_RANGE, name: name, args: [value]);
    else
      return value;
  } else if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "integer"]);
  return null;
}

num getNum(Map<String, Object> map, String name, Context context,
    {bool req: false,
    num min,
    num exclMin,
    num max,
    num def,
    Iterable<num> list}) {
  final value = map[name];
  if (value is num) {
    if (list != null)
      return checkEnum(name, value, list, context) ? value : null;
    else if ((min != null && value < min) ||
        (exclMin != null && value <= exclMin) ||
        (max != null && value > max))
      context.addIssue(GltfError.VALUE_OUT_OF_RANGE, name: name, args: [value]);
    else
      return value;
  } else if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context
        .addIssue(GltfError.TYPE_MISMATCH, name: name, args: [value, "number"]);
  return null;
}

String getString(Map<String, Object> map, String name, Context context,
    {bool req: false, Iterable<String> list, String def}) {
  final value = map[name];
  if (value is String) {
    if (list != null && !checkEnum(name, value, list, context)) return null;
    return value;
  }
  if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context
        .addIssue(GltfError.TYPE_MISMATCH, name: name, args: [value, "string"]);
  return null;
}

Map<String, Object> getMap(
    Map<String, Object> map, String name, Context context,
    {bool req: false}) {
  final value = map[name];
  if (value is Map) {
    // JSON mandates all keys to be string
    return value as dynamic/*=Map<String, Object>*/;
  } else if (value == null) {
    if (req) {
      context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
      return null;
    }
  } else {
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "JSON object"]);
    if (req) return null;
  }
  return <String, dynamic>{};
}

/*Map<String, String> getStringMap(Map<String, Object> map, String name) {
  final value = map[name];
  final result = <String, String>{};
  if (value is Map) {
    // JSON mandates all keys to be string
    value.forEach((mapKey, mapValue) {
      if (mapValue is String)
        result[mapKey] = mapValue;
      else if (mapValue == null)
        context.addIssue(name, "$mapKey value can't be null");
      else
        context.addIssue(name, "$mapKey value ($value) is not a string");
    });
  } else if (value != null) {
    context.addIssue(name, "Value ($value) is not a Map");
  }
  return result;
}*/

Uri getUri(String uri, Context context) {
  try {
    return Uri.parse(uri);
  } on FormatException catch (e) {
    context.addIssue(GltfError.INVALID_URI, name: URI, args: [e]);
    return null;
  }
}

List<bool> getBoolList(Map<String, Object> map, String name, Context context,
    {bool req: false, List<bool> def, List<int> lengthsList}) {
  final value = map[name];
  if (value is List) {
    if ((lengthsList != null) &&
        !checkEnum(name, value.length, lengthsList, context, true)) return null;
    var wrongMemberFound = false;
    for (final v in value) {
      if (v is! bool) {
        context.addIssue(GltfError.ARRAY_TYPE_MISMATCH,
            name: name, args: [v, "boolean"]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) return null;
    return value as dynamic/*=List<bool>*/;
  }
  if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else {
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "boolean[]"]);
  }
  return null;
}

List<num> getNumList(Map<String, Object> map, String name, Context context,
    {bool req: false,
    num min,
    num max,
    num exclMin,
    int minItems,
    int maxItems,
    List<num> def,
    List<num> list,
    Iterable<int> lengthsList}) {
  final value = map[name];
  if (value is List) {
    if (lengthsList != null) {
      if (!checkEnum(name, value.length, lengthsList, context, true))
        return null;
    } else if ((minItems != null && value.length < minItems) ||
        (maxItems != null && value.length > maxItems)) {
      context.addIssue(GltfError.ARRAY_LENGTH_OUT_OF_RANGE,
          name: name, args: [value.length]);
      return null;
    }
    var wrongMemberFound = false;
    for (final v in value) {
      if (v is! num) {
        context.addIssue(GltfError.ARRAY_TYPE_MISMATCH,
            name: name, args: [v, "number"]);
        wrongMemberFound = true;
        continue;
      }
      if (list != null) {
        if (!checkEnum(name, v, list, context)) wrongMemberFound = true;
      } else if ((min != null && v < min) ||
          (exclMin != null && v <= exclMin) ||
          (max != null && v > max)) {
        context.addIssue(GltfError.VALUE_OUT_OF_RANGE, name: name, args: [v]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) return null;
    return value as dynamic/*=List<num>*/;
  } else if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "number[]"]);
  return null;
}

List<String> getStringList(
    Map<String, Object> map, String name, Context context,
    {bool req: false,
    int minItems,
    int maxItems,
    List<String> def,
    List<String> list,
    Iterable<int> lengthsList}) {
  final value = map[name];
  if (value is List) {
    if (lengthsList != null) {
      if (!checkEnum(name, value.length, lengthsList, context, true))
        return null;
    } else if ((minItems != null && value.length < minItems) ||
        (maxItems != null && value.length > maxItems)) {
      context.addIssue(GltfError.ARRAY_LENGTH_OUT_OF_RANGE,
          name: name, args: [value.length]);
      return null;
    }
    var wrongMemberFound = false;
    for (final v in value) {
      if (v is! String) {
        context.addIssue(GltfError.ARRAY_TYPE_MISMATCH,
            name: name, args: [v, "string"]);
        wrongMemberFound = true;
        continue;
      }
      if (list != null && !checkEnum(name, v, list, context))
        wrongMemberFound = true;
    }
    if (wrongMemberFound) return null;
    return value as dynamic/*=List<String>*/;
  } else if (value == null) {
    if (!req) return def;
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "string[]"]);
  return null;
}

List<Map<String, Object>> getMapList(
    Map<String, Object> map, String name, Context context,
    {bool req: false, int minItems: 0}) {
  final value = map[name];
  if (value is List) {
    if (value.length < minItems)
      context.addIssue(GltfError.ARRAY_LENGTH_OUT_OF_RANGE,
          name: name, args: [value.length]);
    var wrongMemberFound = false;
    for (final v in value) {
      if (v is! Map) {
        context.addIssue(GltfError.ARRAY_TYPE_MISMATCH,
            name: name, args: [v, "JSON object"]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) return null;
    return value as dynamic/*=List<Map<String, Object>>*/;
  } else if (value == null) {
    if (!req) return <Map<String, Object>>[];
    context.addIssue(GltfError.UNDEFINED_PROPERTY, name: name);
  } else {
    context.addIssue(GltfError.TYPE_MISMATCH,
        name: name, args: [value, "JSON object[]"]);
    if (!req) return <Map<String, Object>>[];
  }
  return null;
}

String getName(Map<String, Object> map, Context context) =>
    getString(map, NAME, context);

Map<String, Object> getExtensions(
    Map<String, Object> map, Type type, Context context) {
  final extensions = <String, Object>{};
  final extensionMaps = getMap(map, EXTENSIONS, context);

  if (extensionMaps.isEmpty) return extensions;

  context.path.add(EXTENSIONS);
  for (final extension in extensionMaps.keys) {
    if (!context.extensionsLoaded.contains(extension)) {
      if (context.extensionsUsed.contains(extension))
        context.addIssue(GltfWarning.UNSUPPORTED_EXTENSION, args: [extension]);
      else
        context.addIssue(GltfError.UNDECLARED_EXTENSION, name: extension);
      continue;
    }

    final functions =
        context.extensionsFunctions[new ExtensionTuple(type, extension)];

    if (functions == null) {
      context.addIssue(GltfError.UNEXPECTED_EXTENSION, name: extension);
      continue;
    }

    final extensionMap = getMap(extensionMaps, extension, context, req: true);
    if (extensionMap != null) {
      context.path.add(extension);
      extensions[extension] = functions.fromMap(extensionMap, context);
      context.path.removeLast();
    }
  }
  context.path.removeLast();

  return extensions;
}

Object getExtras(Map<String, Object> map) => map[EXTRAS];

bool checkEnum(String name, Object value, Iterable list, Context context,
    [bool isLengthList = false]) {
  if (!list.contains(value)) {
    context.addIssue(
        isLengthList
            ? GltfError.ARRAY_LENGTH_NOT_IN_LIST
            : GltfError.VALUE_NOT_IN_LIST,
        name: name,
        args: [value, list]);

    return false;
  }
  return true;
}

void checkMembers(
    Map<String, Object> map, List<String> knownMembers, Context context,
    [bool useSuper = true]) {
  const superMembers = const <String>[EXTENSIONS, EXTRAS];
  for (final k in map.keys) {
    if (!knownMembers.contains(k) && !(useSuper && superMembers.contains(k)))
      context.addIssue(GltfWarning.UNEXPECTED_PROPERTY, name: k);
  }
}

typedef bool CheckFunction(Object value);

void checkGlType(Object value, int type, int count, Context context,
    [String name = VALUE]) {
  bool checkBool(Object value) => value is bool;

  bool checkByte(Object value) => value is int && value < 128 && value > -129;

  bool checkUbyte(Object value) => value is int && value < 256 && value > -1;

  bool checkShort(Object value) =>
      value is int && value < 32768 && value > -32769;

  bool checkUshort(Object value) => value is int && value < 65536 && value > -1;

  bool checkInt(Object value) =>
      value is int && value < 2147483648 && value > -2147483649;

  bool checkUint(Object value) =>
      value is int && value < 4294967296 && value > -1;

  bool checkFloat(Object value) => value is num;

  bool checkSampler(Object value) => value is String;

  bool checkVec(Object value, CheckFunction checkFunction) {
    if (value is List) {
      final expectedLength = (count ?? 1) * gl.TYPE_LENGTHS[type];

      if (value.length != expectedLength) {
        context.addIssue(GltfError.INVALID_GL_VALUE_LENGTH,
            name: name, args: [value.length, gl.TYPE_NAMES[type], count]);
      }

      for (int i = 0; i < value.length; i++) {
        final val = value[i];
        if (!checkFunction(val)) {
          context.addIssue(GltfError.INVALID_GL_VALUE,
              name: name, args: [value, gl.TYPE_NAMES[type]]);
        }
      }
    } else {
      context.addIssue(GltfError.INVALID_GL_VALUE,
          name: name, args: [value, gl.TYPE_NAMES[type]]);
    }
    return true;
  }

  final checkFunctions = <int, CheckFunction>{
    gl.BYTE: checkByte,
    gl.UNSIGNED_BYTE: checkUbyte,
    gl.SHORT: checkShort,
    gl.UNSIGNED_SHORT: checkUshort,
    gl.INT: checkInt,
    gl.UNSIGNED_INT: checkUint,
    gl.FLOAT: checkFloat,
    gl.FLOAT_VEC2: (value) => checkVec(value, checkFloat),
    gl.FLOAT_VEC3: (value) => checkVec(value, checkFloat),
    gl.FLOAT_VEC4: (value) => checkVec(value, checkFloat),
    gl.INT_VEC2: (value) => checkVec(value, checkInt),
    gl.INT_VEC3: (value) => checkVec(value, checkInt),
    gl.INT_VEC4: (value) => checkVec(value, checkInt),
    gl.BOOL: checkBool,
    gl.BOOL_VEC2: (value) => checkVec(value, checkBool),
    gl.BOOL_VEC3: (value) => checkVec(value, checkBool),
    gl.BOOL_VEC4: (value) => checkVec(value, checkBool),
    gl.FLOAT_MAT2: (value) => checkVec(value, checkFloat),
    gl.FLOAT_MAT3: (value) => checkVec(value, checkFloat),
    gl.FLOAT_MAT4: (value) => checkVec(value, checkFloat),
    gl.SAMPLER_2D: checkSampler
  };

  if (!checkFunctions[type](value))
    context.addIssue(GltfError.INVALID_GL_VALUE,
        name: name, args: [value, gl.TYPE_NAMES[type]]);
}

String mapToString([Map map]) {
  return new Map.fromIterable(
      map.keys.where((key) => key != null && map[key] != null),
      key: (key) => key,
      value: (key) => map[key]).toString();
}
