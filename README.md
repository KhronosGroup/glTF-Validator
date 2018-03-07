<p align="center">
<img src="https://github.com/KhronosGroup/glTF/raw/master/specification/figures/gltf.png" />
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
- [Full list of detectable issues](ISSUES.md).

## Usage

You can use hosted [web front-end tool](http://github.khronos.org/glTF-Validator). It works completely in the browser without any server-side processing.

### Command-line tool

#### Installing from source code

##### Prerequisites
1. Download and install [Dart SDK](https://www.dartlang.org/install) for your platform.
2. Add Dart SDK `bin` folder to your PATH (more info [here](https://www.dartlang.org/tools/pub/installing)).
3. Add packages `bin` folder to your PATH (`~/.pub-cache/bin` for Linux and Mac; `%APPDATA%\Pub\Cache\bin` for Windows).

##### glTF-Validator
1. Clone this repository, `master` branch.
2. From the repository root folder, run `pub get` to get dependencies.
3. Run `pub global activate --source path ./` to add `gltf_validator` executable to your PATH.

##### Installing from behind a corporate firewall
`pub get` downloads dependencies from Google's `pub.dartlang.org` server over HTTPS. If you need to specify a proxy, follow these steps:
1. Set `https_proxy` or `HTTPS_PROXY` environment variable in form `hostname:port`.
2. If the proxy requires credentials, use this syntax: `username:password@hostname:port`.

`pub get` validates server's SSL certificate. If your corporate network interferes with SSL connections, follow these steps to get `pub` running.
1. Save your corporate self-signed root certificate as X.509 file.
2. (Linux only) Try to add your cert to `/etc/pki/tls/certs/ca-bundle.crt` or `/etc/ssl/certs`.
3. If that doesn't work or if you're on Windows, add environment variable `DART_VM_OPTIONS` with value `--root-certs-file=<cert_file>`.

After doing this, `pub get` should be able to download dependencies successfully.

#### Usage
```
Usage: gltf_validator [<options>] <input>

Validation report will be written to `<asset_filename>_report.json`.
If <input> is a directory, validation reports will be recursively created for each glTF asset.

Validation log will be printed to stderr.

Shell return code will be non-zero if at least one error was found.
-r, --[no-]validate-resources    Validate contents of embedded and/or referenced resources (buffers, images).
-p, --[no-]plain-text            Print issues in plain text form to stderr.
-a, --[no-]all-issues            Print all issues to plain text output.
-c, --config                     YAML configuration file with validation options. See docs/config-example.yaml for details.
```

## Building

### Dart Snapshot
To build application snapshot for more convenient deployment, follow these steps after installation:
1. Run `pub run grinder snapshot`.
2. Snapshot will be written to `build/gltf_validator.snapshot`.

It may be used like this:
```
$ dart gltf_validator.snapshot -r -p -a ./path_to_models/
```
Note, that you have to use the same Dart SDK version for building and running the snapshot. For deployment, you will need only two files: application snapshot and `dart` executable.

### NPM Package
To build an npm package for use in Node.js environment, follow these steps after installation:
1. Run `pub run grinder npm`.
2. `gltf-validator` npm package will be written to `build/npm`.

Refer to the [npm package documentation](https://www.npmjs.com/package/gltf-validator) for additional information.

#### Publishing
To publish an npm package, follow these steps after installation:
1. Run `pub run grinder npm-publish`.
2. `gltf-validator` npm package will be built to `build/npm` and published to npm registry using `npm publish`.

### Validation Issues List
To generate [ISSUES.md](ISSUES.md), follow these steps after installation:
1. Run `pub run grinder issues`.
2. `ISSUES.md` file will be written to the repo root.

## Known Issues

- Web version can't differentiate between JSON integers and floats of the same value, e.g., `1` vs `1.0`.
- JSON charset encoding restrictions are not enforced.
