using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class SpeakerPositioning : MonoBehaviour
{
    
    public Transform ListenerPosition;
    public string CsvFilePath = "Assets/CaveSpeakerPositions.csv";
    public GameObject SpeakerPrefab; // Optional if you want to use a custom prefab
    
    [System.Serializable]
    public class SpeakerDetails
    {
        public int ChannelNumber;
        public float AZ_Degrees;
        public float EL_Degrees;
        public float Radius_Cm;
        public Vector3 Position;
        public GameObject SpeakerObject;
    }

    public List<SpeakerDetails> Speakers = new List<SpeakerDetails>();

    public void LoadSpeakersFromCsv()
    {
        string[] lines = File.ReadAllLines(CsvFilePath);
        if (lines.Length < 2)
        {
            Debug.LogError("CSV does not contain enough data.");    
            return;
        }

        for (int i = 1; i < lines.Length; i++)
        {
            string[] tokens = lines[i].Split(',');

            if (tokens.Length < 4) continue;

            SpeakerDetails speaker = new SpeakerDetails
            {
                ChannelNumber = int.Parse(tokens[0]),
                AZ_Degrees = float.Parse(tokens[1]),
                EL_Degrees = float.Parse(tokens[2]),
                Radius_Cm = float.Parse(tokens[3])
            };

            Vector3 position = SphericalToCartesian(
                speaker.AZ_Degrees,
                speaker.EL_Degrees,
                speaker.Radius_Cm / 100f // cm to meters
            );

            speaker.Position = ListenerPosition.position + position;
            speaker.SpeakerObject = CreateSpeakerObject(speaker.Position);
            
            speaker.SpeakerObject.SetActive(false);
            Speakers.Add(speaker);
        }
    }

    Vector3 SphericalToCartesian(float azDeg, float elDeg, float radius)
    {
        float azRad = azDeg * Mathf.Deg2Rad;
        float elRad = elDeg * Mathf.Deg2Rad;

        float x = radius * Mathf.Cos(elRad) * Mathf.Sin(azRad);
        float y = radius * Mathf.Sin(elRad);
        float z = radius * Mathf.Cos(elRad) * Mathf.Cos(azRad);

        return new Vector3(x, y, z);
    }

    GameObject CreateSpeakerObject(Vector3 position)
    {
        GameObject obj = SpeakerPrefab != null
            ? Instantiate(SpeakerPrefab)
            : GameObject.CreatePrimitive(PrimitiveType.Cube);

        obj.transform.position = position;
        obj.transform.localScale = new Vector3(0.121f, 0.181f, 0.115f); // meters (W x H x D)
        obj.name = "Speaker";

        return obj;
    }
}
