/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
 * # Copyright (c) 2016 Alexey Knyazev
 * #
 * # Licensed under the Apache License, Version 2.0 (the 'License');
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an 'AS IS' BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

library gltf.utils;

import 'dart:collection';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

import 'base/gltf_property.dart';
import 'ext/extensions.dart';
import 'gl.dart' as gl;

const _kArray = 'array';
const _kBoolean = 'boolean';
const _kInteger = 'integer';
const _kNumber = 'number';
const _kObject = 'object';
const _kString = 'string';

Object _getGuarded(
    Map<String, Object> map, String name, String type, Context context) {
  final value = map[name];
  if (value == null && map.containsKey(name)) {
    context.addIssue(SchemaError.typeMismatch, name: name, args: [null, type]);
  }
  return value;
}

int getIndex(Map<String, Object> map, String name, Context context,
    {bool req: true}) {
  final value = _getGuarded(map, name, _kInteger, context);
  if (value is int) {
    if (value >= 0) {
      return value;
    }
    context.addIssue(SchemaError.invalidIndex, name: name);
  } else if (value == null) {
    if (req) {
      context.addIssue(SchemaError.undefinedProperty, args: [name]);
    }
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kInteger]);
  }
  return -1;
}

bool getBool(Map<String, Object> map, String name, Context context) {
  final value = _getGuarded(map, name, _kBoolean, context);
  if (value == null) {
    return false;
  }
  if (value is bool) {
    return value;
  }
  context
      .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kBoolean]);
  return false;
}

int getUint(Map<String, Object> map, String name, Context context,
    {bool req: false, int min, int max, int def: -1, Iterable<int> list}) {
  assert(min == null || min >= 0);
  final value = _getGuarded(map, name, _kInteger, context);
  if (value is int) {
    if (list != null) {
      if (!checkEnum<int>(name, value, list, context)) {
        return -1;
      }
    } else if ((min != null && value < min) || (max != null && value > max)) {
      context.addIssue(SchemaError.valueNotInRange, name: name, args: [value]);
      return -1;
    }
    return value;
  } else if (value == null) {
    if (!req) {
      return def;
    }
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kInteger]);
  }
  return -1;
}

double getFloat(Map<String, Object> map, String name, Context context,
    {bool req: false,
    double min,
    double exclMin,
    double max,
    double def: double.NAN,
    Iterable<double> list}) {
  final value = _getGuarded(map, name, _kNumber, context);
  if (value is num) {
    if (list != null) {
      if (!checkEnum<num>(name, value, list, context)) {
        return double.NAN;
      }
    } else if ((min != null && value < min) ||
        (exclMin != null && value <= exclMin) ||
        (max != null && value > max)) {
      context.addIssue(SchemaError.valueNotInRange, name: name, args: [value]);
      return double.NAN;
    }
    return value.toDouble();
  } else if (value == null) {
    if (!req) {
      return def;
    }
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kNumber]);
  }
  return double.NAN;
}

String getString(Map<String, Object> map, String name, Context context,
    {bool req: false, Iterable<String> list, String def, RegExp regexp}) {
  final value = _getGuarded(map, name, _kString, context);
  if (value is String) {
    if (list != null) {
      if (!checkEnum<String>(name, value, list, context)) {
        return null;
      }
    } else if (regexp?.hasMatch(value) == false) {
      context.addIssue(SchemaError.patternMismatch,
          name: name, args: [value, regexp.pattern]);
      return null;
    }
    return value;
  } else if (value == null) {
    if (!req) {
      return def;
    }
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kString]);
  }
  return null;
}

Uri getUri(String uriString, Context context) {
  try {
    final uri = Uri.parse(uriString);
    if (isNonRelativeUri(uri)) {
      context
          .addIssue(SemanticError.nonRelativeUri, name: URI, args: [uriString]);
    }
    return uri;
  } on FormatException catch (e) {
    context.addIssue(SchemaError.invalidUri, name: URI, args: [uriString, e]);
    return null;
  }
}

Map<String, Object> getMap(
    Map<String, Object> map, String name, Context context,
    {bool req: false}) {
  final value = _getGuarded(map, name, _kObject, context);
  if (value is Map<String, Object>) {
    // JSON mandates all keys to be string
    return value;
  } else if (value == null) {
    if (req) {
      context.addIssue(SchemaError.undefinedProperty, args: [name]);
      return null;
    }
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kObject]);
    if (req) {
      return null;
    }
  }
  return <String, Object>{};
}

T getObjectFromInnerMap<T>(Map<String, Object> map, String name,
    Context context, FromMapFunction<T> fromMap,
    {bool req: false}) {
  final value = _getGuarded(map, name, _kObject, context);
  if (value is Map<String, Object>) {
    // JSON mandates all keys to be string
    context.path.add(name);
    final object = fromMap(value, context);
    context.path.removeLast();
    return object;
  } else if (value == null) {
    if (req) {
      context.addIssue(SchemaError.undefinedProperty, args: [name]);
    }
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kObject]);
  }
  return null;
}

List<int> getIndicesList(Map<String, Object> map, String name, Context context,
    {bool req: false}) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }
    if (context.validate) {
      context.path.add(name);
      final uniqueItems = new Set<int>();
      for (var i = 0; i < value.length; i++) {
        final v = value[i];
        if (v is int) {
          if (v < 0) {
            context.addIssue(SchemaError.invalidIndex, index: i);
          } else if (!uniqueItems.add(v)) {
            context.addIssue(SchemaError.arrayDuplicateElements, index: i);
          }
        } else {
          value[i] = -1;
          context.addIssue(SchemaError.typeMismatch,
              index: i, args: [v, _kInteger]);
        }
      }
      context.path.removeLast();
    }
    return value.cast();
  } else if (value == null) {
    if (req) {
      context.addIssue(SchemaError.undefinedProperty, args: [name]);
    }
  } else {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

Map<String, int> getIndicesMap(Map<String, Object> map, String name,
    Context context, _CheckKeyFunction checkKey) {
  final value = _getGuarded(map, name, _kObject, context);
  if (value is Map<String, Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }
    context.path.add(name);
    value.forEach((k, v) {
      checkKey(k);
      if (v is int) {
        if (v < 0) {
          context.addIssue(SchemaError.invalidIndex, name: k);
          // Sanitize value
          value[k] = -1;
        }
      } else {
        // Sanitize value
        value[k] = -1;
        context
            .addIssue(SchemaError.typeMismatch, name: k, args: [v, _kInteger]);
      }
    });
    context.path.removeLast();

    return value.cast();
  } else if (value == null) {
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context.addIssue(SchemaError.typeMismatch,
        name: name, args: [value, _kObject]);
  }
  return null;
}

List<Map<String, int>> getIndicesMapsList(Map<String, Object> map, String name,
    Context context, _CheckKeyFunction checkKey) {
  final list = _getGuarded(map, name, _kArray, context);
  if (list is List<Object>) {
    if (context.validate) {
      if (list.isEmpty) {
        context.addIssue(SchemaError.emptyEntity, name: name);
        return null;
      } else {
        var invalidElementFound = false;
        context.path.add(name);
        for (var i = 0; i < list.length; i++) {
          final innerMap = list[i];
          // JSON mandates all keys to be string
          if (innerMap is Map<String, Object>) {
            if (innerMap.isEmpty) {
              context.addIssue(SchemaError.emptyEntity, index: i);
              invalidElementFound = true;
            } else {
              context.path.add(i.toString());
              innerMap.forEach((k, v) {
                checkKey(k);
                if (v is int) {
                  if (v < 0) {
                    context.addIssue(SchemaError.invalidIndex, name: k);
                    // Sanitize value
                    innerMap[k] = -1;
                  }
                } else {
                  context.addIssue(SchemaError.typeMismatch,
                      name: k, args: [v, _kInteger]);
                  // Sanitize value
                  innerMap[k] = -1;
                }
              });
              context.path.removeLast();
            }
          } else {
            context.addIssue(SchemaError.arrayTypeMismatch,
                args: [innerMap, _kObject]);
            invalidElementFound = true;
          }
        }
        context.path.removeLast();
        if (invalidElementFound) {
          return null;
        }
      }
    }
    return list
        .cast<Map>()
        .map((m) => m.cast<String, int>())
        .toList(growable: false);
  } else if (list != null) {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [list, _kArray]);
  }
  return null;
}

List<double> getFloatList(Map<String, Object> map, String name, Context context,
    {bool req: false,
    bool singlePrecision: false,
    double min,
    double max,
    List<double> def,
    List<int> lengthsList}) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (lengthsList != null) {
      if (!checkEnum<int>(name, value.length, lengthsList, context,
          isLengthList: true)) {
        return null;
      }
    } else if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }

    var wrongMemberFound = false;
    final result = new List<double>(value.length);
    for (var i = 0; i < value.length; ++i) {
      final v = value[i];
      if (v is num) {
        if (context.validate &&
            ((min != null && v < min) || (max != null && v > max))) {
          context.addIssue(SchemaError.valueNotInRange, name: name, args: [v]);
          wrongMemberFound = true;
        }
        if (singlePrecision) {
          result[i] = doubleToSingle(v.toDouble());
        } else {
          result[i] = v.toDouble();
        }
      } else {
        context.addIssue(SchemaError.arrayTypeMismatch,
            name: name, args: [v, _kNumber]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) {
      return null;
    }
    return result;
  } else if (value == null) {
    if (!req) {
      return def;
    }
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

List<num> getGlIntList(Map<String, Object> map, String name, Context context,
    int type, int length) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List) {
    if (value.length != length) {
      context.addIssue(SchemaError.arrayLengthNotInList, name: name, args: [
        value,
        [length]
      ]);
    }
    var wrongMemberFound = false;
    for (final v in value) {
      if (v is num && v.round() == v) {
        // This check works only on DartVM
        if (v is! int) {
          context.addIssue(SemanticError.integerWrittenAsFloat,
              name: name, args: [v]);
        }
        if (type != -1) {
          final min = gl.TYPE_MINS[type];
          final max = gl.TYPE_MAXS[type];
          if ((v < min) || (v > max)) {
            context.addIssue(SemanticError.invalidGlValue,
                name: name, args: [v, gl.TYPE_NAMES[type]]);
            wrongMemberFound = true;
          }
        }
      } else {
        context.addIssue(SchemaError.arrayTypeMismatch,
            name: name, args: [v, _kInteger]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) {
      return null;
    }
    return value.cast();
  } else if (value != null) {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

List<String> getStringList(
    Map<String, Object> map, String name, Context context) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }
    if (context.validate) {
      var wrongMemberFound = false;
      context.path.add(name);
      final uniqueItems = new Set<String>();
      for (var i = 0; i < value.length; i++) {
        final v = value[i];
        if (v is String) {
          if (!uniqueItems.add(v)) {
            context.addIssue(SchemaError.arrayDuplicateElements, index: i);
          }
        } else {
          context.addIssue(SchemaError.arrayTypeMismatch,
              index: i, args: [v, _kString]);
          wrongMemberFound = true;
        }
      }
      context.path.removeLast();
      if (wrongMemberFound) {
        return null;
      }
    }
    return value.cast();
  } else if (value != null) {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

List<Map<String, Object>> getMapList(
    Map<String, Object> map, String name, Context context) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    } else {
      var invalidElementFound = false;
      for (final v in value) {
        if (v is! Map) {
          context.addIssue(SchemaError.arrayTypeMismatch,
              name: name, args: [v, _kObject]);
          invalidElementFound = true;
        }
      }
      if (invalidElementFound) {
        return null;
      }
    }
    return value.cast();
  } else if (value == null) {
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

String getName(Map<String, Object> map, Context context) =>
    getString(map, NAME, context);

Map<String, Object> getExtensions(
    Map<String, Object> map, Type type, Context context,
    {bool warnOnMultipleExtensions: false}) {
  final extensions = <String, Object>{};
  final extensionMaps = getMap(map, EXTENSIONS, context);

  if (extensionMaps.isEmpty) {
    return extensions;
  }

  context.path.add(EXTENSIONS);

  if (warnOnMultipleExtensions && extensionMaps.length > 1) {
    context.addIssue(SemanticError.multipleExtensions,
        args: [null, extensionMaps.keys]);
  }

  for (final extension in extensionMaps.keys) {
    if (!context.extensionsLoaded.contains(extension)) {
      extensions[extension] = null;
      if (context.validate && !context.extensionsUsed.contains(extension)) {
        context.addIssue(LinkError.undeclaredExtension, name: extension);
      }
      continue;
    }

    final functions =
        context.extensionsFunctions[new ExtensionTuple(type, extension)];

    if (functions == null) {
      context.addIssue(LinkError.unexpectedExtensionObject, name: extension);
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

bool checkEnum<T>(String name, T value, Iterable<T> list, Context context,
    {bool isLengthList: false}) {
  if (!list.contains(value)) {
    context.addIssue(
        isLengthList
            ? SchemaError.arrayLengthNotInList
            : SchemaError.valueNotInList,
        name: name,
        args: [value, list]);

    return false;
  }
  return true;
}

void checkMembers(
    Map<String, Object> map, List<String> knownMembers, Context context,
    {bool useSuper = true}) {
  const superMembers = const <String>[EXTENSIONS, EXTRAS];
  for (final k in map.keys) {
    if (!knownMembers.contains(k) && !(useSuper && superMembers.contains(k)))
      context.addIssue(SchemaError.unexpectedProperty, name: k);
  }
}

typedef void _NodeHandlerFunction(Node element, int nodeIndex, int index);

typedef void _CheckKeyFunction(String key);

void resolveNodeList(List<int> sourceList, List<Node> targetList,
    SafeList<Node> nodes, String name, Context context,
    [_NodeHandlerFunction handleNode]) {
  if (sourceList != null) {
    context.path.add(name);
    for (var i = 0; i < sourceList.length; i++) {
      final nodeIndex = sourceList[i];
      if (nodeIndex == null) {
        continue;
      }
      final node = nodes[nodeIndex];
      if (node != null) {
        targetList[i] = node;
        if (handleNode != null) {
          handleNode(node, nodeIndex, i);
        }
      } else {
        context.addIssue(LinkError.unresolvedReference,
            index: i, args: [nodeIndex]);
      }
    }
    context.path.removeLast();
  }
}

/// Adds a [value] to a [map] if that [value] isn't `null`.
void addToMapIfNotNull(Map<String, Object> map, String key, Object value) {
  if (value != null) {
    map[key] = value;
  }
}

/// Clones a map without `null` values and calls `toString` on it.
String mapToString([Map<String, Object> map]) {
  final result = <String, Object>{};
  for (final key in map.keys) {
    final value = map[key];
    if (value != null) {
      result[key] = value;
    }
  }
  return result.toString();
}

class SafeList<T> extends ListBase<T> {
  List<T> _list;
  final int _length;

  SafeList(this._length) {
    _list = new List<T>(length);
  }

  SafeList.empty() : _length = 0 {
    _list = new List<T>(0);
  }

  @override
  T operator [](int index) =>
      (index == null || index < 0 || index >= _list.length)
          ? null
          : _list[index];

  @override
  void operator []=(int index, T value) {
    assert(value != null);
    assert(index >= 0 && index < length);
    _list[index] = value;
  }

  @override
  int get length => _length;

  @override
  set length(int newLength) {
    throw new UnsupportedError('Changing length is not supported');
  }

  @override
  String toString() => _list.toString();

  void forEachWithIndices(void action(int index, T element)) {
    for (var i = 0; i < _length; i++) {
      action(i, _list[i]);
    }
  }
}

final _float = new Float32List(1);
double doubleToSingle(double value) {
  _float[0] = value;
  return _float[0];
}

final _matrix = new Matrix4.zero();
final _translation = new Vector3.zero();
final _rotation = new Quaternion.identity();
final _scale = new Vector3.zero();
bool isTrsDecomposable(Matrix4 matrix) {
  if (matrix[3] != 0.0 ||
      matrix[7] != 0.0 ||
      matrix[11] != 0.0 ||
      matrix[15] != 1.0) {
    return false;
  }

  if (matrix.determinant() == 0.0) {
    return false;
  }

  matrix.decompose(_translation, _rotation, _scale);
  _matrix.setFromTranslationRotationScale(_translation, _rotation, _scale);
  return _matrix.absoluteError(matrix) < 0.00005;
}

bool isPot(int value) => (value != 0) && (value & (value - 1) == 0);

bool isNonRelativeUri(Uri uri) =>
    uri.hasScheme ||
    uri.hasAuthority ||
    uri.hasAbsolutePath ||
    uri.hasQuery ||
    uri.hasFragment;

int padLength(int length) => length + ((4 - (length & 3)) & 3);
