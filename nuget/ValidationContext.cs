using System;
using System.Runtime.InteropServices;

namespace glTF2Validator
{
    /// <summary>
    /// Represents the context used to validate files
    /// </summary>
    public class ValidationContext
    {
        /// <summary>
        /// Path to the gltf-validator command line executable (platform specific).
        /// </summary>
        public static string ValidatorExePath { get; set; }

        /// <summary>
        /// Timeout to cancel the validation operation.
        /// </summary>
        public static TimeSpan TimeOut { get; set; } = TimeSpan.FromSeconds(10);
        
        static ValidationContext()
        {
            SetDefaultPath();
        }

        
        private static void SetDefaultPath()
        {
            var assemblyDir = System.IO.Path.GetDirectoryName(typeof(ValidationContext).Assembly.Location);

            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                if (RuntimeInformation.OSArchitecture != Architecture.X64) return;
                ValidatorExePath = System.IO.Path.Combine(assemblyDir, "gltf_validator.exe");
            }

            if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                ValidatorExePath = System.IO.Path.Combine(assemblyDir, "gltf_validator");
            }
        }
        
        /// <summary>
        /// Validates a glTF file.
        /// </summary>
        /// <param name="gltfFilePath">Path to the glTF file.</param>
        /// <returns>A report.</returns>
        public static ValidationReport ValidateFile(string gltfFilePath)
        {
            if (!System.IO.File.Exists(gltfFilePath)) throw new ArgumentException($"File {gltfFilePath} not found.", nameof(gltfFilePath));

            if (string.IsNullOrWhiteSpace(ValidatorExePath)) return null;

            if (!System.IO.File.Exists(ValidatorExePath)) throw new System.IO.FileNotFoundException(ValidatorExePath);

            if (!System.IO.Path.IsPathRooted(gltfFilePath)) gltfFilePath = System.IO.Path.GetFullPath(gltfFilePath);

            var psi = new System.Diagnostics.ProcessStartInfo(ValidatorExePath);
            psi.Arguments = $"-p -r -a -o \"{gltfFilePath}\"";
            psi.UseShellExecute = false;
            psi.RedirectStandardOutput = true;

            using (var p = System.Diagnostics.Process.Start(psi))
            {
                if (!p.WaitForExit(TimeOut.Milliseconds))
                {
                    try { p.Kill(); } catch { }
                }

                var jsonReport = p.StandardOutput.ReadToEnd();

                if (string.IsNullOrWhiteSpace(jsonReport)) return null;

                return ValidationReport.Parse(jsonReport);
            }
        }
    }
}
