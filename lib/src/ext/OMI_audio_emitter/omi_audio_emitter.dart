/*
 * # Copyright (c) 2021 Open Metaverse Interoperability Group
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

library gltf.extensions.omi_audio_emitter;

import 'dart:typed_data';
import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/utils.dart';

const String OMI_AUDIO_EMITTER = 'OMI_audio_emitter';

const String AUDIO_EMITTERS = 'audioEmitters';
const String AUDIO_SOURCES = 'audioSources';

const List<String> OMI_AUDIO_EMITTER_GLTF_MEMBERS = <String>[
  AUDIO_EMITTERS,
  AUDIO_SOURCES
];

const String GLOBAL = 'global';
const String POSITIONAL = 'positional';

const List<String> OMI_AUDIO_EMITTER_TYPES = <String>[GLOBAL, POSITIONAL];

const String LINEAR = 'linear';
const String INVERSE = 'inverse';
const String EXPONENTIAL = 'exponential';

const List<String> OMI_AUDIO_EMITTER_DISTANCE_MODELS = <String>[
  LINEAR,
  INVERSE,
  EXPONENTIAL
];

const String TYPE = 'type';
const String GAIN = 'gain';
const String LOOP = 'loop';
const String AUTO_PLAY = 'autoPlay';
const String SOURCE = 'source';
const String CONE_INNER_ANGLE = 'coneInnerAngle';
const String CONE_OUTER_ANGLE = 'coneOuterAngle';
const String CONE_OUTER_GAIN = 'coneOuterGain';
const String DISTANCE_MODEL = 'distanceModel';
const String MAX_DISTANCE = 'maxDistance';
const String REF_DISTANCE = 'refDistance';
const String ROLLOFF_FACTOR = 'rolloffFactor';

const List<String> OMI_AUDIO_EMITTER_MEMBERS = <String>[
  TYPE,
  GAIN,
  LOOP,
  AUTO_PLAY,
  SOURCE,
  CONE_INNER_ANGLE,
  CONE_OUTER_ANGLE,
  CONE_OUTER_GAIN,
  DISTANCE_MODEL,
  MAX_DISTANCE,
  REF_DISTANCE,
  ROLLOFF_FACTOR,
  NAME
];

const String AUDIO_MPEG = "audio/mpeg";

const List<String> AUDIO_MIME_TYPES = <String>[AUDIO_MPEG];

const List<String> OMI_AUDIO_SOURCE_MEMBERS = <String>[
  URI,
  MIME_TYPE,
  BUFFER_VIEW,
  NAME
];

const String AUDIO_EMITTER = "audioEmitter";

const List<String> OMI_AUDIO_EMITTER_NODE_MEMBERS = <String>[AUDIO_EMITTER];

const List<String> OMI_AUDIO_EMITTER_SCENE_MEMBERS = <String>[AUDIO_EMITTERS];

class OmiAudioEmitterGltf extends GltfProperty {
  final SafeList<OmiAudioEmitter> audioEmitters;
  final SafeList<OmiAudioSource> audioSources;

  OmiAudioEmitterGltf._(this.audioEmitters, this.audioSources,
      Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiAudioEmitterGltf fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_AUDIO_EMITTER_GLTF_MEMBERS, context);
    }

    SafeList<OmiAudioEmitter> audioEmitters;
    final audioEmitterMaps = getMapList(map, AUDIO_EMITTERS, context);
    if (audioEmitterMaps != null) {
      audioEmitters =
          SafeList<OmiAudioEmitter>(audioEmitterMaps.length, AUDIO_EMITTERS);
      context.path.add(AUDIO_EMITTERS);
      for (var i = 0; i < audioEmitterMaps.length; i++) {
        final audioEmitterMap = audioEmitterMaps[i];
        context.path.add(i.toString());
        audioEmitters[i] = OmiAudioEmitter.fromMap(audioEmitterMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      audioEmitters = SafeList<OmiAudioEmitter>.empty(AUDIO_EMITTERS);
    }

    SafeList<OmiAudioSource> audioSources;
    final audioSourceMaps = getMapList(map, AUDIO_SOURCES, context);
    if (audioSourceMaps != null) {
      audioSources =
          SafeList<OmiAudioSource>(audioEmitterMaps.length, AUDIO_SOURCES);
      context.path.add(AUDIO_SOURCES);
      for (var i = 0; i < audioSourceMaps.length; i++) {
        final audioSourceMap = audioSourceMaps[i];
        context.path.add(i.toString());
        audioSources[i] = OmiAudioSource.fromMap(audioSourceMap, context);
        context.path.removeLast();
      }
      context.path.removeLast();
    } else {
      audioSources = SafeList<OmiAudioSource>.empty(AUDIO_SOURCES);
    }

    return OmiAudioEmitterGltf._(
        audioEmitters,
        audioSources,
        getExtensions(map, OmiAudioEmitterGltf, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (audioEmitters != null) {
      context.path.add(AUDIO_EMITTERS);
      context.extensionCollections[audioEmitters] =
          context.path.toList(growable: false);
      audioEmitters.forEachWithIndices((i, audioEmitter) {
        context.path.add(i.toString());
        audioEmitter.link(gltf, context);
        context.path.removeLast();
      });
      context.path.removeLast();
    }

    if (audioSources != null) {
      context.path.add(AUDIO_SOURCES);
      context.extensionCollections[audioSources] =
          context.path.toList(growable: false);
      audioSources.forEachWithIndices((i, audioSource) {
        context.path.add(i.toString());
        audioSource.link(gltf, context);
        context.path.removeLast();
      });
      context.path.removeLast();
    }
  }
}

class OmiAudioEmitterScene extends GltfProperty {
  final List<int> _audioEmittersIndices;

  List<OmiAudioEmitter> _audioEmitters;

  OmiAudioEmitterScene._(
      this._audioEmittersIndices, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiAudioEmitterScene fromMap(
      Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_AUDIO_EMITTER_SCENE_MEMBERS, context);
    }

    return OmiAudioEmitterScene._(
        getIndicesList(map, AUDIO_EMITTERS, context),
        getExtensions(map, KhrLightsPunctualNode, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    final audioEmitterExtension =
        gltf.extensions[omiAudioEmitterExtension.name];

    if (audioEmitterExtension is OmiAudioEmitterGltf) {
      _audioEmitters =
          List<OmiAudioEmitter>.filled(_audioEmittersIndices.length, null);

      assert(_audioEmittersIndices != null);

      context.path.add(AUDIO_EMITTERS);

      for (var i = 0; i < _audioEmittersIndices.length; i++) {
        final audioEmitterIndex = _audioEmittersIndices[i];

        final audioEmitter =
            audioEmitterExtension.audioEmitters[audioEmitterIndex];

        if (context.validate && audioEmitterIndex != -1) {
          if (audioEmitter == null) {
            context.addIssue(LinkError.unresolvedReference,
                name: AUDIO_EMITTERS, args: [audioEmitterIndex]);
          } else {
            audioEmitter.markAsUsed();
          }
        }
      }

      context.path.removeLast();
    } else if (context.validate) {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${omiAudioEmitterExtension.name}']);
    }
  }

  List<OmiAudioEmitter> get audioEmitters => _audioEmitters;
}

class OmiAudioEmitterNode extends GltfProperty {
  final int _audioEmitterIndex;

  OmiAudioEmitter _audioEmitter;

  OmiAudioEmitterNode._(
      this._audioEmitterIndex, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static OmiAudioEmitterNode fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_AUDIO_EMITTER_NODE_MEMBERS, context);
    }

    return OmiAudioEmitterNode._(
        getIndex(map, AUDIO_EMITTER, context),
        getExtensions(map, KhrLightsPunctualNode, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    final audioEmitterExtension =
        gltf.extensions[omiAudioEmitterExtension.name];
    if (audioEmitterExtension is OmiAudioEmitterGltf) {
      _audioEmitter = audioEmitterExtension.audioEmitters[_audioEmitterIndex];

      if (context.validate && _audioEmitterIndex != -1) {
        if (_audioEmitter == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: AUDIO_EMITTER, args: [_audioEmitterIndex]);
        } else {
          _audioEmitter.markAsUsed();
        }
      }
    } else if (context.validate) {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${omiAudioEmitterExtension.name}']);
    }
  }

  OmiAudioEmitter get audioEmitter => _audioEmitter;
}

class OmiAudioEmitter extends GltfChildOfRootProperty {
  final String type;
  final double gain;
  final bool loop;
  final bool autoPlay;
  final int _sourceIndex;
  OmiAudioSource _source;
  OmiAudioSource get source => _source;
  final double coneInnerAngle;
  final double coneOuterAngle;
  final double coneOuterGain;
  final String distanceModel;
  final double maxDistance;
  final double refDistance;
  final double rolloffFactor;

  OmiAudioEmitter._(
      this.type,
      this.gain,
      this.loop,
      this.autoPlay,
      this._sourceIndex,
      this.coneInnerAngle,
      this.coneOuterAngle,
      this.coneOuterGain,
      this.distanceModel,
      this.maxDistance,
      this.refDistance,
      this.rolloffFactor,
      String name,
      Map<String, Object> extensions,
      Object extras)
      : super(name, extensions, extras);

  static OmiAudioEmitter fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_AUDIO_EMITTER_MEMBERS, context);
    }

    final type =
        getString(map, TYPE, context, list: OMI_AUDIO_EMITTER_TYPES, req: true);

    final gain = getFloat(map, GAIN, context, def: 1, min: 0);

    final loop = getBool(map, LOOP, context);

    final autoPlay = getBool(map, AUTO_PLAY, context);

    final source = getIndex(map, SOURCE, context, req: false);

    final coneInnerAngle = getFloat(map, CONE_INNER_ANGLE, context,
        def: 6.283185307179586, min: 0, max: 6.283185307179586);

    final coneOuterAngle = getFloat(map, CONE_INNER_ANGLE, context,
        def: 6.283185307179586, min: 0, max: 6.283185307179586);

    final coneOuterGain =
        getFloat(map, CONE_OUTER_GAIN, context, def: 0, min: 0, max: 1);

    final distanceModel = getString(map, DISTANCE_MODEL, context,
        list: OMI_AUDIO_EMITTER_DISTANCE_MODELS, def: INVERSE);

    final maxDistance =
        getFloat(map, MAX_DISTANCE, context, def: 10000, exclMin: 0);

    final refDistance = getFloat(map, REF_DISTANCE, context, def: 1, min: 0);

    double rolloffFactor;

    if (distanceModel == LINEAR) {
      rolloffFactor =
          getFloat(map, ROLLOFF_FACTOR, context, def: 1, min: 0, max: 1);
    } else {
      rolloffFactor = getFloat(map, ROLLOFF_FACTOR, context, def: 1, min: 0);
    }

    if (context.validate && type == GLOBAL) {
      if (map.containsKey(CONE_INNER_ANGLE)) {
        context.addIssue(SemanticError.extraProperty, name: CONE_INNER_ANGLE);
      }

      if (map.containsKey(CONE_OUTER_ANGLE)) {
        context.addIssue(SemanticError.extraProperty, name: CONE_OUTER_ANGLE);
      }

      if (map.containsKey(CONE_OUTER_GAIN)) {
        context.addIssue(SemanticError.extraProperty, name: CONE_OUTER_GAIN);
      }

      if (map.containsKey(DISTANCE_MODEL)) {
        context.addIssue(SemanticError.extraProperty, name: DISTANCE_MODEL);
      }

      if (map.containsKey(DISTANCE_MODEL)) {
        context.addIssue(SemanticError.extraProperty, name: DISTANCE_MODEL);
      }

      if (map.containsKey(MAX_DISTANCE)) {
        context.addIssue(SemanticError.extraProperty, name: MAX_DISTANCE);
      }

      if (map.containsKey(REF_DISTANCE)) {
        context.addIssue(SemanticError.extraProperty, name: REF_DISTANCE);
      }

      if (map.containsKey(ROLLOFF_FACTOR)) {
        context.addIssue(SemanticError.extraProperty, name: ROLLOFF_FACTOR);
      }
    }

    return OmiAudioEmitter._(
        type,
        gain,
        loop,
        autoPlay,
        source,
        coneInnerAngle,
        coneOuterAngle,
        coneOuterGain,
        distanceModel,
        maxDistance,
        refDistance,
        rolloffFactor,
        getName(map, context),
        getExtensions(map, OmiAudioEmitter, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    final audioEmitterExtension =
        gltf.extensions[omiAudioEmitterExtension.name];
    if (audioEmitterExtension is OmiAudioEmitterGltf) {
      _source = audioEmitterExtension.audioSources[_sourceIndex];

      if (context.validate && _sourceIndex != -1) {
        if (_source == null) {
          context.addIssue(LinkError.unresolvedReference,
              name: SOURCE, args: [_sourceIndex]);
        } else {
          _source.markAsUsed();
        }
      }
    } else if (context.validate) {
      context.addIssue(SchemaError.unsatisfiedDependency,
          args: ['/$EXTENSIONS/${omiAudioEmitterExtension.name}']);
    }
  }
}

class OmiAudioSource extends GltfChildOfRootProperty {
  final int _bufferViewIndex;
  final String mimeType;
  final Uri uri;

  Uint8List data;
  BufferView _bufferView;

  OmiAudioSource._(this._bufferViewIndex, this.uri, this.mimeType, this.data,
      String name, Map<String, Object> extensions, Object extras)
      : super(name, extensions, extras);

  BufferView get bufferView => _bufferView;

  static OmiAudioSource fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, OMI_AUDIO_SOURCE_MEMBERS, context);
    }

    final bufferViewIndex = getIndex(map, BUFFER_VIEW, context, req: false);
    var mimeType = getString(map, MIME_TYPE, context, list: AUDIO_MIME_TYPES);
    final uriString = getString(map, URI, context, req: false);

    if (context.validate) {
      if (bufferViewIndex != -1 && mimeType == null) {
        context.addIssue(SchemaError.unsatisfiedDependency,
            name: BUFFER_VIEW, args: [MIME_TYPE]);
      }

      if (((bufferViewIndex != -1) && (uriString != null)) ||
          ((bufferViewIndex == -1) && (uriString == null))) {
        context.addIssue(SchemaError.oneOfMismatch, args: [BUFFER_VIEW, URI]);
      }
    }

    Uri uri;
    Uint8List data;

    if (uriString != null) {
      UriData uriData;
      try {
        uriData = UriData.parse(uriString);
      } on FormatException catch (_) {
        uri = getUri(uriString, context);
      }

      if (uriData != null) {
        if (context.isGlb) {
          context.addIssue(DataError.dataUriGlb, name: URI);
        }

        data = uriData.contentAsBytes();

        // Re-assign `mimeType` only if it wasn't set in JSON
        if (mimeType == null) {
          if (context.validate &&
              !context.imageMimeTypes.contains(uriData.mimeType)) {
            context.addIssue(SchemaError.valueNotInList,
                name: URI, args: [uriData.mimeType, AUDIO_MIME_TYPES]);
          }
          mimeType = uriData.mimeType;
        }
      }
    }

    return OmiAudioSource._(
        bufferViewIndex,
        uri,
        mimeType,
        data,
        getName(map, context),
        getExtensions(map, OmiAudioSource, context),
        getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    if (_bufferViewIndex != -1) {
      _bufferView = gltf.bufferViews[_bufferViewIndex];

      if (_bufferView == null) {
        context.addIssue(LinkError.unresolvedReference,
            name: BUFFER_VIEW, args: [_bufferViewIndex]);
      } else {
        _bufferView.setUsage(BufferViewUsage.Other, BUFFER_VIEW, context);
        if (_bufferView.byteStride != -1) {
          context.addIssue(LinkError.audioBufferViewWithByteStride,
              name: BUFFER_VIEW);
        }
      }
    }
  }

  void tryLoadFromBufferView() {
    if (_bufferView?.buffer?.data != null) {
      /// in the worst case, `data` will remain `null`
      try {
        data = Uint8List.view(_bufferView.buffer.data.buffer,
            _bufferView.byteOffset, _bufferView.byteLength);
        // ignore: avoid_catching_errors
      } on ArgumentError catch (_) {}
    }
  }
}

const Extension omiAudioEmitterExtension =
    Extension(OMI_AUDIO_EMITTER, <Type, ExtensionDescriptor>{
  Gltf: ExtensionDescriptor(OmiAudioEmitterGltf.fromMap),
  Scene: ExtensionDescriptor(OmiAudioEmitterScene.fromMap),
  Node: ExtensionDescriptor(OmiAudioEmitterNode.fromMap)
});
