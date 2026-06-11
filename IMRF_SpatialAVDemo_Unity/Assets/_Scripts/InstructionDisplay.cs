using UnityEngine;
using TMPro;
using System.Threading.Tasks;
using UnityEngine.UI;
using Object = UnityEngine.Object;

[RequireComponent(typeof(AudioSource))]
public class InstructionDisplay : MonoBehaviour
{
    private const int TextOnlyInstructionDurationMs = 2500;
    private const string StartPromptText =
        "2AFC task\n\nPress A for LEFT.\nPress S for RIGHT.\n\nRespond as quickly and accurately as you can.\nPress Space to start.";

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

    public static InstructionDisplay GetOrCreateDefault(InstructionDisplay preferred = null)
    {
        InstructionDisplay display = preferred != null ? preferred : FindExistingDisplay();
        if (display == null)
        {
            GameObject displayObject = new GameObject("InstructionDisplay");
            display = displayObject.AddComponent<InstructionDisplay>();
        }

        if (display.GetComponent<AudioSource>() == null)
        {
            display.gameObject.AddComponent<AudioSource>();
        }

        display.EnsureInstructionTexts();
        display.Hide();
        return display;
    }

    void Start()
    {
        EnsureInstructionTexts();
        Hide();
    }

    public void ShowStartPrompt()
    {
        EnsureInstructionTexts();

        if (InitInstructions == null) return;

        InitInstructions.text = StartPromptText;

        if (NormalInstructions != null) NormalInstructions.gameObject.SetActive(false);
        InitInstructions.gameObject.SetActive(true);
    }

    public void HideAll()
    {
        Hide();
    }

    public async Task ShowInit()
    {
        if (InitInstructions == null) return;

        InitInstructions.gameObject.SetActive(true);

        await PlayClipOrDelay(InitInstructionsClip);

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
        if (NormalInstructions == null) return;

        NormalInstructions.text = text;
        NormalInstructions.gameObject.SetActive(true);

        await PlayClipOrDelay(clip);

        Hide();
    }

    async Task PlayClipOrDelay(AudioClip clip)
    {
        AudioSource audioSource = GetComponent<AudioSource>();
        if (clip != null && audioSource != null)
        {
            audioSource.PlayOneShot(clip);
            await Task.Delay((int)(clip.length * 1000));
            return;
        }

        await Task.Delay(TextOnlyInstructionDurationMs);
    }

    void EnsureInstructionTexts()
    {
        Canvas canvas = GetOrCreateCanvas();

        if (InitInstructions == null)
        {
            InitInstructions = GetOrCreateInstructionText(canvas.transform, "InitInstructionsText",
                StartPromptText);
        }

        if (NormalInstructions == null)
        {
            NormalInstructions = GetOrCreateInstructionText(canvas.transform, "NormalInstructionsText", "");
        }
    }

    private static InstructionDisplay FindExistingDisplay()
    {
        InstructionDisplay[] displays =
            Object.FindObjectsByType<InstructionDisplay>(FindObjectsInactive.Include, FindObjectsSortMode.None);

        foreach (InstructionDisplay display in displays)
        {
            if (display.name == "InstructionDisplay") return display;
        }

        return displays.Length > 0 ? displays[0] : null;
    }

    private static Canvas GetOrCreateCanvas()
    {
        GameObject canvasObject = GameObject.Find("InstructionCanvas");
        if (canvasObject == null)
        {
            canvasObject = new GameObject("InstructionCanvas", typeof(RectTransform));
        }

        Canvas canvas = canvasObject.GetComponent<Canvas>();
        if (canvas == null)
        {
            canvas = canvasObject.AddComponent<Canvas>();
        }

        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        canvas.sortingOrder = 100;

        CanvasScaler scaler = canvasObject.GetComponent<CanvasScaler>();
        if (scaler == null)
        {
            scaler = canvasObject.AddComponent<CanvasScaler>();
        }

        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.referenceResolution = new Vector2(1920, 1080);
        scaler.matchWidthOrHeight = 0.5f;

        if (canvasObject.GetComponent<GraphicRaycaster>() == null)
        {
            canvasObject.AddComponent<GraphicRaycaster>();
        }

        return canvas;
    }

    private static TMP_Text GetOrCreateInstructionText(Transform parent, string name, string defaultText)
    {
        TextMeshProUGUI text = FindTextByName(name);
        if (text == null)
        {
            GameObject textObject = new GameObject(name, typeof(RectTransform));
            textObject.transform.SetParent(parent, false);
            text = textObject.AddComponent<TextMeshProUGUI>();
        }
        else
        {
            text.transform.SetParent(parent, false);
        }

        if (string.IsNullOrWhiteSpace(text.text) && !string.IsNullOrEmpty(defaultText))
        {
            text.text = defaultText;
        }

        text.fontSize = 46;
        text.color = Color.white;
        text.alignment = TextAlignmentOptions.Center;
        text.enableWordWrapping = true;
        text.raycastTarget = false;

        RectTransform rectTransform = text.rectTransform;
        rectTransform.anchorMin = new Vector2(0.12f, 0.35f);
        rectTransform.anchorMax = new Vector2(0.88f, 0.65f);
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.offsetMax = Vector2.zero;

        text.gameObject.SetActive(false);
        return text;
    }

    private static TextMeshProUGUI FindTextByName(string name)
    {
        TextMeshProUGUI[] texts =
            Object.FindObjectsByType<TextMeshProUGUI>(FindObjectsInactive.Include, FindObjectsSortMode.None);

        foreach (TextMeshProUGUI text in texts)
        {
            if (text.name == name) return text;
        }

        return null;
    }

    void Hide()
    {
        if (InitInstructions != null) InitInstructions.gameObject.SetActive(false);
        if (NormalInstructions != null) NormalInstructions.gameObject.SetActive(false);

        AudioSource audioSource = GetComponent<AudioSource>();
        if (audioSource != null) audioSource.Stop();
    }
}
