# glTF 1.0.1 Validation Issues
## Errors
| No | Name | Message |
|:-:|------------|-------------|
| 1. | INVALID_JSON | Invalid JSON data. Parser output: %1 |
| 2. | INVALID_JSON_ROOT_OBJECT | JSON root must be an object. |
| 3. | ARRAY_LENGTH_NOT_IN_LIST | Wrong array length `%1`. Valid lengths are: `%2`. |
| 4. | ARRAY_LENGTH_OUT_OF_RANGE | Array length `%1` out of range |
| 5. | ARRAY_TYPE_MISMATCH | Type mismatch. Array member `%1` isn't a `%2` |
| 6. | EMPTY_ID | ID can't be an empty string. |
| 7. | INVALID_ACCESSOR_TYPE | Accessor of type `%1` expected. Got `%2`. |
| 8. | INVALID_GL_VALUE | Invalid value `%1` for GL type `%2`. |
| 9. | INVALID_URI | Invalid URI `%1`. Parser output: %2 |
| 10. | INVALID_DATAURI | Invalid Data URI. Parser output: %1 |
| 11. | INVALID_DATAURI_MIME | Invalid MIME type `%1`. |
| 12. | TYPE_MISMATCH | Type mismatch. Property value `%1` isn't a `%2`. |
| 13. | PATTERN_MISMATCH | Value `%1` doesn't match regexp pattern `%2`. |
| 14. | VALUE_NOT_IN_LIST | Wrong value `%1`. Valid values are `%2`. |
| 15. | VALUE_OUT_OF_RANGE | Value `%1` out of range. |
| 16. | UNDECLARED_EXTENSION | Extension wasn't declared in `extensionsUsed`. |
| 17. | UNDEFINED_PROPERTY | Property must be defined. |
| 18. | UNEXPECTED_EXTENSION | Extension unexpected. |
| 19. | UNRESOLVED_REFERENCE | Unresolved reference: `%1`. |
| 20. | ROOT_DICTIONARY_EMPTY | Dictionary mustn't be empty. |
| 21. | ACCESSOR_INVALID_ELEMENT_ARRAY_TYPE | Invalid value `%1` for bufferView with ELEMENT_ARRAY_BUFFER target. |
| 22. | ACCESSOR_MULTIPLE_COMPONENT_TYPE | Value `%1` isn't a multiple of componentType length `%2`. |
| 23. | ACCESSOR_TOTAL_MULTIPLE_COMPONENT_TYPE | Accessor's total byteOffset `%1` isn't a multiple of a componentType length `%2`. |
| 24. | ACCESSOR_SMALL_BYTESTRIDE | Value `%1` is less than an attribute length `%2`. |
| 25. | ACCESSOR_TOO_LONG | Value `%1` exceeds referenced bufferView (`%2`) length `%3`. |
| 26. | ACCESSOR_UINT_NO_EXT | 5125 (UNSIGNED_INT) is only allowed when the `OES_element_index_uint` GL extension used. |
| 27. | ACCESSOR_UINT_NO_ELEMENT_ARRAY | 5125 (UNSIGNED_INT) is only allowed when the accessor references bufferView with ELEMENT_ARRAY_BUFFER target. |
| 28. | ACCESSOR_UINT_NO_SCALAR | 5125 (UNSIGNED_INT) is only allowed when the type is SCALAR. |
| 29. | ANIMATION_ACCESSOR_INVALID | Incompatible animation accessor `%1`. |
| 30. | BUFFERVIEW_TOO_LONG | BufferView doesn't fit buffer (`%1`) byteLength (`%2`). |
| 31. | CAMERA_ZFAR_ZNEAR | `zfar` can't be equal to `znear`. |
| 32. | MATERIAL_NO_ATTRIBUTES | Material can't refer attribute parameters. |
| 33. | MESH_DEFAULT_NO_POSITION | No POSITION attribute found. |
| 34. | MESH_INVALID_ACCESSOR_BUFFERVIEW | Incompatible accessor referenced: bufferView is undefined or has wrong `target`. |
| 35. | MESH_INVALID_ACCESSOR_TYPE | Incompatible accessor referenced: wrong `type` and/or `componentType`. |
| 36. | MESH_UINT_ATTRIBUTE_ACCESSOR | 5125 (UNSIGNED_INT) accessors aren't allowed for attributes. |
| 37. | MESH_UNEQUAL_ACCESSOR_COUNT | All accessors of the same primitive must have the same `count`. |
| 38. | TEXTURE_FORMAT_INTERNALFORMAT | When defined, `format` must match `internalformat`. |
| 39. | TEXTURE_FORMAT_TYPE | Invalid combination of `type` and `format`. |
| 40. | SKIN_INVALID_ACCESSOR_COUNT | Incompatible accessor used. Expected count: `%1`, got: `%2`. |
| 41. | TECHNIQUE_AMBIGUOUS_PARAMETER | Parameter can't be uniform and attribute at the same time. |
| 42. | TECHNIQUE_ATTRIBUTE_COUNT | Attribute parameter can't have `count` property. |
| 43. | TECHNIQUE_ATTRIBUTE_NODE | Attribute parameter can't have `node` property. |
| 44. | TECHNIQUE_ATTRIBUTE_VALUE | Attribute parameter can't have `value` property. |
| 45. | TECHNIQUE_ATTRIBUTE_INVALID_TYPE | Invalid type `%1` for attribute parameter. |
| 46. | TECHNIQUE_ATTRIBUTE_TYPE_OVERRIDE | Invalid type override for semantic `%1`. |
| 47. | TECHNIQUE_INVALID_SEMANTIC | Invalid `semantic` value (`%1`). |
| 48. | TECHNIQUE_UNIFORM_NODE_TYPE | When `node` is defined, `type` must be FLOAT_MAT4. |
| 49. | TECHNIQUE_UNIFORM_SEMANTIC_TYPE | Unexpected type `%1` for semantic `%2`. |
| 50. | TECHNIQUE_UNIFORM_SEMANTIC_COUNT | Semantic `%1` can't have `count` property. |
| 51. | TECHNIQUE_UNIFORM_SEMANTIC_NO_COUNT | Semantic `%1` must have `count` property. |
| 52. | TECHNIQUE_UNUSED_PARAMETER | Unused parameter. |

## Warnings
| No | Name | Message |
|:-:|------------|-------------|
| 1. | BUFFER_EMBEDDED_BYTELENGTH_MISMATCH | Value `%1` is not equal to the embedded data length `%2`. |
| 2. | DUPLICATE_ITEMS | Array contains duplicate items. |
| 3. | MATERIALS_VALUES_WITHOUT_TECHNIQUE | When technique is undefined, values must be undefined too. |
| 4. | NORMALIZED_FLOAT | Only non-float attributes can be normalized. |
| 5. | NORMALIZED_NON_ARRAY_BUFFER | Only vertex array buffer data can be normalized. |
| 6. | ANIMATION_ACCESSOR_WRONG_BUFFERVIEW_TARGET | `bufferView.target` must be undefined for an animation accessor `%1`. |
| 7. | SKIN_ACCESSOR_WRONG_BUFFERVIEW_TARGET | `bufferView.target` must be undefined for an IBM skin accessor `%1`. |
| 8. | UNEXPECTED_ATTRIBUTE | Unexpected attribute `%1` for `%2` technique or extension. |
| 9. | UNEXPECTED_PROPERTY | Unexpected property. |
| 10. | UNSUPPORTED_EXTENSION | Unsupported extension `%1`. |
