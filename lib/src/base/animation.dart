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

library gltf.base.animation;

import 'dart:math';

import 'package:gltf/src/base/gltf_property.dart';

class Animation extends GltfChildOfRootProperty {
  final SafeList<AnimationChannel> channels;
  final SafeList<AnimationSampler> samplers;

  Animation._(this.channels, this.samplers, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  static Animation fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ANIMATION_MEMBERS, context);
    }

    SafeList<AnimationChannel> channels;
    final channelMaps = getMapList(map, CHANNELS, context);
    if (channelMaps != null) {
      channels = SafeList<AnimationChannel>(channelMaps.length, CHANNELS);
      context.path.add(CHANNELS);
      for (var i = 0; i < channelMaps.length; i++) {
        final channelMap = channelMaps[i];
        context.path.add(i.toString());
        channels[i] = AnimationChannel.fromMap(channelMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    }

    SafeList<AnimationSampler> samplers;
    final samplerMaps = getMapList(map, SAMPLERS, context);
    if (samplerMaps != null) {
      samplers = SafeList<AnimationSampler>(samplerMaps.length, SAMPLERS);
      context.path.add(SAMPLERS);
      for (var i = 0; i < samplerMaps.length; i++) {
        final samplerMap = samplerMaps[i];
        context.path.add(i.toString());
        samplers[i] = AnimationSampler.fromMap(samplerMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    }

    return Animation._(channels, samplers, getName(map, context),
        getExtensions(map, Animation, context), getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (samplers == null || channels == null) {
      return;
    }

    context.path.add(SAMPLERS);
    samplers.forEachWithIndices((i, sampler) {
      context.path.add(i.toString());

      sampler
        .._input = gltf.accessors[sampler._inputIndex]
        .._output = gltf.accessors[sampler._outputIndex];

      if (sampler._inputIndex != -1) {
        if (sampler._input == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: INPUT, args: [sampler._inputIndex]);
        } else {
          sampler._input.setUsage(AccessorUsage.AnimationInput, INPUT, context);

          final inputBufferView = sampler._input.bufferView;
          if (inputBufferView != null) {
            inputBufferView.setUsage(BufferViewUsage.Other, INPUT, context);
            if (context.validate && inputBufferView.byteStride != -1) {
              context.addIssue(LinkError.animationSamplerAccessorWithByteStride,
                  name: INPUT);
            }
          }

          if (context.validate) {
            context.path.add(INPUT);
            final inputFormat = AccessorFormat.fromAccessor(sampler._input);
            if (inputFormat != ANIMATION_SAMPLER_INPUT_FORMAT) {
              context.addIssue(
                  LinkError.animationSamplerInputAccessorInvalidFormat,
                  args: [
                    inputFormat,
                    [ANIMATION_SAMPLER_INPUT_FORMAT]
                  ]);
            } else {
              context.addElementChecker(sampler._input,
                  AnimationInputChecker(context.getPointerString()));
            }

            if (sampler._input.min == null || sampler._input.max == null) {
              context.addIssue(
                  LinkError.animationSamplerInputAccessorWithoutBounds);
            }

            if (sampler.interpolation == CUBICSPLINE &&
                sampler._input.count < 2) {
              context.addIssue(
                  LinkError.animationSamplerInputAccessorTooFewElements,
                  args: [CUBICSPLINE, 2, sampler._input.count]);
            }
            context.path.removeLast();
          }
        }
      }

      if (sampler._outputIndex != -1) {
        if (sampler._output == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: OUTPUT, args: [sampler._outputIndex]);
        } else {
          sampler._output
              .setUsage(AccessorUsage.AnimationOutput, OUTPUT, context);
          final outputBufferView = sampler._output.bufferView;
          if (outputBufferView != null) {
            outputBufferView.setUsage(BufferViewUsage.Other, OUTPUT, context);
            if (context.validate && outputBufferView.byteStride != -1) {
              context.addIssue(LinkError.animationSamplerAccessorWithByteStride,
                  name: OUTPUT);
            }
          }

          sampler._output.bufferView
              ?.setUsage(BufferViewUsage.Other, OUTPUT, context);
          sampler._output
              .trySetInterpolation(cubic: CUBICSPLINE == sampler.interpolation);
        }
      }

      context.path.removeLast();
    });

    context.path
      ..removeLast()
      ..add(CHANNELS);

    channels.forEachWithIndices((i, channel) {
      context.path.add(i.toString());

      channel._sampler = samplers[channel._samplerIndex];

      if (channel.target != null) {
        channel.target._node = gltf.nodes[channel.target._nodeIndex];
        if (context.validate && channel.target._nodeIndex != -1) {
          context.path.add(TARGET);
          if (channel.target._node == null) {
            context.addIssue(LinkError.unresolvedReference,
                name: NODE, args: [channel.target._nodeIndex]);
          } else {
            channel.target._node.markAsUsed();
            switch (channel.target.path) {
              case TRANSLATION:
              case ROTATION:
              case SCALE:
                if (channel.target._node.matrix != null) {
                  context.addIssue(LinkError.animationChannelTargetNodeMatrix);
                }

                if (channel.target._node.skin != null) {
                  context.addIssue(SemanticError.animationChannelTargetNodeSkin,
                      name: PATH);
                }
                break;
              case WEIGHTS:
                if (channel.target._node?.mesh?.primitives?.first?.targets ==
                    null) {
                  context.addIssue(
                      LinkError.animationChannelTargetNodeWeightsNoMorphs);
                }
                break;
            }
          }
          context.path.removeLast();
        }
      }

      if (channel._samplerIndex != -1) {
        if (channel._sampler == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: SAMPLER, args: [channel._samplerIndex]);
        } else {
          channel._sampler.markAsUsed();
          if (channel.target != null && channel._sampler._output != null) {
            if (channel.target.path == ROTATION) {
              if (context.validate) {
                final accessor = channel._sampler._output;
                // TODO warn when there're more than two equal
                // consequential animation frames

                // TODO warn when interpolation may produce zero-length
                // quaternions

                // quaternion animation output
                if (accessor.components == 4) {
                  context.path.add(SAMPLER);
                  context.addElementChecker(
                      accessor,
                      QuaternionFloatChecker(context.getPointerString(),
                          accessor.isFloat ? null : accessor.normalizeValue,
                          hasTangents:
                              CUBICSPLINE == channel._sampler.interpolation));
                  context.path.removeLast();
                }
              }
              channel._sampler._output.setUnit();
            }

            if (context.validate) {
              final outputFormat =
                  AccessorFormat.fromAccessor(channel._sampler._output);
              final validFormats =
                  ANIMATION_SAMPLER_OUTPUT_FORMATS[channel.target.path];

              if (validFormats?.contains(outputFormat) == false) {
                context.addIssue(
                    LinkError.animationSamplerOutputAccessorInvalidFormat,
                    name: SAMPLER,
                    args: [outputFormat, validFormats, channel.target.path]);
              }

              if (channel._sampler._input != null &&
                  channel._sampler._input.count != -1 &&
                  channel._sampler._output.count != -1 &&
                  channel._sampler.interpolation != null) {
                var expectedCount = channel._sampler._input.count;

                if (channel._sampler.interpolation == CUBICSPLINE) {
                  expectedCount *= 3;
                }

                if (channel.target.path == WEIGHTS) {
                  final targetsCount = channel
                      .target._node?.mesh?.primitives?.first?.targets?.length;
                  expectedCount *= targetsCount ?? 0;
                }

                if (expectedCount != 0 &&
                    expectedCount != channel._sampler._output.count) {
                  context.addIssue(
                      LinkError.animationSamplerOutputAccessorInvalidCount,
                      name: SAMPLER,
                      args: [expectedCount, channel._sampler._output.count]);
                }
              }
            }
          }
        }

        for (var j = i + 1; j < channels.length; j++) {
          if (channel.target != null &&
              channel.target.isSameAs(channels[j].target)) {
            context.addIssue(LinkError.animationDuplicateTargets,
                name: TARGET, args: [j]);
          }
        }
        context.path.removeLast();
      }
    });
    context.path.removeLast();

    if (context.validate) {
      context.path.add(SAMPLERS);
      for (var i = 0; i < samplers.length; ++i) {
        if (!samplers[i].isUsed) {
          context.addIssue(LinkError.unusedObject, index: i);
        }
      }
      context.path.removeLast();
    }
  }
}

class AnimationChannel extends GltfProperty {
  final int _samplerIndex;
  final AnimationChannelTarget target;

  AnimationSampler _sampler;

  AnimationChannel._(this._samplerIndex, this.target,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  AnimationSampler get sampler => _sampler;

  static AnimationChannel fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ANIMATION_CHANNEL_MEMBERS, context);
    }

    return AnimationChannel._(
        getIndex(map, SAMPLER, context),
        getObjectFromInnerMap<AnimationChannelTarget>(
            map, TARGET, context, AnimationChannelTarget.fromMap,
            req: true),
        getExtensions(map, AnimationChannel, context),
        getExtras(map, context));
  }
}

class AnimationChannelTarget extends GltfProperty {
  final int _nodeIndex;
  final String path;

  Node _node;

  AnimationChannelTarget._(
      this._nodeIndex, this.path, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  Node get node => _node;

  static AnimationChannelTarget fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ANIMATION_CHANNEL_TARGET_MEMBERS, context);
    }

    return AnimationChannelTarget._(
        getIndex(map, NODE, context, req: false),
        getString(map, PATH, context,
            req: true, list: ANIMATION_CHANNEL_TARGET_PATHS),
        getExtensions(map, AnimationChannelTarget, context),
        getExtras(map, context));
  }

  bool isSameAs(AnimationChannelTarget other) =>
      other != null &&
      _nodeIndex != -1 &&
      _nodeIndex == other._nodeIndex &&
      path == other.path;
}

class AnimationSampler extends GltfProperty {
  final int _inputIndex;
  final String interpolation;
  final int _outputIndex;

  Accessor _input;
  Accessor _output;

  AnimationSampler._(this._inputIndex, this.interpolation, this._outputIndex,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  Accessor get input => _input;
  Accessor get output => _output;

  static AnimationSampler fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, ANIMATION_SAMPLER_MEMBERS, context);
    }

    return AnimationSampler._(
        getIndex(map, INPUT, context),
        getString(map, INTERPOLATION, context,
            list: ANIMATION_SAMPLER_INTERPOLATIONS, def: LINEAR),
        getIndex(map, OUTPUT, context),
        getExtensions(map, AnimationSampler, context),
        getExtras(map, context));
  }
}

class AnimationInputChecker extends ElementChecker<double> {
  AnimationInputChecker(this.path);

  double _lastValue = 0;

  @override
  final String path;

  @override
  bool check(Context context, int index, int componentIndex, double value) {
    assert(componentIndex == 0);
    if (value < 0.0) {
      context.addIssue(DataError.accessorAnimationInputNegative,
          name: path, args: [index, value]);
    } else {
      if (index != 0 && value <= _lastValue) {
        context.addIssue(DataError.accessorAnimationInputNonIncreasing,
            name: path, args: [index, value, _lastValue]);
      }
      _lastValue = value;
    }

    return true;
  }
}

class QuaternionFloatChecker<T extends num> extends ElementChecker<T> {
  final bool hasTangents;
  final double Function(num value) normalizeValue;

  @override
  final String path;

  QuaternionFloatChecker(this.path, this.normalizeValue,
      {this.hasTangents = false});

  // used only for quaternions with cubic spline tangents
  // 0-3  - in tangent
  // 4-7  - actual value
  // 8-11 - out tangent
  int _fullComponentIndex = 0;

  double _sum = 0;

  @override
  bool check(Context context, int index, int componentIndex, T value) {
    assert(componentIndex < 4);

    if (!hasTangents || 4 == 4 & _fullComponentIndex) {
      final v = normalizeValue != null ? normalizeValue(value) : value;
      _sum += v * v;
      if (3 == componentIndex) {
        if ((sqrt(_sum) - 1.0).abs() > unitLengthThresholdVec4) {
          context.addIssue(
              DataError.accessorAnimationSamplerOutputNonNormalizedQuaternion,
              name: path,
              args: [index - 3, index, sqrt(_sum)]);
        }
        _sum = 0;
      }
    }

    if (++_fullComponentIndex == 12) {
      _fullComponentIndex = 0;
    }

    return true;
  }
}
