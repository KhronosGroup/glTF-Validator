// Copyright 2024 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0

library gltf.extensions.khr_animation_pointer;

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';

const String KHR_ANIMATION_POINTER = 'KHR_animation_pointer';

const String POINTER = 'pointer';

const List<String> KHR_ANIMATION_POINTER_MEMBERS = <String>[
  POINTER,
];

// Spec: "If the Object Model Data Type is one of the float* types, the output
// accessor values are converted based on the accessor's component type".
// So float properties only need their vector size checked, while integer and
// boolean properties need to be scalar and type checked.
enum PointerValidity {
  invalid,
  unknown,
  extra,
  validIfBool,
  validIfInt,
  validIfScalar,
  validIfScalarArray,
  validIfVec2,
  validIfVec3,
  validIfVec4,
}

class KhrAnimationPointer extends GltfProperty {
  final String pointer;

  KhrAnimationPointer._(
      this.pointer, Map<String, Object> extensions, Object extras)
      : super(extensions, extras);

  static final RegExp _pointerRegExp = RegExp(r'^(?:\/(?:[^/~]|~0|~1)*)*$');

  static KhrAnimationPointer fromMap(Map<String, Object> map, Context context) {
    if (context.validate) {
      checkMembers(map, KHR_ANIMATION_POINTER_MEMBERS, context);
    }

    final pointer =
        getString(map, POINTER, context, req: true, regexp: _pointerRegExp);

    final extensions = getExtensions(map, KhrAnimationPointer, context);

    return KhrAnimationPointer._(pointer, extensions, getExtras(map, context));
  }

  @override
  void link(Gltf gltf, Context context) {
    // TODO:
    // * channel target uniqueness

    Object o = this;
    while (o != null) {
      o = context.owners[o];
      if (o is AnimationChannelTarget) {
        if (o.node != null) {
          context.addIssue(
              SemanticError.khrAnimationPointerAnimationChannelTargetNode);
        }
        if (o.path != POINTER) {
          context.addIssue(
              SemanticError.khrAnimationPointerAnimationChannelTargetPath,
              args: [o.path]);
        }
        break;
      }
    }
    if (o == null) {
      return;
    }
    if (pointer == null) {
      return;
    }
    // Retrieve the channel and its sampler.
    final animChannel = context.owners[o] as AnimationChannel;
    final sampler = animChannel.sampler;
    if (sampler == null) {
      return; // The animation parser will report this issue.
    }
    final outputAccessor = sampler.output;
    if (outputAccessor == null) {
      return; // The animation parser will report this issue.
    }
    final compType = outputAccessor.componentType;
    // Validate pointer existence.
    final parts = pointer.split('/');
    final validity = _validatePointerExistence(context, parts, gltf);
    // Validate if the type is compatible if it exists.
    switch (validity) {
      case PointerValidity.invalid:
        context.addIssue(SemanticError.khrAnimationPointerInvalidPointer,
            args: [pointer]);
        break;
      case PointerValidity.unknown:
        context.addIssue(LinkError.incompleteExtensionSupport);
        break;
      case PointerValidity.extra:
        context.addIssue(SemanticError.khrAnimationPointerCannotValidateExtras,
            args: [pointer]);
        break;
      case PointerValidity.validIfBool:
        // Spec: "If the Object Model Data Type is bool, the output accessor
        // component type MUST be unsigned byte"
        if (compType != 5121) {
          context.addIssue(
              SemanticError.khrAnimationPointerComponentTypeMismatch,
              args: [pointer, '5121 (unsigned byte)', compType]);
        }
        if (outputAccessor.type != SCALAR) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'SCALAR', outputAccessor.type]);
        }
        // Spec: "Animation samplers used with int or bool Object Model
        // Data Types MUST use STEP interpolation."
        if (sampler.interpolation != STEP) {
          context.addIssue(
              SemanticError.khrAnimationPointerIntegerNonStepInterpolation,
              args: [pointer, STEP, sampler.interpolation]);
        }
        break;
      case PointerValidity.validIfInt:
        // Spec: "If the Object Model Data Type is int, the output accessor
        // component type MUST be one of the non-normalized integer types"
        if (outputAccessor.normalized) {
          context.addIssue(
              SemanticError.khrAnimationPointerComponentTypeMismatch,
              args: [pointer, 'non-normalized integer type', compType]);
        }
        switch (compType) {
          // Core glTF integer types:
          case 5120: // BYTE (signed)
          case 5121: // UNSIGNED_BYTE
          case 5122: // SHORT (signed)
          case 5123: // UNSIGNED_SHORT
          case 5125: // UNSIGNED_INT
            break;
          // Other OpenGL integer types provided by glTF extensions:
          case 5124: // INT (signed)
          case 5134: // INT64
          case 5135: // UNSIGNED_INT64
            // TODO: Validate that the corresponding extensions are present.
            context.addIssue(LinkError.incompleteExtensionSupport);
            break;
          default:
            context.addIssue(
                SemanticError.khrAnimationPointerComponentTypeMismatch,
                args: [pointer, 'non-normalized integer type', compType]);
        }
        if (outputAccessor.type != SCALAR) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'SCALAR', outputAccessor.type]);
        }
        if (sampler.interpolation != STEP) {
          context.addIssue(
              SemanticError.khrAnimationPointerIntegerNonStepInterpolation,
              args: [pointer, STEP, sampler.interpolation]);
        }
        break;
      // Spec: "If the Object Model Data Type is one of the float* types,
      // the output accessor values are converted based on the accessor's
      // component type" so any component type is valid for float properties.
      case PointerValidity.validIfScalar:
        if (outputAccessor.type != SCALAR) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'SCALAR', outputAccessor.type]);
        }
        break;
      case PointerValidity.validIfScalarArray:
        // TODO: Validate array length somehow.
        if (outputAccessor.type != SCALAR) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'SCALAR', outputAccessor.type]);
        }
        break;
      case PointerValidity.validIfVec2:
        if (outputAccessor.type != VEC2) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'VEC2', outputAccessor.type]);
        }
        break;
      case PointerValidity.validIfVec3:
        if (outputAccessor.type != VEC3) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'VEC3', outputAccessor.type]);
        }
        break;
      case PointerValidity.validIfVec4:
        if (outputAccessor.type != VEC4) {
          context.addIssue(SemanticError.khrAnimationPointerVectorSizeMismatch,
              args: [pointer, 'VEC4', outputAccessor.type]);
        }
        break;
    }
  }

  // Check if pointer points to a property that exists in the glTF file.
  static PointerValidity _validatePointerExistence(
      Context context, List<String> pointer, Gltf gltf) {
    if (pointer == null || pointer.length < 3) {
      return PointerValidity.invalid;
    }
    // Pointer must start with a slash, so the split first element is ''.
    if (pointer[0] != '') {
      return PointerValidity.invalid;
    }
    if (pointer[1] == EXTENSIONS || pointer[1] == EXTRAS) {
      return _validateExtensionsExtras(context, pointer, gltf, 1);
    }
    // Aside from extras, all valid pointers are at least 3 levels deep (len 4).
    if (pointer.length < 4) {
      return PointerValidity.invalid;
    }
    final itemProperty = pointer[3];
    if (pointer[1] == ASSET) {
      // There are no core glTF pointers directly in asset,
      // so the only possible valid case is a pointer into extensions/extras.
      return _validateExtensionsExtras(context, pointer, gltf.asset, 2);
    }
    // Everything below here addresses top-level glTF arrays.
    final topLevelIndex = int.tryParse(pointer[2]);
    if (topLevelIndex == null || topLevelIndex < 0) {
      return PointerValidity.invalid;
    }
    if (pointer[1] == ACCESSORS) {
      if (topLevelIndex >= gltf.accessors.length) {
        return PointerValidity.invalid;
      }
      final accessor = gltf.accessors[topLevelIndex];
      // There are no core glTF pointers directly in accessors,
      // so the only possible valid case is a pointer into extensions.
      if (itemProperty == SPARSE && pointer.length > 5) {
        // Shortest possible pointer into accessor sparse:
        // `/accessors/0/sparse/extras/someExtra`
        // Remember that this has a length of 6, the first is an empty string.
        final sparse = accessor.sparse;
        if (sparse == null) {
          return PointerValidity.invalid;
        }
        final subProperty = pointer[4];
        if (subProperty == INDICES) {
          final indices = sparse.indices;
          if (indices == null) {
            return PointerValidity.invalid;
          }
          return _validateExtensionsExtras(context, pointer, indices, 5);
        }
        if (subProperty == VALUES) {
          final values = sparse.values;
          if (values == null) {
            return PointerValidity.invalid;
          }
          return _validateExtensionsExtras(context, pointer, values, 5);
        }
        return _validateExtensionsExtras(context, pointer, sparse, 4);
      }
      return _validateExtensionsExtras(context, pointer, accessor, 3);
    } else if (pointer[1] == ANIMATIONS) {
      if (topLevelIndex >= gltf.animations.length) {
        return PointerValidity.invalid;
      }
      final animation = gltf.animations[topLevelIndex];
      // There are no core glTF pointers directly in animations,
      // so the only possible valid case is a pointer into extensions.
      if (pointer.length > 6) {
        // Shortest possible pointer into channels/samplers:
        // `/animations/0/channels/0/extras/someExtra`
        if (itemProperty == CHANNELS) {
          final channelIndex = int.tryParse(pointer[4]);
          if (channelIndex == null ||
              channelIndex < 0 ||
              channelIndex >= animation.channels.length) {
            return PointerValidity.invalid;
          }
          final channel = animation.channels[channelIndex];
          if (pointer[5] == TARGET) {
            final target = channel.target;
            if (target == null) {
              return PointerValidity.invalid;
            }
            return _validateExtensionsExtras(context, pointer, target, 6);
          }
          return _validateExtensionsExtras(context, pointer, channel, 5);
        }
        if (itemProperty == SAMPLERS) {
          final samplerIndex = int.tryParse(pointer[4]);
          if (samplerIndex == null ||
              samplerIndex < 0 ||
              samplerIndex >= animation.samplers.length) {
            return PointerValidity.invalid;
          }
          final sampler = animation.samplers[samplerIndex];
          if (sampler == null) {
            return PointerValidity.invalid;
          }
          return _validateExtensionsExtras(context, pointer, sampler, 5);
        }
      }
      return _validateExtensionsExtras(context, pointer, animation, 3);
    } else if (pointer[1] == BUFFERS) {
      if (topLevelIndex >= gltf.buffers.length) {
        return PointerValidity.invalid;
      }
      final buffer = gltf.buffers[topLevelIndex];
      // There are no core glTF pointers directly in buffers,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, buffer, 3);
    } else if (pointer[1] == BUFFER_VIEWS) {
      if (topLevelIndex >= gltf.bufferViews.length) {
        return PointerValidity.invalid;
      }
      final bufferView = gltf.bufferViews[topLevelIndex];
      // There are no core glTF pointers directly in buffer views,
      // so the only possible valid case is a pointer into extensions/extras.
      return _validateExtensionsExtras(context, pointer, bufferView, 3);
    } else if (pointer[1] == CAMERAS) {
      if (topLevelIndex >= gltf.cameras.length) {
        return PointerValidity.invalid;
      }
      // All camera core pointers and extensions are at least 5 levels deep.
      if (pointer.length < 5) {
        return PointerValidity.invalid;
      }
      final camera = gltf.cameras[topLevelIndex];
      final subProperty = pointer[4];
      // Spec: "Pointers to the asset properties that do not have a
      // spec-defined default value, such as /cameras/0/perspective/zfar,
      // are invalid if the property is not defined in the asset explicitly."
      // We can check for this by checking if the parsed value is NaN.
      if (itemProperty == ORTHOGRAPHIC) {
        final orthographic = camera.orthographic;
        if (orthographic == null) {
          return PointerValidity.invalid;
        }
        if (subProperty == XMAG && !orthographic.xmag.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == YMAG && !orthographic.ymag.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == ZFAR && !orthographic.zfar.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == ZNEAR && !orthographic.znear.isNaN) {
          return PointerValidity.validIfScalar;
        }
        return _validateExtensionsExtras(context, pointer, orthographic, 4);
      } else if (itemProperty == PERSPECTIVE) {
        final perspective = camera.perspective;
        if (perspective == null) {
          return PointerValidity.invalid;
        }
        if (subProperty == ASPECT_RATIO && !perspective.aspectRatio.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == YFOV && !perspective.yfov.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == ZFAR && !perspective.zfar.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == ZNEAR && !perspective.znear.isNaN) {
          return PointerValidity.validIfScalar;
        }
        return _validateExtensionsExtras(context, pointer, perspective, 4);
      }
      return _validateExtensionsExtras(context, pointer, camera, 3);
    } else if (pointer[1] == IMAGES) {
      if (topLevelIndex >= gltf.images.length) {
        return PointerValidity.invalid;
      }
      final image = gltf.images[topLevelIndex];
      // There are no core glTF pointers directly in images,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, image, 3);
    } else if (pointer[1] == MATERIALS) {
      if (topLevelIndex >= gltf.materials.length) {
        return PointerValidity.invalid;
      }
      final material = gltf.materials[topLevelIndex];
      if (itemProperty == ALPHA_CUTOFF && !material.alphaCutoff.isNaN) {
        return PointerValidity.validIfScalar;
      }
      if (itemProperty == EMISSIVE_FACTOR &&
          material.emissiveFactor != null &&
          material.emissiveFactor.length == 3) {
        return PointerValidity.validIfVec3;
      }
      // Remaining core properties and extensions are at least 5 levels deep.
      if (pointer.length < 5) {
        return PointerValidity.invalid;
      }
      final subProperty = pointer[4];
      if (itemProperty == EMISSIVE_TEXTURE) {
        final emissiveTex = material.emissiveTexture;
        if (emissiveTex == null) {
          return PointerValidity.invalid;
        }
        return _validateExtensionsExtras(context, pointer, emissiveTex, 4);
      }
      if (itemProperty == NORMAL_TEXTURE) {
        final normTex = material.normalTexture;
        if (normTex == null) {
          return PointerValidity.invalid;
        }
        if (subProperty == 'scale' && !normTex.scale.isNaN) {
          return PointerValidity.validIfScalar;
        }
        return _validateExtensionsExtras(context, pointer, normTex, 4);
      }
      if (itemProperty == OCCLUSION_TEXTURE) {
        final occTex = material.occlusionTexture;
        if (occTex == null) {
          return PointerValidity.invalid;
        }
        if (subProperty == 'strength' && !occTex.strength.isNaN) {
          return PointerValidity.validIfScalar;
        }
        return _validateExtensionsExtras(context, pointer, occTex, 4);
      }
      if (itemProperty == PBR_METALLIC_ROUGHNESS) {
        final pbr = material.pbrMetallicRoughness;
        if (pbr == null) {
          return PointerValidity.invalid;
        }
        if (subProperty == BASE_COLOR_FACTOR &&
            pbr.baseColorFactor != null &&
            pbr.baseColorFactor.length == 4) {
          return PointerValidity.validIfVec4;
        }
        if (subProperty == BASE_COLOR_TEXTURE) {
          final baseTex = pbr.baseColorTexture;
          if (baseTex == null) {
            return PointerValidity.invalid;
          }
          return _validateExtensionsExtras(context, pointer, baseTex, 4);
        }
        if (subProperty == METALLIC_FACTOR && !pbr.metallicFactor.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == ROUGHNESS_FACTOR && !pbr.roughnessFactor.isNaN) {
          return PointerValidity.validIfScalar;
        }
        if (subProperty == METALLIC_ROUGHNESS_TEXTURE) {
          final mrTex = pbr.metallicRoughnessTexture;
          if (mrTex == null) {
            return PointerValidity.invalid;
          }
          return _validateExtensionsExtras(context, pointer, mrTex, 4);
        }
        return _validateExtensionsExtras(context, pointer, pbr, 4);
      }
      return _validateExtensionsExtras(context, pointer, material, 3);
    } else if (pointer[1] == MESHES) {
      if (topLevelIndex >= gltf.meshes.length) {
        return PointerValidity.invalid;
      }
      final mesh = gltf.meshes[topLevelIndex];
      if (itemProperty == PRIMITIVES) {
        if (mesh.primitives.isEmpty) {
          return PointerValidity.invalid;
        }
        // Shortest possible pointer into primitives:
        // `/meshes/0/primitives/0/extras/someExtra`
        // Remember that this has a length of 7, the first is an empty string.
        if (pointer.length < 7) {
          return PointerValidity.invalid;
        }
        final primIndex = int.tryParse(pointer[4]);
        if (primIndex == null ||
            primIndex < 0 ||
            primIndex >= mesh.primitives.length) {
          return PointerValidity.invalid;
        }
        final primitive = mesh.primitives[primIndex];
        return _validateExtensionsExtras(context, pointer, primitive, 5);
      }
      if (itemProperty == WEIGHTS) {
        if (pointer.length == 4) {
          return PointerValidity.validIfScalarArray;
        } else if (pointer.length == 5) {
          final weightIndex = int.tryParse(pointer[4]);
          if (weightIndex == null || weightIndex < 0) {
            return PointerValidity.invalid;
          }
          if (mesh.weights != null && weightIndex < mesh.weights.length) {
            return PointerValidity.validIfScalar;
          }
          return PointerValidity.invalid;
        } else {
          return PointerValidity.invalid;
        }
      }
      return _validateExtensionsExtras(context, pointer, mesh, 3);
    } else if (pointer[1] == NODES) {
      if (topLevelIndex >= gltf.nodes.length) {
        return PointerValidity.invalid;
      }
      final node = gltf.nodes[topLevelIndex];
      if (pointer.length == 4) {
        if (itemProperty == TRANSLATION) {
          return PointerValidity.validIfVec3;
        }
        if (itemProperty == ROTATION) {
          return PointerValidity.validIfVec4;
        }
        if (itemProperty == SCALE) {
          return PointerValidity.validIfVec3;
        }
      }
      if (itemProperty == WEIGHTS) {
        if (pointer.length == 4) {
          return PointerValidity.validIfScalarArray;
        } else if (pointer.length == 5) {
          final weightIndex = int.tryParse(pointer[4]);
          if (weightIndex == null || weightIndex < 0) {
            return PointerValidity.invalid;
          }
          if (node.weights != null && weightIndex < node.weights.length) {
            return PointerValidity.validIfScalar;
          }
          return PointerValidity.invalid;
        } else {
          return PointerValidity.invalid;
        }
      }
      return _validateExtensionsExtras(context, pointer, node, 3);
    } else if (pointer[1] == SAMPLERS) {
      if (topLevelIndex >= gltf.samplers.length) {
        return PointerValidity.invalid;
      }
      final sampler = gltf.samplers[topLevelIndex];
      // There are no core glTF pointers directly in samplers,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, sampler, 3);
    } else if (pointer[1] == SCENES) {
      if (topLevelIndex >= gltf.scenes.length) {
        return PointerValidity.invalid;
      }
      final scene = gltf.scenes[topLevelIndex];
      // There are no mutable core glTF pointers directly in scenes,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, scene, 3);
    } else if (pointer[1] == SKINS) {
      if (topLevelIndex >= gltf.skins.length) {
        return PointerValidity.invalid;
      }
      final skin = gltf.skins[topLevelIndex];
      // There are no mutable core glTF pointers directly in skins,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, skin, 3);
    } else if (pointer[1] == TEXTURES) {
      if (topLevelIndex >= gltf.textures.length) {
        return PointerValidity.invalid;
      }
      final texture = gltf.textures[topLevelIndex];
      // There are no core glTF pointers directly in textures,
      // so the only possible valid case is a pointer into extensions.
      return _validateExtensionsExtras(context, pointer, texture, 3);
    }
    return PointerValidity.invalid;
  }

  // Validate pointers into extensions and extras.
  // This is always the last resort after checking everything else.
  static PointerValidity _validateExtensionsExtras(Context context,
      List<String> pointer, GltfProperty prop, int inPropDepth) {
    if (pointer.length < inPropDepth + 2) {
      return PointerValidity.invalid;
    }
    final itemProperty = pointer[inPropDepth];
    // Extensions must be at least +2 levels deep: prop/extensions/extName/here.
    if (itemProperty == EXTENSIONS && pointer.length >= inPropDepth + 2) {
      return Context.validateExtensionPointer(
          context, pointer, prop, inPropDepth);
    }
    if (itemProperty == EXTRAS) {
      // Spec: "Properties located in extras objects MAY be
      // targeted as well, but validity and interpretation of the
      // animated values is entirely application specific."
      // So the only validation we can do is check if the key exists.
      if (prop.extras is Map<String, Object>) {
        final extrasMap = prop.extras as Map<String, Object>;
        if (extrasMap.containsKey(pointer[inPropDepth + 1])) {
          return PointerValidity.extra;
        }
      }
    }
    return PointerValidity.invalid;
  }
}

const Extension khrAnimationPointerExtension = Extension(
    KHR_ANIMATION_POINTER,
    <Type, ExtensionDescriptor>{
      AnimationChannelTarget: ExtensionDescriptor(KhrAnimationPointer.fromMap)
    },
    init: _init);

void _init(Context context) {
  context.animationChannelTargetPaths.add(POINTER);
}
