using System;
using UnityEditor;
using UnityEngine;

public class AprilTagTexturePostprocessor : AssetPostprocessor
{
    private const string AprilTagResourcePath = "Assets/Resources/AprilTags/";

    private void OnPreprocessTexture()
    {
        if (!assetPath.StartsWith(AprilTagResourcePath, StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        TextureImporter importer = (TextureImporter)assetImporter;
        importer.textureType = TextureImporterType.Default;
        importer.mipmapEnabled = false;
        importer.alphaIsTransparency = false;
        importer.filterMode = FilterMode.Point;
        importer.textureCompression = TextureImporterCompression.Uncompressed;
        importer.sRGBTexture = false;
        importer.npotScale = TextureImporterNPOTScale.None;
        importer.wrapMode = TextureWrapMode.Clamp;
        importer.maxTextureSize = 4096;
    }
}
