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