const fs = require("fs");
const path = require("path");
const validator = require('./index.js');

const filename = __dirname + '/Box.gltf';
const asset = fs.readFileSync(filename);

validator.validate(filename, new Uint8Array(asset), (uri) =>
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
    // Validation report in object form
    console.log(JSON.stringify(result));
}, (result) => {
    // Validation exception
    console.error(result.toString());
});