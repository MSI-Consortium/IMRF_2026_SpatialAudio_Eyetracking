using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using LSL;
using UnityEditor;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using USE_Data;
using TrialDef = TrialDefGenerator.TrialDef;
using TaskDef = TrialDefGenerator.TaskDef;

//[RequireComponent(typeof(SendOSCMessage))]
public class TrialController3D : MonoBehaviour
{
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
    private readonly string[] lsl_sample = { "" };


    private readonly string StreamName = "AV_Localization";

    private readonly string StreamType = "Markers";
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
    private double reactATimestamp;

    // public HeadScript head;
    //private SendOSCMessage sendOSCMessage;
    private bool startButtonPressed; //stupid solution but does the job
    private bool stateInitialized;

    private float stimOnTime;

    private int trialCountInBlock = -1;
    private int trialCountInExpt = -1;

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
        InputSystem.pollingFrequency = 1000;
    }

    private void Start()
    {
        //_sendOscMessage = GetComponent<SendOSCMessage>();
        Application.targetFrameRate = frameRate;

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

        //Setting up LSL connection
        Hash128 osc_hash = new();
        osc_hash.Append(StreamName);
        osc_hash.Append(StreamType);
        StreamInfo streamInfo = new(StreamName, StreamType, 1, LSL.LSL.IRREGULAR_RATE,
            channel_format_t.cf_string, osc_hash.ToString());
        lsl_outlet = new StreamOutlet(streamInfo);

        foreach (GameObject go in VisualTargets) go.SetActive(false);
        FixationTarget.SetActive(false);

        confirmAction = InputSystem.actions.FindAction("Confirm");
        cancelAction = InputSystem.actions.FindActionMap("Experiment Control").FindAction("Cancel");
        reactAAction = InputSystem.actions.FindActionMap("Experiment Control").FindAction("React A");
        reactBAction = InputSystem.actions.FindActionMap("Experiment Control").FindAction("React B");

        reactAAction.started += context => reactATimestamp = context.time;
    }

    private async void Update()
    {
        await HandleState(); // Handles the current trial state logic - all actual stimulus control, timing, etc, should be handled here

        if (cancelAction.IsPressed()) Application.Quit(); // Quit the application when the Escape key is pressed

        if (frameData != null && CurrentTrialDef != null) StartCoroutine(frameData.AppendDataToBuffer());
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
                if (!stateInitialized && confirmAction.IsPressed())
                {
                    stateInitialized = true;
                    startButtonPressed = false;

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
                        //Debug.Log("Remaining trials in block: " + CurrentBlockTrialDefs.Count);
                    }
                    else if (AllTrialDefs.Count > 0) //no trials left in current block, still more blocks left
                    {
                        blockCount++;
                        trialCountInBlock = 0;
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

                if (confirmAction.IsPressed())
                {
                    //InitState("StimOn");
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
                        lsl_sample[0] = CurrentTrialDef.Code;
                        lsl_outlet.push_sample(lsl_sample);
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
        SubjectDataFolder = Application.persistentDataPath + dataSubFolder + "/Subject_" + ParticipantID + "_AVLoc_Data_" + dateString;

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