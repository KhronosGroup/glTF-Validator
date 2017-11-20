## 2.0.0-dev.1.4

* Added new validation checks `UNRESERVED_EXTENSION_PREFIX` and `MATERIAL_ALPHA_CUTOFF_INVALID_MODE`.

* Refined JSON-Pointers for `DUPLICATE_ELEMENTS`, `UNSUPPORTED_EXTENSION`, `UNUSED_EXTENSION_REQUIRED`, `UNDEFINED_PROPERTY`, `ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND`, `ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND`, `ACCESSOR_MIN_MISMATCH`, and `ACCESSOR_MAX_MISMATCH`.

## 2.0.0-dev.1.3

* JS docs update.

## 2.0.0-dev.1.2

* Updated JS API. See [README.md](tool/npm_template/README.md) for details.

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