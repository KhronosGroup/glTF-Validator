using System;
using System.Collections.Generic;
using System.Text;

namespace glTF2Validator
{
    /// <summary>
    /// Represents the resulting report of a glTF validation.
    /// </summary>
    public sealed class ValidationReport
    {
        internal ValidationReport(string srcPath, string rawReport)
        {
            var lines = rawReport.Split('\n');

            var status = 0;

            var www = new List<string>();
            var eee = new List<string>();

            foreach (var l in lines)
            {
                if (l == "\tWarnings:") { status = 1; continue; }
                if (l == "\tErrors:") { status = 2; continue; }

                if (status == 1) www.Add(l.Trim());
                if (status == 2) eee.Add(l.Trim());
            }

            FilePath = srcPath;
            RawReport = rawReport;
            Warnings = www;
            Errors = eee;
        }

        /// <summary>
        /// Gets the file path from which this report was originated.
        /// </summary>
        public string FilePath { get; private set; }

        /// <summary>
        /// Gets the original report as emitted by gltf-validator.
        /// </summary>
        public string RawReport { get; private set; }

        /// <summary>
        /// Gets the warnings as a list.
        /// </summary>
        public IReadOnlyList<String> Warnings { get; private set; }

        /// <summary>
        /// Gets the errors as a list.
        /// </summary>
        public IReadOnlyList<String> Errors { get; private set; }

        
        /// <summary>
        /// True if warnings were found.
        /// </summary>
        public bool HasWarnings => Warnings.Count > 0;

        /// <summary>
        /// True if errors were found.
        /// </summary>
        public bool HasErrors => Errors.Count > 0;

        public override string ToString()
        {
            return RawReport;
        }
    }
}
