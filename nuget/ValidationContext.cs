/*
 * # Copyright (c) 2020 The Khronos Group Inc.
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

using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Khronos.glTF2.Validator.Report;

namespace Khronos.glTF2.Validator
{
    /// <summary>
    ///     Represents the context used to validate files
    /// </summary>
    public class ValidationContext : IDisposable
    {
        /// <value>
        ///     Default validation timeout value, 10 seconds
        /// </value>
        public static readonly TimeSpan DefaultTimeout = TimeSpan.FromSeconds(10);

        private static readonly JsonSerializerOptions Options = new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };

        private readonly string _embeddedValidatorPath;

        /// <summary>
        ///     Prepares embedded glTF-Validator executable.
        /// </summary>
        /// <remarks>
        ///     When embedded validator is used, created <c>ValidationContext</c> instance must be disposed.
        /// </remarks>
        /// <param name="useEmbeddedValidator">When false, an application is expected to provide its own validator executable.</param>
        /// <exception cref="NotSupportedException">
        ///     Thrown when the library is used on unsupported CPU architecture or operating
        ///     system.
        /// </exception>
        /// <exception cref="FileNotFoundException">
        ///     Thrown when the library does not contain embedded validator executable for the
        ///     current platform.
        /// </exception>
        public ValidationContext(bool useEmbeddedValidator = true)
        {
            if (!useEmbeddedValidator) return;

            if (RuntimeInformation.OSArchitecture != Architecture.X64)
                throw new NotSupportedException("Only x64 operating systems are supported.");

            var exeName = "gltf_validator";
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                exeName += "-win64.exe";
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
                exeName += "-linux64";
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
                exeName += "-osx64";
            else
                throw new NotSupportedException("Only Windows, Linux, and macOS are supported.");

            var assembly = Assembly.GetExecutingAssembly();
            var resourceStream = assembly.GetManifestResourceStream($"glTF-Validator.compiled.{exeName}");

            if (resourceStream == null)
                throw new FileNotFoundException(
                    $"Embedded validator named {exeName} not found. Maybe it was not included in the build.");

            _embeddedValidatorPath = Path.Combine(Path.GetTempPath(), $"{Path.GetRandomFileName()}_{exeName}");

            using (var fileStream = File.OpenWrite(_embeddedValidatorPath))
            {
                resourceStream.CopyTo(fileStream);
            }

            if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux) || RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
                Process.Start("chmod", $@"+x ""{_embeddedValidatorPath}""");
        }

        /// <summary>
        ///     Removes extracted glTF-Validator temporary executable.
        /// </summary>
        public void Dispose()
        {
            if (_embeddedValidatorPath == null) return;
            try
            {
                File.Delete(_embeddedValidatorPath);
            }
            catch
            {
                // ignored
            }
        }

        /// <summary>
        ///     Deserializes validation report from JSON string.
        /// </summary>
        /// <param name="json">String containing the report.</param>
        public static ValidationReport Parse(string json)
        {
            return JsonSerializer.Deserialize<ValidationReport>(json, Options);
        }

        /// <summary>
        ///     Asynchronously deserializes validation report from JSON stream.
        /// </summary>
        /// <param name="json">Stream containing JSON report.</param>
        /// <param name="cancellationToken">A token that may be used to cancel the operation.</param>
        public static ValueTask<ValidationReport> ParseAsync(Stream json, CancellationToken cancellationToken = default)
        {
            return JsonSerializer.DeserializeAsync<ValidationReport>(json, Options, cancellationToken);
        }

        /// <summary>
        ///     Runs glTF-Validator on provided asset and returns deserialized report.
        /// </summary>
        /// <param name="path">Path to the glTF file.</param>
        /// <param name="customValidatorPath">
        ///     Path to the custom glTF-Validator executable. Must be provided if
        ///     <c>ValidationContext</c> was created with <c>useEmbeddedValidator = false</c>.
        /// </param>
        /// <param name="validateResources">When set to <c>false</c>, only JSON description is validated.</param>
        /// <param name="timeout">Overrides default validation timeout.</param>
        /// <returns>A <c>ValidationReport</c> instance.</returns>
        /// <exception cref="ArgumentException">Thrown when either asset or custom glTF-Validator path is incorrect.</exception>
        /// <exception cref="FileNotFoundException">Thrown when glTF asset or custom glTF-Validator is not found.</exception>
        /// <exception cref="InvalidOperationException">
        ///     Thrown when the <c>ValidationContext</c> was created without embedded
        ///     validator but custom one was not provided.
        /// </exception>
        /// <exception cref="TimeoutException">Thrown when validation takes longer than allowed time.</exception>
        /// <exception cref="ApplicationException">Thrown when the validator encounters unhandled runtime error.</exception>
        public ValidationReport Validate(string path, string customValidatorPath = "", bool validateResources = true,
            TimeSpan timeout = default)
        {
            return ValidateAsync(path, customValidatorPath, validateResources, timeout).Result;
        }

        /// <summary>
        ///     Asynchronously runs glTF-Validator on provided asset and returns deserialized report.
        /// </summary>
        /// <param name="path">Path to the glTF file.</param>
        /// <param name="customValidatorPath">
        ///     Path to the custom glTF-Validator executable. Must be provided if
        ///     <c>ValidationContext</c> was created with <c>useEmbeddedValidator = false</c>.
        /// </param>
        /// <param name="validateResources">When set to <c>false</c>, only JSON description is validated.</param>
        /// <param name="timeout">Overrides default validation timeout.</param>
        /// <returns>A <c>ValueTask</c> completing with <c>ValidationReport</c> instance.</returns>
        /// <exception cref="ArgumentException">Thrown when either asset or custom glTF-Validator path is incorrect.</exception>
        /// <exception cref="FileNotFoundException">Thrown when glTF asset or custom glTF-Validator is not found.</exception>
        /// <exception cref="InvalidOperationException">
        ///     Thrown when the <c>ValidationContext</c> was created without embedded
        ///     validator but custom one was not provided.
        /// </exception>
        /// <exception cref="TimeoutException">Thrown when validation takes longer than allowed time.</exception>
        /// <exception cref="ApplicationException">Thrown when the validator encounters unhandled runtime error.</exception>
        public async Task<ValidationReport> ValidateAsync(string path, string customValidatorPath = "",
            bool validateResources = true, TimeSpan timeout = default)
        {
            if (string.IsNullOrWhiteSpace(path))
                throw new ArgumentException("Asset path cannot be null or empty.", nameof(path));

            if (!File.Exists(path)) throw new FileNotFoundException($"Asset {path} not found.", path);

            if (!Path.IsPathRooted(path)) path = Path.GetFullPath(path);

            var validatorPath = string.IsNullOrWhiteSpace(customValidatorPath)
                ? _embeddedValidatorPath
                : customValidatorPath;

            if (_embeddedValidatorPath == null && string.IsNullOrWhiteSpace(validatorPath))
                throw new InvalidOperationException("Nor embedded neither custom validator is available.");

            if (!File.Exists(validatorPath))
                throw new FileNotFoundException($"Validator executable {path} not found.", validatorPath);

            if (timeout == default) timeout = DefaultTimeout;

            using (var p = new Process())
            {
                p.StartInfo = new ProcessStartInfo
                {
                    FileName = validatorPath,
                    Arguments = $@"{(validateResources ? "-oprt" : "-opt")} ""{path}""",
                    UseShellExecute = false,
                    RedirectStandardError = true,
                    RedirectStandardOutput = true
                };
                using (var cancellationTokenSource = new CancellationTokenSource())
                {
                    p.Start();
                    var reportTask = ParseAsync(p.StandardOutput.BaseStream, cancellationTokenSource.Token).AsTask();
                    var delayTask = Task.Delay(timeout, cancellationTokenSource.Token);
                    if (await Task.WhenAny(reportTask, delayTask) == delayTask)
                    {
                        try
                        {
                            cancellationTokenSource.Cancel(); // cancels JSON parsing
                            p.Kill();
                        }
                        catch
                        {
                            // ignored
                        }

                        throw new TimeoutException($"Validation exceeded {timeout} time limit.");
                    }

                    cancellationTokenSource.Cancel(); // cancels delayed timeout task
                    try
                    {
                        return reportTask.Result;
                    }
                    catch (AggregateException ae)
                    {
                        // JSON parsing error likely caused by the validator runtime error that ends with empty stdout
                        if (ae.InnerExceptions[0] is JsonException)
                            throw new ApplicationException(p.StandardError.ReadToEnd());
                        throw ae.InnerExceptions[0];
                    }
                }
            }
        }
    }
}
