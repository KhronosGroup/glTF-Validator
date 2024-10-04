# glTF 2.0 Validation Issues
## IoError
| Code | Message | Severity |
|------|---------|----------|
|IO_ERROR|`%1`|Error|
## SchemaError
| Code | Message | Severity |
|------|---------|----------|
|ARRAY_LENGTH_NOT_IN_LIST|Invalid array length `%1`. Valid lengths are: ('`%a`', '`%b`', '`%c`').|Error|
|ARRAY_TYPE_MISMATCH|Type mismatch. Array element '`%1`' is not a '`%2`'.|Error|
|DUPLICATE_ELEMENTS|Duplicate element.|Error|
|EMPTY_ENTITY|Entity cannot be empty.|Error|
|INVALID_INDEX|Index must be a non-negative integer.|Error|
|INVALID_JSON|Invalid JSON data. Parser output: `%1`|Error|
|INVALID_URI|Invalid URI '`%1`'. Parser output: `%2`|Error|
|ONE_OF_MISMATCH|Exactly one of ('`%1`', '`%2`', '`%3`', '`%4`', '`%5`') properties must be defined.|Error|
|PATTERN_MISMATCH|Value '`%1`' does not match regexp pattern '`%2`'.|Error|
|TYPE_MISMATCH|Type mismatch. Property value '`%1`' is not a '`%2`'.|Error|
|UNDEFINED_PROPERTY|Property '`%1`' must be defined.|Error|
|UNEXPECTED_PROPERTY|Unexpected property.|Warning|
|UNSATISFIED_DEPENDENCY|Dependency failed. '`%1`' must be defined.|Error|
|VALUE_MULTIPLE_OF|Value `%1` is not a multiple of `%2`.|Error|
|VALUE_NOT_IN_LIST|Invalid value '`%1`'. Valid values are ('`%a`', '`%b`', '`%c`').|Warning|
|VALUE_NOT_IN_RANGE|Value `%1` is out of range.|Error|
## SemanticError
| Code | Message | Severity |
|------|---------|----------|
|ACCESSOR_MATRIX_ALIGNMENT|Matrix accessors must be aligned to 4-byte boundaries.|Error|
|ACCESSOR_NORMALIZED_INVALID|Only (u)byte and (u)short accessors can be normalized.|Error|
|ACCESSOR_OFFSET_ALIGNMENT|Offset `%1` is not a multiple of componentType length `%2`.|Error|
|ACCESSOR_SPARSE_COUNT_OUT_OF_RANGE|Sparse accessor overrides more elements (`%1`) than the base accessor contains (`%2`).|Error|
|ANIMATION_CHANNEL_TARGET_NODE_SKIN|Animated TRS properties will not affect a skinned mesh.|Warning|
|ASSET_MIN_VERSION_GREATER_THAN_VERSION|Asset minVersion '`%1`' is greater than version '`%2`'.|Error|
|BUFFER_DATA_URI_MIME_TYPE_INVALID|Data URI media type must be 'application/octet-stream' or 'application/gltf-buffer'. Found '`%1`' instead.|Error|
|BUFFER_VIEW_INVALID_BYTE_STRIDE|Only buffer views with raw vertex data can have byteStride.|Error|
|BUFFER_VIEW_TOO_BIG_BYTE_STRIDE|Buffer view's byteStride (`%1`) is greater than byteLength (`%2`).|Error|
|CAMERA_XMAG_YMAG_NEGATIVE|xmag and ymag should not be negative.|Warning|
|CAMERA_XMAG_YMAG_ZERO|xmag and ymag must not be zero.|Error|
|CAMERA_YFOV_GEQUAL_PI|yfov should be less than Pi.|Warning|
|CAMERA_ZFAR_LEQUAL_ZNEAR|zfar must be greater than znear.|Error|
|EXTRA_PROPERTY|This property should not be defined as it will not be used.|Information|
|INVALID_EXTENSION_NAME_FORMAT|Extension name has invalid format.|Warning|
|INVALID_GL_VALUE|Invalid value `%1` for GL type '`%2`'.|Error|
|KHR_ANIMATION_POINTER_ANIMATION_CHANNEL_TARGET_NODE|This extension requires the animation channel target node to be undefined.|Error|
|KHR_ANIMATION_POINTER_ANIMATION_CHANNEL_TARGET_PATH|This extension requires the animation channel target path to be 'pointer'. Found '`%1`' instead.|Error|
|KHR_LIGHTS_PUNCTUAL_LIGHT_SPOT_ANGLES|outerConeAngle (`%2`) is less than or equal to innerConeAngle (`%1`).|Error|
|KHR_MATERIALS_ANISOTROPY_ANISOTROPY_TEXTURE_TEXCOORD|Normal and anisotropy textures should use the same texture coords.|Warning|
|KHR_MATERIALS_CLEARCOAT_CLEARCOAT_NORMAL_TEXTURE_TEXCOORD|Normal and clearcoat normal textures should use the same texture coords.|Warning|
|KHR_MATERIALS_DISPERSION_NO_VOLUME|The dispersion extension needs to be combined with the volume extension.|Warning|
|KHR_MATERIALS_EMISSIVE_STRENGTH_ZERO_FACTOR|Emissive strength has no effect when the emissive factor is zero or undefined.|Warning|
|KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_WITHOUT_TEXTURE|Thickness minimum has no effect when a thickness texture is not defined.|Information|
|KHR_MATERIALS_IRIDESCENCE_THICKNESS_TEXTURE_UNUSED|Thickness texture has no effect when the thickness minimum is equal to the thickness maximum.|Information|
|KHR_MATERIALS_VOLUME_DOUBLE_SIDED|The volume extension should not be used with double-sided materials.|Warning|
|KHR_MATERIALS_VOLUME_NO_TRANSMISSION|The volume extension needs to be combined with an extension that allows light to transmit through the surface.|Warning|
|MATERIAL_ALPHA_CUTOFF_INVALID_MODE|Alpha cutoff is supported only for 'MASK' alpha mode.|Warning|
|MESH_INVALID_WEIGHTS_COUNT|The length of weights array (`%1`) does not match the number of morph targets (`%2`).|Error|
|MESH_PRIMITIVES_UNEQUAL_TARGETS_COUNT|All primitives must have the same number of morph targets.|Error|
|MESH_PRIMITIVE_INDEXED_SEMANTIC_CONTINUITY|Indices for indexed attribute semantic '`%1`' must start with 0 and be continuous. Total expected indices: `%2`, total provided indices: `%3`.|Error|
|MESH_PRIMITIVE_INVALID_ATTRIBUTE|Invalid attribute name.|Error|
|MESH_PRIMITIVE_JOINTS_WEIGHTS_MISMATCH|Number of JOINTS attribute semantics (`%1`) does not match the number of WEIGHTS (`%2`).|Error|
|MESH_PRIMITIVE_NO_POSITION|No POSITION attribute found.|Warning|
|MESH_PRIMITIVE_TANGENT_WITHOUT_NORMAL|TANGENT attribute without NORMAL found.|Warning|
|MULTIPLE_EXTENSIONS|This extension may be incompatible with other extensions for the object.|Warning|
|NODE_EMPTY|Empty node encountered.|Information|
|NODE_MATRIX_DEFAULT|Do not specify default transform matrix.|Information|
|NODE_MATRIX_NON_TRS|Matrix must be decomposable to TRS.|Error|
|NODE_MATRIX_TRS|A node can have either a matrix or any combination of translation/rotation/scale (TRS) properties.|Error|
|NODE_SKINNED_MESH_LOCAL_TRANSFORMS|Local transforms will not affect a skinned mesh.|Warning|
|NODE_SKINNED_MESH_NON_ROOT|Node with a skinned mesh is not root. Parent transforms will not affect a skinned mesh.|Warning|
|NODE_SKIN_NO_SCENE|A node with a skinned mesh is used in a scene that does not contain joint nodes.|Error|
|NON_OBJECT_EXTRAS|Prefer JSON Objects for extras.|Information|
|NON_RELATIVE_URI|Non-relative URI found: '`%1`'.|Warning|
|NON_REQUIRED_EXTENSION|Extension '`%1`' cannot be optional.|Error|
|ROTATION_NON_UNIT|Rotation quaternion must be normalized.|Error|
|SKIN_NO_COMMON_ROOT|Joints do not have a common root.|Error|
|SKIN_SKELETON_INVALID|Skeleton node is not a common root.|Error|
|UNKNOWN_ASSET_MAJOR_VERSION|Unknown glTF major asset version: `%1`.|Error|
|UNKNOWN_ASSET_MINOR_VERSION|Unknown glTF minor asset version: `%1`.|Warning|
|UNUSED_EXTENSION_REQUIRED|Unused extension '`%1`' cannot be required.|Error|
## LinkError
| Code | Message | Severity |
|------|---------|----------|
|ACCESSOR_SMALL_BYTESTRIDE|Referenced bufferView's byteStride value `%1` is less than accessor element's length `%2`.|Error|
|ACCESSOR_TOO_LONG|Accessor (offset: `%1`, length: `%2`) does not fit referenced bufferView [`%3`] length `%4`.|Error|
|ACCESSOR_TOTAL_OFFSET_ALIGNMENT|Accessor's total byteOffset `%1` isn't a multiple of componentType length `%2`.|Error|
|ACCESSOR_USAGE_OVERRIDE|Override of previously set accessor usage. Initial: '`%1`', new: '`%2`'.|Error|
|ANIMATION_CHANNEL_TARGET_NODE_MATRIX|Animation channel cannot target TRS properties of a node with defined matrix.|Error|
|ANIMATION_CHANNEL_TARGET_NODE_WEIGHTS_NO_MORPHS|Animation channel cannot target WEIGHTS when mesh does not have morph targets.|Error|
|ANIMATION_DUPLICATE_TARGETS|Animation channel has the same target as channel `%1`.|Error|
|ANIMATION_SAMPLER_ACCESSOR_WITH_BYTESTRIDE|bufferView.byteStride must not be defined for buffer views used by animation sampler accessors.|Error|
|ANIMATION_SAMPLER_INPUT_ACCESSOR_INVALID_FORMAT|Invalid Animation sampler input accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|ANIMATION_SAMPLER_INPUT_ACCESSOR_TOO_FEW_ELEMENTS|Animation sampler output accessor with '`%1`' interpolation must have at least `%2` elements. Got `%3`.|Error|
|ANIMATION_SAMPLER_INPUT_ACCESSOR_WITHOUT_BOUNDS|accessor.min and accessor.max must be defined for animation input accessor.|Error|
|ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_COUNT|Animation sampler output accessor of count `%1` expected. Found `%2`.|Error|
|ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_FORMAT|Invalid animation sampler output accessor format '`%1`' for path '`%3`'. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|BUFFER_MISSING_GLB_DATA|Buffer refers to an unresolved GLB binary chunk.|Error|
|BUFFER_VIEW_TARGET_MISSING|bufferView.target should be set for vertex or index data.|Hint|
|BUFFER_VIEW_TARGET_OVERRIDE|Override of previously set bufferView target or usage. Initial: '`%1`', new: '`%2`'.|Error|
|BUFFER_VIEW_TOO_LONG|BufferView does not fit buffer (`%1`) byteLength (`%2`).|Error|
|IMAGE_BUFFER_VIEW_WITH_BYTESTRIDE|bufferView.byteStride must not be defined for buffer views containing image data.|Error|
|INCOMPLETE_EXTENSION_SUPPORT|Validation support for this extension is incomplete; the asset may have undetected issues.|Information|
|INVALID_IBM_ACCESSOR_COUNT|IBM accessor must have at least `%1` elements. Found `%2`.|Error|
|KHR_MATERIALS_VARIANTS_NON_UNIQUE_VARIANT|This variant is used more than once for this mesh primitive.|Error|
|MESH_PRIMITIVE_ACCESSOR_UNALIGNED|Vertex attribute data must be aligned to 4-byte boundaries.|Error|
|MESH_PRIMITIVE_ACCESSOR_WITHOUT_BYTESTRIDE|bufferView.byteStride must be defined when two or more accessors use the same buffer view.|Error|
|MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_INVALID_FORMAT|Invalid accessor format '`%1`' for this attribute semantic. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_UNSIGNED_INT|Mesh attributes cannot use UNSIGNED_INT component type.|Error|
|MESH_PRIMITIVE_GENERATED_TANGENT_SPACE|Material requires a tangent space but the mesh primitive does not provide it. Runtime-generated tangent space may be non-portable across implementations.|Warning|
|MESH_PRIMITIVE_INCOMPATIBLE_MODE|Number of vertices or indices (`%1`) is not compatible with used drawing mode ('`%2`').|Warning|
|MESH_PRIMITIVE_INDICES_ACCESSOR_INVALID_FORMAT|Invalid indices accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`'). |Error|
|MESH_PRIMITIVE_INDICES_ACCESSOR_WITH_BYTESTRIDE|bufferView.byteStride must not be defined for indices accessor.|Error|
|MESH_PRIMITIVE_MORPH_TARGET_INVALID_ATTRIBUTE_COUNT|Base accessor has different count.|Error|
|MESH_PRIMITIVE_MORPH_TARGET_NO_BASE_ACCESSOR|The mesh primitive does not define this attribute semantic.|Error|
|MESH_PRIMITIVE_NO_TANGENT_SPACE|Material requires a tangent space but the mesh primitive does not provide it and the material does not contain a normal map to generate it.|Error|
|MESH_PRIMITIVE_POSITION_ACCESSOR_WITHOUT_BOUNDS|accessor.min and accessor.max must be defined for POSITION attribute accessor.|Error|
|MESH_PRIMITIVE_TOO_FEW_TEXCOORDS|Material is incompatible with mesh primitive: Texture binding '`%1`' needs 'TEXCOORD_`%2`' attribute.|Error|
|MESH_PRIMITIVE_UNEQUAL_ACCESSOR_COUNT|All accessors of the same primitive must have the same count.|Error|
|NODE_LOOP|Node is a part of a node loop.|Error|
|NODE_PARENT_OVERRIDE|Value overrides parent of node `%1`.|Error|
|NODE_SKINNED_MESH_WITHOUT_SKIN|Node uses skinned mesh, but has no skin defined.|Warning|
|NODE_SKIN_WITH_NON_SKINNED_MESH|Node has skin defined, but mesh has no joints data.|Error|
|NODE_WEIGHTS_INVALID|The length of weights array (`%1`) does not match the number of morph targets (`%2`).|Error|
|SCENE_NON_ROOT_NODE|Node `%1` is not a root node.|Error|
|SKIN_IBM_ACCESSOR_WITH_BYTESTRIDE|bufferView.byteStride must not be defined for buffer views used by inverse bind matrices accessors.|Error|
|SKIN_IBM_INVALID_FORMAT|Invalid IBM accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`'). |Error|
|TEXTURE_INVALID_IMAGE_MIME_TYPE|Invalid MIME type '`%1`' for the texture source. Valid MIME types are ('`%a`', '`%b`', '`%c`').|Error|
|UNDECLARED_EXTENSION|Extension is not declared in extensionsUsed.|Error|
|UNEXPECTED_EXTENSION_OBJECT|Unexpected location for this extension.|Error|
|UNRESOLVED_REFERENCE|Unresolved reference: `%1`.|Error|
|UNSUPPORTED_EXTENSION|Cannot validate an extension as it is not supported by the validator: '`%1`'.|Information|
|UNUSED_MESH_TANGENT|Tangents are not used because the material has no normal texture.|Information|
|UNUSED_MESH_WEIGHTS|The static morph target weights are always overridden.|Information|
|UNUSED_OBJECT|This object may be unused.|Information|
## DataError
| Code | Message | Severity |
|------|---------|----------|
|ACCESSOR_ANIMATION_INPUT_NEGATIVE|Animation input accessor element at index `%1` is negative: `%2`.|Error|
|ACCESSOR_ANIMATION_INPUT_NON_INCREASING|Animation input accessor element at index `%1` is less than or equal to previous: `%2` <= `%3`.|Error|
|ACCESSOR_ANIMATION_SAMPLER_OUTPUT_NON_NORMALIZED_QUATERNION|Animation sampler output accessor element at indices `%1`..`%2` is not of unit length: `%3`.|Error|
|ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND|Accessor contains `%1` element(s) greater than declared maximum value `%2`.|Error|
|ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND|Accessor contains `%1` element(s) less than declared minimum value `%2`.|Error|
|ACCESSOR_INDEX_OOB|Indices accessor element at index `%1` has value `%2` that is greater than the maximum vertex index available (`%3`).|Error|
|ACCESSOR_INDEX_PRIMITIVE_RESTART|Indices accessor contains primitive restart value (`%1`) at index `%2`.|Error|
|ACCESSOR_INDEX_TRIANGLE_DEGENERATE|Indices accessor contains `%1` degenerate triangles (out of `%2`).|Information|
|ACCESSOR_INVALID_FLOAT|Accessor element at index `%1` is `%2`.|Error|
|ACCESSOR_INVALID_IBM|Matrix element at index `%1` (component index `%2`) contains invalid value: `%3`.|Error|
|ACCESSOR_INVALID_SIGN|Vector3 with sign at accessor indices `%1`..`%2` has invalid w component: `%3`. Must be 1.0 or -1.0.|Error|
|ACCESSOR_JOINTS_INDEX_DUPLICATE|Joints accessor element at index `%1` (component index `%2`) has value `%3` that is already in use for the vertex.|Error|
|ACCESSOR_JOINTS_INDEX_OOB|Joints accessor element at index `%1` (component index `%2`) has value `%3` that is greater than the maximum joint index (`%4`) set by skin `%5`.|Error|
|ACCESSOR_JOINTS_USED_ZERO_WEIGHT|Joints accessor element at index `%1` (component index `%2`) is used with zero weight but has non-zero value (`%3`).|Warning|
|ACCESSOR_MAX_MISMATCH|Declared maximum value for this component (`%1`) does not match actual maximum (`%2`).|Error|
|ACCESSOR_MIN_MISMATCH|Declared minimum value for this component (`%1`) does not match actual minimum (`%2`).|Error|
|ACCESSOR_NON_CLAMPED|Accessor element at index `%1` is not clamped to 0..1 range: `%2`.|Error|
|ACCESSOR_SPARSE_INDEX_OOB|Accessor sparse indices element at index `%1` is greater than or equal to the number of accessor elements: `%2` >= `%3`.|Error|
|ACCESSOR_SPARSE_INDICES_NON_INCREASING|Accessor sparse indices element at index `%1` is less than or equal to previous: `%2` <= `%3`.|Error|
|ACCESSOR_VECTOR3_NON_UNIT|Vector3 at accessor indices `%1`..`%2` is not of unit length: `%3`.|Error|
|ACCESSOR_WEIGHTS_NEGATIVE|Weights accessor element at index `%1` (component index `%2`) has negative value `%3`.|Error|
|ACCESSOR_WEIGHTS_NON_NORMALIZED|Weights accessor elements (at indices `%1`..`%2`) have non-normalized sum: `%3`.|Error|
|BUFFER_BYTE_LENGTH_MISMATCH|Actual data byte length (`%1`) is less than the declared buffer byte length (`%2`).|Error|
|BUFFER_GLB_CHUNK_TOO_BIG|GLB-stored BIN chunk contains `%1` extra padding byte(s).|Warning|
|DATA_URI_GLB|Data URI is used in GLB container.|Warning|
|IMAGE_DATA_INVALID|Image data is invalid. `%1`|Error|
|IMAGE_FEATURES_UNSUPPORTED|Image contains unsupported features like non-default colorspace information, non-square pixels, or animation.|Warning|
|IMAGE_MIME_TYPE_INVALID|Recognized image format '`%1`' does not match declared image format '`%2`'.|Error|
|IMAGE_NON_ENABLED_MIME_TYPE|'`%1`' MIME type requires an extension.|Error|
|IMAGE_NPOT_DIMENSIONS|Image has non-power-of-two dimensions: `%1`x`%2`.|Information|
|IMAGE_UNEXPECTED_EOS|Unexpected end of image stream.|Error|
|IMAGE_UNRECOGNIZED_FORMAT|Image format not recognized.|Warning|
|URI_GLB|URI is used in GLB container.|Information|
## GlbError
| Code | Message | Severity |
|------|---------|----------|
|GLB_CHUNK_LENGTH_UNALIGNED|Length of `%1` chunk is not aligned to 4-byte boundaries.|Error|
|GLB_CHUNK_TOO_BIG|Chunk (`%1`) length (`%2`) does not fit total GLB length.|Error|
|GLB_DUPLICATE_CHUNK|Chunk of type `%1` has already been used.|Error|
|GLB_EMPTY_BIN_CHUNK|Empty BIN chunk should be omitted.|Information|
|GLB_EMPTY_CHUNK|Chunk (`%1`) cannot have zero length.|Error|
|GLB_EXTRA_DATA|Extra data after the end of GLB stream.|Warning|
|GLB_INVALID_MAGIC|Invalid GLB magic value (`%1`).|Error|
|GLB_INVALID_VERSION|Invalid GLB version value `%1`.|Error|
|GLB_LENGTH_MISMATCH|Declared length (`%1`) does not match GLB length (`%2`).|Error|
|GLB_LENGTH_TOO_SMALL|Declared GLB length (`%1`) is too small.|Error|
|GLB_UNEXPECTED_BIN_CHUNK|BIN chunk must be the second chunk.|Error|
|GLB_UNEXPECTED_END_OF_CHUNK_DATA|Unexpected end of chunk data.|Error|
|GLB_UNEXPECTED_END_OF_CHUNK_HEADER|Unexpected end of chunk header.|Error|
|GLB_UNEXPECTED_END_OF_HEADER|Unexpected end of header.|Error|
|GLB_UNEXPECTED_FIRST_CHUNK|First chunk must be of JSON type. Found `%1` instead.|Error|
|GLB_UNKNOWN_CHUNK_TYPE|Unknown GLB chunk type: `%1`.|Warning|
