/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
 * #
 * # Licensed under the Apache License, Version 2.0 (the "License");
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an "AS IS" BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

const validator = require('./gltf_validator.dart.js');

/**
 * @callback loadExternalResourceCallback
 * @param {string} uri - Relative URI of the external resource
 * @returns {Promise} - Promise with Uint8Array data
 */

/**
 * Validates an asset.
 * @param {string} name - URI or other ID.
 * @param {Uint8Array} data - Byte array containing glTF or GLB data.
 * @param {loadExternalResourceCallback} loadExternalResource - Function for loading external resources
 * @returns {Promise} Promise with validation result
 */
exports.validate = (name, data, loadExternalResource) => validator.validate(name, data, loadExternalResource);