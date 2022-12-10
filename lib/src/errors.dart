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

library gltf.error;

import 'package:meta/meta.dart';

typedef ErrorFunction = String Function(List args);

enum Severity { Error, Warning, Information, Hint }

abstract class IssueType {
  final Severity severity;
  final String code;
  final ErrorFunction message;

  IssueType(this.code, this.message, this.severity);
}

// These values are slightly greater
// than the maximum error from signed 8-bit quantization
const unitLengthThresholdVec3 = 0.00674;
const unitLengthThresholdVec4 = 0.00769;

// This value is slightly greater
// than the maximum error from unsigned 8-bit quantization
// 1..2 elements - 0 * step
// 3..4 elements - 1 * step
// 5..6 elements - 2 * step
// ...
const unitSumThresholdStep = 0.0039216;

class DataError extends IssueType {
  static final DataError bufferByteLengthMismatch = DataError._(
      'BUFFER_BYTE_LENGTH_MISMATCH',
      (args) => 'Actual data byte length (${args[0]}) is less than '
          'the declared buffer byte length (${args[1]}).');

  static final DataError bufferGlbChunkTooBig = DataError._(
      'BUFFER_GLB_CHUNK_TOO_BIG',
      (args) =>
          'GLB-stored BIN chunk contains ${args[0]} extra padding byte(s).',
      Severity.Warning);

  static final DataError accessorMinMismatch = DataError._(
      'ACCESSOR_MIN_MISMATCH',
      (args) => 'Declared minimum value for this component '
          '(${args[0]}) does not match actual minimum (${args[1]}).');

  static final DataError accessorMaxMismatch = DataError._(
      'ACCESSOR_MAX_MISMATCH',
      (args) => 'Declared maximum value for this component '
          '(${args[0]}) does not match actual maximum (${args[1]}).');

  static final DataError accessorElementOutOfMinBound = DataError._(
      'ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND',
      (args) => 'Accessor contains ${args[0]} '
          'element(s) less than declared minimum value ${args[1]}.');

  static final DataError accessorElementOutOfMaxBound = DataError._(
      'ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND',
      (args) => 'Accessor contains ${args[0]} '
          'element(s) greater than declared maximum value ${args[1]}.');

  static final DataError accessorVector3NonUnit = DataError._(
      'ACCESSOR_VECTOR3_NON_UNIT',
      (args) => 'Vector3 at accessor indices ${args[0]}..${args[1]} '
          'is not of unit length: ${args[2]}.');

  static final DataError accessorInvalidSign = DataError._(
      'ACCESSOR_INVALID_SIGN',
      (args) => 'Vector3 with sign at accessor indices '
          '${args[0]}..${args[1]} '
          'has invalid w component: ${args[2]}. Must be 1.0 or -1.0.');

  static final DataError accessorAnimationSamplerOutputNonNormalizedQuaternion =
      DataError._(
          'ACCESSOR_ANIMATION_SAMPLER_OUTPUT_NON_NORMALIZED_QUATERNION',
          (args) => 'Animation sampler output accessor element at indices '
              '${args[0]}..${args[1]} is not of unit length: ${args[2]}.');

  static final DataError accessorNonClamped = DataError._(
      'ACCESSOR_NON_CLAMPED',
      (args) => 'Accessor element at index ${args[0]} '
          'is not clamped to 0..1 range: ${args[1]}.');

  static final DataError accessorInvalidFloat = DataError._(
      'ACCESSOR_INVALID_FLOAT',
      (args) => 'Accessor element at index ${args[0]} is ${args[1]}.');

  static final DataError accessorIndexOob = DataError._(
      'ACCESSOR_INDEX_OOB',
      (args) => 'Indices accessor element at index ${args[0]} '
          'has value ${args[1]} that is greater than the maximum vertex '
          'index available (${args[2]}).');

  static final DataError accessorIndexTriangleDegenerate = DataError._(
      'ACCESSOR_INDEX_TRIANGLE_DEGENERATE',
      (args) => 'Indices accessor contains ${args[0]} degenerate triangles '
          '(out of ${args[1]}).',
      Severity.Information);

  static final DataError accessorIndexPrimitiveRestart = DataError._(
      'ACCESSOR_INDEX_PRIMITIVE_RESTART',
      (args) => 'Indices accessor contains primitive restart value '
          '(${args[0]}) at index ${args[1]}.');

  static final DataError accessorAnimationInputNegative = DataError._(
      'ACCESSOR_ANIMATION_INPUT_NEGATIVE',
      (args) => 'Animation input accessor element at index ${args[0]} '
          'is negative: ${args[1]}.');

  static final DataError accessorAnimationInputNonIncreasing = DataError._(
      'ACCESSOR_ANIMATION_INPUT_NON_INCREASING',
      (args) => 'Animation input accessor element at index ${args[0]} '
          'is less than or equal to previous: ${args[1]} <= ${args[2]}.');

  static final DataError accessorSparseIndicesNonIncreasing = DataError._(
      'ACCESSOR_SPARSE_INDICES_NON_INCREASING',
      (args) => 'Accessor sparse indices element at index ${args[0]} '
          'is less than or equal to previous: ${args[1]} <= ${args[2]}.');

  static final DataError accessorSparseIndexOob = DataError._(
      'ACCESSOR_SPARSE_INDEX_OOB',
      (args) => 'Accessor sparse indices element at index ${args[0]} '
          'is greater than or equal to '
          'the number of accessor elements: ${args[1]} >= ${args[2]}.');

  static final DataError accessorInvalidInverseBindMatrix = DataError._(
      'ACCESSOR_INVALID_IBM',
      (args) => 'Matrix element at index ${args[0]} '
          '(component index ${args[1]}) contains invalid value: ${args[2]}.');

  static final DataError imageDataInvalid = DataError._(
      'IMAGE_DATA_INVALID', (args) => 'Image data is invalid. ${args[0]}');

  static final DataError imageMimeTypeInvalid = DataError._(
      'IMAGE_MIME_TYPE_INVALID',
      (args) => 'Recognized image format ${_q(args[0])} does not match '
          'declared image format ${_q(args[1])}.');

  static final DataError imageUnexpectedEos = DataError._(
      'IMAGE_UNEXPECTED_EOS', (args) => 'Unexpected end of image stream.');

  static final DataError imageUnrecognizedFormat = DataError._(
      'IMAGE_UNRECOGNIZED_FORMAT',
      (args) => 'Image format not recognized.',
      Severity.Warning);

  static final DataError imageNonEnabledMimeType = DataError._(
      'IMAGE_NON_ENABLED_MIME_TYPE',
      (args) => '${_q(args[0])} MIME type requires an extension.');

  static final DataError imageNonPowerOfTwoDimensions = DataError._(
      'IMAGE_NPOT_DIMENSIONS',
      (args) => 'Image has non-power-of-two dimensions: ${args[0]}x${args[1]}.',
      Severity.Information);

  static final DataError imageFeaturesUnsupported = DataError._(
      'IMAGE_FEATURES_UNSUPPORTED',
      (args) => 'Image contains unsupported features like non-default '
          'colorspace information, non-square pixels, or animation.',
      Severity.Warning);

  static final DataError uriGlb = DataError._('URI_GLB',
      (args) => 'URI is used in GLB container.', Severity.Information);

  static final DataError dataUriGlb = DataError._('DATA_URI_GLB',
      (args) => 'Data URI is used in GLB container.', Severity.Warning);

  static final DataError accessorJointsIndexOob = DataError._(
      'ACCESSOR_JOINTS_INDEX_OOB',
      (args) => 'Joints accessor element at index ${args[0]} '
          '(component index ${args[1]}) has value ${args[2]} that is greater '
          'than the maximum joint index (${args[3]}) set by skin ${args[4]}.');

  static final DataError accessorJointsIndexDuplicate = DataError._(
      'ACCESSOR_JOINTS_INDEX_DUPLICATE',
      (args) => 'Joints accessor element at index ${args[0]} '
          '(component index ${args[1]}) has value ${args[2]} that is already '
          'in use for the vertex.');

  static final DataError accessorWeightsNegative = DataError._(
      'ACCESSOR_WEIGHTS_NEGATIVE',
      (args) => 'Weights accessor element at index ${args[0]} '
          '(component index ${args[1]}) has negative value ${args[2]}.');

  static final DataError accessorWeightsNonNormalized = DataError._(
      'ACCESSOR_WEIGHTS_NON_NORMALIZED',
      (args) => 'Weights accessor elements (at indices ${args[0]}..${args[1]}) '
          'have non-normalized sum: ${args[2]}.');

  static final DataError accessorJointsUsedZeroWeight = DataError._(
      'ACCESSOR_JOINTS_USED_ZERO_WEIGHT',
      (args) => 'Joints accessor element at index ${args[0]} '
          '(component index ${args[1]}) is used with zero weight but has '
          'non-zero value (${args[2]}).',
      Severity.Warning);

  DataError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

class IoError extends IssueType {
  static final IoError ioError =
      IoError._('IO_ERROR', (args) => args[0].toString());

  IoError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

class SchemaError extends IssueType {
  static final SchemaError arrayLengthNotInList = SchemaError._(
      'ARRAY_LENGTH_NOT_IN_LIST',
      (args) => 'Invalid array length ${args[0]}. '
          'Valid lengths are: ${(args[1] as Iterable).map(_mbq)}.');

  static final SchemaError arrayTypeMismatch = SchemaError._(
      'ARRAY_TYPE_MISMATCH',
      (args) => 'Type mismatch. '
          'Array element ${_mbq(args[0])} is not a ${_q(args[1])}.');

  static final SchemaError arrayDuplicateElements =
      SchemaError._('DUPLICATE_ELEMENTS', (args) => 'Duplicate element.');

  static final SchemaError invalidIndex = SchemaError._(
      'INVALID_INDEX', (_) => 'Index must be a non-negative integer.');

  static final SchemaError invalidJson = SchemaError._(
      'INVALID_JSON', (args) => 'Invalid JSON data. Parser output: ${args[0]}');

  static final SchemaError invalidUri = SchemaError._('INVALID_URI',
      (args) => 'Invalid URI ${_q(args[0])}. Parser output:\n${args[1]}');

  static final SchemaError emptyEntity =
      SchemaError._('EMPTY_ENTITY', (args) => 'Entity cannot be empty.');

  static final SchemaError oneOfMismatch = SchemaError._('ONE_OF_MISMATCH',
      (args) => 'Exactly one of ${args.map(_q)} properties must be defined.');

  static final SchemaError patternMismatch = SchemaError._(
      'PATTERN_MISMATCH',
      (args) =>
          'Value ${_q(args[0])} does not match regexp pattern ${_q(args[1])}.');

  static final SchemaError typeMismatch = SchemaError._(
      'TYPE_MISMATCH',
      (args) => 'Type mismatch. '
          'Property value ${_mbq(args[0])} is not a ${_q(args[1])}.');

  static final SchemaError valueNotInList = SchemaError._(
      'VALUE_NOT_IN_LIST',
      (args) => 'Invalid value ${_mbq(args[0])}. '
          'Valid values are ${(args[1] as Iterable).map(_mbq)}.',
      Severity.Warning);

  static final SchemaError valueNotInRange = SchemaError._(
      'VALUE_NOT_IN_RANGE', (args) => 'Value ${args[0]} is out of range.');

  static final SchemaError valueMultipleOf = SchemaError._('VALUE_MULTIPLE_OF',
      (args) => 'Value ${args[0]} is not a multiple of ${args[1]}.');

  static final SchemaError undefinedProperty = SchemaError._(
      'UNDEFINED_PROPERTY',
      (args) => 'Property ${_q(args[0])} must be defined.');

  static final SchemaError unexpectedProperty = SchemaError._(
      'UNEXPECTED_PROPERTY',
      (args) => 'Unexpected property.',
      Severity.Warning);

  static final SchemaError unsatisfiedDependency = SchemaError._(
      'UNSATISFIED_DEPENDENCY',
      (args) => 'Dependency failed. ${_q(args[0])} must be defined.');

  SchemaError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

class SemanticError extends IssueType {
  static final SemanticError unknownAssetMajorVersion = SemanticError._(
      'UNKNOWN_ASSET_MAJOR_VERSION',
      (args) => 'Unknown glTF major asset version: ${args[0]}.');

  static final SemanticError unknownAssetMinorVersion = SemanticError._(
      'UNKNOWN_ASSET_MINOR_VERSION',
      (args) => 'Unknown glTF minor asset version: ${args[0]}.',
      Severity.Warning);

  static final SemanticError minVersionGreaterThanVersion = SemanticError._(
      'ASSET_MIN_VERSION_GREATER_THAN_VERSION',
      (args) => 'Asset minVersion ${_q(args[0])} is greater '
          'than version ${_q(args[1])}.');

  static final SemanticError invalidGlValue = SemanticError._(
      'INVALID_GL_VALUE',
      (args) => 'Invalid value ${args[0]} for GL type ${_q(args[1])}.');

  static final SemanticError accessorNormalizedInvalid = SemanticError._(
      'ACCESSOR_NORMALIZED_INVALID',
      (args) => 'Only (u)byte and (u)short accessors can be normalized.');

  static final SemanticError accessorOffsetAlignment = SemanticError._(
      'ACCESSOR_OFFSET_ALIGNMENT',
      (args) => 'Offset ${args[0]} is not a multiple of '
          'componentType length ${args[1]}.');

  static final SemanticError accessorMatrixAlignment = SemanticError._(
      'ACCESSOR_MATRIX_ALIGNMENT',
      (args) => 'Matrix accessors must be aligned to 4-byte boundaries.');

  static final SemanticError accessorSparseCountOutOfRange = SemanticError._(
      'ACCESSOR_SPARSE_COUNT_OUT_OF_RANGE',
      (args) => 'Sparse accessor overrides more elements (${args[0]}) '
          'than the base accessor contains (${args[1]}).');

  static final SemanticError animationChannelTargetNodeSkin = SemanticError._(
      'ANIMATION_CHANNEL_TARGET_NODE_SKIN',
      (args) => 'Animated TRS properties will not affect a skinned mesh.',
      Severity.Warning);

  static final SemanticError bufferDataUriMimeTypeInvalid = SemanticError._(
      'BUFFER_DATA_URI_MIME_TYPE_INVALID',
      (args) => "Data URI media type must be 'application/octet-stream' "
          "or 'application/gltf-buffer'. Found ${_q(args[0])} instead.");

  static final SemanticError bufferViewTooBigByteStride = SemanticError._(
      'BUFFER_VIEW_TOO_BIG_BYTE_STRIDE',
      (args) => "Buffer view's byteStride (${args[0]}) is "
          'greater than byteLength (${args[1]}).');

  static final SemanticError bufferViewInvalidByteStride = SemanticError._(
      'BUFFER_VIEW_INVALID_BYTE_STRIDE',
      (args) => 'Only buffer views with raw vertex data can have byteStride.');

  static final SemanticError cameraXmagYmagNegative = SemanticError._(
      'CAMERA_XMAG_YMAG_NEGATIVE',
      (args) => 'xmag and ymag should not be negative.',
      Severity.Warning);

  static final SemanticError cameraXmagYmagZero = SemanticError._(
      'CAMERA_XMAG_YMAG_ZERO', (args) => 'xmag and ymag must not be zero.');

  static final SemanticError cameraYFovGequalPi = SemanticError._(
      'CAMERA_YFOV_GEQUAL_PI',
      (args) => 'yfov should be less than Pi.',
      Severity.Warning);

  static final SemanticError cameraZfarLequalZnear = SemanticError._(
      'CAMERA_ZFAR_LEQUAL_ZNEAR', (args) => 'zfar must be greater than znear.');

  static final SemanticError materialAlphaCutoffInvalidMode = SemanticError._(
      'MATERIAL_ALPHA_CUTOFF_INVALID_MODE',
      (args) => "Alpha cutoff is supported only for 'MASK' alpha mode.",
      Severity.Warning);

  static final SemanticError meshPrimitiveInvalidAttribute = SemanticError._(
      'MESH_PRIMITIVE_INVALID_ATTRIBUTE', (args) => 'Invalid attribute name.');

  static final SemanticError meshPrimitivesUnequalTargetsCount =
      SemanticError._(
          'MESH_PRIMITIVES_UNEQUAL_TARGETS_COUNT',
          (args) =>
              'All primitives must have the same number of morph targets.');

  static final SemanticError meshPrimitiveNoPosition = SemanticError._(
      'MESH_PRIMITIVE_NO_POSITION',
      (args) => 'No POSITION attribute found.',
      Severity.Warning);

  static final SemanticError meshPrimitiveIndexedSemanticContinuity =
      SemanticError._(
          'MESH_PRIMITIVE_INDEXED_SEMANTIC_CONTINUITY',
          (args) => 'Indices for indexed attribute semantic ${_q(args[0])} '
              'must start with 0 and be continuous. '
              'Total expected indices: ${args[1]}, '
              'total provided indices: ${args[2]}.');

  static final SemanticError meshPrimitiveTangentWithoutNormal =
      SemanticError._(
          'MESH_PRIMITIVE_TANGENT_WITHOUT_NORMAL',
          (args) => 'TANGENT attribute without NORMAL found.',
          Severity.Warning);

  static final SemanticError meshPrimitiveJointsWeightsMismatch =
      SemanticError._(
          'MESH_PRIMITIVE_JOINTS_WEIGHTS_MISMATCH',
          (args) => 'Number of JOINTS attribute semantics (${args[0]}) '
              'does not match the number of WEIGHTS (${args[1]}).');

  static final SemanticError meshInvalidWeightsCount = SemanticError._(
      'MESH_INVALID_WEIGHTS_COUNT',
      (args) => 'The length of weights array (${args[0]}) does not match '
          'the number of morph targets (${args[1]}).');

  static final SemanticError nodeMatrixTrs = SemanticError._(
      'NODE_MATRIX_TRS',
      (args) => 'A node can have either a matrix or any combination of '
          'translation/rotation/scale (TRS) properties.');

  static final SemanticError nodeDefaultMatrix = SemanticError._(
      'NODE_MATRIX_DEFAULT',
      (args) => 'Do not specify default transform matrix.',
      Severity.Information);

  static final SemanticError nodeNonTrsMatrix = SemanticError._(
      'NODE_MATRIX_NON_TRS', (args) => 'Matrix must be decomposable to TRS.');

  static final SemanticError rotationNonUnit = SemanticError._(
      'ROTATION_NON_UNIT', (args) => 'Rotation quaternion must be normalized.');

  static final SemanticError unusedExtensionRequired = SemanticError._(
      'UNUSED_EXTENSION_REQUIRED',
      (args) => 'Unused extension ${_q(args[0])} cannot be required.');

  static final SemanticError nonRequiredExtension = SemanticError._(
      'NON_REQUIRED_EXTENSION',
      (args) => 'Extension ${_q(args[0])} cannot be optional.');

  static final SemanticError unreservedExtensionPrefix = SemanticError._(
      'UNRESERVED_EXTENSION_PREFIX',
      (args) => 'Extension uses unreserved extension prefix ${_q(args[0])}.',
      Severity.Warning);

  static final SemanticError invalidExtensionNameFormat = SemanticError._(
      'INVALID_EXTENSION_NAME_FORMAT',
      (args) => 'Extension name has invalid format.',
      Severity.Warning);

  static final SemanticError nodeEmpty = SemanticError._(
      'NODE_EMPTY', (args) => 'Empty node encountered.', Severity.Information);

  static final SemanticError nodeSkinnedMeshNonRoot = SemanticError._(
      'NODE_SKINNED_MESH_NON_ROOT',
      (args) => 'Node with a skinned mesh is not root. '
          'Parent transforms will not affect a skinned mesh.',
      Severity.Warning);

  static final SemanticError nodeSkinnedMeshLocalTransforms = SemanticError._(
      'NODE_SKINNED_MESH_LOCAL_TRANSFORMS',
      (args) => 'Local transforms will not affect a skinned mesh.',
      Severity.Warning);

  static final SemanticError nodeSkinNoScene = SemanticError._(
      'NODE_SKIN_NO_SCENE',
      (args) => 'A node with a skinned mesh is used in a scene that does not '
          'contain joint nodes.');

  static final SemanticError skinNoCommonRoot = SemanticError._(
      'SKIN_NO_COMMON_ROOT', (args) => 'Joints do not have a common root.');

  static final SemanticError skinSkeletonInvalid = SemanticError._(
      'SKIN_SKELETON_INVALID', (args) => 'Skeleton node is not a common root.');

  static final SemanticError nonRelativeUri = SemanticError._(
      'NON_RELATIVE_URI',
      (args) => 'Non-relative URI found: ${_q(args[0])}.',
      Severity.Warning);

  static final SemanticError multipleExtensions = SemanticError._(
      'MULTIPLE_EXTENSIONS',
      (args) => 'This extension may be incompatible '
          'with other extensions for the object.',
      Severity.Warning);

  static final SemanticError nonObjectExtras = SemanticError._(
      'NON_OBJECT_EXTRAS',
      (args) => 'Prefer JSON Objects for extras.',
      Severity.Information);

  static final SemanticError sharesNodeWith = SemanticError._(
      'SHARES_NODE_WITH',
      (args) => '${args[0]} must be on its own glTF node, '
          'it cannot be on the same glTF node as ${args[1]}.'
          '${args.length > 2 ? ' Move the ${args[2]} to a child node.' : ''}',
      Severity.Error);

  static final SemanticError extraProperty = SemanticError._(
      'EXTRA_PROPERTY',
      (args) => 'This property should not be defined as it will not be used.',
      Severity.Information);

  static final SemanticError khrLightsPunctualLightSpotAngles = SemanticError._(
      'KHR_LIGHTS_PUNCTUAL_LIGHT_SPOT_ANGLES',
      (args) => 'outerConeAngle (${args[1]}) is less than or equal to '
          'innerConeAngle (${args[0]}).');

  static final SemanticError khrMaterialsEmissiveStrengthZeroFactor =
      SemanticError._(
          'KHR_MATERIALS_EMISSIVE_STRENGTH_ZERO_FACTOR',
          (args) => 'Emissive strength has no effect '
              'when the emissive factor is zero or undefined.',
          Severity.Warning);

  static final SemanticError khrMaterialsVolumeNoTransmission = SemanticError._(
      'KHR_MATERIALS_VOLUME_NO_TRANSMISSION',
      (args) => 'The volume extension needs to be combined with an extension '
          'that allows light to transmit through the surface.',
      Severity.Warning);

  static final SemanticError khrMaterialsVolumeDoubleSided = SemanticError._(
      'KHR_MATERIALS_VOLUME_DOUBLE_SIDED',
      (args) => 'The volume extension should not be used '
          'with double-sided materials.',
      Severity.Warning);

  static final SemanticError
      khrMaterialsIridescenceThicknessRangeWithoutTexture = SemanticError._(
          'KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_WITHOUT_TEXTURE',
          (args) => 'Thickness minimum has no effect '
              'when a thickness texture is not defined.',
          Severity.Information);

  static final SemanticError khrMaterialsIridescenceThicknessRangeInvalid =
      SemanticError._(
          'KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_INVALID',
          (args) => 'Thickness maximum must be greater than or '
              'equal to the thickness minimum.');

  static final SemanticError khrMaterialsIridescenceThicknessTextureUnused =
      SemanticError._(
          'KHR_MATERIALS_IRIDESCENCE_THICKNESS_TEXTURE_UNUSED',
          (args) => 'Thickness texture has no effect when the thickness '
              'minimum is equal to the thickness maximum.',
          Severity.Information);

  static final SemanticError omiColliderInvalidCapsuleHeight =
      SemanticError._(
          'OMI_COLLIDER_INVALID_CAPSULE_HEIGHT',
          (args) => 'The capsule height must be at least twice the radius.',
          Severity.Error);

  static final SemanticError omiColliderTrimeshTrigger =
      SemanticError._(
          'OMI_COLLIDER_TRIMESH_TRIGGER',
          (args) => 'This collider is both a trimesh and a trigger. This '
              'is valid but not recommended since trimeshes do not have an '
              'interior volume and the trigger may not work as expected.',
          Severity.Information);

  static final SemanticError omiPhysicsBodyMissingCollider =
      SemanticError._(
          'OMI_PHYSICS_BODY_MISSING_COLLIDER',
          (args) => 'This physics body does not have any colliders. '
              'This is valid but body will not collide with anything.',
          Severity.Information);

  static final SemanticError omiPhysicsBodyInvalidInertiaTensor =
      SemanticError._(
          'OMI_PHYSICS_BODY_INVALID_INERTIA_TENSOR',
          (args) => 'This physics body has an invalid inertia tensor. '
              'The inertia tensor must be a symmetric 3x3 matrix.',
          Severity.Error);

  SemanticError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

class LinkError extends IssueType {
  static final LinkError accessorTotalOffsetAlignment = LinkError._(
      'ACCESSOR_TOTAL_OFFSET_ALIGNMENT',
      (args) => "Accessor's total byteOffset ${args[0]} isn't a multiple of "
          'componentType length ${args[1]}.');

  static final LinkError accessorSmallStride = LinkError._(
      'ACCESSOR_SMALL_BYTESTRIDE',
      (args) =>
          "Referenced bufferView's byteStride value ${args[0]} is less than "
          "accessor element's length ${args[1]}.");

  static final LinkError accessorTooLong = LinkError._(
      'ACCESSOR_TOO_LONG',
      (args) =>
          'Accessor (offset: ${args[0]}, length: ${args[1]}) does not fit '
          'referenced bufferView [${args[2]}] length ${args[3]}.');

  static final LinkError accessorUsageOverride = LinkError._(
      'ACCESSOR_USAGE_OVERRIDE',
      (args) => 'Override of previously set accessor usage. '
          'Initial: ${_q(args[0])}, new: ${_q(args[1])}.');

  static final LinkError animationDuplicateTargets = LinkError._(
      'ANIMATION_DUPLICATE_TARGETS',
      (args) => 'Animation channel has the same target as channel ${args[0]}.');

  static final LinkError animationChannelTargetNodeMatrix = LinkError._(
      'ANIMATION_CHANNEL_TARGET_NODE_MATRIX',
      (args) => 'Animation channel cannot target TRS properties '
          'of a node with defined matrix.');

  static final LinkError animationChannelTargetNodeWeightsNoMorphs =
      LinkError._(
          'ANIMATION_CHANNEL_TARGET_NODE_WEIGHTS_NO_MORPHS',
          (args) => 'Animation channel cannot target WEIGHTS when mesh '
              'does not have morph targets.');

  static final LinkError animationSamplerInputAccessorWithoutBounds =
      LinkError._(
          'ANIMATION_SAMPLER_INPUT_ACCESSOR_WITHOUT_BOUNDS',
          (args) => 'accessor.min and accessor.max must be defined for '
              'animation input accessor.');

  static final LinkError animationSamplerInputAccessorInvalidFormat =
      LinkError._(
          'ANIMATION_SAMPLER_INPUT_ACCESSOR_INVALID_FORMAT',
          (args) =>
              'Invalid Animation sampler input accessor format ${_q(args[0])}. '
              'Must be one of ${(args[1] as Iterable).map(_q)}.');

  static final LinkError animationSamplerOutputAccessorInvalidFormat =
      LinkError._(
          'ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_FORMAT',
          (args) => 'Invalid animation sampler output accessor format '
              '${_q(args[0])} for path ${_q(args[2])}. '
              'Must be one of ${(args[1] as Iterable).map(_q)}.');

  static final LinkError animationSamplerInputAccessorTooFewElements =
      LinkError._(
          'ANIMATION_SAMPLER_INPUT_ACCESSOR_TOO_FEW_ELEMENTS',
          (args) => 'Animation sampler output accessor with ${_q(args[0])} '
              'interpolation must have at least ${args[1]} elements. '
              'Got ${args[2]}.');

  static final LinkError animationSamplerOutputAccessorInvalidCount =
      LinkError._(
          'ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_COUNT',
          (args) => 'Animation sampler output accessor of count '
              '${args[0]} expected. Found ${args[1]}.');

  static final LinkError animationSamplerAccessorWithByteStride = LinkError._(
      'ANIMATION_SAMPLER_ACCESSOR_WITH_BYTESTRIDE',
      (args) => 'bufferView.byteStride must not be defined for '
          'buffer views used by animation sampler accessors.');

  static final LinkError bufferMissingGlbData = LinkError._(
      'BUFFER_MISSING_GLB_DATA',
      (args) => 'Buffer refers to an unresolved GLB binary chunk.');

  static final LinkError bufferViewTooLong = LinkError._(
      'BUFFER_VIEW_TOO_LONG',
      (args) => 'BufferView does not fit buffer '
          '(${args[0]}) byteLength (${args[1]}).');

  static final LinkError bufferViewTargetOverride = LinkError._(
      'BUFFER_VIEW_TARGET_OVERRIDE',
      (args) => 'Override of previously set bufferView target or usage. '
          'Initial: ${_q(args[0])}, new: ${_q(args[1])}.');

  static final LinkError bufferViewTargetMissing = LinkError._(
      'BUFFER_VIEW_TARGET_MISSING',
      (args) => 'bufferView.target should be set for vertex or index data.',
      Severity.Hint);

  static final LinkError imageBufferViewWithByteStride = LinkError._(
      'IMAGE_BUFFER_VIEW_WITH_BYTESTRIDE',
      (args) => 'bufferView.byteStride must not be defined for '
          'buffer views containing image data.');

  static final LinkError invalidIbmAccessorCount = LinkError._(
      'INVALID_IBM_ACCESSOR_COUNT',
      (args) => 'IBM accessor must have at least ${args[0]} elements.'
          ' Found ${args[1]}.');

  static final LinkError meshPrimitiveAttributesAccessorInvalidFormat =
      LinkError._(
          'MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_INVALID_FORMAT',
          (args) => 'Invalid accessor format ${_q(args[0])} '
              'for this attribute semantic. '
              'Must be one of ${(args[1] as Iterable).map(_q)}.');

  static final LinkError meshPrimitiveAttributesAccessorUnsignedInt =
      LinkError._('MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_UNSIGNED_INT',
          (args) => 'Mesh attributes cannot use UNSIGNED_INT component type.');

  static final LinkError meshPrimitivePositionAccessorWithoutBounds =
      LinkError._(
          'MESH_PRIMITIVE_POSITION_ACCESSOR_WITHOUT_BOUNDS',
          (args) => 'accessor.min and accessor.max must be defined for '
              'POSITION attribute accessor.');

  static final LinkError meshPrimitiveAccessorWithoutByteStride = LinkError._(
      'MESH_PRIMITIVE_ACCESSOR_WITHOUT_BYTESTRIDE',
      (args) => 'bufferView.byteStride must be defined when '
          'two or more accessors use the same buffer view.');

  static final LinkError meshPrimitiveAccessorUnaligned = LinkError._(
      'MESH_PRIMITIVE_ACCESSOR_UNALIGNED',
      (args) => 'Vertex attribute data must be aligned to 4-byte boundaries.');

  static final LinkError meshPrimitiveIndicesAccessorWithByteStride =
      LinkError._(
          'MESH_PRIMITIVE_INDICES_ACCESSOR_WITH_BYTESTRIDE',
          (args) => 'bufferView.byteStride must not be defined '
              'for indices accessor.');

  static final LinkError meshPrimitiveIndicesAccessorInvalidFormat =
      LinkError._(
          'MESH_PRIMITIVE_INDICES_ACCESSOR_INVALID_FORMAT',
          (args) => 'Invalid indices accessor format ${_q(args[0])}. '
              'Must be one of ${(args[1] as Iterable).map(_q)}. ');

  static final LinkError meshPrimitiveIncompatibleMode = LinkError._(
      'MESH_PRIMITIVE_INCOMPATIBLE_MODE',
      (args) => 'Number of vertices or indices (${args[0]}) '
          'is not compatible with used drawing mode (${_q(args[1])}).',
      Severity.Warning);

  static final LinkError meshPrimitiveTooFewTexcoords = LinkError._(
      'MESH_PRIMITIVE_TOO_FEW_TEXCOORDS',
      (args) => 'Material is incompatible with mesh primitive: '
          'Texture binding ${_q(args[0])} '
          "needs 'TEXCOORD_${args[1]}' attribute.");

  static final LinkError meshPrimitiveUnequalAccessorsCount = LinkError._(
      'MESH_PRIMITIVE_UNEQUAL_ACCESSOR_COUNT',
      (args) =>
          'All accessors of the same primitive must have the same count.');

  static final LinkError meshPrimitiveMorphTargetNoBaseAccessor = LinkError._(
      'MESH_PRIMITIVE_MORPH_TARGET_NO_BASE_ACCESSOR',
      (args) => 'The mesh primitive does not define this attribute semantic.');

  static final LinkError meshPrimitiveMorphTargetInvalidAttributeCount =
      LinkError._('MESH_PRIMITIVE_MORPH_TARGET_INVALID_ATTRIBUTE_COUNT',
          (args) => 'Base accessor has different count.');

  static final LinkError nodeLoop =
      LinkError._('NODE_LOOP', (args) => 'Node is a part of a node loop.');

  static final LinkError nodeParentOverride = LinkError._(
      'NODE_PARENT_OVERRIDE',
      (args) => 'Value overrides parent of node ${args[0]}.');

  static final LinkError nodeWeightsInvalid = LinkError._(
      'NODE_WEIGHTS_INVALID',
      (args) => 'The length of weights array (${args[0]}) does not match '
          'the number of morph targets (${args[1] ?? 0}).');

  static final LinkError nodeSkinWithNonSkinnedMesh = LinkError._(
      'NODE_SKIN_WITH_NON_SKINNED_MESH',
      (args) => 'Node has skin defined, but mesh has no joints data.');

  static final LinkError nodeSkinnedMeshWithoutSkin = LinkError._(
      'NODE_SKINNED_MESH_WITHOUT_SKIN',
      (args) => 'Node uses skinned mesh, but has no skin defined.',
      Severity.Warning);

  static final LinkError sceneNonRootNode = LinkError._(
      'SCENE_NON_ROOT_NODE', (args) => 'Node ${args[0]} is not a root node.');

  static final LinkError skinIbmInvalidFormat = LinkError._(
      'SKIN_IBM_INVALID_FORMAT',
      (args) => 'Invalid IBM accessor format ${_q(args[0])}. '
          'Must be one of ${(args[1] as Iterable).map(_q)}. ');

  static final LinkError skinIbmAccessorWithByteStride = LinkError._(
      'SKIN_IBM_ACCESSOR_WITH_BYTESTRIDE',
      (args) => 'bufferView.byteStride must not be defined for '
          'buffer views used by inverse bind matrices accessors.');

  static final LinkError textureInvalidImageMimeType = LinkError._(
      'TEXTURE_INVALID_IMAGE_MIME_TYPE',
      (args) => 'Invalid MIME type ${_q(args[0])} for the texture '
          'source. Valid MIME types are ${(args[1] as Iterable).map(_q)}.');

  static final LinkError undeclaredExtension = LinkError._(
      'UNDECLARED_EXTENSION',
      (args) => 'Extension is not declared in extensionsUsed.');

  static final LinkError unexpectedExtensionObject = LinkError._(
      'UNEXPECTED_EXTENSION_OBJECT',
      (args) => 'Unexpected location for this extension.');

  static final LinkError unresolvedReference = LinkError._(
      'UNRESOLVED_REFERENCE', (args) => 'Unresolved reference: ${args[0]}.');

  static final LinkError unsupportedExtension = LinkError._(
      'UNSUPPORTED_EXTENSION',
      (args) => 'Cannot validate an extension as it is not supported '
          'by the validator: ${_q(args[0])}.',
      Severity.Information);

  static final LinkError unusedObject = LinkError._('UNUSED_OBJECT',
      (args) => 'This object may be unused.', Severity.Information);

  static final LinkError unusedMeshWeights = LinkError._(
      'UNUSED_MESH_WEIGHTS',
      (args) => 'The static morph target weights are always overridden.',
      Severity.Information);

  static final LinkError unusedMeshTangent = LinkError._(
      'UNUSED_MESH_TANGENT',
      (args) =>
          'Tangents are not used because the material has no normal texture.',
      Severity.Information);

  static final LinkError khrMaterialsVariantsNonUniqueVariant = LinkError._(
      'KHR_MATERIALS_VARIANTS_NON_UNIQUE_VARIANT',
      (args) => 'This variant is used more than once for this mesh primitive.');

  LinkError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

class GlbError extends IssueType {
  static final GlbError invalidMagic = GlbError._(
      'GLB_INVALID_MAGIC', (args) => 'Invalid GLB magic value (${args[0]}).');

  static final GlbError invalidVersion = GlbError._(
      'GLB_INVALID_VERSION', (args) => 'Invalid GLB version value ${args[0]}.');

  static final GlbError lengthTooSmall = GlbError._('GLB_LENGTH_TOO_SMALL',
      (args) => 'Declared GLB length (${args[0]}) is too small.');

  static final GlbError chunkLengthUnaligned = GlbError._(
      'GLB_CHUNK_LENGTH_UNALIGNED',
      (args) =>
          'Length of ${args[0]} chunk is not aligned to 4-byte boundaries.');

  static final GlbError lengthMismatch = GlbError._(
      'GLB_LENGTH_MISMATCH',
      (args) => 'Declared length (${args[0]}) does not match '
          'GLB length (${args[1]}).');

  static final GlbError chunkTooBig = GlbError._(
      'GLB_CHUNK_TOO_BIG',
      (args) => 'Chunk (${args[0]}) length (${args[1]}) does not fit '
          'total GLB length.');

  static final GlbError emptyChunk = GlbError._('GLB_EMPTY_CHUNK',
      (args) => 'Chunk (${args[0]}) cannot have zero length.');

  static final GlbError emptyBinChunk = GlbError._('GLB_EMPTY_BIN_CHUNK',
      (args) => 'Empty BIN chunk should be omitted.', Severity.Information);

  static final GlbError duplicateChunk = GlbError._('GLB_DUPLICATE_CHUNK',
      (args) => 'Chunk of type ${args[0]} has already been used.');

  static final GlbError unexpectedEndOfChunkHeader = GlbError._(
      'GLB_UNEXPECTED_END_OF_CHUNK_HEADER',
      (args) => 'Unexpected end of chunk header.');

  static final GlbError unexpectedEndOfChunkData = GlbError._(
      'GLB_UNEXPECTED_END_OF_CHUNK_DATA',
      (args) => 'Unexpected end of chunk data.');

  static final GlbError unexpectedEndOfHeader = GlbError._(
      'GLB_UNEXPECTED_END_OF_HEADER', (args) => 'Unexpected end of header.');

  static final GlbError unexpectedFirstChunk = GlbError._(
      'GLB_UNEXPECTED_FIRST_CHUNK',
      (args) => 'First chunk must be of JSON type. Found ${args[0]} instead.');

  static final GlbError unexpectedBinChunk = GlbError._(
      'GLB_UNEXPECTED_BIN_CHUNK',
      (args) => 'BIN chunk must be the second chunk.');

  static final GlbError unknownChunkType = GlbError._('GLB_UNKNOWN_CHUNK_TYPE',
      (args) => 'Unknown GLB chunk type: ${args[0]}.', Severity.Warning);

  static final GlbError extraData = GlbError._('GLB_EXTRA_DATA',
      (args) => 'Extra data after the end of GLB stream.', Severity.Warning);

  GlbError._(String type, ErrorFunction message,
      [Severity severity = Severity.Error])
      : super(type, message, severity);
}

@immutable
class Issue {
  final IssueType type;
  final Severity severityOverride;
  final String pointer;
  final int offset;
  final List _args;

  const Issue(this.type, this._args,
      {this.pointer, this.offset, this.severityOverride})
      : assert((pointer == null) ^ (offset == null));

  String get message =>
      (type.message != null) ? type.message(_args).trimRight() : type.code;

  Severity get severity => severityOverride ?? type.severity;

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) =>
      other is Issue && other.toString() == toString();

  Map<String, Object> toMap() {
    final map = <String, Object>{
      'code': type.code,
      'message': message,
      'severity': severity.index
    };

    if (pointer != null) {
      map['pointer'] = pointer;
    } else if (offset != null) {
      map['offset'] = offset;
    }

    return map;
  }

  @override
  String toString() {
    if (pointer != null && pointer.isNotEmpty) {
      return '$pointer: $message';
    }

    if (offset != null) {
      return '@$offset: $message';
    }

    return message;
  }
}

String _q(Object o) => "'$o'";

String _mbq(Object o) => o is String ? "'$o'" : o.toString();
