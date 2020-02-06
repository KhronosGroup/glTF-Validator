using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace glTF2Validator
{
    /// <summary>
    /// Represents the resulting report of a glTF validation.
    /// </summary>
    public sealed class ValidationReport
    {
        public static ValidationReport Parse(string json)
        {
            return JsonSerializer.Deserialize<ValidationReport>(json);
        }

        public string uri { get; set; }
        public string mimeType { get; set; }
        public string validatorVersion { get; set; }

        public ValidationIssues issues { get; set; }

        public ValidationInfo info { get; set; }
    }

    public sealed class ValidationIssues
    {
        public int numErrors { get; set; }
        public int numWarnings { get; set; }
        public int numInfos { get; set; }
        public int numHints { get; set; }
        public string[] messages { get; set; }
        public bool truncated { get; set; }
    }

    public sealed class ValidationInfo
    {
        public string version { get; set; }
        public string generator { get; set; }
        public int animationCount { get; set; }
        public int materialCount { get; set; }
        public bool hasMorphTargets { get; set; }
        public bool hasSkins { get; set; }
        public bool hasTextures { get; set; }
        public bool hasDefaultScene { get; set; }
        public int drawCallCount { get; set; }
        public int totalTriangleCount { get; set; }
        public int maxUVs { get; set; }
        public int maxInfluences { get; set; }
        public int maxAttributes { get; set; }
    }
}
