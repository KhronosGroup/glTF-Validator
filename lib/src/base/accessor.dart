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

library gltf.base.accessor;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

abstract class Accessor<T extends num> extends GltfChildOfRootProperty {
  final int _bufferViewIndex;
  final int byteOffset;
  final int componentType;
  final int count;
  final String type;
  final bool normalized;
  final List<T> max;
  final List<T> min;
  final AccessorSparse sparse;

  final int componentLength;

  BufferView _bufferView;
  int _byteStride = 0;
  bool _isUnit = false;
  bool _isClamped = false;
  bool _isXyzSign = false;
  bool _containsCubicSpline;
  AccessorUsage _usage;

  Accessor._(
      this._bufferViewIndex,
      this.byteOffset,
      this.componentType,
      this.count,
      this.type,
      this.normalized,
      this.max,
      this.min,
      this.sparse,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : componentLength = gl.componentTypeLength(componentType),
        super(name, extensions, extras);

  bool get _isMatrixWithGaps =>
      ((componentType == gl.UNSIGNED_BYTE || componentType == gl.BYTE) &&
          (type == MAT2 || type == MAT3)) ||
      ((componentType == gl.UNSIGNED_SHORT || componentType == gl.SHORT) &&
          type == MAT3);

  BufferView get bufferView => _bufferView;

  int get components => ACCESSOR_TYPES_LENGTHS[type] ?? 0;

  int get elementLength {
    // TODO: generalize to non-square matrices
    if (componentType == gl.UNSIGNED_BYTE || componentType == gl.BYTE) {
      if (type == MAT2) {
        return 6;
      } else if (type == MAT3) {
        return 11;
      }
      return components;
    } else if (componentType == gl.UNSIGNED_SHORT ||
        componentType == gl.SHORT) {
      if (type == MAT3) {
        return 22;
      }
      return 2 * components;
    }
    // gl.FLOAT || gl.UNSIGNED_INT
    return 4 * components;
  }

  int get byteStride {
    if (_byteStride != 0) {
      return _byteStride;
    }

    // TODO: generalize to non-square matrices
    if (componentType == gl.UNSIGNED_BYTE || componentType == gl.BYTE) {
      if (type == MAT2) {
        return 8;
      } else if (type == MAT3) {
        return 12;
      }
      return components;
    } else if (componentType == gl.UNSIGNED_SHORT ||
        componentType == gl.SHORT) {
      if (type == MAT3) {
        return 24;
      }
      return 2 * components;
    }
    // gl.FLOAT || gl.UNSIGNED_INT
    return 4 * components;
  }

  int get byteLength => byteStride * (count - 1) + elementLength;

  bool get isFloat => gl.FLOAT == componentType;
  bool get isClamped => _isClamped;
  bool get isUnit => _isUnit;
  bool get isXyzSign => _isXyzSign;
  bool get containsCubicSpline => _containsCubicSpline == true;

  AccessorUsage get usage => _usage;

  static Accessor fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ACCESSOR_MEMBERS, context);
    }

    final bufferViewIndex = getIndex(map, BUFFER_VIEW, context, req: false);

    var byteOffset = 0;
    if (bufferViewIndex == -1) {
      if (context.validate && map.containsKey(BYTE_OFFSET)) {
        context.addIssue(SchemaError.unsatisfiedDependency,
            name: BYTE_OFFSET, args: [BUFFER_VIEW]);
      }
    } else {
      byteOffset = getUint(map, BYTE_OFFSET, context, def: 0);
    }

    final componentType = getUint(map, COMPONENT_TYPE, context,
        req: true, list: gl.COMPONENT_TYPES);

    final count = getUint(map, COUNT, context, req: true, min: 1);
    final type = getString(map, TYPE, context,
        req: true, list: ACCESSOR_TYPES_LENGTHS.keys);

    final normalized = getBool(map, NORMALIZED, context);

    List<num> max;
    List<num> min;
    if (type != null && componentType != -1) {
      final length = ACCESSOR_TYPES_LENGTHS[type];
      if (length != null) {
        if (componentType == gl.FLOAT) {
          min = getFloatList(map, MIN, context,
              lengthsList: [length], singlePrecision: true);
          max = getFloatList(map, MAX, context,
              lengthsList: [length], singlePrecision: true);
        } else {
          min = getGlIntList(map, MIN, context, componentType, length);
          max = getGlIntList(map, MAX, context, componentType, length);
        }
      }
    }

    final sparse = getObjectFromInnerMap<AccessorSparse>(
        map, SPARSE, context, AccessorSparse.fromMap);

    if (context.validate) {
      if (normalized &&
          (componentType == gl.FLOAT || componentType == gl.UNSIGNED_INT)) {
        context.addIssue(SemanticError.accessorNormalizedInvalid,
            name: NORMALIZED);
      }

      if ((type == MAT2 || type == MAT3 || type == MAT4) &&
          byteOffset != -1 &&
          byteOffset & 3 != 0) {
        context.addIssue(SemanticError.accessorMatrixAlignment,
            name: BYTE_OFFSET);
      }
    }

    Accessor accessor;

    switch (componentType) {
      case gl.BYTE:
      case gl.UNSIGNED_BYTE:
      case gl.SHORT:
      case gl.UNSIGNED_SHORT:
      case gl.UNSIGNED_INT:
        accessor = _AccessorInt._(
            bufferViewIndex,
            byteOffset,
            componentType,
            count,
            type,
            normalized,
            max as List<int>,
            min as List<int>,
            sparse,
            getName(map, context),
            getExtensions(map, Accessor, context),
            getExtras(map, context));

        if (context.validate) {
          // accessor.min
          if (min != null) {
            context.addElementChecker(
                accessor,
                MinIntegerChecker(
                    context.getPointerString(), min as List<int>));
          }

          // accessor.max
          if (max != null) {
            context.addElementChecker(
                accessor,
                MaxIntegerChecker(
                    context.getPointerString(), max as List<int>));
          }
        }
        break;
      default:
        accessor = _AccessorFloat._(
            bufferViewIndex,
            byteOffset,
            componentType,
            count,
            type,
            normalized,
            max as List<double>,
            min as List<double>,
            sparse,
            getName(map, context),
            getExtensions(map, Accessor, context),
            getExtras(map, context));

        if (context.validate) {
          // NaN or Infinity
          context.addElementChecker(
              accessor, InvalidFloatChecker(context.getPointerString()));

          // accessor.min
          if (min != null) {
            context.addElementChecker(
                accessor,
                MinFloatChecker(
                    context.getPointerString(), min as List<double>));
          }

          // accessor.max
          if (max != null) {
            context.addElementChecker(
                accessor,
                MaxFloatChecker(
                    context.getPointerString(), max as List<double>));
          }
        }
        break;
    }

    return accessor;
  }

  @override
  void link(Gltf gltf, Context context) {
    _bufferView = gltf.bufferViews[_bufferViewIndex];

    if (_bufferView != null && _bufferView.byteStride != -1) {
      _byteStride = _bufferView.byteStride;
    }

    // Ensure required fields to not check for them each time
    if (componentType == -1 || count == -1 || type == null) {
      return;
    }

    // Check length and alignment when bufferView is present
    if (context.validate && _bufferViewIndex != -1) {
      if (_bufferView == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: BUFFER_VIEW, args: [_bufferViewIndex]);
      } else {
        _bufferView.markAsUsed();
        // Byte Stride
        if (_bufferView.byteStride != -1 &&
            _bufferView.byteStride < elementLength) {
          context.addIssue(LinkError.accessorSmallStride,
              args: [_bufferView.byteStride, elementLength]);
        }

        _checkByteOffsetAndLength(byteOffset, componentLength, byteLength,
            _bufferView, _bufferViewIndex, context);
      }
    }

    if (sparse != null) {
      if (sparse.count == -1 ||
          sparse.indices == null ||
          sparse.values == null) {
        return;
      }

      context.path.add(SPARSE);
      {
        if (context.validate && sparse.count > count) {
          context.addIssue(SemanticError.accessorSparseCountOutOfRange,
              name: COUNT, args: [sparse.count, count]);
        }

        sparse.values.link(gltf, context);

        context.path.add(INDICES);
        {
          final indices = sparse.indices;

          if (indices._bufferViewIndex != -1) {
            sparse.indices.link(gltf, context);

            if (indices._bufferView == null) {
              context.addIssue(LinkError.unresolvedReference,
                  name: BUFFER_VIEW, args: [indices._bufferViewIndex]);
            } else {
              indices._bufferView
                  .setUsage(BufferViewUsage.Other, BUFFER_VIEW, context);

              if (context.validate) {
                if (indices._bufferView.byteStride != -1) {
                  context.addIssue(SemanticError.bufferViewInvalidByteStride,
                      name: BUFFER_VIEW);
                }

                if (indices.componentType != -1) {
                  _checkByteOffsetAndLength(
                      indices.byteOffset,
                      gl.componentTypeLength(indices.componentType),
                      gl.componentTypeLength(indices.componentType) *
                          sparse.count,
                      indices._bufferView,
                      indices._bufferViewIndex,
                      context);
                }
              }
            }
          }
        }
        context.path
          ..removeLast()
          ..add(VALUES);
        {
          final values = sparse.values;

          if (values._bufferViewIndex != -1) {
            if (values._bufferView == null) {
              context.addIssue(LinkError.unresolvedReference,
                  name: BUFFER_VIEW, args: [values._bufferViewIndex]);
            } else {
              values._bufferView
                  .setUsage(BufferViewUsage.Other, BUFFER_VIEW, context);

              if (context.validate) {
                if (values._bufferView.byteStride != -1) {
                  context.addIssue(SemanticError.bufferViewInvalidByteStride,
                      name: BUFFER_VIEW);
                }

                _checkByteOffsetAndLength(
                    values.byteOffset,
                    componentLength,
                    componentLength *
                        (ACCESSOR_TYPES_LENGTHS[type] ?? 0) *
                        sparse.count,
                    values._bufferView,
                    values._bufferViewIndex,
                    context);
              }
            }
          }
        }
        context.path.removeLast();
      }
      context.path.removeLast();
    }
  }

  void setUsage(AccessorUsage value, String name, Context context) {
    markAsUsed();
    if (_usage == null) {
      _usage = value;
    } else if (context.validate && _usage != value) {
      context.addIssue(LinkError.accessorUsageOverride,
          name: name, args: [_usage, value]);
    }
  }

  void setClamped() => _isClamped = true;

  void setUnit() => _isUnit = true;

  void setXyzSign() => _isXyzSign = true;

  bool trySetInterpolation({bool cubic = false}) {
    if (_containsCubicSpline == null) {
      _containsCubicSpline = cubic;
    } else if (_containsCubicSpline != cubic) {
      return false;
    }
    return true;
  }

  Iterable<T> getElements();

  Iterable<double> getElementsNormalized();

  double normalizeValue(num value) {
    if (!normalized || gl.FLOAT == componentType) {
      return value.toDouble();
    }

    final width = componentLength * 8;
    if (componentType == gl.BYTE ||
        componentType == gl.SHORT ||
        componentType == gl.INT) {
      // Signed
      final divider = (1 << width - 1) - 1;
      return math.max<double>(value / divider, -1);
    } else {
      // Unsigned
      final divider = (1 << width) - 1;
      return value / divider;
    }
  }

  static bool _checkByteOffsetAndLength(int byteOffset, int componentLength,
      int byteLength, BufferView bufferView,
      [int _bufferViewIndex, Context context]) {
    // Local offset
    if (byteOffset == -1) {
      return false;
    }

    if (byteOffset.remainder(componentLength) != 0) {
      if (context != null) {
        context.addIssue(SemanticError.accessorOffsetAlignment,
            name: BYTE_OFFSET, args: [byteOffset, componentLength]);
      } else {
        return false;
      }
    }

    // Total offset
    if (bufferView.byteOffset == -1) {
      return false;
    }

    final totalOffset = bufferView.byteOffset + byteOffset;
    if (totalOffset.remainder(componentLength) != 0) {
      if (context != null) {
        context.addIssue(LinkError.accessorTotalOffsetAlignment,
            args: [totalOffset, componentLength]);
      } else {
        return false;
      }
    }

    // Length
    if (byteOffset > bufferView.byteLength) {
      if (context != null) {
        context.addIssue(LinkError.accessorTooLong, name: BYTE_OFFSET, args: [
          byteOffset,
          byteLength,
          _bufferViewIndex,
          bufferView.byteLength
        ]);
      } else {
        return false;
      }
    } else if (byteOffset + byteLength > bufferView.byteLength) {
      if (context != null) {
        context.addIssue(LinkError.accessorTooLong, args: [
          byteOffset,
          byteLength,
          _bufferViewIndex,
          bufferView.byteLength
        ]);
      } else {
        return false;
      }
    }
    return true;
  }

  static List<int> _typedViewIndices(
      int componentType, ByteBuffer buffer, int offsetInBytes, int length) {
    assert(gl.COMPONENT_TYPES.contains(componentType));
    if (buffer == null ||
        buffer.lengthInBytes <
            offsetInBytes + gl.componentTypeLength(componentType) * length) {
      return null;
    }
    switch (componentType) {
      case gl.UNSIGNED_BYTE:
        return Uint8List.view(buffer, offsetInBytes, length);
      case gl.UNSIGNED_SHORT:
        return Uint16List.view(buffer, offsetInBytes, length);
      case gl.UNSIGNED_INT:
        return Uint32List.view(buffer, offsetInBytes, length);
      default:
        return null;
    }
  }

  static Float32List _typedViewFloat(
      int componentType, ByteBuffer buffer, int offsetInBytes, int length) {
    assert(gl.COMPONENT_TYPES.contains(componentType));
    if (buffer == null ||
        buffer.lengthInBytes <
            offsetInBytes + gl.componentTypeLength(componentType) * length) {
      return null;
    }
    switch (componentType) {
      case gl.FLOAT:
        return Float32List.view(buffer, offsetInBytes, length);
      default:
        return null;
    }
  }

  static List<int> _typedViewInt(
      int componentType, ByteBuffer buffer, int offsetInBytes, int length) {
    assert(gl.COMPONENT_TYPES.contains(componentType));
    if (buffer == null ||
        buffer.lengthInBytes <
            offsetInBytes + gl.componentTypeLength(componentType) * length) {
      return null;
    }
    switch (componentType) {
      case gl.BYTE:
        return Int8List.view(buffer, offsetInBytes, length);
      case gl.UNSIGNED_BYTE:
        return Uint8List.view(buffer, offsetInBytes, length);
      case gl.SHORT:
        return Int16List.view(buffer, offsetInBytes, length);
      case gl.UNSIGNED_SHORT:
        return Uint16List.view(buffer, offsetInBytes, length);
/*    case gl.INT:
      return Int32List.view(buffer, offsetInBytes, length);*/
      case gl.UNSIGNED_INT:
        return Uint32List.view(buffer, offsetInBytes, length);
      default:
        return null;
    }
  }
}

class _AccessorInt extends Accessor<int> {
  _AccessorInt._(
      int _bufferViewIndex,
      int byteOffset,
      int componentType,
      int count,
      String type,
      bool normalized,
      List<int> max,
      List<int> min,
      AccessorSparse sparse,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super._(_bufferViewIndex, byteOffset, componentType, count, type,
            normalized, max, min, sparse, name, extensions, extras);

  @override
  Iterable<int> getElements({bool normalize = false}) sync* {
    // Ensure required fields to not check for them each time
    if (componentType == -1 || count == -1 || type == null) {
      return;
    }

    final components = this.components;
    final elementsCount = count * components;

    Iterable<int> elements;

    if (_bufferView != null) {
      if (_bufferView.buffer?.data == null) {
        return;
      }

      if (byteStride < elementLength) {
        return;
      }

      if (!Accessor._checkByteOffsetAndLength(
          byteOffset, componentLength, byteLength, _bufferView)) {
        return;
      }

      final view = Accessor._typedViewInt(
          componentType,
          _bufferView.buffer.data.buffer,
          _bufferView.byteOffset + byteOffset,
          byteLength ~/ componentLength);

      if (view == null) {
        return;
      }

      final length = view.length;
      if (_isMatrixWithGaps) {
        // type is either MAT2 or MAT3 here
        // TODO: generalize to non-square matrices
        final skip = byteStride ~/ componentLength - (type == MAT2 ? 8 : 12);
        final rowCount = type == MAT2 ? 2 : 3;
        final columnCount = rowCount;

        elements = () sync* {
          var index = 0;
          var rowIndex = 0;
          var columnIndex = 0;
          while (index < length) {
            yield view[index];
            index++;
            rowIndex++;
            if (rowIndex == rowCount) {
              index += 4 - rowIndex;
              columnIndex++;
              rowIndex = 0;
              if (columnIndex == columnCount) {
                columnIndex = 0;
                index += skip;
              }
            }
          }
        }();
      } else {
        final skip = byteStride ~/ componentLength - components;
        elements = (int length, int components, int skip) sync* {
          var index = 0;
          var componentIndex = 0;
          while (index < length) {
            yield view[index];
            index++;
            componentIndex++;
            if (componentIndex == components) {
              componentIndex = 0;
              index += skip;
            }
          }
        }(length, components, skip);
      }
    } else {
      // Base accessor is filled with zeros
      elements = Iterable<int>.generate(elementsCount, (_) => 0);
    }

    if (sparse != null) {
      if (sparse.values.byteOffset == -1 ||
          sparse.values._bufferView == null ||
          sparse.values._bufferView.byteLength == -1 ||
          sparse.values._bufferView.byteOffset == -1 ||
          sparse.values._bufferView.buffer?.data == null ||
          sparse.indices.componentType == -1 ||
          sparse.indices.byteOffset == -1 ||
          sparse.indices._bufferView == null ||
          sparse.indices._bufferView.byteLength == -1 ||
          sparse.indices._bufferView.byteOffset == -1 ||
          sparse.indices._bufferView.buffer?.data == null) {
        return;
      }

      if (sparse.count > count) {
        return;
      }

      if (!Accessor._checkByteOffsetAndLength(
              sparse.indices.byteOffset,
              gl.componentTypeLength(sparse.indices.componentType),
              gl.componentTypeLength(sparse.indices.componentType) *
                  sparse.count,
              sparse.indices._bufferView) ||
          !Accessor._checkByteOffsetAndLength(
              sparse.values.byteOffset,
              componentLength,
              componentLength *
                  (ACCESSOR_TYPES_LENGTHS[type] ?? 0) *
                  sparse.count,
              sparse.values._bufferView)) {
        return;
      }

      final indices = Accessor._typedViewIndices(
          sparse.indices.componentType,
          sparse.indices._bufferView.buffer.data.buffer,
          sparse.indices._bufferView.byteOffset + sparse.indices.byteOffset,
          sparse.count);

      final values = Accessor._typedViewInt(
          componentType,
          sparse.values._bufferView.buffer.data.buffer,
          sparse.values._bufferView.byteOffset + sparse.values.byteOffset,
          sparse.count * components);

      if (indices == null || values == null) {
        return;
      }

      final baseElements = elements;

      elements = () sync* {
        var index = 0;
        var componentIndex = 0;
        var sparsePosition = 0;
        var sparseIndex = indices[0];
        for (final element in baseElements) {
          if (componentIndex == components) {
            if (index == sparseIndex && sparsePosition != sparse.count - 1) {
              sparsePosition++;
              sparseIndex = indices[sparsePosition];
            }
            index++;
            componentIndex = 0;
          }

          if (index == sparseIndex) {
            yield values[sparsePosition * components + componentIndex];
          } else {
            yield element;
          }
          componentIndex++;
        }
      }();
    }
    yield* elements;
  }

  @override
  Iterable<double> getElementsNormalized() sync* {
    final width = componentLength * 8;
    if (componentType == gl.BYTE ||
        componentType == gl.SHORT ||
        componentType == gl.INT) {
      // Signed
      final denom = 1 / ((1 << width - 1) - 1);
      // TODO check if math.max could be replaced with something better
      yield* getElements().map((value) => math.max(value * denom, -1));
    } else {
      // Unsigned
      final denom = 1 / ((1 << width) - 1);
      yield* getElements().map((value) => value * denom);
    }
  }
}

class _AccessorFloat extends Accessor<double> {
  _AccessorFloat._(
      int _bufferViewIndex,
      int byteOffset,
      int componentType,
      int count,
      String type,
      bool normalized,
      List<double> max,
      List<double> min,
      AccessorSparse sparse,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super._(_bufferViewIndex, byteOffset, componentType, count, type,
            normalized, max, min, sparse, name, extensions, extras);

  @override
  Iterable<double> getElements() sync* {
    // Ensure required fields to not check for them each time
    if (componentType == -1 || count == -1 || type == null) {
      return;
    }

    final components = this.components;
    final elementsCount = count * components;

    Iterable<double> elements;

    if (_bufferView != null) {
      if (_bufferView.buffer?.data == null) {
        return;
      }

      if (byteStride < elementLength) {
        return;
      }

      if (!Accessor._checkByteOffsetAndLength(
          byteOffset, componentLength, byteLength, _bufferView)) {
        return;
      }

      final view = Accessor._typedViewFloat(
          componentType,
          _bufferView.buffer.data.buffer,
          _bufferView.byteOffset + byteOffset,
          byteLength ~/ componentLength);

      if (view == null) {
        return;
      }

      final length = view.length;
      if (_isMatrixWithGaps) {
        // type is either MAT2 or MAT3 here
        // TODO: generalize to non-square matrices
        final skip = byteStride ~/ componentLength - (type == MAT2 ? 8 : 12);
        final rowCount = type == MAT2 ? 2 : 3;
        final columnCount = rowCount;

        elements = () sync* {
          var index = 0;
          var rowIndex = 0;
          var columnIndex = 0;
          while (index < length) {
            yield view[index];
            index++;
            rowIndex++;
            if (rowIndex == rowCount) {
              index += 4 - rowIndex;
              columnIndex++;
              rowIndex = 0;
              if (columnIndex == columnCount) {
                columnIndex = 0;
                index += skip;
              }
            }
          }
        }();
      } else {
        final skip = byteStride ~/ componentLength - components;
        elements = (int length, int components, int skip) sync* {
          var index = 0;
          var componentIndex = 0;
          while (index < length) {
            yield view[index];
            index++;
            componentIndex++;
            if (componentIndex == components) {
              componentIndex = 0;
              index += skip;
            }
          }
        }(length, components, skip);
      }
    } else {
      // Base accessor is filled with zeros
      elements = Iterable<double>.generate(elementsCount, (_) => 0);
    }

    if (sparse != null) {
      if (sparse.values.byteOffset == -1 ||
          sparse.values._bufferView == null ||
          sparse.values._bufferView.byteLength == -1 ||
          sparse.values._bufferView.byteOffset == -1 ||
          sparse.values._bufferView.buffer?.data == null ||
          sparse.indices.componentType == -1 ||
          sparse.indices.byteOffset == -1 ||
          sparse.indices._bufferView == null ||
          sparse.indices._bufferView.byteLength == -1 ||
          sparse.indices._bufferView.byteOffset == -1 ||
          sparse.indices._bufferView.buffer?.data == null) {
        return;
      }

      if (sparse.count > count) {
        return;
      }

      if (!Accessor._checkByteOffsetAndLength(
              sparse.indices.byteOffset,
              gl.componentTypeLength(sparse.indices.componentType),
              gl.componentTypeLength(sparse.indices.componentType) *
                  sparse.count,
              sparse.indices._bufferView) ||
          !Accessor._checkByteOffsetAndLength(
              sparse.values.byteOffset,
              componentLength,
              componentLength *
                  (ACCESSOR_TYPES_LENGTHS[type] ?? 0) *
                  sparse.count,
              sparse.values._bufferView)) {
        return;
      }

      final indices = Accessor._typedViewIndices(
          sparse.indices.componentType,
          sparse.indices._bufferView.buffer.data.buffer,
          sparse.indices._bufferView.byteOffset + sparse.indices.byteOffset,
          sparse.count);

      final values = Accessor._typedViewFloat(
          componentType,
          sparse.values._bufferView.buffer.data.buffer,
          sparse.values._bufferView.byteOffset + sparse.values.byteOffset,
          sparse.count * components);

      if (indices == null || values == null) {
        return;
      }

      final baseElements = elements;

      elements = () sync* {
        var index = 0;
        var componentIndex = 0;
        var sparsePosition = 0;
        var sparseIndex = indices[0];
        for (final element in baseElements) {
          if (componentIndex == components) {
            if (index == sparseIndex && sparsePosition != sparse.count - 1) {
              sparsePosition++;
              sparseIndex = indices[sparsePosition];
            }
            index++;
            componentIndex = 0;
          }

          if (index == sparseIndex) {
            yield values[sparsePosition * components + componentIndex];
          } else {
            yield element;
          }
          componentIndex++;
        }
      }();
    }
    yield* elements;
  }

  @override
  Iterable<double> getElementsNormalized() => getElements();
}

class AccessorSparse extends GltfProperty {
  final int count;
  final AccessorSparseIndices indices;
  final AccessorSparseValues values;

  AccessorSparse._(this.count, this.indices, this.values,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  List<int> get indicesTypedView {
    if (indices._bufferView?.buffer?.data == null) {
      return null;
    }

    return Accessor._typedViewIndices(
        indices.componentType,
        indices._bufferView.buffer.data.buffer,
        indices._bufferView.byteOffset + indices.byteOffset,
        count);
  }

  static AccessorSparse fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ACCESSOR_SPARSE_MEMBERS, context);
    }

    final count = getUint(map, COUNT, context, min: 1, req: true);
    final indices = getObjectFromInnerMap<AccessorSparseIndices>(
        map, INDICES, context, AccessorSparseIndices.fromMap,
        req: true);
    final values = getObjectFromInnerMap<AccessorSparseValues>(
        map, VALUES, context, AccessorSparseValues.fromMap,
        req: true);

    if (count == -1 || indices == null || values == null) {
      return null;
    }

    return AccessorSparse._(count, indices, values,
        getExtensions(map, AccessorSparse, context), getExtras(map, context));
  }
}

class AccessorSparseIndices extends GltfProperty {
  final int _bufferViewIndex;
  final int byteOffset;
  final int componentType;

  BufferView _bufferView;

  AccessorSparseIndices._(this._bufferViewIndex, this.byteOffset,
      this.componentType, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  BufferView get bufferView => _bufferView;

  static AccessorSparseIndices fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ACCESSOR_SPARSE_INDICES_MEMBERS, context);
    }

    return AccessorSparseIndices._(
        getIndex(map, BUFFER_VIEW, context, req: true),
        getUint(map, BYTE_OFFSET, context, def: 0),
        getUint(map, COMPONENT_TYPE, context,
            req: true, list: gl.ELEMENT_ARRAY_TYPES),
        getExtensions(map, AccessorSparseIndices, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    _bufferView = gltf.bufferViews[_bufferViewIndex];
  }
}

class AccessorSparseValues extends GltfProperty {
  final int _bufferViewIndex;
  final int byteOffset;

  BufferView _bufferView;

  AccessorSparseValues._(this._bufferViewIndex, this.byteOffset,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  BufferView get bufferView => _bufferView;

  static AccessorSparseValues fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ACCESSOR_SPARSE_VALUES_MEMBERS, context);
    }

    return AccessorSparseValues._(
        getIndex(map, BUFFER_VIEW, context, req: true),
        getUint(map, BYTE_OFFSET, context, def: 0),
        getExtensions(map, AccessorSparseValues, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    _bufferView = gltf.bufferViews[_bufferViewIndex];
  }
}

class InvalidFloatChecker extends ElementChecker<double> {
  InvalidFloatChecker(this.path);

  @override
  final String path;

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    if (value.isInfinite || value.isNaN) {
      context.addIssue(DataError.accessorInvalidFloat,
          name: path, args: [index, value]);
      return false;
    }
    return true;
  }
}

class MinFloatChecker extends ElementChecker<double> {
  final List<int> _invalidMinCount;
  final List<double> _computedMin;
  final List<double> _providedMin;

  @override
  final String path;

  MinFloatChecker(this.path, List<double> min)
      : _invalidMinCount = List<int>.filled(min.length, 0),
        _computedMin = List<double>(min.length),
        _providedMin = min.toList(growable: false);

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    assert(componentIndex < _invalidMinCount.length);
    if (index == componentIndex || _computedMin[componentIndex] > value) {
      _computedMin[componentIndex] = value;
    }

    if (value < _providedMin[componentIndex]) {
      ++_invalidMinCount[componentIndex];
    }

    return true;
  }

  @override
  bool done(Context context) {
    for (var c = 0; c < _computedMin.length; ++c) {
      if (_providedMin[c] != _computedMin[c]) {
        context.addIssue(DataError.accessorMinMismatch,
            name: '$path/$MIN/$c', args: [_providedMin[c], _computedMin[c]]);

        if (_invalidMinCount[c] > 0) {
          context.addIssue(DataError.accessorElementOutOfMinBound,
              name: '$path/$MIN/$c',
              args: [_invalidMinCount[c], _providedMin[c]]);
        }
      }
    }

    return true;
  }
}

class MaxFloatChecker extends ElementChecker<double> {
  final List<int> _invalidMaxCount;
  final List<double> _computedMax;
  final List<double> _providedMax;

  @override
  final String path;

  MaxFloatChecker(this.path, List<double> max)
      : _invalidMaxCount = List<int>.filled(max.length, 0),
        _computedMax = List<double>(max.length),
        _providedMax = max.toList(growable: false);

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    assert(componentIndex < _invalidMaxCount.length);
    if (index == componentIndex || _computedMax[componentIndex] < value) {
      _computedMax[componentIndex] = value;
    }

    if (value > _providedMax[componentIndex]) {
      ++_invalidMaxCount[componentIndex];
    }

    return true;
  }

  @override
  bool done(Context context) {
    for (var c = 0; c < _computedMax.length; ++c) {
      if (_providedMax[c] != _computedMax[c]) {
        context.addIssue(DataError.accessorMaxMismatch,
            name: '$path/$MAX/$c', args: [_providedMax[c], _computedMax[c]]);

        if (_invalidMaxCount[c] > 0) {
          context.addIssue(DataError.accessorElementOutOfMaxBound,
              name: '$path/$MAX/$c',
              args: [_invalidMaxCount[c], _providedMax[c]]);
        }
      }
    }

    return true;
  }
}

class MinIntegerChecker extends ElementChecker<int> {
  final List<int> _invalidMinCount;
  final List<int> _computedMin;
  final List<int> _providedMin;

  @override
  final String path;

  MinIntegerChecker(this.path, List<int> min)
      : _invalidMinCount = List<int>.filled(min.length, 0),
        _computedMin = List<int>(min.length),
        _providedMin = min.toList(growable: false);

  @override
  bool check(Context context, int index, int componentIndex, int value) {
    assert(componentIndex < _invalidMinCount.length);
    if (index == componentIndex || _computedMin[componentIndex] > value) {
      _computedMin[componentIndex] = value;
    }

    if (value < _providedMin[componentIndex]) {
      ++_invalidMinCount[componentIndex];
    }

    return true;
  }

  @override
  bool done(Context context) {
    for (var c = 0; c < _computedMin.length; ++c) {
      if (_providedMin[c] != _computedMin[c]) {
        context.addIssue(DataError.accessorMinMismatch,
            name: '$path/$MIN/$c', args: [_providedMin[c], _computedMin[c]]);

        if (_invalidMinCount[c] > 0) {
          context.addIssue(DataError.accessorElementOutOfMinBound,
              name: '$path/$MIN/$c',
              args: [_invalidMinCount[c], _providedMin[c]]);
        }
      }
    }

    return true;
  }
}

class MaxIntegerChecker extends ElementChecker<int> {
  final List<int> _invalidMaxCount;
  final List<int> _computedMax;
  final List<int> _providedMax;

  @override
  final String path;

  MaxIntegerChecker(this.path, List<int> max)
      : _invalidMaxCount = List<int>.filled(max.length, 0),
        _computedMax = List<int>(max.length),
        _providedMax = max.toList(growable: false);

  @override
  bool check(Context context, int index, int componentIndex, int value) {
    assert(componentIndex < _invalidMaxCount.length);
    if (index == componentIndex || _computedMax[componentIndex] < value) {
      _computedMax[componentIndex] = value;
    }

    if (value > _providedMax[componentIndex]) {
      ++_invalidMaxCount[componentIndex];
    }

    return true;
  }

  @override
  bool done(Context context) {
    for (var c = 0; c < _computedMax.length; ++c) {
      if (_providedMax[c] != _computedMax[c]) {
        context.addIssue(DataError.accessorMaxMismatch,
            name: '$path/$MAX/$c', args: [_providedMax[c], _computedMax[c]]);

        if (_invalidMaxCount[c] > 0) {
          context.addIssue(DataError.accessorElementOutOfMaxBound,
              name: '$path/$MAX/$c',
              args: [_invalidMaxCount[c], _providedMax[c]]);
        }
      }
    }

    return true;
  }
}
