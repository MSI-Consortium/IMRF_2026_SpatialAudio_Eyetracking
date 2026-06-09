using UnityEngine;
using TMPro;
using System.Threading.Tasks;

[RequireComponent(typeof(AudioSource))]
public class InstructionDisplay : MonoBehaviour
{
    public TMP_Text InitInstructions;
    public TMP_Text NormalInstructions;
    public AudioClip InitInstructionsClip;

    // screw it, everything's hard coded
    // proper way would be to make each phase modular and call Show() on their own
    // but since we have a giant Update() loop, we'd have to put some references in TrialController3D and some here, which doesn't make sense

    [TextArea]
    public string InterblockStartText = "Great job! Take a few moments to rest your eyes and ears.";
    public AudioClip InterblockStartClip;

    [TextArea]
    public string InterblockEndText = "The break will end soon, please get ready to point to where you hear the sound coming from once more.";
    public AudioClip InterblockEndClip;

    [TextArea]
    public string FinalBlockEndText = "In this final block, there won't be any sounds. Here, you need to point at the visual object as soon as it appears.";
    public AudioClip FinalBlockEndClip;

    [TextArea]
    public string EndOfExpText = "That's it! Thanks very much for your time and effort.";
    public AudioClip EndOfExpClip;

    void Start()
    {
        Hide();
    }

    public async Task ShowInit()
    {
        InitInstructions.gameObject.SetActive(true);

        GetComponent<AudioSource>().PlayOneShot(InitInstructionsClip);
        await Task.Delay((int)(InitInstructionsClip.length * 1000));

        Hide();
    }

    public async Task ShowInterblockStart()
    {
        await Show(InterblockStartText, InterblockStartClip);
    }

    public async Task ShowInterblockEnd()
    {
        await Show(InterblockEndText, InterblockEndClip);
    }

    public async Task ShowFinalBlockEnd()
    {
        await Show(FinalBlockEndText, FinalBlockEndClip);
    }

    public async Task ShowEndOfExp()
    {
        await Show(EndOfExpText, EndOfExpClip);
    }

    async Task Show(string text, AudioClip clip)
    {
        NormalInstructions.text = text;
        NormalInstructions.gameObject.SetActive(true);

        GetComponent<AudioSource>().PlayOneShot(clip);
        await Task.Delay((int)(clip.length * 1000));

        Hide();
    }

    void Hide()
    {
        InitInstructions.gameObject.SetActive(false);
        NormalInstructions.gameObject.SetActive(false);
        GetComponent<AudioSource>().Stop();
    }
}
