/*
 * # Copyright (c) 2016-2019 The Khronos Group Inc.
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

import * as v from './gltf_validator.dart.js';

/**
 * Returns a version string.
 * @returns {string}
 */
export const version = () => v.default.version();

/**
 * Returns an array of supported extensions names.
 * @returns {string[]}
 */
export const supportedExtensions = () => v.default.supportedExtensions();

/**
 * Validates an asset from bytes.
 * @param {Uint8Array} data - Byte array containing glTF or GLB data.
 * @param {ValidationOptions} options - Object with validation options.
 * @returns {Promise} Promise with validation result in object form.
 */
export const validateBytes = (data, options) => v.default.validateBytes(data, options);

/**
 * Validates an asset from JSON string.
 * @param {string} json - String containing glTF JSON.
 * @param {ValidationOptions} options - Object with validation options.
 * @returns {Promise} Promise with validation result in object form.
 */
export const validateString = (json, options) => v.default.validateString(json, options);

/**
 @typedef {Object} ValidationOptions
 @property {string} uri - Absolute or relative asset URI that will be copied to validation report.
 @property {string} format - Set to `glb` or `gltf` to skip auto-detection of the asset format based on the first byte; any other value will be ignored. This option has no effect on `validateString`.
 @property {ExternalResourceFunction} externalResourceFunction - Function for loading external resources. If omitted, external resources are not validated.
 @property {boolean} writeTimestamp - Set to `false` to omit timestamp from the validation report.
 @property {number} maxIssues - Max number of reported issues. Use `0` for unlimited output.
 @property {string[]} ignoredIssues - Array of ignored issue codes.
 @property {string[]} onlyIssues - Array of only issues to consider. Cannot be used along with ignoredIssues.
 @property {Object} severityOverrides - Object with overridden severities for issue codes.
 */

/**
 * @callback ExternalResourceFunction
 * @param {string} uri - Relative URI of the external resource.
 * @returns {Promise} - Promise with Uint8Array data.
 */
