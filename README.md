<p align="center">
<img src="https://github.com/KhronosGroup/glTF/raw/master/specification/figures/gltf.png" alt=""/>
</p>

# glTF-Validator

[![Build Status](https://travis-ci.org/KhronosGroup/glTF-Validator.svg?branch=master)](https://travis-ci.org/KhronosGroup/glTF-Validator)

Tool to validate [glTF](https://github.com/KhronosGroup/glTF) assets.

Validation is performed against [glTF 2.0](https://github.com/KhronosGroup/glTF/tree/master/specification/2.0) specification.

Validator writes a validation report (in JSON-format) with all found issues and asset stats.

Live drag-n-drop tool: http://github.khronos.org/glTF-Validator

NPM package: https://www.npmjs.com/package/gltf-validator

## Implemented features

- JSON syntax check and [GLBv2](https://github.com/KhronosGroup/glTF/tree/master/specification/2.0#glb-file-format-specification) file format correctness.
- Asset description validation
  - All properties and their types from JSON-Schemas (including implicit limitations on valid values).
  - Validity and compatibility of internal references.
  - Correctness of `Data URI` encoding.
- Binary buffers validation
  - Forbidden or incorrect accessor values (e.g., `NaN`, invalid quaternions, indecomposable matrices, etc).
  - `accessor.min` and `accessor.max` values.
  - Sparse accessors encoding.
  - Animation inputs and outputs.
- Images validation
  - Warning on non-power-of-two dimensions.
  - Warning on unsupported image features (like animations or custom color spaces).
- Extensions validation
  - EXT_texture_webp
  - KHR_lights_punctual
  - KHR_materials_pbrSpecularGlossiness
  - KHR_materials_unlit
  - KHR_quantized_geometry
  - KHR_texture_transform
- [Full list of detectable issues](ISSUES.md).

## Usage

You can use hosted [web front-end tool](https://github.khronos.org/glTF-Validator). It works completely in the browser without any server-side processing.

#### Command Line Tool Usage
```
Usage: gltf_validator [<options>] <input>

Validation report will be written to `<asset_filename>.report.json`.
If <input> is a directory, validation reports will be recursively created for each glTF asset.

Validation log will be printed to stderr.

Shell return code will be non-zero if at least one error was found.
-r, --[no-]validate-resources    Validate contents of embedded and/or referenced resources (buffers, images).
-t, --[no-]write-timestamp       Write UTC timestamp to the validation report.
-p, --[no-]absolute-path         Write absolute asset path to the validation report.
-m, --[no-]messages              Print issue messages to stderr. Otherwise, only total number of issues will be printed.
-a, --[no-]all                   Print all issue messages to stderr. Otherwise, only errors will be printed. Implies --messages.
-c, --config                     YAML configuration file with validation options. See docs/config-example.yaml for details.
```

## Building

### Prerequisites
1. Download and install [Dart SDK](https://dart.dev/tools/sdk/archive) for your platform.
2. Add Dart SDK `bin` folder to your PATH.

### Drag-n-Drop Web Tool
To build a drag-n-drop online validation tool (as hosted [here](http://github.khronos.org/glTF-Validator/)), follow these steps after installation:
1. Run `pub run grinder web`.
2. All needed files will be written to `build/web` directory.

### CLI tool
1. Run `pub run grinder exe`.
2. Native executable file will be written to `build/bin/gltf_validator` or `build/bin/gltf_validator.exe`.

### NPM Package
To build an npm package for use in Node.js environment, follow these steps after installation:
1. Run `pub run grinder npm`.
2. `gltf-validator` npm package will be written to `build/node`.

Refer to the [npm package documentation](https://www.npmjs.com/package/gltf-validator) for additional information.

#### Publishing
To publish an npm package, follow these steps after installation:
1. Run `pub run grinder npm-publish`.
2. `gltf-validator` npm package will be built to `build/node` and published to npm registry using `npm publish`.

### Validation Issues List
To generate [ISSUES.md](ISSUES.md), follow these steps after installation:
1. Run `pub run grinder issues`.
2. `ISSUES.md` file will be written to the repo root.

## Known Issues
- Web and npm versions cannot differentiate between JSON integers and floats of the same value, e.g., `1` vs `1.0`.
- JSON charset encoding restrictions are not enforced.
