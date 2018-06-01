# gltf-validator

This is an npm package for the official [glTF Validator](https://github.com/KhronosGroup/glTF-Validator/) compiled from Dart to JS.

## Installation

```
npm install --save gltf-validator
```

## Examples

### Basic usage (Node.js)

```javascript
const fs = require('fs');
const validator = require('gltf-validator');

const asset = fs.readFileSync('./Box.gltf');

validator.validateBytes(new Uint8Array(asset))
    .then((report) => console.info('Validation succeeded: ', report))
    .catch((error) => console.error('Validation failed: ', error));
```

### Basic usage (Browser)

```javascript
const validator = require('gltf-validator');

fetch('Box.gltf')
    .then((response) => response.arrayBuffer())
    .then((asset) => validator.validateBytes(new Uint8Array(asset)))
    .then((report) => console.info('Validation succeeded: ', report))
    .catch((error) => console.error('Validation failed: ', error));
```

### Full usage

```javascript
const fs = require("fs");
const path = require("path");
const validator = require('gltf-validator');

const filename = 'Box.gltf';
const fullpath = __dirname + '/' + filename;
const asset = fs.readFileSync(fullpath);

validator.validateBytes(new Uint8Array(asset), {
    uri: filename,
    maxIssues: 10, // limit max number of output issues to 10
    ignoredIssues: ['UNSUPPORTED_EXTENSION'], // mute UNSUPPORTED_EXTENSION issue
    severityOverrides: { 'ACCESSOR_INDEX_TRIANGLE_DEGENERATE': 0 }, // treat degenerate triangles as errors
    externalResourceFunction: (uri) =>
        new Promise((resolve, reject) => {
            uri = path.resolve(path.dirname(fullpath), decodeURIComponent(uri));
            console.info("Loading external file: " + uri);
            fs.readFile(uri, (err, data) => {
                if (err) {
                    console.error(err.toString());
                    reject(err.toString());
                    return;
                }
                resolve(data);
            });
        })
}).then((result) => {
    // [result] will contain validation report in object form.
    // You can convert it to JSON to see its internal structure. 
    console.log(JSON.stringify(result, null, '  '));
}, (result) => {
    // Promise rejection means that arguments were invalid or validator was unable 
    // to detect file format (glTF or GLB). 
    // [result] will contain exception string.
    console.error(result);
});
```

## API

<!--- API BEGIN --->

<!--- API END --->
