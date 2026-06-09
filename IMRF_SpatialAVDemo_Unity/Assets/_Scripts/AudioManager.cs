using System.Collections.Generic;
using System.Linq;
using extOSC;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    [SerializeField] private string oscHost = "127.0.0.1";
    [SerializeField] private int oscPort = 7374;

    private OSCTransmitter oscTransmitter;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public void InitOSC()
    {
        oscTransmitter = gameObject.AddComponent<OSCTransmitter>();
        oscTransmitter.RemoteHost = oscHost;
        oscTransmitter.RemotePort = oscPort;
        oscTransmitter.Connect();
    }


    public void SetPlaybackMode(string mode)
    {
        OSCMessage oscmsg = new("mode");
        oscmsg.AddValue(OSCValue.String(mode));
        oscTransmitter.Send(oscmsg);
    }

    public void SetPlaybackMode(string mode, int channel)
    {
        OSCMessage oscmsg = new("mode");
        oscmsg.AddValue(OSCValue.String(mode));
        oscmsg.AddValue(OSCValue.Int(channel));
        oscTransmitter.Send(oscmsg);
    }

    public void SetGain(int gain)
    {
        OSCMessage oscmsg = new("gain");
        oscmsg.AddValue(OSCValue.Int(gain));
        oscTransmitter.Send(oscmsg);
    }

    public void SetSourceLocation(int sourceID, Vector3 location, string vectorType)
    {
        OSCMessage oscmsg = AmbiPointOscMsg("source", vectorType, sourceID, location);
        oscTransmitter.Send(oscmsg);
    }

    public void SetSpeakerLocations(Vector3[] locations, string vectorType)
    {
        int[] ids = Enumerable.Range(1, locations.Length).ToArray();
        OSCMessage oscmsg = AmbiPointOscMsg("speakers", vectorType, ids, locations);
        Debug.Log(oscTransmitter);
        oscTransmitter.Send(oscmsg);
    }

    private OSCMessage AmbiPointOscMsg(string address, string vectorType, int id, Vector3 location)
    {
        OSCMessage oscmsg = new(address);
        oscmsg.AddValue(OSCValue.String(vectorType));
        oscmsg.AddValue(OSCValue.Int(id));
        oscmsg.AddValue(OSCValue.Float(location.x));
        oscmsg.AddValue(OSCValue.Float(location.y));
        oscmsg.AddValue(OSCValue.Float(location.z));

        return oscmsg;
    }

    private OSCMessage AmbiPointOscMsg(string address, string vectorType, IEnumerable<int> ids, Vector3[] locations)
    {
        OSCMessage oscmsg = new(address);
        for (int iLoc = 0; iLoc < locations.Count(); iLoc++)
        {
            Vector3 loc = locations.ElementAt(iLoc);
            oscmsg.AddValue(OSCValue.String(vectorType));
            oscmsg.AddValue(OSCValue.Int(ids.ElementAt(iLoc)));
            oscmsg.AddValue(OSCValue.Float(loc.x));
            oscmsg.AddValue(OSCValue.Float(loc.y));
            oscmsg.AddValue(OSCValue.Float(loc.z));
        }

        return oscmsg;
    }

    public Vector3 XYZtoAED(Vector3 xyz)
    {
        // Distance (r) - Magnitude of the vector
        float distance = xyz.magnitude;

        // Azimuth (theta) - Angle in the XY plane
        float azimuth = Mathf.Atan2(xyz.x, xyz.z) * Mathf.Rad2Deg;

        // Elevation (phi) - Angle from the XY plane towards the Z-axis
        float elevation = Mathf.Asin(xyz.y / distance) * Mathf.Rad2Deg;

        return new Vector3(azimuth, elevation, distance);
    }

    public void PreloadAudioFile(int id, string filename)
    {
        OSCMessage oscmsg = new("sfplay");
        oscmsg.AddValue(OSCValue.String("preload"));
        oscmsg.AddValue(OSCValue.Int(id));
        oscmsg.AddValue(OSCValue.String(filename));
        oscTransmitter.Send(oscmsg);
    }

    public void PreloadAudioFile(int id, string audiotype, string filename)
    {
        OSCMessage oscmsg = new("sfplay");
        oscmsg.AddValue(OSCValue.String(audiotype));
        oscmsg.AddValue(OSCValue.String("preload"));
        oscmsg.AddValue(OSCValue.Int(id));
        oscmsg.AddValue(OSCValue.String(filename));
        oscTransmitter.Send(oscmsg);
    }

    public void Play(int id)
    {
        OSCMessage oscmsg = new("sfplay");
        oscmsg.AddValue(OSCValue.String("play"));
        oscmsg.AddValue(OSCValue.Int(id));
        oscTransmitter.Send(oscmsg);
    }

    public void Stop()
    {
        OSCMessage oscmsg = new("sfplay");
        oscmsg.AddValue(OSCValue.String("play"));
        oscmsg.AddValue(OSCValue.String("stop"));
        oscTransmitter.Send(oscmsg);
    }

    public void Play(int id, string audiotype)
    {
        OSCMessage oscmsg = new("sfplay");
        oscmsg.AddValue(OSCValue.String(audiotype));
        oscmsg.AddValue(OSCValue.String("play"));
        oscmsg.AddValue(OSCValue.Int(id));
        oscTransmitter.Send(oscmsg);
    }
}