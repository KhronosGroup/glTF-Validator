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
