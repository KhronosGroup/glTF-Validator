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

library gltf.utils;

import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/gl.dart' as gl;
import 'package:vector_math/vector_math.dart';

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

// Convert an integer value parsed as double to a sound integer.
Object _tryFixInt(Object value) =>
    value is double && value.floorToDouble() == value ? value.toInt() : value;

int getIndex(Map<String, Object> map, String name, Context context,
    {bool req = true}) {
  final value = _tryFixInt(_getGuarded(map, name, _kInteger, context));
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
    {bool req = false,
    int min = 0,
    int max = -1,
    int def = -1,
    Iterable<int> list}) {
  assert(min != null && min >= 0);
  assert(max == -1 || max >= min);
  assert(list == null || list.every((v) => v >= 0));
  final value = _tryFixInt(_getGuarded(map, name, _kInteger, context));
  if (value is int) {
    if (list != null) {
      if (!checkEnum<int>(name, value, list, context)) {
        return -1;
      }
    } else if ((value < min) || (max != -1 && value > max)) {
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
    {bool req = false,
    double standalone = double.nan,
    double min = double.negativeInfinity,
    double exclMin = double.negativeInfinity,
    double max = double.infinity,
    double exclMax = double.infinity,
    double def = double.nan}) {
  assert(min != null && max != null && exclMin != null && exclMax != null);
  assert(exclMax > min && max >= min && exclMax > exclMin && max > exclMin);
  final value = _getGuarded(map, name, _kNumber, context);
  if (value is num) {
    if (value != standalone &&
        (value < min || value <= exclMin || value > max || value >= exclMax)) {
      context.addIssue(SchemaError.valueNotInRange, name: name, args: [value]);
      return double.nan;
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
  return double.nan;
}

String getString(Map<String, Object> map, String name, Context context,
    {bool req = false, Iterable<String> list, String def, RegExp regexp}) {
  final value = _getGuarded(map, name, _kString, context);
  if (value is String) {
    if (list != null) {
      checkEnum<String>(name, value, list, context);
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
    {bool req = false}) {
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
    {bool req = false}) {
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
    {bool req = false}) {
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }
    if (context.validate) {
      context.path.add(name);
      final uniqueItems = <int>{};
      for (var i = 0; i < value.length; i++) {
        final v = _tryFixInt(value[i]);
        if (v is int && v >= 0) {
          if (!uniqueItems.add(v)) {
            context.addIssue(SchemaError.arrayDuplicateElements, index: i);
          }
          // Ensure that the returned entry is integer
          value[i] = v;
        } else {
          // Sanitize value
          value[i] = -1;
          context.addIssue(SchemaError.invalidIndex, index: i);
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
      v = _tryFixInt(v);
      if (v is int && v >= 0) {
        // Ensure that the returned entry is integer
        value[k] = v;
      } else {
        // Sanitize value
        value[k] = -1;
        context.addIssue(SchemaError.invalidIndex, name: k);
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
                v = _tryFixInt(v);
                if (v is int && v >= 0) {
                  // Ensure that the returned entry is integer
                  innerMap[k] = v;
                } else {
                  // Sanitize value
                  innerMap[k] = -1;
                  context.addIssue(SchemaError.invalidIndex, name: k);
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
    {bool req = false,
    bool singlePrecision = false,
    double min = double.negativeInfinity,
    double max = double.infinity,
    List<double> def,
    List<int> lengthsList}) {
  assert(min != null && max != null);
  assert(max >= min);
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.isEmpty) {
      context.addIssue(SchemaError.emptyEntity, name: name);
      return null;
    }

    if (lengthsList != null &&
        !checkEnum<int>(name, value.length, lengthsList, context,
            lengthList: true)) {
      return null;
    }

    var wrongMemberFound = false;
    final result = List<double>.filled(value.length, 0);
    for (var i = 0; i < value.length; ++i) {
      final v = value[i];
      if (v is num) {
        if (context.validate && (v.isInfinite || v < min || v > max)) {
          context
            ..path.add(name)
            ..addIssue(SchemaError.valueNotInRange, index: i, args: [v])
            ..path.removeLast();
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
      return def?.toList(growable: false);
    }
    context.addIssue(SchemaError.undefinedProperty, args: [name]);
  } else {
    context
        .addIssue(SchemaError.typeMismatch, name: name, args: [value, _kArray]);
  }
  return null;
}

List<int> getGlIntList(Map<String, Object> map, String name, Context context,
    int type, int length) {
  assert(type > 0 && length > 0);
  final value = _getGuarded(map, name, _kArray, context);
  if (value is List<Object>) {
    if (value.length != length) {
      context.addIssue(SchemaError.arrayLengthNotInList, name: name, args: [
        value.length,
        [length]
      ]);
      return null;
    }
    final min = gl.typeMin(type);
    final max = gl.typeMax(type);
    final result = createTypedIntList(type, length);
    var wrongMemberFound = false;
    for (var i = 0; i < value.length; ++i) {
      final v = _tryFixInt(value[i]);
      if (v is int) {
        if (context.validate && ((v < min) || (v > max))) {
          context.addIssue(SemanticError.invalidGlValue,
              name: name, args: [v, gl.TYPE_NAMES[type]]);
          wrongMemberFound = true;
        }
        result[i] = v;
      } else {
        context.addIssue(SchemaError.arrayTypeMismatch,
            name: name, args: [v, _kInteger]);
        wrongMemberFound = true;
      }
    }
    if (wrongMemberFound) {
      return null;
    }
    return result;
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
      final uniqueItems = <String>{};
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
        if (v is! Map<String, Object>) {
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

String getName(Map<String, Object> map, Context context, {bool req = false}) =>
    getString(map, NAME, context, req: req);

Map<String, Object> getExtensions(
    Map<String, Object> map, Type type, Context context,
    {Type overriddenType}) {
  final extensions = <String, Object>{};
  final extensionMaps = getMap(map, EXTENSIONS, context);

  if (extensionMaps.isEmpty) {
    return extensions;
  }

  context.path.add(EXTENSIONS);

  for (final extension in extensionMaps.keys) {
    // Fetch extension JSON map first to ensure schema compliance.
    final extensionMap = getMap(extensionMaps, extension, context);

    if (!context.extensionsLoaded.contains(extension)) {
      if (context.validate && !context.extensionsUsed.contains(extension)) {
        context.addIssue(LinkError.undeclaredExtension, name: extension);
      }
      continue;
    }

    final extensionDescriptor =
        context.extensionDescriptors[ExtensionTuple(type, extension)];

    if (extensionDescriptor == null) {
      context.addIssue(LinkError.unexpectedExtensionObject, name: extension);
      continue;
    }

    if (extensionMaps.length > 1 && extensionDescriptor.standalone) {
      context.addIssue(SemanticError.multipleExtensions, name: extension);
    }

    if (extensionMap != null) {
      context.path.add(extension);
      final object = extensionDescriptor.fromMap(extensionMap, context);
      extensions[extension] = object;
      if (!extensionDescriptor.localLink && object is Linkable) {
        context.linkableExtensions
            .putIfAbsent(
                overriddenType ?? type, () => <LinkableExtensionEntry>[])
            .add(LinkableExtensionEntry(
                object, context.path.toList(growable: false)));
      }

      if (object is ResourceValidatable) {
        context.resourceValidatableExtensions.add(
            ResourceValidatableExtensionEntry(
                object, context.path.toList(growable: false)));
      }
      context.path.removeLast();
    }
  }
  context.path.removeLast();

  return extensions;
}

Object getExtras(Map<String, Object> map, Context context) {
  final extras = map[EXTRAS];
  if (context.validate && extras != null && extras is! Map) {
    context.addIssue(SemanticError.nonObjectExtras, name: EXTRAS);
  }
  return extras;
}

bool checkEnum<T>(String name, T value, Iterable<T> list, Context context,
    {bool lengthList = false}) {
  if (!list.contains(value)) {
    context.addIssue(
        lengthList
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
  const superMembers = <String>[EXTENSIONS, EXTRAS];
  for (final k in map.keys) {
    if (!knownMembers.contains(k) && !(useSuper && superMembers.contains(k))) {
      context.addIssue(SchemaError.unexpectedProperty, name: k);
    }
  }
}

typedef _CheckKeyFunction = void Function(String key);

void resolveNodeList(List<int> sourceList, List<Node> targetList,
    SafeList<Node> nodes, String name, Context context,
    [void Function(Node element, int nodeIndex, int index) handleNode]) {
  assert(sourceList != null);
  context.path.add(name);
  for (var i = 0; i < sourceList.length; i++) {
    final nodeIndex = sourceList[i];
    if (nodeIndex == -1) {
      continue;
    }
    final node = nodes[nodeIndex];
    if (node != null) {
      node.markAsUsed();
      targetList[i] = node;
      if (handleNode != null) {
        handleNode(node, nodeIndex, i);
      }
    } else {
      context
          .addIssue(LinkError.unresolvedReference, index: i, args: [nodeIndex]);
    }
  }
  context.path.removeLast();
}

/// Adds a [value] to a [map] if that [value] isn't `null`.
void addToMapIfNotNull(Map<String, Object> map, String key, Object value) {
  if (value != null) {
    map[key] = value;
  }
}

class SafeList<T> extends ListBase<T> {
  final List<T> _list;
  final int _length;
  final String name;

  SafeList(this._length, this.name) : _list = List<T>.filled(_length, null);

  SafeList.empty(this.name)
      : _length = 0,
        _list = List<T>.empty();

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
    throw UnsupportedError('Changing length is not supported');
  }

  @override
  String toString() => _list.toString();

  void forEachWithIndices(void Function(int index, T element) action) {
    for (var i = 0; i < _length; i++) {
      final e = _list[i];
      // Skip broken objects
      if (e == null) {
        continue;
      }
      action(i, e);
    }
  }
}

final _float = Float32List(1);
double doubleToSingle(double value) {
  _float[0] = value;
  return _float[0];
}

final _matrix = Matrix4.zero();
final _translation = Vector3.zero();
final _rotation = Quaternion.identity();
final _scale = Vector3.zero();
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

int padLength(int length) => length + (-length & 3);

List<int> createTypedIntList(int type, int length) {
  assert(length > 0);
  switch (type) {
    case gl.BYTE:
      return Int8List(length);
    case gl.UNSIGNED_BYTE:
      return Uint8List(length);
    case gl.SHORT:
      return Int16List(length);
    case gl.UNSIGNED_SHORT:
      return Uint16List(length);
    case gl.INT:
      return Int32List(length);
    case gl.UNSIGNED_INT:
      return Uint32List(length);
    default:
      throw ArgumentError();
  }
}

extension QuaternionIsDefault on Quaternion {
  bool get isDefault => x == 0 && y == 0 && z == 0 && w == 1;
}

extension Vector3IsOneOrZero on Vector3 {
  bool get isOne => x == 1 && y == 1 && z == 1;

  bool get isZero => x == 0 && y == 0 && z == 0;
}

abstract class ElementChecker<T extends num> {
  const ElementChecker();
  String get path => '';

  bool check(Context context, int index, int componentIndex, T value);

  bool done(Context context) => true;
}

class UnitVec3FloatChecker extends ElementChecker<num> {
  UnitVec3FloatChecker(this.path, this.normalizeValue);

  double _sum = 0;

  @override
  final String path;

  final double Function(num value) normalizeValue;

  @override
  bool check(Context context, int index, int componentIndex, num value) {
    assert(componentIndex < 3);
    final v = normalizeValue != null ? normalizeValue(value) : value;
    _sum += v * v;
    if (2 == componentIndex) {
      if ((sqrt(_sum) - 1.0).abs() > unitLengthThresholdVec3) {
        context.addIssue(DataError.accessorVector3NonUnit,
            name: path, args: [index - 2, index, sqrt(_sum)]);
      }
      _sum = 0.0;
    }

    return true;
  }
}

class UnitVec3SignFloatChecker extends ElementChecker<num> {
  UnitVec3SignFloatChecker(this.path, this.normalizeValue);

  double _sum = 0;

  @override
  final String path;

  final double Function(num value) normalizeValue;

  @override
  bool check(Context context, int index, int componentIndex, num value) {
    assert(componentIndex < 4);
    final v = normalizeValue != null ? normalizeValue(value) : value;
    if (3 == componentIndex) {
      if (1.0 != v && -1.0 != v) {
        context.addIssue(DataError.accessorInvalidSign,
            name: path, args: [index - 3, index, v]);
      }
    } else {
      _sum += v * v;
      if (2 == componentIndex) {
        if ((sqrt(_sum) - 1.0).abs() > unitLengthThresholdVec3) {
          context.addIssue(DataError.accessorVector3NonUnit,
              name: path, args: [index - 2, index, sqrt(_sum)]);
        }
        _sum = 0.0;
      }
    }

    return true;
  }
}

class ClampedRangeFloatChecker extends ElementChecker<double> {
  const ClampedRangeFloatChecker(this.path);

  @override
  final String path;

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    if (1.0 < value || 0.0 > value) {
      context.addIssue(DataError.accessorNonClamped,
          name: path, args: [index, value]);
    }

    return true;
  }
}
