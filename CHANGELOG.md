# Changelog

## 2.0.0-dev.3.8

### New Features

* Added support for `KHR_materials_iridescence` extension. Added:
  * `KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_INVALID` error;
  * `KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_WITHOUT_TEXTURE` info;
  * `KHR_MATERIALS_IRIDESCENCE_THICKNESS_TEXTURE_UNUSED` info.

* Added new vendor prefixes.

### Bugfixes

* Fixed inconsistent handling of meshes with morphed and non-morphed primitives.

## 2.0.0-dev.3.7

### New Features

* Added `GLB_EXTRA_DATA` warning. Extra bytes beyond the declared GLB total length are now ignored.

### Bugfixes

* Fixed crash when exceeding the maximum reported issues threshold while parsing GLB structures.

* Fixed erroneous line break in the generated issues table.

### Integration updates

* ZIP-archives generated on Windows can now be opened on other platforms.

## 2.0.0-dev.3.6

### New Features

* Added support for `KHR_materials_emissive_strength` extension; added `KHR_MATERIALS_EMISSIVE_STRENGTH_ZERO_FACTOR` warning.

* Added `KHR_MATERIALS_VOLUME_NO_TRANSMISSION` warning.

* Added 10 new vendor prefixes.

* Added allowed accessor formats for `TEXCOORD_n` and `COLOR_n` morph target attributes.

* Added `ANIMATION_SAMPLER_ACCESSOR_WITH_BYTESTRIDE` error.

* Added `BUFFER_BYTE_LENGTH_MISMATCH` error.

* Added `BUFFER_VIEW_TARGET_MISSING` hint.

* Added `CAMERA_XMAG_YMAG_NEGATIVE` warning.

* Added `GLB_EMPTY_BIN_CHUNK` info.

* Added `URI_GLB` info.

* Added `UNUSED_MESH_WEIGHTS` and `UNUSED_MESH_TANGENT` infos.

### Changes

* Skipped range-checking for vertex color attributes not defined in the spec.

* Data URIs with content not matching the declared `mediatype` now trigger `INVALID_URI` error.

* Updated `INVALID_IBM_ACCESSOR_COUNT` validation logic and message.

* Updated `MESH_PRIMITIVE_MORPH_TARGET_NO_BASE_ACCESSOR` validation message.

* Fixed JSON-pointers for `IMAGE_MIME_TYPE_INVALID` error.

* Changed `ASSET_MIN_VERSION_GREATER_THAN_VERSION` default severity to Error.

* Changed `CAMERA_XMAG_YMAG_ZERO` default severity to Error.

* Changed `DATA_URI_GLB` default severity to Warning.

* Removed `BUFFER_EMBEDDED_BYTELENGTH_MISMATCH` error.

* Removed `BUFFER_EXTERNAL_BYTELENGTH_MISMATCH` error.

* Removed `INTEGER_WRITTEN_AS_FLOAT` warning.

* Removed `MESH_PRIMITIVE_TANGENT_POINTS` and `MESH_PRIMITIVES_UNEQUAL_JOINTS_COUNT` validation issues.

### Bugfixes

* Fixed false positive `NODE_EMPTY` caused by unknown extensions.

* Fixed assertion on JSON arrays containing numbers that do not fit into double precision.

* Made `BUFFER_DATA_URI_MIME_TYPE_INVALID` validation case-insensitive.

* Tightened JPEG and WebP detection logic.

## 2.0.0-dev.3.5

### Integration updates

* Updated 3rd-party licenses and included docs in all generated archives.

## 2.0.0-dev.3.4

### New Features

* Added support for `KHR_materials_variants` extension.

* Added support for new PBR extensions: `KHR_materials_ior`, `KHR_materials_specular`, and `KHR_materials_volume`.

* Added `MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_UNSIGNED_INT` validation error (#154).

* Added new vendor prefixes: `ASOBO`, `CITRUS`, `CLO`, `OFT`.

### Bugfixes

* Fixed incomplete JSON pointers for out-of-range array elements.

* Web build is now usable from a local filesystem.

### Integration updates

* Added `exe-archive` and `web-archive` tasks to generate release archives.

* Fixed test names for `KHR_lights_punctual` extension.

* Changed default severity of `UNSUPPORTED_EXTENSION` to Info.

## 2.0.0-dev.3.3

### New Features

* Added support for new PBR extensions: `KHR_materials_clearcoat`, `KHR_materials_transmission`, and `KHR_materials_sheen`.

* Added `CAMERA_YFOV_GEQUAL_PI` validation warning (#140).

* Added new `SKIN_IBM_ACCESSOR_WITH_BYTESTRIDE` error for IBM accessors using buffer views with defined `byteStride`.

* Added new `IMAGE_BUFFER_VIEW_WITH_BYTESTRIDE` error for images using buffer views with defined `byteStride`.

* Added new vendor prefixes: `ANIMECH`, `EPIC`, `GRIFFEL`, `MAXAR`, `MPEG`, `PANDA3D`, `PTC`, `SEIN`, `SPECTRUM`, `TRYON`, `UX3D`, and `VRMC`.

### Changes

* Modified `MULTIPLE_EXTENSIONS` warning. It is now reported only for explicitly standalone extensions (#145 and #146).

* Added missing check for morph target accessors overriding buffer view usage.

### Bugfixes

* Fixed an endless loop on assets with a node loop within a scene (#141).

* Fixed wrong pointer for undeclared root extensions (#150).

* Fixed building all targets at once (`pub run grinder` with no args).

* Fixed missing JS API error messages when the validator is compiled in debug mode.

* Web drag-n-drop tool now shows a correct message when no glTF assets were provided.

### Integration updates

* npm tool no longer re-defines `require` (#139).

* npm tool no longer requires `options.externalResourceFunction` for GLB or assets with embedded data (#138).

* `options.validateAccessorData` npm tool flag is removed, accessors' data validation is always enabled.

* npm tool now reports `IO_ERROR` for external resources when `options.externalResourceFunction` is not provided.

* CLI tool now supports `--stdout` flag for writing a single validation report to STDOUT instead of a new file.

* CLI tool validates binary data by default (#138).

## 2.0.0-dev.3.2

### Bugfixes

* Validating an asset with an extension that alters allowed enum values (like MIME types for images or vertex formats for accessors) no longer affects subsequent validation runs (introduced in `2.0.0-dev.3.0`).

* Special characters (`~` and `/`) in JSON Pointers (RFC 6901) are now properly escaped.

## 2.0.0-dev.3.1

### New Features

* (CLI) When validating a directory, the validator now additionally lists assets with errors in the end.

* (CLI) Usage info and runtime errors are more accurate now.

### Bugfixes

* Fixed crash on unresolved node children used in a scene (introduced in `2.0.0-dev.3.0`).

* Fixed incorrect error message in `ARRAY_LENGTH_NOT_IN_LIST` for accessors of integer component type.

* `ARRAY_LENGTH_NOT_IN_LIST` no longer reported for accessors of unknown type.

* IBM and attribute accessor data is no longer validated when the accessors have invalid formats.

* (CLI) Uncaught runtime errors no longer hang directory validation.

* (CLI) Await until the report is written and flushed to disk (#126).

* (npm) Fixed crash on missing validation options JS object (introduced in `2.0.0-dev.3.0`).

* (npm) Fixed compatibility with Web Workers (was broken in `2.0.0-dev.3.0`).

## 2.0.0-dev.3.0 (January 2020)

### New Features

* Added support for `EXT_texture_webp` extension.

  * When the extension is not declared in `extensionsUsed`, image objects with WebP data are reported with a new `IMAGE_NON_ENABLED_MIME_TYPE` error.

* Added support for `KHR_mesh_quantization` extension.

* Added `NON_REQUIRED_EXTENSION` error for extensions that cannot be optional (such as `KHR_quantized_geometry`).

* Added vendor prefixes: `MESHOPT`, `POLUTROPON`, and `AGT` (#119).

* Added vendor prefixes: `ALCM` and `SKYLINE`.

* Added vendor prefixes: `FOXIT`, `KDAB`, and `CAPTURE`.

* Extension names are now validated to have an upper-case prefix separated from the rest on the name with underscore (new `INVALID_EXTENSION_NAME_FORMAT` warning).

* Referencing an image of type defined by an extension from the core objects now results in `TEXTURE_INVALID_IMAGE_MIME_TYPE` error.

* Added `IMAGE_FEATURES_UNSUPPORTED` warning for images that contain features (like animation in WebP) not supported by glTF.

* Validation report now includes color-space information for provided images.

* Validation report `info` object now includes more information about asset's performance characteristics (see #120).

* Vertex colors with values outside of `[0.0 .. 1.0]` range now issue `ACCESSOR_NON_CLAMPED` error.

* Skinning validation (fixes #58):

  * When a node with a skinned mesh is used in a scene, the skeleton's common root must be available in the same scene (`NODE_SKIN_NO_SCENE` error).

  * The skeleton nodes of a skin must have a common root (`SKIN_NO_COMMON_ROOT` error).

  * The `skin.skeleton` property, when present, must point to a common root (`SKIN_SKELETON_INVALID` error).

  * Animation channels should not target a node with a skinned mesh (`ANIMATION_CHANNEL_TARGET_NODE_SKIN` warning).

  * A node with a skinned mesh should be a root node (`NODE_SKINNED_MESH_NON_ROOT` warning).

  * A node with a skinned mesh should not have local transforms (`NODE_SKINNED_MESH_LOCAL_TRANSFORMS` warning).

  * Vertex influences validation:

    * All joints values must be within the range of joints in the skin (`ACCESSOR_JOINTS_INDEX_OOB` error).

    * No joint may have more than one non-zero weight for a given vertex (`ACCESSOR_JOINTS_INDEX_DUPLICATE` error).

    * Weights must be non-negative (`ACCESSOR_WEIGHTS_NEGATIVE` error).

    * Weights for each vertex must be normalized to have a linear sum of `1.0` (`ACCESSOR_WEIGHTS_NON_NORMALIZED` error).

    * Unused joint values (i.e. joints with a weight of zero) should be set to zero (`ACCESSOR_JOINTS_USED_ZERO_WEIGHT` warning).

### Integration updates

* Upgraded to the latest stable SDK.

* Generated npm package no longer requires polyfills when using webpack with certain configurations (fixes #110).

* It is now possible to omit timestamps from validation reports.

* It is now possible to set the number of used threads for directory validation (cmd-line tool only).

* Validation report now consistently uses lower-case enums.

* Native executable binaries can now be compiled. See the [readme](README.md) for details (fixes #113).

* Generated report filename is now `<asset>.report.json`.

* Unit tests (300+) are now consistently stored: an asset and its validation report. Combined with provided JSON catalogs, they could be used for testing other glTF implementations.

### Changes

* Major refactoring of binary data validation. Now, mesh and animation accessor issues are attributed to the corresponding binding points rather than to accessor objects. This change makes validation reports more precise when accessors are reused. Namely:

  * `ACCESSOR_ANIMATION_INPUT_NEGATIVE` and `ACCESSOR_ANIMATION_INPUT_NON_INCREASING` are attributed to `animation.sampler.input`.

  * `ANIMATION_SAMPLER_OUTPUT_ACCESSOR_NON_NORMALIZED_QUATERNION` (new) is attributed to `animation.channel.sampler`.

  * `ACCESSOR_INVALID_SIGN` is attributed to `mesh.primitive.attributes.TANGENT`; its message is more sound now.

  * `ACCESSOR_VECTOR3_NON_UNIT` (renamed from `ACCESSOR_NON_UNIT`) is attributed to `mesh.primitive.attributes.NORMAL` or `mesh.primitive.attributes.TANGENT`.

  * `ACCESSOR_NON_CLAMPED` is attributed to `mesh.primitive.attributes.COLOR`.

  * `ACCESSOR_INVALID_IBM` is attributed to `skin.inverseBindMatrices`.

  * `ACCESSOR_INDEX_OOB`, `ACCESSOR_INDEX_PRIMITIVE_RESTART`, and `ACCESSOR_INDEX_TRIANGLE_DEGENERATE` are attributed to `mesh.primitive.indices`.

* `ACCESSOR_INVALID_FLOAT` message is more specific.

* Fixed incorrect message in `ACCESSOR_INDEX_OOB`.

* `BUFFER_VIEW_TOO_LONG` is now attributed to `bufferView.byteLength` when `bufferView.byteOffset` fits the referenced buffer.

* `FILE_NOT_FOUND` is renamed to `IO_ERROR`; its error messages are now more consistent across platforms.

* Web drag-n-drop validator now issues an error when external resources are not available among dropped files.

* `ACCESSOR_INDECOMPOSABLE_MATRIX` renamed to `ACCESSOR_INVALID_IBM`; IBM data is no longer checked for TRS decomposition.

* Unused texture coordinates are now consistently reported as `UNUSED_OBJECT` with proper pointers regardless of material presence; `MESH_PRIMITIVE_UNUSED_TEXCOORD` is removed (fixes #117).

* `MESH_PRIMITIVE_JOINTS_WEIGHTS_MISMATCH` now reports mismatching numbers.

* Removed `BUFFER_NON_FIRST_GLB` warning (fixes #121).

* Removed `ANIMATION_SAMPLER_OUTPUT_INTERPOLATION`.

* Removed `WEB3D_quantized_attributes` and `CESIUM_RTC` extensions support.

### Bugfixes

* Fixed possible crash on empty input stream.

* Fixed possible crash on unresolved animation sampler inputs.

* `BUFFER_VIEW_TOO_LONG` is now correctly attributed to the invalid property.

* When `buffer.byteLength` is undefined for an embedded buffer, `BUFFER_EMBEDDED_BYTELENGTH_MISMATCH` is no longer reported.

* When `asset.version` is undefined or incorrect, `ASSET_MIN_VERSION_GREATER_THAN_VERSION`, `UNKNOWN_ASSET_MAJOR_VERSION`, and `UNKNOWN_ASSET_MINOR_VERSION` are no longer reported.

* When reported, `UNKNOWN_ASSET_MAJOR_VERSION` and `UNKNOWN_ASSET_MINOR_VERSION` errors now point to `asset.version`.

* `MESH_PRIMITIVE_TANGENT_WITHOUT_NORMAL` and `MESH_PRIMITIVE_TANGENT_POINTS` now point to tangent attribute instead of `primitive.attributes` object.

* Numerical thresholds for unit-length vectors are now chosen to accommodate possibly-quantized values.

* Fixed missing `UNRESOLVED_REFERENCE` errors for `KHR_lights_punctual` extension.

* When the root `KHR_lights_punctual` (with `lights` array) extension object is not present, its node counterpart now issues `UNSATISFIED_DEPENDENCY` error.

* Reported issues about invalid JSON syntax or invalid root object type no longer have JSON pointers.

* Fixed incorrect message in `BUFFER_VIEW_TOO_BIG_BYTE_STRIDE`.

* Fixed possible crash on invalid buffer or image objects (#125).

## 2.0.0-dev.2.7

* Added `ACCESSOR_INDEX_PRIMITIVE_RESTART` (#102).

* Added `DATA_URI_GLB` (#103).

* Updated language for `UNSUPPORTED_EXTENSION`, publish a list of supported extensions (#101).

* JS API can now provide a list of supported extensions.

* Updated indexed semantics validation to match the updated spec (#107).

* Unsupported extension objects cannot be `null` anymore (#108).

* Added `KHR_lights_punctual` support.

* Renamed error code `NODE_ROTATION_NON_UNIT` to `ROTATION_NON_UNIT`.

## 2.0.0-dev.2.6

* Fixed crash on validating sparse accessors when data is unavailable (#99).

* Added `NON_OBJECT_EXTRAS` validation issue.

## 2.0.0-dev.2.5

* Updated extension reserved prefixes.

## 2.0.0-dev.2.4

* Improved errors on invalid JS API usage.

* Fixed global namespace issues for npm build.

* Added ES6 module definition.

## 2.0.0-dev.2.3

* Fixed an NPM package regression caused by the new building process.

* Changed `INTEGER_WRITTEN_AS_FLOAT` default severity to Warning.

* Changed `UNUSED_OBJECT` default severity to Info.

* Fixed handling of GLB assets with buffers with broken URIs.

* Internal tweaks.

## 2.0.0-dev.2.2

* Added `UNUSED_OBJECT` hint (#80).

* Added `KHR_texture_transform` support.

* Changed `MESH_PRIMITIVE_NO_POSITION` default severity to Warning.

* Added UTF-8 BOM detection for byte inputs.

## 2.0.0-dev.2.1

* Fixed a crash in the NPM build when `externalResourceFunction` isn't provided (#81).

## 2.0.0-dev.2.0

* Changed `VALUE_NOT_IN_LIST` and `IMAGE_UNRECOGNIZED_FORMAT` default severities to Warning (#77).

* Using custom image format no longer issues `UNSATISFIED_DEPENDENCY` (#77).

* Improved pointers for not found resources.

* Buffers with broken URIs are no longer treated as GLB-stored.

* Fixed a crash on images with broken URIs.

* Updated validation report schema.

## 2.0.0-dev.1.8

* Added `MESH_PRIMITIVE_UNUSED_TEXCOORD` issue.

* `ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND` and `ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND` report only summary of bounds violation.

* Changed `ACCESSOR_TOTAL_OFFSET_ALIGNMENT` issue pointer to the whole accessor object.

## 2.0.0-dev.1.7

* Added `NODE_SKINNED_MESH_WITHOUT_SKIN`, `MESH_PRIMITIVES_UNEQUAL_JOINTS_COUNT` issues.

* Removed Catmull-Rom as valid spline interpolation mode.

* Fixed issue pointer corruption on empty accessors.

* Improved drag-n-drop validator UX when assets contain many issues (#60, #65).

* Fixed crash on malformed JSON (#66).

* Fixed cubic splines unit length check (#70).

* Added support for `KHR_materials_unlit` extension.

* Added `MULTIPLE_EXTENSIONS` warning.

* Updated the list of reserved extension prefixes.

* Added `GLB_UNEXPECTED_BIN_CHUNK`, `BUFFER_NON_FIRST_GLB`, and `BUFFER_MISSING_GLB_DATA` (#67).

* Added `ANIMATION_SAMPLER_INPUT_ACCESSOR_TOO_FEW_ELEMENTS` and `ANIMATION_SAMPLER_OUTPUT_INTERPOLATION` issues.

## 2.0.0-dev.1.6

* Fixed a crash when validating an asset from a string source with `maxIssues` option set.

* Updated JS usage example to reflect that external resource callback should expect URI-encoded string.

## 2.0.0-dev.1.5

* Users can now skip accessors data validation.

## 2.0.0-dev.1.4

* Added new validation checks `UNRESERVED_EXTENSION_PREFIX` and `MATERIAL_ALPHA_CUTOFF_INVALID_MODE`.

* Refined JSON-Pointers for `DUPLICATE_ELEMENTS`, `UNSUPPORTED_EXTENSION`, `UNUSED_EXTENSION_REQUIRED`, `UNDEFINED_PROPERTY`, `ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND`, `ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND`, `ACCESSOR_MIN_MISMATCH`, and `ACCESSOR_MAX_MISMATCH`.

* Web front-end supports files selection in addition to drag-n-drop.

## 2.0.0-dev.1.3

* JS docs update.

## 2.0.0-dev.1.2

* Updated JS API. See [README.md](node/README.md) for details.

* Added external resources support for drag-n-drop web frontend.

* Internal fixes.

## 2.0.0-dev.1

* New validation report format. See [JSON Schema](docs/validation.schema.json) for details.

* New validation checks: `MESH_PRIMITIVE_INDEXED_SEMANTIC_CONTINUITY` and `MESH_PRIMITIVE_TOO_FEW_TEXCOORDS`.

* Users can now set max number of reported issues.

* Users can now mute validation issues and/or override their severity.

* Language and default severities of certain validation issues were refined.

* Cmd-line version uses multiple threads when validating multiple assets.

* Added `npm-publish` grinder task (for package maintainers only).

* Updated README with info about building from behind a corporate firewall.

## 2.0.0-dev.0

* Initial tagged 2.0 release.
