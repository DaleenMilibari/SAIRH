using DBFunction;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AIE
{
    public partial class Survey : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                divError.Visible = false;

                bool isFirstTime = Request.QueryString["first"] == "1";
                if (isFirstTime)
                {
                    pnlFirstTimeBanner.Visible = true;
                    if (Ado.UserDetails != null && !string.IsNullOrEmpty(Ado.UserDetails.FullName))
                    {
                        LitUserName.Text = HttpUtility.HtmlEncode(Ado.UserDetails.FullName);
                    }
                }
            }
        }

        protected void BtnSubmitSurvey_Click(object sender, EventArgs e)
        {
            try
            {
                var interestsArr = Request.Form.GetValues("interests");
                var boothTypesArr = Request.Form.GetValues("boothTypes");
                var goalsArr = Request.Form.GetValues("goals");
                string countStr = Request.Form["boothCount"] ?? "5";

                var interests = interestsArr != null ? interestsArr.ToList() : new List<string>();
                var boothTypes = boothTypesArr != null ? boothTypesArr.ToList() : new List<string>();
                var goals = goalsArr != null ? goalsArr.ToList() : new List<string>();

                int boothCount = 5;
                int.TryParse(countStr, out boothCount);
                if (boothCount <= 0) boothCount = 5;

                // Score booths and generate roadmap
                var recommendedBooths = SurveyService.CalculateRecommendations(interests, boothTypes, goals, boothCount);
                var recommendedCodes = recommendedBooths.Select(b => b.BoothCode).ToList();

                // Get current user info if signed in
                string userEmail = "attendee@sairh.com";
                int? attendeeId = null;

                if (Ado.UserDetails != null)
                {
                    userEmail = Ado.UserDetails.UserName ?? Ado.UserDetails.FullName;
                    attendeeId = Ado.UserDetails.UserID;
                }
                else
                {
                    var cookie = Request.Cookies["sairh_user"];
                    if (cookie != null && !string.IsNullOrEmpty(cookie.Value))
                    {
                        userEmail = cookie.Value;
                    }
                }

                // Save to database & session
                SurveyService.SaveSurveyResponse(userEmail, attendeeId, interests, boothTypes, goals, boothCount, recommendedCodes, "en");

                // Also store recommendations in session for immediate render
                Session["UserRoadmap"] = recommendedCodes;
                Session["SurveyCompleted"] = true;

                // Redirect to the Exhibition page with highlight
                Response.Redirect("~/Schedules.aspx?survey=completed");
            }
            catch (Exception ex)
            {
                AuthService.LogError("Survey Submit", ex);
                divError.Visible = true;
                divError.InnerHtml = HttpUtility.HtmlEncode(AuthMessages.Get("GenericError", false));
            }
        }

        private static void LogError(string context, Exception ex)
        {
            System.Diagnostics.Trace.TraceError("[Survey] " + context + ": " + ex);
        }
    }
}