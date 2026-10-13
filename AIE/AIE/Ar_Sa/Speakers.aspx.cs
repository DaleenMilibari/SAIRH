using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;

namespace AIE.Ar_Sa
{
    public partial class Speakers : System.Web.UI.Page
    {
        public bool IsLoadedFromDatabase { get; private set; }
        public string DatabaseErrorMessage { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSpeakers();
            }
        }

        private void LoadSpeakers()
        {
            try
            {
                bool loadedFromDb;
                string errorMsg;
                List<SpeakerService.SpeakerViewModel> speakers = SpeakerService.GetSpeakers(isArabic: true, loadedFromDb: out loadedFromDb, errorMessage: out errorMsg);

                IsLoadedFromDatabase = loadedFromDb;
                DatabaseErrorMessage = errorMsg;

                if (speakers != null && speakers.Count > 0)
                {
                    rptSpeakers.DataSource = speakers;
                    rptSpeakers.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Ultimate defensive try-catch to guarantee page never crashes if DB fails
                System.Diagnostics.Trace.TraceError("[Ar_Sa/Speakers.aspx] Page Load Error: " + ex);
                DatabaseErrorMessage = ex.Message;
                IsLoadedFromDatabase = false;

                try
                {
                    // Fallback to static JSON cache in Arabic
                    List<SpeakerService.SpeakerViewModel> fallback = SpeakerService.GetFallbackSpeakers(isArabic: true);
                    rptSpeakers.DataSource = fallback;
                    rptSpeakers.DataBind();
                }
                catch (Exception fallbackEx)
                {
                    System.Diagnostics.Trace.TraceError("[Ar_Sa/Speakers.aspx] Fallback failed: " + fallbackEx);
                }
            }
        }

        protected string ResolveSpeakerUrl(object pathObj)
        {
            if (pathObj == null) return string.Empty;
            string path = pathObj.ToString().Trim();
            if (string.IsNullOrEmpty(path)) return string.Empty;
            if (path.StartsWith("~")) return ResolveUrl(path);
            return path;
        }

        protected string RenderLectureHtml(string lectureTitle, string lectureLabel)
        {
            if (string.IsNullOrWhiteSpace(lectureTitle)) return string.Empty;
            return string.Format(
                "<div class=\"speaker-lecture-card\">" +
                "<div class=\"speaker-lecture-label\"><i class=\"bi bi-mic-fill\"></i> {0}</div>" +
                "<p class=\"speaker-lecture-title\">{1}</p>" +
                "</div>",
                HttpUtility.HtmlEncode(lectureLabel ?? "عنوان المحاضرة"),
                lectureTitle
            );
        }

        protected string RenderKeynotePill(string sessionRole)
        {
            return string.Empty;
        }

        protected string RenderSessionStrip(object roomObj, object dayObj, object timeObj, bool isAr)
        {
            return string.Empty;
        }
    }
}