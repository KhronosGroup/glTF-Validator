/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
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

library gltf.base.accessor;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

class Accessor extends GltfChildOfRootProperty {
  final int _bufferViewIndex;
  final int byteOffset;
  final int componentType;
  final int count;
  final String type;
  final bool normalized;
  final List<num> max;
  final List<num> min;
  final AccessorSparse sparse;

  final int componentLength;

  BufferView _bufferView;
  int _byteStride = 0;
  bool _isUnit = false;
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

  bool get isUnit => _isUnit;
  bool get isXyzSign => _isXyzSign;
  bool get containsCubicSpline => _containsCubicSpline == true;

  AccessorUsage get usage => _usage;

  @override
  String toString([_]) => super.toString({
        BUFFER_VIEW: _bufferViewIndex,
        BYTE_OFFSET: byteOffset,
        COMPONENT_TYPE: componentType,
        COUNT: count,
        TYPE: type,
        NORMALIZED: normalized,
        MAX: max,
        MIN: min,
        SPARSE: sparse
      });

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
      final length = ACCESSOR_TYPES_LENGTHS[type] ?? -1;
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

    return Accessor._(
        bufferViewIndex,
        byteOffset,
        componentType,
        count,
        type,
        normalized,
        max,
        min,
        sparse,
        getName(map, context),
        getExtensions(map, Accessor, context),
        getExtras(map, context));
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
                        ACCESSOR_TYPES_LENGTHS[type] *
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

  Iterable<num> getElements({bool normalize = false}) sync* {
    // Ensure required fields to not check for them each time
    if (componentType == -1 || count == -1 || type == null) {
      return;
    }

    final components = this.components;
    final elementsCount = count * components;

    Iterable<num> elements;

    if (_bufferView != null) {
      if (_bufferView.buffer?.data == null) {
        return;
      }

      if (byteStride < elementLength) {
        return;
      }

      if (!_checkByteOffsetAndLength(
          byteOffset, componentLength, byteLength, _bufferView)) {
        return;
      }

      final view = _typedView(componentType, _bufferView.buffer.data.buffer,
          _bufferView.byteOffset + byteOffset, byteLength ~/ componentLength);

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
      elements = Iterable<num>.generate(elementsCount, (_) => 0);
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

      if (!_checkByteOffsetAndLength(
              sparse.indices.byteOffset,
              gl.componentTypeLength(sparse.indices.componentType),
              gl.componentTypeLength(sparse.indices.componentType) *
                  sparse.count,
              sparse.indices._bufferView) ||
          !_checkByteOffsetAndLength(
              sparse.values.byteOffset,
              componentLength,
              componentLength * ACCESSOR_TYPES_LENGTHS[type] * sparse.count,
              sparse.values._bufferView)) {
        return;
      }

      final indices = _typedView(
          sparse.indices.componentType,
          sparse.indices._bufferView.buffer.data.buffer,
          sparse.indices._bufferView.byteOffset + sparse.indices.byteOffset,
          sparse.count);

      final values = _typedView(
          componentType,
          sparse.values._bufferView.buffer.data.buffer,
          sparse.values._bufferView.byteOffset + sparse.values.byteOffset,
          sparse.count * components);

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

    if (normalized && normalize) {
      final width = componentLength * 8;
      if (componentType == gl.BYTE ||
          componentType == gl.SHORT ||
          componentType == gl.INT) {
        // Signed
        final denom = 1 / ((1 << width - 1) - 1);
        yield* elements.map((value) => math.max(value * denom, -1.0));
      } else {
        // Unsigned
        final denom = 1 / ((1 << width) - 1);
        yield* elements.map((value) => value * denom);
      }
    } else {
      // Non-normalized
      yield* elements;
    }
  }

  double normalizeValue(num value) {
    if (!normalized) {
      return value.toDouble();
    }

    final width = componentLength * 8;
    if (componentType == gl.BYTE ||
        componentType == gl.SHORT ||
        componentType == gl.INT) {
      // Signed
      final divider = (1 << width - 1) - 1;
      return math.max<double>(value / divider, -1.0);
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
    if (bufferView.byteOffset == null) {
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
    if (bufferView.byteLength == -1) {
      return false;
    }

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
        context?.addIssue(LinkError.accessorTooLong, args: [
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
}

class AccessorSparse extends GltfProperty {
  final int count;
  final AccessorSparseIndices indices;
  final AccessorSparseValues values;

  AccessorSparse._(this.count, this.indices, this.values,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  @override
  String toString([_]) =>
      super.toString({COUNT: count, INDICES: indices, VALUES: values});

  List<int> get indicesTypedView {
    if (indices._bufferView?.buffer?.data == null) {
      return null;
    }

    try {
      /// Due to [indices.componentType],
      /// runtime return type is always [List<int>].

      // ignore: return_of_invalid_type
      return _typedView(
          indices.componentType,
          indices._bufferView.buffer.data.buffer,
          indices._bufferView.byteOffset + indices.byteOffset,
          count);
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {
      return null;
    }
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

  @override
  String toString([_]) => super.toString({
        BUFFER_VIEW: _bufferViewIndex,
        BYTE_OFFSET: byteOffset,
        COMPONENT_TYPE: componentType,
      });

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

  @override
  String toString([_]) =>
      super.toString({BUFFER_VIEW: _bufferViewIndex, BYTE_OFFSET: byteOffset});

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

List<num> _typedView(
    int componentType, ByteBuffer buffer, int offsetInBytes, int length) {
  assert(buffer != null);
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
    case gl.FLOAT:
      return Float32List.view(buffer, offsetInBytes, length);
    default:
      return null;
  }
}
