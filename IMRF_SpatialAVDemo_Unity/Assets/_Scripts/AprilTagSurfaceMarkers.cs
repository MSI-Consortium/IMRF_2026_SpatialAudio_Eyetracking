using System;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

[DisallowMultipleComponent]
public class AprilTagSurfaceMarkers : MonoBehaviour
{
    private const string CanvasName = "AprilTagSurfaceCanvas";
    private const string RootName = "AprilTagSurfaceMarkerRoot";

    private static readonly int[] TagIds = { 10, 11, 12, 13, 14, 15, 16, 17 };

    [Header("PNG Resources")]
    public string ResourceFolder = "AprilTags";
    public string ResourceNameFormat = "tag36h11_{0}";

    [Header("Layout")]
    public bool Visible = true;
    public Vector2 ReferenceResolution = new(3840f, 2160f);
    public float MonitorWidthCm = 71.0f;
    public float ViewingDistanceCm = 67.0f;
    public float MarkerSizeDeg = 4.0f;
    public float PaddingDeg = 0.8f;
    public int SortingOrder = 80;

    private Canvas markerCanvas;
    private RectTransform markerRoot;
    private int lastScreenWidth;
    private int lastScreenHeight;
    private bool lastVisible = true;

    public static AprilTagSurfaceMarkers GetOrCreateDefault(AprilTagSurfaceMarkers preferred = null)
    {
        AprilTagSurfaceMarkers markers = preferred != null ? preferred : FindExistingMarkers();
        if (markers == null)
        {
            GameObject markerObject = new GameObject("AprilTagSurfaceMarkers");
            markers = markerObject.AddComponent<AprilTagSurfaceMarkers>();
        }

        markers.EnsureMarkers();
        return markers;
    }

    private void Start()
    {
        EnsureMarkers();
    }

    private void Update()
    {
        if (Screen.width != lastScreenWidth || Screen.height != lastScreenHeight || Visible != lastVisible)
        {
            EnsureMarkers();
        }
    }

    public void EnsureMarkers()
    {
        markerCanvas = GetOrCreateCanvas();
        markerRoot = GetOrCreateRoot(markerCanvas.transform);

        markerCanvas.sortingOrder = SortingOrder;
        markerCanvas.gameObject.SetActive(Visible);

        ClearMarkerRoot();
        lastScreenWidth = Screen.width;
        lastScreenHeight = Screen.height;
        lastVisible = Visible;

        if (!Visible)
        {
            return;
        }

        float marginPx = ComputeMarkerMarginPx(
            ReferenceResolution.x,
            MonitorWidthCm,
            ViewingDistanceCm,
            MarkerSizeDeg,
            PaddingDeg
        );

        float scaleX = Screen.width / ReferenceResolution.x;
        float scaleY = Screen.height / ReferenceResolution.y;
        float markerWidth = Mathf.Max(1f, 2f * marginPx * scaleX);
        float markerHeight = Mathf.Max(1f, 2f * marginPx * scaleY);

        foreach (int tagId in TagIds)
        {
            Texture2D texture = LoadTagTexture(tagId);
            if (texture == null)
            {
                Debug.LogWarning(
                    "Missing AprilTag texture: Assets/Resources/" +
                    $"{ResourceFolder}/{string.Format(ResourceNameFormat, tagId)}.png"
                );
                continue;
            }

            Vector2 topLeftPosition = GetMarkerCentreTopLeftPx(tagId, marginPx, scaleX, scaleY);
            CreateMarkerImage(tagId, texture, topLeftPosition, new Vector2(markerWidth, markerHeight));
        }
    }

    private Texture2D LoadTagTexture(int tagId)
    {
        string resourceName = string.Format(ResourceNameFormat, tagId);
        string resourcePath = string.IsNullOrWhiteSpace(ResourceFolder)
            ? resourceName
            : $"{ResourceFolder}/{resourceName}";
        return Resources.Load<Texture2D>(resourcePath);
    }

    private Vector2 GetMarkerCentreTopLeftPx(int tagId, float marginPx, float scaleX, float scaleY)
    {
        float w = Screen.width;
        float h = Screen.height;
        float mx = marginPx * scaleX;
        float my = marginPx * scaleY;

        return tagId switch
        {
            10 => new Vector2(mx, h - my),       // bottom-left
            11 => new Vector2(mx, h / 2f),       // middle-left
            12 => new Vector2(mx, my),           // top-left
            13 => new Vector2(w / 2f, my),       // top-centre
            14 => new Vector2(w - mx, my),       // top-right
            15 => new Vector2(w - mx, h / 2f),   // middle-right
            16 => new Vector2(w - mx, h - my),   // bottom-right
            17 => new Vector2(w / 2f, h - my),   // bottom-centre
            _ => new Vector2(w / 2f, h / 2f)
        };
    }

    private void CreateMarkerImage(int tagId, Texture2D texture, Vector2 topLeftPosition, Vector2 size)
    {
        GameObject markerObject = new GameObject($"AprilTag_{tagId}", typeof(RectTransform), typeof(Image));
        markerObject.transform.SetParent(markerRoot, false);

        RectTransform markerRect = markerObject.GetComponent<RectTransform>();
        markerRect.anchorMin = Vector2.zero;
        markerRect.anchorMax = Vector2.zero;
        markerRect.pivot = new Vector2(0.5f, 0.5f);
        markerRect.sizeDelta = size;
        markerRect.anchoredPosition = new Vector2(topLeftPosition.x, Screen.height - topLeftPosition.y);

        Image backing = markerObject.GetComponent<Image>();
        backing.color = Color.white;
        backing.raycastTarget = false;

        GameObject textureObject = new GameObject("Texture", typeof(RectTransform), typeof(RawImage));
        textureObject.transform.SetParent(markerObject.transform, false);

        RectTransform textureRect = textureObject.GetComponent<RectTransform>();
        textureRect.anchorMin = Vector2.zero;
        textureRect.anchorMax = Vector2.one;
        textureRect.offsetMin = Vector2.zero;
        textureRect.offsetMax = Vector2.zero;

        RawImage image = textureObject.GetComponent<RawImage>();
        image.texture = texture;
        image.color = Color.white;
        image.raycastTarget = false;
    }

    private static float ComputeMarkerMarginPx(
        float screenWidthPx,
        float monitorWidthCm,
        float viewingDistanceCm,
        float markerSizeDeg,
        float paddingDeg
    )
    {
        float marginDeg = (markerSizeDeg + 2f * paddingDeg) / 2f;
        float marginCm = 2f * viewingDistanceCm * Mathf.Tan(marginDeg * Mathf.Deg2Rad / 2f);
        float pxPerCm = screenWidthPx / Mathf.Max(0.001f, monitorWidthCm);
        return marginCm * pxPerCm;
    }

    private static AprilTagSurfaceMarkers FindExistingMarkers()
    {
        AprilTagSurfaceMarkers[] markers =
            Object.FindObjectsByType<AprilTagSurfaceMarkers>(FindObjectsInactive.Include, FindObjectsSortMode.None);

        foreach (AprilTagSurfaceMarkers marker in markers)
        {
            if (marker.name == "AprilTagSurfaceMarkers") return marker;
        }

        return markers.Length > 0 ? markers[0] : null;
    }

    private static Canvas GetOrCreateCanvas()
    {
        GameObject canvasObject = GameObject.Find(CanvasName);
        if (canvasObject == null)
        {
            canvasObject = new GameObject(CanvasName, typeof(RectTransform));
        }

        Canvas canvas = canvasObject.GetComponent<Canvas>();
        if (canvas == null)
        {
            canvas = canvasObject.AddComponent<Canvas>();
        }

        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        canvas.pixelPerfect = true;

        CanvasScaler scaler = canvasObject.GetComponent<CanvasScaler>();
        if (scaler == null)
        {
            scaler = canvasObject.AddComponent<CanvasScaler>();
        }

        scaler.uiScaleMode = CanvasScaler.ScaleMode.ConstantPixelSize;
        scaler.scaleFactor = 1f;
        scaler.referencePixelsPerUnit = 100f;

        if (canvasObject.GetComponent<GraphicRaycaster>() == null)
        {
            canvasObject.AddComponent<GraphicRaycaster>();
        }

        return canvas;
    }

    private static RectTransform GetOrCreateRoot(Transform parent)
    {
        Transform existing = parent.Find(RootName);
        if (existing != null)
        {
            return existing.GetComponent<RectTransform>();
        }

        GameObject rootObject = new GameObject(RootName, typeof(RectTransform));
        rootObject.transform.SetParent(parent, false);

        RectTransform rectTransform = rootObject.GetComponent<RectTransform>();
        rectTransform.anchorMin = Vector2.zero;
        rectTransform.anchorMax = Vector2.one;
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.offsetMax = Vector2.zero;
        return rectTransform;
    }

    private void ClearMarkerRoot()
    {
        if (markerRoot == null)
        {
            return;
        }

        for (int i = markerRoot.childCount - 1; i >= 0; i--)
        {
            Transform child = markerRoot.GetChild(i);
            if (Application.isPlaying)
            {
                Destroy(child.gameObject);
            }
            else
            {
                DestroyImmediate(child.gameObject);
            }
        }
    }
}
