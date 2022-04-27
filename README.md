<p align="center">
<img src="web/logos/glTF_RGB_June16.svg" alt="" height="250"/>
</p>

# glTF-Validator

[![Build Status](https://github.com/KhronosGroup/glTF-Validator/workflows/CI/badge.svg)](https://github.com/KhronosGroup/glTF-Validator/actions?query=workflow%3ACI)

Tool to validate [glTF](https://github.com/KhronosGroup/glTF) assets.

Validation is performed against [glTF 2.0](https://www.khronos.org/registry/glTF/specs/2.0/glTF-2.0.html) specification.

Validator writes a validation report (in JSON-format) with all found issues and asset stats.

Live drag-n-drop tool: https://github.khronos.org/glTF-Validator

NPM package: https://www.npmjs.com/package/gltf-validator

NuGet package [Third-party contribution]: https://www.nuget.org/packages/GltfValidator/

## Implemented features

- JSON syntax check and [GLBv2](https://www.khronos.org/registry/glTF/specs/2.0/glTF-2.0.html#glb-file-format-specification) file format correctness.
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
  - KHR_materials_clearcoat
  - KHR_materials_emissive_strength
  - KHR_materials_ior
  - KHR_materials_pbrSpecularGlossiness
  - KHR_materials_sheen
  - KHR_materials_specular
  - KHR_materials_transmission
  - KHR_materials_unlit
  - KHR_materials_variants
  - KHR_materials_volume
  - KHR_mesh_quantization
  - KHR_texture_transform
- [Full list of detectable issues](ISSUES.md).

## Usage

You can use hosted [web front-end tool](https://github.khronos.org/glTF-Validator). It works completely in the browser without any server-side processing.

#### Command Line Tool Usage
```
Usage: gltf_validator [<options>] <input>

Validation report will be written to `<asset_filename>.report.json`.
If <input> is a directory, validation reports will be recursively created for each *.gltf or *.glb asset.

Validation log will be printed to stderr.

Shell return code will be non-zero if at least one error was found.
-o, --[no-]stdout                Print JSON report to stdout instead of writing it to a file. This option cannot be used with directory input.
-r, --[no-]validate-resources    Validate contents of embedded and/or referenced resources (buffers, images).
                                 (defaults to on)
-t, --[no-]write-timestamp       Write UTC timestamp to the validation report.
-p, --[no-]absolute-path         Write absolute asset path to the validation report.
-m, --[no-]messages              Print issue messages to stderr. Otherwise, only total number of issues will be printed.
-a, --[no-]all                   Print all issue messages to stderr. Otherwise, only errors will be printed. Implies --messages.
-c, --config                     YAML configuration file with validation options. See docs/config-example.yaml for details.
-h, --threads                    The number of threads for directory validation. Set to 0 (default) for auto selection.
```

## Building

### Prerequisites
1. Download and install [Dart SDK](https://dart.dev/tools/sdk/archive) for your platform.
2. Add Dart SDK `bin` folder to your PATH.
3. From the repository root folder, run `dart pub get` to get dependencies.

#### Fetching dependencies from behind a corporate firewall
`dart pub get` downloads dependencies from Google's `pub.dev` server over HTTPS. If you need to specify a proxy, follow these steps:
1. Set `https_proxy` or `HTTPS_PROXY` environment variable in form `hostname:port`.
2. If the proxy requires credentials, use this syntax: `username:password@hostname:port`.

`dart pub get` validates server's SSL certificate. If your corporate network interferes with SSL connections, follow these steps to get it running.
1. Save your corporate self-signed root certificate as X.509 file.
2. (Linux only) Try to add your cert to `/etc/pki/tls/certs/ca-bundle.crt` or `/etc/ssl/certs`.
3. If that doesn't work or if you're on Windows, add environment variable `DART_VM_OPTIONS` with value `--root-certs-file=<cert_file>`.

After doing this, `dart pub get` should be able to download dependencies successfully.

### Drag-n-Drop Web Tool
To build a drag-n-drop online validation tool (as hosted [here](https://github.khronos.org/glTF-Validator/)), follow these steps after installation:
1. Run `dart run grinder web`.
2. All needed files will be written to `build/web` directory.

### CLI tool
1. Run `dart run grinder exe`.
2. Native executable file will be written to `build/bin/gltf_validator` or `build/bin/gltf_validator.exe`.

### NPM Package
To build an npm package for use in Node.js environment, follow these steps after installation:
1. Run `dart run grinder npm`.
2. `gltf-validator` npm package will be written to `build/node`.

Refer to the [npm package documentation](https://www.npmjs.com/package/gltf-validator) for additional information.

#### Publishing
To publish an npm package, follow these steps after installation:
1. Run `dart run grinder npm-publish`.
2. `gltf-validator` npm package will be built to `build/node` and published to npm registry using `npm publish`.

### Validation Issues List
To generate [ISSUES.md](ISSUES.md), follow these steps after installation:
1. Run `dart run grinder issues`.
2. `ISSUES.md` file will be written to the repo root.
