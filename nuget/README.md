# glTF-Validator

This is a NuGet wrapper package for the official [glTF Validator](https://github.com/KhronosGroup/glTF-Validator/) containing pre-compiled binaries for Windows, Linux, and macOS.

See the main [README](https://github.com/KhronosGroup/glTF-Validator/blob/master/README.md) for the complete description of implemented validation features.

## Usage

### Adding Reference
```csharp
using Khronos.glTF2.Validator;
```

### Using embedded validator executable

1. Initialize a `ValidationContext` instance, this unpacks platform-specific executable into user's temporary folder.
2. Use synchronous or asynchronous API to validate glTF assets. Async API can simultaneously process multiple assets.
3. Dispose the `ValidationContext` instance (explicitly or via `using`). This removes the unpacked validator executable.

```csharp
const string path = "asset.gltf";
using (var v = new ValidationContext())
{
    var report = await v.ValidateAsync(path);
    // use report
}
```

### Using custom validator executable

1. Initialize a `ValidationContext` instance with `useEmbeddedValidator` set to `false`. In such a case, a temporary file is not created.
2. Use synchronous or asynchronous API to validate glTF assets, providing path to a custom validator executable.
3. Dispose the `ValidationContext` instance or leave it to GC.

```csharp
const string path = "asset.gltf";
const string validatorPath = "custom/gltf_validator.exe";
using (var v = new ValidationContext(false))
{
    var report = v.Validate(path, validatorPath);
    // use report
}
```

## Building

**TBD**