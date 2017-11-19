# glTF 2.0 Validation Issues
## IoError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|FILE_NOT_FOUND|File not found. `%1`|Error|
## SchemaError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|ARRAY_LENGTH_NOT_IN_LIST|Invalid array length `%1`. Valid lengths are: ('`%a`', '`%b`', '`%c`').|Error|
|2|ARRAY_TYPE_MISMATCH|Type mismatch. Array element '`%1`' is not a '`%2`'.|Error|
|3|DUPLICATE_ELEMENTS|Duplicate element.|Error|
|4|INVALID_INDEX|Index must be a non-negative integer.|Error|
|5|INVALID_JSON|Invalid JSON data. Parser output: `%1`|Error|
|6|INVALID_URI|Invalid URI `%1`. Parser output: `%2`|Error|
|7|EMPTY_ENTITY|Entity cannot be empty.|Error|
|8|ONE_OF_MISMATCH|Exactly one of ('`%1`', '`%2`', '`%3`', '`%4`') properties must be defined.|Error|
|9|PATTERN_MISMATCH|Value '`%1`' does not match regexp pattern '`%2`'.|Error|
|10|TYPE_MISMATCH|Type mismatch. Property value '`%1`' is not a '`%2`'.|Error|
|11|VALUE_NOT_IN_LIST|Invalid value '`%1`'. Valid values are ('`%a`', '`%b`', '`%c`').|Error|
|12|VALUE_NOT_IN_RANGE|Value `%1` is out of range.|Error|
|13|VALUE_MULTIPLE_OF|Value `%1` is not a multiple of `%2`.|Error|
|14|UNDEFINED_PROPERTY|Property '`%1`' must be defined.|Error|
|15|UNEXPECTED_PROPERTY|Unexpected property.|Warning|
|16|UNSATISFIED_DEPENDENCY|Dependency failed. '`%1`' must be defined.|Error|
## SemanticError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|UNKNOWN_ASSET_MAJOR_VERSION|Unknown glTF major asset version: `%1`.|Error|
|2|UNKNOWN_ASSET_MINOR_VERSION|Unknown glTF minor asset version: `%1`.|Warning|
|3|ASSET_MIN_VERSION_GREATER_THAN_VERSION|Asset minVersion '`%1`' is greater than version '`%2`'.|Warning|
|4|INVALID_GL_VALUE|Invalid value `%1` for GL type '`%2`'.|Error|
|5|INTEGER_WRITTEN_AS_FLOAT|Integer value is written with fractional part: `%1`.|Error|
|6|ACCESSOR_NORMALIZED_INVALID|Only (u)byte and (u)short accessors can be normalized.|Error|
|7|ACCESSOR_OFFSET_ALIGNMENT|Offset `%1` is not a multiple of componentType length `%2`.|Error|
|8|ACCESSOR_MATRIX_ALIGNMENT|Matrix accessors must be aligned to 4-byte boundaries.|Error|
|9|ACCESSOR_SPARSE_COUNT_OUT_OF_RANGE|Sparse accessor overrides more elements (`%1`) than the base accessor contains (`%2`).|Error|
|10|BUFFER_DATA_URI_MIME_TYPE_INVALID|Buffer's Data URI MIME-Type must be 'application/octet-stream' or 'application/gltf-buffer'. Found '`%1`' instead.|Error|
|11|BUFFER_VIEW_TOO_BIG_BYTE_STRIDE|Buffer view's byteStride (`%1`) is smaller than byteLength (`%2`).|Error|
|12|BUFFER_VIEW_INVALID_BYTE_STRIDE|Only buffer views with raw vertex data can have byteStride.|Error|
|13|CAMERA_XMAG_YMAG_ZERO|xmag and ymag must not be zero.|Warning|
|14|CAMERA_ZFAR_LEQUAL_ZNEAR|zfar must be greater than znear.|Error|
|15|MESH_PRIMITIVE_INVALID_ATTRIBUTE|Invalid attribute name '`%1`'.|Error|
|16|MESH_PRIMITIVES_UNEQUAL_TARGETS_COUNT|All primitives must have the same number of morph targets.|Error|
|17|MESH_PRIMITIVE_NO_POSITION|No POSITION attribute found.|Error|
|18|MESH_PRIMITIVE_INDEXED_SEMANTIC_CONTINUITY|Indices for indexed attribute semantic '`%1`' must start with 0 and be continuous.|Error|
|19|MESH_PRIMITIVE_TANGENT_WITHOUT_NORMAL|TANGENT attribute without NORMAL found.|Warning|
|20|MESH_PRIMITIVE_JOINTS_WEIGHTS_MISMATCH|Number of JOINTS attribute semantics must match number of WEIGHTS.|Error|
|21|MESH_PRIMITIVE_TANGENT_POINTS|TANGENT attribute defined for POINTS rendering mode.|Warning|
|22|MESH_INVALID_WEIGHTS_COUNT|The length of weights array (`%1`) does not match the number of morph targets (`%2`).|Error|
|23|NODE_MATRIX_TRS|A node can have either a matrix or any combination of translation/rotation/scale (TRS) properties.|Error|
|24|NODE_MATRIX_DEFAULT|Do not specify default transform matrix.|Information|
|25|NODE_MATRIX_NON_TRS|Matrix must be decomposable to TRS.|Error|
|26|NODE_ROTATION_NON_UNIT|Rotation quaternion must be normalized.|Error|
|27|UNUSED_EXTENSION_REQUIRED|Unused extension '`%1`' cannot be required.|Error|
|28|UNRESERVED_EXTENSION_PREFIX|Extension uses unreserved extension prefix '`%1`'.|Warning|
|29|NODE_EMPTY|Empty node encountered.|Information|
|30|NON_RELATIVE_URI|Non-relative URI found: `%1`.|Warning|
## LinkError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|ACCESSOR_TOTAL_OFFSET_ALIGNMENT|Accessor's total byteOffset `%1` isn't a multiple of componentType length `%2`.|Error|
|2|ACCESSOR_SMALL_BYTESTRIDE|Referenced bufferView's byteStride value `%1` is less than accessor element's length `%2`.|Error|
|3|ACCESSOR_TOO_LONG|Accessor (offset: `%1`, length: `%2`) does not fit referenced bufferView [`%3`] length `%4`.|Error|
|4|ACCESSOR_USAGE_OVERRIDE|Override of previously set accessor usage. Initial: '`%1`', new: '`%2`'.|Error|
|5|ANIMATION_DUPLICATE_TARGETS|Animation channel has the same target as channel `%1`.|Error|
|6|ANIMATION_CHANNEL_TARGET_NODE_MATRIX|Animation channel cannot target TRS properties of node with defined matrix.|Error|
|7|ANIMATION_CHANNEL_TARGET_NODE_WEIGHTS_NO_MORPHS|Animation channel cannot target WEIGHTS when mesh does not have morph targets.|Error|
|8|ANIMATION_SAMPLER_INPUT_ACCESSOR_WITHOUT_BOUNDS|accessor.min and accessor.max must be defined for animation input accessor.|Error|
|9|ANIMATION_SAMPLER_INPUT_ACCESSOR_INVALID_FORMAT|Invalid Animation sampler input accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|10|ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_FORMAT|Invalid animation sampler output accessor format '`%1`' for path '`%3`'. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|11|ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_COUNT|Animation sampler output accessor of count `%1` expected. Found `%2`.|Error|
|12|BUFFER_VIEW_TOO_LONG|BufferView does not fit buffer (`%1`) byteLength (`%2`).|Error|
|13|BUFFER_VIEW_TARGET_OVERRIDE|Override of previously set bufferView target or usage. Initial: '`%1`', new: '`%2`'.|Error|
|14|INVALID_IBM_ACCESSOR_COUNT|Accessor of count `%1` expected. Found `%2`.|Error|
|15|MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_INVALID_FORMAT|Invalid accessor format '`%1`' for this attribute semantic. Must be one of ('`%a`', '`%b`', '`%c`').|Error|
|16|MESH_PRIMITIVE_POSITION_ACCESSOR_WITHOUT_BOUNDS|accessor.min and accessor.max must be defined for POSITION attribute accessor.|Error|
|17|MESH_PRIMITIVE_ACCESSOR_WITHOUT_BYTESTRIDE|bufferView.byteStride must be defined when two or more accessors use the same buffer view.|Error|
|18|MESH_PRIMITIVE_ACCESSOR_UNALIGNED|Vertex attribute data must be aligned to 4-byte boundaries.|Error|
|19|MESH_PRIMITIVE_INDICES_ACCESSOR_WITH_BYTESTRIDE|bufferView.byteStride must not be defined for indices accessor.|Error|
|20|MESH_PRIMITIVE_INDICES_ACCESSOR_INVALID_FORMAT|Invalid indices accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`'). |Error|
|21|MESH_PRIMITIVE_INCOMPATIBLE_MODE|Number of vertices or indices (`%1`) is not compatible with used drawing mode ('`%2`').|Warning|
|22|MESH_PRIMITIVE_TOO_FEW_TEXCOORDS|Material is incompatible with mesh primitive: Texture binding '`%1`' needs 'TEXCOORD_`%2`' attribute.|Error|
|23|MESH_PRIMITIVE_UNEQUAL_ACCESSOR_COUNT|All accessors of the same primitive must have the same count.|Error|
|24|MESH_PRIMITIVE_MORPH_TARGET_NO_BASE_ACCESSOR|No base accessor for this attribute semantic.|Error|
|25|MESH_PRIMITIVE_MORPH_TARGET_INVALID_ATTRIBUTE_COUNT|Base accessor has different count.|Error|
|26|NODE_LOOP|Node is a part of a node loop.|Error|
|27|NODE_PARENT_OVERRIDE|Value overrides parent of node `%1`.|Error|
|28|NODE_WEIGHTS_INVALID|The length of weights array (`%1`) does not match the number of morph targets (`%2`).|Error|
|29|NODE_WITH_NON_SKINNED_MESH|Node has skin defined, but mesh has no joints data.|Error|
|30|SCENE_NON_ROOT_NODE|Node `%1` is not a root node.|Error|
|31|SKIN_IBM_INVALID_FORMAT|Invalid IBM accessor format '`%1`'. Must be one of ('`%a`', '`%b`', '`%c`'). |Error|
|32|UNDECLARED_EXTENSION|Extension was not declared in extensionsUsed.|Error|
|33|UNEXPECTED_EXTENSION_OBJECT|Unexpected location for this extension.|Error|
|34|UNRESOLVED_REFERENCE|Unresolved reference: `%1`.|Error|
|35|UNSUPPORTED_EXTENSION|Unsupported extension encountered: '`%1`'.|Warning|
## DataError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|BUFFER_EMBEDDED_BYTELENGTH_MISMATCH|Actual data length `%1` is not equal to the declared buffer byteLength `%2`.|Error|
|2|BUFFER_EXTERNAL_BYTELENGTH_MISMATCH|Actual data length `%1` is less than the declared buffer byteLength `%2`.|Error|
|3|BUFFER_GLB_CHUNK_TOO_BIG|GLB-stored BIN chunk contains `%1` extra padding byte(s).|Warning|
|4|ACCESSOR_MIN_MISMATCH|Declared minimum value for this component (`%1`) does not match actual minimum (`%2`).|Error|
|5|ACCESSOR_MAX_MISMATCH|Declared maximum value for this component (`%1`) does not match actual maximum (`%2`).|Error|
|6|ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND|Accessor element `%1` at index `%2` is less than declared minimum value `%3`.|Error|
|7|ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND|Accessor element `%1` at index `%2` is greater than declared maximum value `%3`.|Error|
|8|ACCESSOR_NON_UNIT|Accessor element at index `%1` is not of unit length: `%2`.|Error|
|9|ACCESSOR_INVALID_SIGN|Accessor element at index `%1` has invalid w component: `%2`. Must be 1.0 or -1.0.|Error|
|10|ACCESSOR_INVALID_FLOAT|Accessor element at index `%1` is NaN or Infinity.|Error|
|11|ACCESSOR_INDEX_OOB|Indices accessor element at index `%1` has vertex index `%2` that exceeds number of available vertices `%3`.|Error|
|12|ACCESSOR_INDEX_TRIANGLE_DEGENERATE|Indices accessor contains `%1` degenerate triangles.|Information|
|13|ACCESSOR_ANIMATION_INPUT_NEGATIVE|Animation input accessor element at index `%1` is negative: `%2`.|Error|
|14|ACCESSOR_ANIMATION_INPUT_NON_INCREASING|Animation input accessor element at index `%1` is less than or equal to previous: `%2` <= `%3`.|Error|
|15|ACCESSOR_SPARSE_INDICES_NON_INCREASING|Accessor sparse indices element at index `%1` is less than or equal to previous: `%2` <= `%3`.|Error|
|16|ACCESSOR_SPARSE_INDEX_OOB|Accessor sparse indices element at index `%1` is greater than or equal to the number of accessor elements: `%2` >= `%3`.|Error|
|17|ACCESSOR_INDECOMPOSABLE_MATRIX|Matrix element at index `%1` is not decomposable to TRS.|Error|
|18|IMAGE_DATA_INVALID|Image data is invalid. `%1`|Error|
|19|IMAGE_MIME_TYPE_INVALID|Recognized image format '`%1`' does not match declared image format '`%2`'.|Error|
|20|IMAGE_UNEXPECTED_EOS|Unexpected end of image stream.|Error|
|21|IMAGE_UNRECOGNIZED_FORMAT|Image format not recognized.|Error|
|22|IMAGE_NPOT_DIMENSIONS|Image has non-power-of-two dimensions: `%1`x`%2`.|Information|
## GlbError
| No | Code | Message | Severity |
|:---:|-----|---------|----------|
|1|GLB_INVALID_MAGIC|Invalid GLB magic value (`%1`).|Error|
|2|GLB_INVALID_VERSION|Invalid GLB version value `%1`.|Error|
|3|GLB_LENGTH_TOO_SMALL|Declared GLB length (`%1`) is too small.|Error|
|4|GLB_CHUNK_LENGTH_UNALIGNED|Length of `%1` chunk is not aligned to 4-byte boundaries.|Error|
|5|GLB_LENGTH_MISMATCH|Declared length (`%1`) does not match GLB length (`%2`).|Error|
|6|GLB_CHUNK_TOO_BIG|Chunk (`%1`) length (`%2`) does not fit total GLB length.|Error|
|7|GLB_EMPTY_CHUNK|Chunk (`%1`) cannot have zero length.|Error|
|8|GLB_DUPLICATE_CHUNK|Chunk of type `%1` has already been used.|Error|
|9|GLB_UNEXPECTED_END_OF_CHUNK_HEADER|Unexpected end of chunk header.|Error|
|10|GLB_UNEXPECTED_END_OF_CHUNK_DATA|Unexpected end of chunk data.|Error|
|11|GLB_UNEXPECTED_END_OF_HEADER|Unexpected end of header.|Error|
|12|GLB_UNEXPECTED_FIRST_CHUNK|First chunk must be of JSON type. Found `%1` instead.|Error|
|13|GLB_UNKNOWN_CHUNK_TYPE|Unknown GLB chunk type: `%1`.|Warning|
