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

namespace Khronos.glTF2.Validator.Report
{
    /// <summary>
    ///     Represents the resulting report of a glTF validation.
    /// </summary>
    public sealed class ValidationReport
    {
        /// <value>
        ///     URI of the validated asset
        /// </value>
        public string Uri { get; set; }

        /// <value>
        ///     MIME type of validated asset
        /// </value>
        public string MimeType { get; set; }

        /// <value>
        ///     Version string
        /// </value>
        public string ValidatorVersion { get; set; }

        /// <value>
        ///     UTC timestamp
        /// </value>
        public DateTimeOffset ValidatedAt { get; set; }

        /// <value>
        ///     Found validation issues
        /// </value>
        public ValidationIssues Issues { get; set; }

        /// <value>
        ///     Extra information about the validated asset
        /// </value>
        public ValidationInfo Info { get; set; }
    }

    /// <summary>
    ///     Found validation issues
    /// </summary>
    public sealed class ValidationIssues
    {
        /// <value>
        ///     Number of found validation errors
        /// </value>
        public uint NumErrors { get; set; }

        /// <value>
        ///     Number of validation warnings
        /// </value>
        public uint NumWarnings { get; set; }

        /// <value>
        ///     Number of validation infos
        /// </value>
        public uint NumInfos { get; set; }

        /// <value>
        ///     Number of validation hints
        /// </value>
        public uint NumHints { get; set; }

        /// <value>
        ///     Array with validation messages
        /// </value>
        public ValidationMessage[] Messages { get; set; }

        /// <value>
        ///     Indicates that validation output is incomplete due to too many messages
        /// </value>
        public bool Truncated { get; set; }
    }

    /// <summary>
    ///     Single validation message
    /// </summary>
    public sealed class ValidationMessage
    {
        /// <value>
        ///     Issue code
        /// </value>
        public string Code { get; set; }

        /// <value>
        ///     Issue message
        /// </value>
        public string Message { get; set; }

        /// <value>
        ///     Indicates that validation output is incomplete due to too many messages
        /// </value>
        public Severity Severity { get; set; }

        /// <value>
        ///     JSON Pointer to the object causing the issue
        /// </value>
        public string Pointer { get; set; }

        /// <value>
        ///     Byte offset in GLB file. Applicable only to GLB issues.
        /// </value>
        public uint Offset { get; set; }
    }

    /// <summary>
    ///     Possible validation issue severities
    /// </summary>
    public enum Severity
    {
#pragma warning disable 1591
        Error,
        Warning,
        Info,
        Hint
#pragma warning restore 1591
    }

    /// <summary>
    ///     Extra information about the validated asset
    /// </summary>
    public sealed class ValidationInfo
    {
        /// <value />
        public string Version { get; set; }

        /// <value />
        public string MinVersion { get; set; }

        /// <value />
        public string Generator { get; set; }

        /// <value />
        public string[] ExtensionsUsed { get; set; }

        /// <value />
        public string[] ExtensionsRequired { get; set; }

        /// <value />
        public uint AnimationCount { get; set; }

        /// <value />
        public uint MaterialCount { get; set; }

        /// <value />
        public bool HasMorphTargets { get; set; }

        /// <value />
        public bool HasSkins { get; set; }

        /// <value />
        public bool HasTextures { get; set; }

        /// <value />
        public bool HasDefaultScene { get; set; }

        /// <value />
        public uint DrawCallCount { get; set; }

        /// <value />
        public uint TotalVertexCount { get; set; }

        /// <value />
        public uint TotalTriangleCount { get; set; }

        /// <value />
        public uint MaxUVs { get; set; }

        /// <value />
        public uint MaxInfluences { get; set; }

        /// <value />
        public uint MaxAttributes { get; set; }
    }
}
