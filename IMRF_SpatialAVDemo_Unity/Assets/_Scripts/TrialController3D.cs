using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Threading.Tasks;
using LSL;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using USE_Data;
using TrialDef = TrialDefGenerator.TrialDef;
using TaskDef = TrialDefGenerator.TaskDef;

//[RequireComponent(typeof(SendOSCMessage))]
public class TrialController3D : MonoBehaviour
{
    private const string StreamName = "AV_Localization";
    private const string StreamType = "Markers";
    // Keep the stream name stable for LabRecorder, but make the source_id unique per
    // run so pylsl does not reconnect to stale empty outlets from earlier Unity runs.
    private const string StreamSourceIdPrefix = "IMRF_2026_SpatialAV_Unity_AV_Localization_Int32";

    private const int LslCodeUnknownStatus = 990;
    private const int LslCodeReady = 900;
    private const int LslCodeRunning = 902;
    private const int LslCodeBlockStart = 910;
    private const int LslCodeBlockEnd = 911;
    private const int LslCodeTrialStart = 912;
    private const int LslCodeStop = 997;
    private const int LslCodeFinished = 998;
    private const int LslCodeClosed = 999;

    private static TrialController3D activeController;

    public AudioManager audioManager;
    public SpeakerPositioning SpeakerPositioning;
    public InstructionDisplay InstructionDisplay;

    public Vector3[] speakerPositions;

    public string dataSubFolder;
    public int frameRate = 60;

    public GameObject listener;
    public int gain;

    public List<GameObject> VisualTargets;
    public GameObject FixationTarget;
    public Material fixationMaterialGreen, fixationMaterialRed;
    public List<string> AudioFiles;

    public TrialDefGenerator.ExperimentType ExperimentType;
    private readonly float InterBlockBreakTime = 10f;
    private readonly int[] lsl_sample = { 0 };


    // public GameObject target;

    //private SendOSCMessage _sendOscMessage;
    private TaskDef TaskDef;
    private List<List<TrialDef>> AllTrialDefs;
    private List<TrialDef> CurrentBlockTrialDefs;
    private TrialDef CurrentTrialDef;
    private int blockCount;
    private bool blockEndInitialized;

    private InputAction confirmAction, cancelAction, reactAAction, reactBAction;
    private Vector3 correctedWandDirection;

    private string dateString, SubjectDataFolder;

    private FrameData frameData;
    private bool isCoroutineRunning = false; // Flag to prevent multiple coroutines from overlapping
    private StreamOutlet lsl_outlet;
    private bool lslReady;
    private string lslStreamSourceId;
    private double reactATimestamp;
    private bool hasSentClosedMarker;
    private bool ownsControllerSlot;
    private bool startPromptShown;
    private int lslSampleCount;
    private InputActionMap experimentControlActions;

    // public HeadScript head;
    //private SendOSCMessage sendOSCMessage;
    private bool startButtonPressed; //stupid solution but does the job
    private bool stateInitialized;

    private float stimOnTime;

    private int trialCountInBlock = -1;
    private int trialCountInExpt = -1;
    private int lslBlockNumber = 1;
    private int lslTrialNumber = 0;
    private int lslTrialInBlockNumber = 0;

    private TrialData trialData;
    private string trialState, prevTrialState;
    private float TrialStateOnsetTime;

    public Vector3? VisualTargetPos, AudioTargetPos, FixationPos;
    public bool StoreData { get; set; } = true;

    public string ParticipantID { get; set; }
    public string Handedness { get; set; }
    public string Age { get; set; }
    public string Gender { get; set; }

    private void Awake()
    {
        if (activeController != null && activeController != this)
        {
            Debug.LogWarning("Duplicate TrialController3D detected; disabling this instance to keep one Unity LSL outlet.");
            enabled = false;
            return;
        }

        activeController = this;
        ownsControllerSlot = true;
        InputSystem.pollingFrequency = 1000;
    }

    private void Start()
    {
        //_sendOscMessage = GetComponent<SendOSCMessage>();
        Application.targetFrameRate = frameRate;

        foreach (GameObject go in VisualTargets) go.SetActive(false);
        FixationTarget.SetActive(false);
        InstructionDisplay = global::InstructionDisplay.GetOrCreateDefault(InstructionDisplay);
        startPromptShown = false;

        SpeakerPositioning.LoadSpeakersFromCsv();

        speakerPositions = new Vector3[SpeakerPositioning.Speakers.Count];
        for (int iSpeaker = 0; iSpeaker < SpeakerPositioning.Speakers.Count; iSpeaker++)
            speakerPositions[iSpeaker] = SpeakerPositioning.Speakers[iSpeaker].Position - listener.transform.position;
        audioManager.InitOSC();
        audioManager.SetSpeakerLocations(speakerPositions, "xyz");

        //_sendOscMessage.address = "speakers";
        //_sendOscMessage.SendXYZVectors(speakerPositions);
        //TODO add in live speaker handling

        trialState = "none";
        stateInitialized = false;
        blockEndInitialized = false;

        InitLSL();

        if (InputSystem.actions != null)
        {
            experimentControlActions = InputSystem.actions.FindActionMap("Experiment Control");
            experimentControlActions?.Enable();
            confirmAction = experimentControlActions?.FindAction("Confirm");
            cancelAction = experimentControlActions?.FindAction("Cancel");
            reactAAction = experimentControlActions?.FindAction("React A");
            reactBAction = experimentControlActions?.FindAction("React B");
        }
        else
        {
            Debug.LogWarning("Project-wide Input System actions are unavailable. Falling back to direct keyboard input.");
        }

        if (reactAAction != null) reactAAction.started += context => reactATimestamp = context.time;
    }

    private async void Update()
    {
        await HandleState(); // Handles the current trial state logic - all actual stimulus control, timing, etc, should be handled here

        if (IsCancelPressed()) Application.Quit(); // Quit the application when the Escape key is pressed

        if (reactAAction == null && Keyboard.current != null && Keyboard.current.aKey.wasPressedThisFrame)
            reactATimestamp = Time.timeAsDouble;

        if (frameData != null && CurrentTrialDef != null) StartCoroutine(frameData.AppendDataToBuffer());
    }

    private bool IsConfirmPressed()
    {
        if (confirmAction != null && confirmAction.WasPressedThisFrame()) return true;

        return Keyboard.current != null && Keyboard.current.spaceKey.wasPressedThisFrame;
    }

    private bool IsCancelPressed()
    {
        if (cancelAction != null && cancelAction.WasPressedThisFrame()) return true;

        return Keyboard.current != null && Keyboard.current.escapeKey.wasPressedThisFrame;
    }

    private void InitLSL()
    {
        lslReady = false;

        try
        {
            Debug.Log("LSL native library loaded. liblsl version: " + LSL.LSL.library_version());
            lslStreamSourceId = StreamSourceIdPrefix + "_" + Guid.NewGuid().ToString("N").Substring(0, 8);
            Debug.Log("Unity LSL source ID: " + lslStreamSourceId);
            StreamInfo streamInfo = new(StreamName, StreamType, 1, LSL.LSL.IRREGULAR_RATE,
                channel_format_t.cf_int32, lslStreamSourceId);
            lsl_outlet = new StreamOutlet(streamInfo, chunk_size: 1);
            lslReady = true;
            PushLslMarker("STATUS:READY");
        }
        catch (DllNotFoundException e)
        {
            Debug.LogWarning("LSL native library was not found. The experiment will continue without LSL markers. " +
                             e.Message);
        }
        catch (Exception e)
        {
            Debug.LogWarning("Could not initialize LSL markers. The experiment will continue without LSL markers. " +
                             e.Message);
        }
    }

    private void PushLslMarker(string marker)
    {
        if (!lslReady || lsl_outlet == null || string.IsNullOrEmpty(marker)) return;

        try
        {
            lsl_sample[0] = MarkerCode(marker);
            lsl_outlet.push_sample(lsl_sample);
            lslSampleCount++;
            Debug.Log("LSL marker sent: " + marker + " -> " + lsl_sample[0]);
        }
        catch (Exception e)
        {
            lslReady = false;
            Debug.LogWarning("Could not send LSL marker. Disabling LSL markers for this run. " + e.Message);
        }
    }

    private static string MarkerValue(object value)
    {
        if (value == null) return "none";

        return value.ToString()
            .Replace("|", "_")
            .Replace("=", "_")
            .Replace(";", "_");
    }

    private static string NullableIntValue(int? value)
    {
        return value.HasValue ? value.Value.ToString() : "none";
    }

    private static int MarkerCode(string marker)
    {
        if (string.IsNullOrEmpty(marker)) return LslCodeUnknownStatus;

        if (marker.StartsWith("LSL_", StringComparison.OrdinalIgnoreCase) &&
            int.TryParse(marker.Substring(4), out int lslCode))
            return lslCode;

        string[] parts = marker.Split('|');
        string firstPart = parts[0];
        if (int.TryParse(firstPart, out int numericCode))
            return numericCode;

        if (firstPart.StartsWith("STATUS:", StringComparison.Ordinal))
        {
            if (firstPart == "STATUS:READY") return LslCodeReady;
            if (firstPart == "STATUS:RUNNING" || firstPart == "STATUS:START") return LslCodeRunning;
            if (firstPart.StartsWith("STATUS:BLOCK_START:", StringComparison.Ordinal)) return LslCodeBlockStart;
            if (firstPart.StartsWith("STATUS:BLOCK_END:", StringComparison.Ordinal)) return LslCodeBlockEnd;
            if (firstPart == "STATUS:STOP") return LslCodeStop;
            if (firstPart == "STATUS:FINISHED") return LslCodeFinished;
            if (firstPart == "STATUS:CLOSED") return LslCodeClosed;
            return LslCodeUnknownStatus;
        }

        string eventName = "";
        string triggerCode = "";
        foreach (string part in parts)
        {
            string[] kv = part.Split(new[] { '=' }, 2);
            if (kv.Length != 2) continue;
            if (kv[0] == "event") eventName = kv[1];
            if (kv[0] == "trigger_code") triggerCode = kv[1];
        }

        if (eventName == "TRIAL_START") return LslCodeTrialStart;
        if (eventName == "STIM_ON" && int.TryParse(triggerCode, out int stimCode)) return stimCode;

        return LslCodeUnknownStatus;
    }

    private static string TriggerCodeForCondition(string condition)
    {
        switch (condition.ToLowerInvariant())
        {
            case "a":
                return "3";
            case "v":
                return "6";
            case "av":
                return "11";
            default:
                return "none";
        }
    }

    private string CurrentTrialMarker(string eventName)
    {
        string code = CurrentTrialDef?.Code ?? "none";
        string condition = code.Split('_')[0];

        return string.Join("|", new[]
        {
            MarkerValue(code),
            "event=" + MarkerValue(eventName),
            "block=" + lslBlockNumber,
            "trial=" + lslTrialNumber,
            "trial_in_block=" + lslTrialInBlockNumber,
            "condition=" + MarkerValue(condition),
            "trigger_code=" + TriggerCodeForCondition(condition),
            "visual_index=" + NullableIntValue(CurrentTrialDef?.VisualStimIndex),
            "audio_index=" + NullableIntValue(CurrentTrialDef?.AudioStimIndex),
            "audio_delivery=" + MarkerValue(CurrentTrialDef?.AudioStimDelivery),
            "unity_time=" + Time.time.ToString("F6", CultureInfo.InvariantCulture),
            "frame=" + Time.frameCount
        });
    }
    //
    // public void SetExperimentType(int type)
    // {
    //     ExperimentType = (TrialDefGenerator.ExperimentType)type;
    // }
    //
    // public void OnStartButtonPressed()
    // {
    //     startButtonPressed = true;
    // }

    // Method to handle the state transitions of the trial
    private async Task HandleState()
    {
        switch (trialState)
        {
            case "none":
                if (!startPromptShown)
                {
                    InstructionDisplay.ShowStartPrompt();
                    startPromptShown = true;
                }

                if (!stateInitialized && IsConfirmPressed())
                {
                    stateInitialized = true;
                    startButtonPressed = false;
                    InstructionDisplay.HideAll();
                    lslBlockNumber = 1;
                    lslTrialNumber = 0;
                    lslTrialInBlockNumber = 0;

                    TaskDef = TrialDefGenerator.GenerateTaskDef(ExperimentType);
                    AllTrialDefs = TrialDefGenerator.GenerateTrialDefs(ExperimentType, this);
                    

                    CurrentBlockTrialDefs = AllTrialDefs[0];
                    AllTrialDefs.RemoveAt(0);
                    PrepareData();


                    for (int iAudio = 0; iAudio < AudioFiles.Count; iAudio++)
                        audioManager.PreloadAudioFile(1, AudioFiles[iAudio]);
                    //_sendOscMessage.oscSender.Client.SendCustomFormat("preload", ",is", iAudio + 1,
                    //AudioFiles[iAudio]);

                    if (TaskDef.StartingInstructions) 
                        await InstructionDisplay.ShowInit();

                    PushLslMarker("STATUS:RUNNING");
                    InitState("ITI"); // Move to the Inter-Trial Interval state
                }

                break;

            case "ITI":
                if (!stateInitialized)
                {
                    stateInitialized = true;

                    if (prevTrialState != "InterBlockBreak")
                    {
                        trialCountInExpt++;
                        trialCountInBlock++;
                    }

                    if (trialCountInExpt > 0 && prevTrialState != "InterBlockBreak")
                    {
                        StartCoroutine(trialData.AppendDataToBuffer());
                        StartCoroutine(trialData.AppendDataToFile());
                        StartCoroutine(frameData.AppendDataToFile());
                    }

                    //assign trial conditions
                    if (CurrentBlockTrialDefs.Count > 0) //there are still trials left in current block
                    {
                        CurrentTrialDef = CurrentBlockTrialDefs[0];
                        CurrentBlockTrialDefs.RemoveAt(0);
                        lslTrialNumber++;
                        lslTrialInBlockNumber++;
                        if (lslTrialInBlockNumber == 1)
                            PushLslMarker("STATUS:BLOCK_START:" + lslBlockNumber);
                        PushLslMarker(CurrentTrialMarker("TRIAL_START"));
                        //Debug.Log("Remaining trials in block: " + CurrentBlockTrialDefs.Count);
                    }
                    else if (AllTrialDefs.Count > 0) //no trials left in current block, still more blocks left
                    {
                        PushLslMarker("STATUS:BLOCK_END:" + lslBlockNumber);
                        blockCount++;
                        trialCountInBlock = 0;
                        lslBlockNumber++;
                        lslTrialInBlockNumber = 0;
                        if (CurrentTrialDef.VisualStimIndex.HasValue &&
                            VisualTargets[CurrentTrialDef.VisualStimIndex.Value].activeSelf)
                            VisualTargets[CurrentTrialDef.VisualStimIndex.Value].SetActive(false);

                        CurrentBlockTrialDefs = AllTrialDefs[0];
                        AllTrialDefs.RemoveAt(0);
                        // _sendOscMessage.oscSender.Client.SendCustomFormat("preload", ",is", 1, AudioFiles[CurrentTrialDef.AudioStimIndex.Value]);

                        //Debug.Log("#######Remaining blocks in expt: " + AllTrialDefs.Count);

                        InitState("InterBlockBreak");
                    }
                    else // end of experiment
                    {
                        //Debug.Log("Finished eXpt!");
                        PushLslMarker("STATUS:BLOCK_END:" + lslBlockNumber);
                        InitState("EndOfExpt");
                    }

                    // Debug.Log("Block: " + blockCount + ", Trial: " + trialCountInBlock + ", CurrentChannel: " + CurrentTrialDef.SpeakerDetails.ChannelNumber);

                    if (CurrentTrialDef.AudioStimIndex.HasValue)
                    {
                        //switch playback type
                        if (CurrentTrialDef.AudioStimDelivery.ToLower() == "vbap")
                            audioManager.SetPlaybackMode("vbap");
                        else if (CurrentTrialDef.AudioStimDelivery.ToLower() == "mono")
                            audioManager.SetPlaybackMode("mono", CurrentTrialDef.SpeakerDetails.ChannelNumber);


                        //send target location to max
                        audioManager.SetSourceLocation(1,
                            CurrentTrialDef.AudioStimLocation.Value - listener.transform.position, "xyz");


                        audioManager.SetGain(gain);
                    }


                    break;
                }


                if (CurrentTrialDef.VisualStimIndex.HasValue &&
                    VisualTargets[CurrentTrialDef.VisualStimIndex.Value].activeSelf && Time.time - stimOnTime >= 0.05f)
                    VisualTargets[CurrentTrialDef.VisualStimIndex.Value].SetActive(false);

                if (Time.time - TrialStateOnsetTime >= CurrentTrialDef.PreStimPauseDuration)
                {
                    if (CurrentTrialDef.FixationLocation.HasValue)
                        InitState("Fixation");
                    else
                        InitState("StimOn");
                }

                break;

            case "Fixation":
                if (!stateInitialized)
                {
                    stateInitialized = true;
                    FixationPos = CurrentTrialDef.FixationLocation;
                    FixationTarget.transform.position = FixationPos.Value;
                    FixationTarget.SetActive(true);
                }
                //
                // if (Time.time - TrialStateOnsetTime < 0.05f)
                // {
                //     InitState("FixError");
                //     FixationTarget.GetComponent<Renderer>().material = fixationMaterialRed;
                // }
                // else
                // {
                //     InitState("PostFixation");
                // }
                
                if (Time.time - TrialStateOnsetTime > CurrentTrialDef.MaxFixationDuration)
                    InitState("PostFixation");

                break;

            case "StimOn":
                if (!stateInitialized)
                {
                    stateInitialized = true;

                    if (CurrentTrialDef.AudioStimIndex.HasValue)
                        //play audio cue
                        audioManager.Play(CurrentTrialDef.AudioStimIndex.Value + 1);
                    //_sendOscMessage.address = "play";
                    //_sendOscMessage.SendInt(CurrentTrialDef.AudioStimIndex.Value + 1);
                    if (CurrentTrialDef.VisualStimIndex.HasValue)
                    {
                        int idx = CurrentTrialDef.VisualStimIndex.Value;
                        if (VisualTargets != null && idx >= 0 && idx < VisualTargets.Count)
                        {
                            if (CurrentTrialDef.VisualStimLocation.HasValue)
                                VisualTargets[idx].transform.position = CurrentTrialDef.VisualStimLocation.Value;

                            VisualTargets[idx].SetActive(true);
                        }
                    }

                    AudioTargetPos = CurrentTrialDef.AudioStimLocation;
                    VisualTargetPos = CurrentTrialDef.VisualStimLocation;
                    stimOnTime = TrialStateOnsetTime;
                    if (CurrentTrialDef.Code != null)
                    {
                        PushLslMarker(CurrentTrialMarker("STIM_ON"));
                    }
                }

                //InputType - buttons
                //Check for button press

                if (Time.time - TrialStateOnsetTime >= CurrentTrialDef.StimDuration)
                {
                    if (CurrentTrialDef.VisualStimIndex.HasValue)
                    {
                        int idx = CurrentTrialDef.VisualStimIndex.Value;
                        if (VisualTargets != null && idx >= 0 && idx < VisualTargets.Count)
                            VisualTargets[idx].SetActive(false);
                    }

                    audioManager.Stop(); //explicitly stop playback to prevent ghosting?

                    InitState("ISI"); // Move to ISI state
                }


                break;

            case "ISI":

                if (!stateInitialized) stateInitialized = true;


                if (Time.time - TrialStateOnsetTime >= CurrentTrialDef.PostStimPauseDuration)
                    // StartCoroutine(trialData.AppendDataToBuffer());
                    // StartCoroutine(trialData.AppendDataToFile());
                    InitState("ITI"); // Move to ISI state


                break;

            case "PostFixation":
                if (!stateInitialized)
                {
                    stateInitialized = true;
                    FixationTarget.SetActive(false);
                }

                if (Time.time - TrialStateOnsetTime >= CurrentTrialDef.PostFixationPauseDuration)
                    InitState("StimOn");

                break;

            case "InterBlockBreak":
                if (!stateInitialized)
                {
                    stateInitialized = true;
                    if (TaskDef.InterblockStartInstructions)
                        await InstructionDisplay.ShowInterblockStart();
                }

                if (!blockEndInitialized && Time.time - TrialStateOnsetTime > InterBlockBreakTime)
                {
                    blockEndInitialized = true;

                    if (TaskDef.InterblockEndInstructions)
                    {
                        if (AllTrialDefs.Count == 0)
                            await InstructionDisplay.ShowFinalBlockEnd();
                        else
                            await InstructionDisplay.ShowInterblockEnd();
                    }

                    InitState("ITI");
                }

                break;

            case "EndOfExpt":
                if (!stateInitialized)
                {
                    stateInitialized = true;
                    PushLslMarker("STATUS:FINISHED");
                    await InstructionDisplay.ShowEndOfExp();
                }

#if UNITY_EDITOR
                EditorApplication.isPlaying = false;
#elif UNITY_WEBPLAYER
        Application.OpenURL(webplayerQuitURL);
#else
                Application.Quit();
#endif

                break;
        }
    }

    // Initializes the new state by setting the relevant flags and state properties
    private void InitState(string newState)
    {
        Debug.Log("Trial State " + newState + " started.");
        prevTrialState = trialState;
        trialState = newState;
        TrialStateOnsetTime = Time.time;
        stateInitialized = false;
        blockEndInitialized = false;
    }

    private void OnApplicationQuit()
    {
        PushClosedMarkerOnce();
    }

    private void OnDestroy()
    {
        PushClosedMarkerOnce();

        if (lsl_outlet != null)
        {
            lsl_outlet.Dispose();
            lsl_outlet = null;
            lslReady = false;
        }

        if (ownsControllerSlot && activeController == this)
            activeController = null;
    }

    private void PushClosedMarkerOnce()
    {
        if (hasSentClosedMarker) return;

        PushLslMarker("STATUS:CLOSED");
        hasSentClosedMarker = true;
    }

    private void PrepareData()
    {
        //TODO: maybe should just return if StoreData is false?

        trialData = gameObject.AddComponent<TrialData>();
        trialData.DefineManually = true;
        // selectionData.CreateFile();
        trialData.InitDataController();
        trialData.AddDatum("ParticipantNumber", () => ParticipantID);
        trialData.AddDatum("BlockCount", () => blockCount);
        trialData.AddDatum("TrialCountInExpt", () => trialCountInExpt - 1);
        trialData.AddDatum("TrialCountInBlock", () => trialCountInBlock - 1);
        trialData.AddDatum("VisualTargetIndex", () => CurrentTrialDef.VisualStimIndex);
        trialData.AddDatum("AudioTargetIndex", () => CurrentTrialDef.AudioStimIndex);
        trialData.AddDatum("VisualTargetPosition", () => VisualTargetPos);
        trialData.AddDatum("FixationPosition", () => FixationPos);
        trialData.AddDatum("AudioTargetPosition", () => AudioTargetPos);
        trialData.AddDatum("AudioStimType", () => CurrentTrialDef.AudioStimDelivery);
        trialData.AddDatum("RT", () =>
            (float)reactATimestamp - stimOnTime > float.Epsilon ? (float)reactATimestamp - stimOnTime : null
        );


        //InputType - buttons
        //adddatum of response

        frameData = gameObject.AddComponent<FrameData>();
        frameData.DefineManually = true;
        // selectionData.CreateFile();
        frameData.InitDataController();
        frameData.AddDatum("ParticipantNumber", () => ParticipantID);
        frameData.AddDatum("FrameRate", () => frameRate);
        frameData.AddDatum("BlockCount", () => blockCount);
        frameData.AddDatum("TrialCountInExpt", () => trialCountInExpt);
        frameData.AddDatum("TrialCountInBlock", () => trialCountInBlock);
        frameData.AddDatum("TrialState", () => trialState);
        frameData.AddDatum("FrameCount", () => Time.frameCount);
        frameData.AddDatum("FrameStart", () => Time.time);
        frameData.AddDatum("VisualTargetPosition", () => VisualTargetPos);
        frameData.AddDatum("AudioTargetPosition", () => AudioTargetPos);
        //
        //InputType - buttons
        //adddatum current button press status


        dateString = DateTime.Now.ToString("yyyy__MM_dd__HH_mm_ss");
        SubjectDataFolder = Path.Combine(GetLocalDataRootFolder(), dataSubFolder,
            "Subject_" + ParticipantID + "_AVLoc_Data_" + dateString);
        Debug.Log("Saving experiment data to: " + SubjectDataFolder);

        trialData.folderPath = SubjectDataFolder;
        trialData.fileName = "IMRFDemo_TrialData_Subject_" + ParticipantID + "__" + dateString + ".csv";
        trialData.StoreData = StoreData;
        trialData.DefineDataController();
        StartCoroutine(trialData.CreateFile());


        frameData.folderPath = SubjectDataFolder; // + "/FrameData";    
        frameData.fileName = "IMRFDemo_FrameData_Subject_" + ParticipantID + "__" + dateString + ".csv";
        frameData.StoreData = StoreData;
        frameData.DefineDataController();
        StartCoroutine(frameData.CreateFile());

        if (StoreData)
        {
            string metadataFileName = "IMRFDemo_Metadata_Subject_" + ParticipantID + "__" + dateString + ".csv";
            string metadataFilePath = Path.Combine(SubjectDataFolder, metadataFileName);
            try
            {
                Directory.CreateDirectory(SubjectDataFolder);
                using StreamWriter writer = File.CreateText(metadataFilePath);
                writer.WriteLine("ExperimentType,ParticipantID,Handedness,Age,Gender");
                writer.WriteLine($"{ExperimentType},{ParticipantID},{Handedness},{Age},{Gender}");
            }
            catch (Exception e)
            {
                Debug.LogError("Error creating metadata file: " + e.Message);
            }
        }
    }

    private string GetLocalDataRootFolder()
    {
#if UNITY_EDITOR
        DirectoryInfo assetsDirectory = Directory.GetParent(Application.dataPath);
        if (assetsDirectory != null) return assetsDirectory.FullName;
#elif UNITY_STANDALONE_OSX
        DirectoryInfo directory = new(Application.dataPath);
        while (directory != null && !directory.Name.EndsWith(".app", StringComparison.OrdinalIgnoreCase))
        {
            directory = directory.Parent;
        }

        if (directory?.Parent != null) return directory.Parent.FullName;
#endif

        DirectoryInfo dataDirectory = Directory.GetParent(Application.dataPath);
        return dataDirectory != null ? dataDirectory.FullName : Application.persistentDataPath;
    }

    private class TrialData : DataController
    {
        public override void DefineDataController()
        {
        }
    }

    private class FrameData : DataController
    {
        public override void DefineDataController()
        {
        }
    }

}
