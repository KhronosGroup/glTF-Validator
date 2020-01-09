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

library gltf.data_access.validate_accessors_data;

import 'package:meta/meta.dart';

import 'package:gltf/gltf.dart';
import 'package:gltf/src/base/gltf_property.dart';

Accessor<T> _guardAccessor<T extends num>(Accessor<T> accessor) {
  if (accessor == null) {
    return null;
  }

  // Skip broken accessors
  if (accessor.type == null ||
      accessor.componentType == -1 ||
      accessor.count == -1) {
    return null;
  }

  // Skip empty accessors
  if (accessor.bufferView == null && accessor.sparse == null) {
    return null;
  }

  return accessor;
}

void validateAccessorsData(Gltf gltf, Context context) {
  // Check sparse accessors data
  gltf.accessors.forEachWithIndices((i, accessor) {
    if (_guardAccessor(accessor)?.sparse != null) {
      context.path
        ..clear()
        ..add(ACCESSORS)
        ..add(i.toString());

      // Check sparse indices
      final view = accessor.sparse.indicesTypedView;
      if (view != null) {
        var index = 0;
        var lastValue = -1;
        for (final value in view) {
          if (lastValue != -1 && value <= lastValue) {
            context.addIssue(DataError.accessorSparseIndicesNonIncreasing,
                name: SPARSE, args: [index, value, lastValue]);
          }
          if (value >= accessor.count) {
            context.addIssue(DataError.accessorSparseIndexOob,
                name: SPARSE, args: [index, value, accessor.count]);
          }
          lastValue = value;
          ++index;
        }
      }
    }
  });

  // Perform scheduled domain-specific element checks
  _processAccessorElements(context);

  // Validate skinning influences.
  // This requires a pre-pass to get effective joints limits and subsequent
  // complex simultaneous iteration over several accessors.
  final influencesIterators = <Iterator<num>>[];
  final influencesCheckers = <InfluencesChecker>[];

  context.path
    ..clear()
    ..add(MESHES);

  for (var meshIndex = 0; meshIndex < gltf.meshes.length; meshIndex++) {
    final mesh = gltf.meshes[meshIndex];

    // Broken mesh or mesh.primitives objects
    if (mesh?.primitives == null) {
      continue;
    }

    // Skip meshes without joints data
    if (mesh.primitives.every((primitive) => primitive.jointsCount == 0)) {
      continue;
    }

    // Find the minimum number of skin.joints that is used with this mesh
    var maxJoints = -1;
    var limitingSkinIndex = -1;

    for (final node in gltf.nodes) {
      if (node.mesh == mesh && node.skin?.joints != null) {
        final jointsCount = node.skin.joints.length;
        if (maxJoints == -1 || jointsCount < maxJoints) {
          maxJoints = jointsCount;
          limitingSkinIndex = gltf.skins.indexOf(node.skin);
        }
      }
    }

    // skip the mesh if all skins are broken
    if (maxJoints < 1) {
      continue;
    }

    context.path..add(meshIndex.toString())..add(PRIMITIVES);

    mesh.primitives.forEachWithIndices((primitiveIndex, primitive) {
      assert(maxJoints > 0 && limitingSkinIndex != -1);
      assert(primitive.jointsCount == primitive.weightsCount);

      var skipValidation = false;
      final vertexCount = primitive.vertexCount;

      // joints/weights pair covers a subset of primitive influences
      final jointsIterators = List<Iterator<int>>(primitive.jointsCount);
      final weightsIterators = List<Iterator<double>>(primitive.jointsCount);
      for (var i = 0; i < primitive.jointsCount; i++) {
        final jointsAccessor =
            _guardAccessor(primitive.attributes['${JOINTS_}_$i']);
        final weightsAccessor =
            _guardAccessor(primitive.attributes['${WEIGHTS_}_$i']);

        // skip when accessors are broken or have wrong count
        if (jointsAccessor?.count != vertexCount ||
            weightsAccessor?.count != vertexCount) {
          skipValidation = true;
          break;
        }

        jointsIterators[i] =
            (jointsAccessor as Accessor<int>).getElements().iterator;
        weightsIterators[i] = weightsAccessor.getElementsNormalized().iterator;
      }

      // skip primitive
      if (skipValidation) {
        return;
      }

      context.path..add(primitiveIndex.toString())..add(ATTRIBUTES);

      // add iterators from the current primitive to the global list
      influencesIterators..addAll(jointsIterators)..addAll(weightsIterators);

      // add a checker from the current primitive to the global list
      influencesCheckers.add(InfluencesChecker(context.getPointerString(),
          jointsIterators: jointsIterators,
          weightsIterators: weightsIterators,
          maxJointIndex: maxJoints - 1,
          limitingSkinIndex: limitingSkinIndex));

      context.path..removeLast()..removeLast();
    });
    context.path..removeLast()..removeLast();
  }
  context.path.removeLast();

  assert(context.path.isEmpty);

  // Skip the final loops
  if (influencesIterators.isEmpty) {
    return;
  }

  while (_stepInfluencesIterators(influencesIterators)) {
    for (final checker in influencesCheckers) {
      if (!checker.done) {
        checker.checkNext(context);
      }
    }
  }
}

bool _stepInfluencesIterators(List<Iterator<num>> influencesIterators) {
  // step all iterators
  for (final iterator in influencesIterators) {
    iterator.moveNext();
  }

  // remove finished
  influencesIterators.removeWhere((iterator) => iterator.current == null);

  return influencesIterators.isNotEmpty;
}

void _processAccessorElements(Context context) {
  for (final entry in context.accessorElementCheckers.entries) {
    final accessor = _guardAccessor(entry.key);
    if (accessor == null) {
      continue;
    }

    final components = accessor.components;
    final elementCheckers = entry.value;

    context.path.clear();

    var index = 0;
    var componentIndex = 0;
    var notEmpty = false;

    for (final value in accessor.getElements()) {
      for (var t = 0; t < elementCheckers.length; t++) {
        if (!elementCheckers[t].check(context, index, componentIndex, value)) {
          continue;
        }
      }

      if (++componentIndex == components) {
        componentIndex = 0;
      }
      ++index;
      notEmpty = true;
    }

    if (notEmpty) {
      for (var t = 0; t < elementCheckers.length; t++) {
        elementCheckers[t].done(context);
      }
    }
  }
}

class InfluencesChecker {
  final List<Iterator<int>> jointsIterators;
  final List<Iterator<double>> weightsIterators;
  final int maxJointIndex;
  final int limitingSkinIndex;
  final String path;

  int _index = 0;
  int _componentIndex = 0;

  bool get done => _done;
  bool _done = false;

  double _sum = 0;
  double _threshold = 0;
  final Set<int> _currentIndices = <int>{};

  InfluencesChecker(this.path,
      {@required this.jointsIterators,
      @required this.weightsIterators,
      @required this.maxJointIndex,
      @required this.limitingSkinIndex})
      : assert(jointsIterators.length == weightsIterators.length),
        assert(maxJointIndex >= 0),
        assert(limitingSkinIndex >= 0);

  void checkNext(Context context) {
    assert(!_done);

    for (var i = 0; i < jointsIterators.length; ++i) {
      final joint = jointsIterators[i].current;

      if (joint == null) {
        // all iterators for the same primitive must yield the same
        // amount of elements
        _done = true;
        return;
      }

      if (joint > maxJointIndex) {
        context.addIssue(DataError.accessorJointsIndexOob,
            name: '$path/${JOINTS_}_$i',
            args: [
              _index,
              _componentIndex,
              joint,
              maxJointIndex,
              limitingSkinIndex
            ]);
        continue;
      }

      final weight = weightsIterators[i].current;
      assert(weight != null);

      if (weight != 0) {
        var unique = true;
        if (!_currentIndices.add(joint)) {
          context.addIssue(DataError.accessorJointsIndexDuplicate,
              name: '$path/${JOINTS_}_$i',
              args: [_index, _componentIndex, joint]);
          unique = false;
        }

        if (weight < 0) {
          context.addIssue(DataError.accessorWeightsNegative,
              name: '$path/${WEIGHTS_}_$i',
              args: [_index, _componentIndex, weight]);
        } else if (unique) {
          // keep sum within float32 precision
          _sum = doubleToSingle(_sum + weight);
          _threshold += 2e-7;
        }
      } else if (joint != 0) {
        context.addIssue(DataError.accessorJointsUsedZeroWeight,
            name: '$path/${JOINTS_}_$i',
            args: [_index, _componentIndex, joint]);
      }
    }

    if (4 == ++_componentIndex) {
      if ((_sum - 1.0).abs() > _threshold) {
        for (var i = 0; i < jointsIterators.length; i++) {
          context.addIssue(DataError.accessorWeightsNonNormalized,
              name: '$path/${WEIGHTS_}_$i', args: [_index - 3, _index, _sum]);
        }
      }
      _currentIndices.clear();
      _componentIndex = 0;
      _threshold = 0;
      _sum = 0;
    }
    _index++;
  }
}
