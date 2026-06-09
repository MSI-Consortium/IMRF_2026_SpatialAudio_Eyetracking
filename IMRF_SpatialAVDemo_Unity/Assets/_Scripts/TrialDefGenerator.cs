using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using Random = UnityEngine.Random;

public static class TrialDefGenerator
{
    public enum ExperimentType
    {
        IMRF_Demo,
        IMRF_AudioVerification,
    }

    public class TaskDef
    {
        public bool StartingInstructions;
        public bool InterblockStartInstructions;
        public bool InterblockEndInstructions;
    }
    
    
    public class TrialDef
    {
        public string AudioStimDelivery;
        public int? AudioStimIndex;
        public Vector3? AudioStimLocation;
        public string Code;
        public float PostStimPauseDuration;
        public float PreStimPauseDuration;
        public SpeakerPositioning.SpeakerDetails SpeakerDetails;
        public float? StimDuration;
        public int? VisualStimIndex;
        public Vector3? VisualStimLocation;
        public Vector3? FixationLocation;
        public float? MaxFixationDuration;
        public float? MinFixationDuration;
        public float PostFixationPauseDuration;
    }

    public static List<List<TrialDef>> GenerateTrialDefs(ExperimentType experimentType, TrialController3D controller)
    {
        switch (experimentType)
        {
            case ExperimentType.IMRF_Demo:
            {
                return IMRF_Demo_Trials();
            }
            case ExperimentType.IMRF_AudioVerification:
            {
                return IMRF_AudioVerification();
            }

            default:
                Debug.LogError($"Unknown trial type: {experimentType}");
                return new List<List<TrialDef>>();
        }
    }

    public static TaskDef GenerateTaskDef(ExperimentType experimentType)
    {
        TaskDef td = new TaskDef();
        switch (experimentType)
        {
            case ExperimentType.IMRF_Demo:
            {
                // td.StartingInstructions = true;
                return td;
            }
            case ExperimentType.IMRF_AudioVerification:
            {
                return td;
            }
            default:
                Debug.LogError($"Unknown expt type: {experimentType}");
                return td;
        }
    }

    private static List<List<TrialDef>> IMRF_Demo_Trials()
    {
        int nBlocks = 3;
        int nTrialsPerBlock = 30;

        Vector3[] targetLocations = new[]
            { new Vector3(-1, 1.2f, 1), new Vector3(1, 1.2f, 1) };
        
        //list of lists of trials (each list of trials is one block)
        List<List<TrialDef>> blockList = new();
        for (int iBlock = 0; iBlock < nBlocks; iBlock++)
        {
            List<TrialDef> blockTrialList = new();
            for (int iTrial = 0; iTrial < nTrialsPerBlock; iTrial += targetLocations.Length * 3)
            {
                List<TrialDef> td_a = GenerateTrials(targetLocations, "a");
                List<TrialDef> td_v = GenerateTrials(targetLocations, "v");
                List<TrialDef> td_av = GenerateTrials(targetLocations, "av");
                blockTrialList.AddRange(td_a);
                blockTrialList.AddRange(td_v);
                blockTrialList.AddRange(td_av);
            }
            blockTrialList = Shuffle(blockTrialList);
            blockList.Add(blockTrialList);
        }

        return blockList;
    }

    private static List<TrialDef> GenerateTrials(Vector3[] locations, string trialType)
    {
        float minITI = 1f;
        float maxITI = 2f;
        List<TrialDef> trialDefs = new List<TrialDef>();
        for (int iTrial = 0; iTrial < locations.Length; iTrial++)
        {
            TrialDef td = new TrialDef();
            td.StimDuration = 0.5f;
            td.PreStimPauseDuration = 0f;
            td.PostStimPauseDuration =  Random.Range(minITI, maxITI);
            td.SpeakerDetails = new SpeakerPositioning.SpeakerDetails();
            td.Code = trialType + "_" + iTrial;
            if (trialType.ToLower() == "a" || trialType.ToLower() == "av")
            {
                td.AudioStimIndex = 0;
                td.AudioStimDelivery = "vbap";
                td.AudioStimLocation = locations[iTrial];
            }

            if (trialType.ToLower() == "v" || trialType.ToLower() == "av")
            {
                td.VisualStimIndex = 0;
                td.VisualStimLocation = locations[iTrial];
            }
            trialDefs.Add(td);
        }
        return trialDefs;
    }

    private static List<List<TrialDef>> IMRF_AudioVerification()
    {
        //list of lists of trials (each list of trials is one block)
        List<List<TrialDef>> blockList = new();
        List<TrialDef> blockTrialList = new();
        
        

        blockList.Add(blockTrialList);
        return blockList;
    }
    
    
    private static List<T> Shuffle<T>(List<T> list)
    {
        int n = list.Count;
        for (int i = n - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1); // Use UnityEngine.Random for generating random numbers
            T temp = list[i];
            list[i] = list[j];
            list[j] = temp;
        }

        return list;
    }

}