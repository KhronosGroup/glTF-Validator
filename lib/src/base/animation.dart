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

library gltf.core.animation;

import 'gltf_property.dart';
import 'package:gltf/src/gl.dart' as gl;

class Animation extends GltfChildOfRootProperty implements Linkable {
  final List<AnimationChannel> channels;
  final Map<String, String> _parametersIds;
  final Map<String, AnimationSampler> samplers;

  final Map<String, Accessor> parameters = <String, Accessor>{};

  Animation._(this.channels, this._parametersIds, this.samplers, String name,
      Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  String toString([_]) => super.toString(
      {PARAMETERS: _parametersIds, CHANNELS: channels, SAMPLERS: samplers});

  static Animation fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ANIMATION_MEMBERS, context);

    context.path.add(CHANNELS);
    int i = 0;
    final channels = getMapList(map, CHANNELS, context)
        ?.map((Map<String, Object> channelMap) {
      context.path.add((i++).toString());
      final channel = new AnimationChannel.fromMap(channelMap, context);
      context.path.removeLast();
      return channel;
    })?.toList();
    context.path.removeLast();

    final samplers = <String, AnimationSampler>{};
    final samplerMaps = getMap(map, SAMPLERS, context);
    if (samplerMaps.isNotEmpty) {
      context.path.add(SAMPLERS);
      for (final id in samplerMaps.keys) {
        final samplerMap = getMap(samplerMaps, id, context, req: true);
        if (samplerMap == null) continue;
        context.path.add(id);
        samplers[id] = new AnimationSampler.fromMap(samplerMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    }

    return new Animation._(
        channels,
        getMap(map, PARAMETERS, context),
        samplers,
        getName(map, context),
        getExtensions(map, Animation, context),
        getExtras(map));
  }

  void link(Gltf gltf, Context context) {
    if (_parametersIds.isNotEmpty) {
      context.path.add(PARAMETERS);
      _parametersIds.forEach((id, accessorId) {
        parameters[id] = gltf.accessors[accessorId];

        if (context.validate) {
          if (parameters[id] == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: id, args: [accessorId]);
          } else if (parameters[id].bufferView?.target != null) {
            context.addIssue(
                GltfWarning.ANIMATION_ACCESSOR_WRONG_BUFFERVIEW_TARGET,
                name: id,
                args: [accessorId]);
          }
        }
      });
      context.path.removeLast();
    }

    if (samplers.isNotEmpty) {
      context.path.add(SAMPLERS);
      samplers.forEach((id, sampler) {
        sampler.input = parameters[sampler._inputId];
        sampler.output = parameters[sampler._outputId];

        if (context.validate) {
          context.path.add(id);
          if (sampler.input == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: INPUT, args: [sampler._inputId]);
          }

          if (sampler.output == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: OUTPUT, args: [sampler._outputId]);
          }
          context.path.removeLast();
        }
      });
      context.path.removeLast();
    }

    if (channels.isNotEmpty) {
      context.path.add(CHANNELS);
      for (int i = 0; i < channels.length; i++) {
        final channel = channels[i];
        channel.sampler = samplers[channel._samplerId];

        if (channel.target != null) {
          channel.target.node = gltf.nodes[channel.target._id];
          if (context.validate && channel.target.node == null) {
            context.path.add(TARGET);
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: ID, args: [channel.target._id]);
            context.path.removeLast();
          }
        }

        if (context.validate) {
          context.path.add(i.toString());

          if (channel.sampler == null) {
            context.addIssue(GltfError.UNRESOLVED_REFERENCE,
                name: SAMPLER, args: [channel._samplerId]);
          } else {
            if (channel.target != null &&
                channel.sampler.input != null &&
                channel.sampler.output != null) {
              if (channel.sampler.input.type != SCALAR) {
                context.addIssue(GltfError.ANIMATION_ACCESSOR_INVALID,
                    name: SAMPLER, args: [channel.sampler._inputId]);
              }

              const outputTypes = const <String, String>{
                TRANSLATION: VEC3,
                ROTATION: VEC4,
                SCALE: VEC3
              };

              if (channel.sampler.output.type !=
                  outputTypes[channel.target.path]) {
                context.addIssue(GltfError.ANIMATION_ACCESSOR_INVALID,
                    name: SAMPLER, args: [channel.sampler._outputId]);
              }
            }
          }
          context.path.removeLast();
        }
      }
      context.path.removeLast();
    }
  }
}

class AnimationChannel extends GltfProperty {
  final String _samplerId;
  final AnimationChannelTarget target;

  AnimationSampler sampler;

  AnimationChannel._(this._samplerId, this.target,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({SAMPLER: _samplerId, TARGET: target});

  factory AnimationChannel.fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ANIMATION_CHANNEL_MEMBERS, context);

    AnimationChannelTarget target;
    final targetMap = getMap(map, TARGET, context, req: true);
    if (targetMap != null) {
      target = new AnimationChannelTarget.fromMap(targetMap, context);
    }

    return new AnimationChannel._(getId(map, SAMPLER, context), target,
        getExtensions(map, AnimationChannel, context), getExtras(map));
  }
}

class AnimationChannelTarget extends GltfProperty {
  static const String TRANSLATION = "translation";
  static const String ROTATION = "rotation";
  static const String SCALE = "scale";

  final String _id;
  final String path;

  Node node;

  AnimationChannelTarget._(
      this._id, this.path, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString({ID: _id, PATH: path});

  factory AnimationChannelTarget.fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate)
      checkMembers(map, ANIMATION_CHANNEL_TARGET_MEMBERS, context);

    const List<String> propertyNamesEnum = const <String>[
      TRANSLATION,
      ROTATION,
      SCALE
    ];

    return new AnimationChannelTarget._(
        getId(map, ID, context),
        getString(map, PATH, context, req: true, list: propertyNamesEnum),
        getExtensions(map, AnimationChannelTarget, context),
        getExtras(map));
  }
}

class AnimationSampler extends GltfProperty {
  static const String LINEAR = "LINEAR";
  static const String STEP = "STEP";

  final String _inputId;
  final String interpolation;
  final String _outputId;

  Accessor input;
  Accessor output;

  AnimationSampler._(this._inputId, this.interpolation, this._outputId,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  String toString([_]) => super.toString(
      {INPUT: _inputId, INTERPOLATION: interpolation, OUTPUT: _outputId});

  factory AnimationSampler.fromMap(Map<String, Object> map, Context context) {
    if (context.validate) checkMembers(map, ANIMATION_SAMPLER_MEMBERS, context);

    const List<String> interpolationTypesEnum = const <String>[LINEAR, STEP];

    return new AnimationSampler._(
        getId(map, INPUT, context),
        getString(map, INTERPOLATION, context,
            list: interpolationTypesEnum, def: LINEAR),
        getId(map, OUTPUT, context),
        getExtensions(map, AnimationSampler, context),
        getExtras(map));
  }
}
