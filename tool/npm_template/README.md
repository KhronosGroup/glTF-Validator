# gltf-validator

This is an npm package for the official [glTF Validator](https://github.com/KhronosGroup/glTF-Validator/) compiled from Dart to JS.

Refer to [`index.js`](index.js) for API reference or see usage example below.

```javascript
const fs = require("fs");
const path = require("path");
const validator = require('./index.js');

const filename = __dirname + '/Box.gltf';
const asset = fs.readFileSync(filename);

validator.validateBytes(filename, new Uint8Array(asset), (uri) =>
    new Promise((resolve, reject) => {
            uri = path.resolve(path.dirname(filename), uri);
            console.info("Loading external file: " + uri);
            fs.readFile(uri, (err, data) => {
                if (err) {
                    console.error(err.toString());
                    reject(err.toString());
                    return;
                }
                resolve(data);
            });
        }
    )
).then((result) => {
    // [result] will contain validation report in object form.
    // You can convert it to JSON to see its internal structure. 
    console.log(JSON.stringify(result, null, '  '));
}, (result) => {
    // Promise rejection means that validator was unable 
    // to detect file format (glTF or GLB) or has encountered an internal error. 
    // [result] will contain exception object.
    console.error(result.toString());
});
```