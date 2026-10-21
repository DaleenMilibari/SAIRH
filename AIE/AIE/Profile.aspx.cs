using DBFunction;
using System;
using System.Linq;
using System.Web;

namespace AIE
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/Login");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserData();
            }

            divError.Visible = false;
            divErrorProfile.Visible = false;
        }

        private void LoadUserData()
        {
            AuthService.Account account = AuthService.GetById(Ado.UserDetails.UserID);
            if (account != null)
            {
                LblId.Text = account.Id.ToString();
                LblName.Text = account.FullName;
                TxtEmail.Text = account.Email;
                TxtMobile.Text = string.IsNullOrEmpty(account.MobileNo) ? "-" : account.MobileNo;

                if (LblUserRoleBadge != null)
                {
                    LblUserRoleBadge.Text = account.UserLevel ?? "Attendee";
                    LblUserRoleBadge.CssClass = string.Equals(account.UserLevel, "Admin", StringComparison.OrdinalIgnoreCase) 
                        ? "badge badge-danger" : "badge badge-info";
                }

                if (!string.IsNullOrEmpty(account.Organization) || !string.IsNullOrEmpty(account.JobTitle))
                {
                    string orgInfo = string.Join(" • ", new[] { account.JobTitle, account.Organization }.Where(s => !string.IsNullOrEmpty(s)));
                    if (LblOrgTitle != null) LblOrgTitle.Text = orgInfo;
                    if (pOrgTitle != null) pOrgTitle.Visible = true;
                }
                else if (pOrgTitle != null)
                {
                    pOrgTitle.Visible = false;
                }

                TxtEditFullName.Text = account.FullName;
                TxtEditMobile.Text = account.MobileNo ?? string.Empty;
                if (TxtEditOrg != null) TxtEditOrg.Text = account.Organization ?? string.Empty;
                if (TxtEditJobTitle != null) TxtEditJobTitle.Text = account.JobTitle ?? string.Empty;
                if (TxtEditSpecialty != null) TxtEditSpecialty.Text = account.Specialty ?? string.Empty;
                if (TxtEditLinkedIn != null) TxtEditLinkedIn.Text = account.LinkedInUrl ?? string.Empty;

                // Load Exhibition Roadmap
                var roadmap = SurveyService.GetUserRoadmap(account.Email);
                if (roadmap != null && roadmap.Count > 0)
                {
                    if (LblSurveyBadge != null)
                    {
                        LblSurveyBadge.Visible = false;
                        LblSurveyBadge.Text = string.Empty;
                    }
                    pRoadmapDesc.InnerText = "Your personalized itinerary is active with " + roadmap.Count + " recommended booth and research stops.";
                    pnlSurveyStops.Visible = true;
                    pnlSurveyStops.Style["display"] = "block";

                    var sb = new System.Text.StringBuilder();
                    foreach (var code in roadmap)
                    {
                        sb.AppendFormat("<span class=\"roadmap-stop-chip mr-1 mb-1\">{0}</span>", HttpUtility.HtmlEncode(code));
                    }
                    pnlStopsChips.InnerHtml = sb.ToString();

                    if (pnlRoadmapActions != null)
                    {
                        pnlRoadmapActions.InnerHtml = "<a href=\"Schedules\" id=\"lnkFloorMapAction\" class=\"roadmap-highlight-cta\"><i class=\"bi bi-compass mr-2\"></i><span>View on Floor Map</span><i class=\"bi bi-arrow-right ml-2 cta-arrow\"></i></a>\n<a href=\"Survey\" id=\"lnkSurveyAction\" class=\"roadmap-retake-btn\"><i class=\"bi bi-arrow-repeat mr-2\"></i><span>Retake Survey</span></a>";
                    }
                }
                else
                {
                    if (LblSurveyBadge != null)
                    {
                        LblSurveyBadge.Visible = false;
                        LblSurveyBadge.Text = string.Empty;
                    }
                    pRoadmapDesc.InnerText = "Answer 3 quick questions to generate a personalized tour of exhibitor booths and research showcases.";
                    pnlSurveyStops.Visible = false;
                    pnlSurveyStops.Style["display"] = "none";

                    if (pnlRoadmapActions != null)
                    {
                        pnlRoadmapActions.InnerHtml = "<a href=\"Survey\" id=\"lnkSurveyAction\" class=\"roadmap-highlight-cta\"><i class=\"bi bi-magic mr-2\"></i><span>Build My Roadmap</span><i class=\"bi bi-arrow-right ml-2 cta-arrow\"></i></a>";
                    }
                }
            }
        }

        protected void BtnShowChangePass_Click(object sender, EventArgs e)
        {
            div_changepasss.Visible = true;
            div_editprofile.Visible = false;
            divError.Visible = false;
            divErrorProfile.Visible = false;
        }

        protected void BtnShowProfile_Click(object sender, EventArgs e)
        {
            div_changepasss.Visible = false;
            div_editprofile.Visible = true;
            divError.Visible = false;
            divErrorProfile.Visible = false;
        }

        protected void BtnPudateProfile_Click(object sender, EventArgs e)
        {
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/Login");
                return;
            }

            string name = AuthService.NormalizeName(TxtEditFullName.Text);
            string mobile = AuthService.NormalizeMobile(TxtEditMobile.Text);

            string nameErr = AuthService.ValidateFullName(name);
            if (nameErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(nameErr, false), false);
                return;
            }

            string mobileErr = AuthService.ValidateMobile(mobile);
            if (mobileErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(mobileErr, false), false);
                return;
            }

            string org = (TxtEditOrg?.Text ?? string.Empty).Trim();
            string jobTitle = (TxtEditJobTitle?.Text ?? string.Empty).Trim();
            string specialty = (TxtEditSpecialty?.Text ?? string.Empty).Trim();
            string linkedIn = (TxtEditLinkedIn?.Text ?? string.Empty).Trim();

            if (!string.IsNullOrEmpty(linkedIn) && !linkedIn.StartsWith("http://", StringComparison.OrdinalIgnoreCase) && !linkedIn.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                linkedIn = "https://" + linkedIn;
            }

            try
            {
                AuthService.UpdateProfile(Ado.UserDetails.UserID, name, mobile, org, jobTitle, specialty, linkedIn, null);

                Ado.UserDetails.FullName = name;
                Ado.UserDetails.MobileNo = mobile;
                Ado.UserDetails.Organization = org;
                Ado.UserDetails.JobTitle = jobTitle;
                Ado.UserDetails.Specialty = specialty;
                Ado.UserDetails.LinkedInUrl = linkedIn;

                LblName.Text = name;
                TxtMobile.Text = string.IsNullOrEmpty(mobile) ? "-" : mobile;

                if (!string.IsNullOrEmpty(org) || !string.IsNullOrEmpty(jobTitle))
                {
                    string orgInfo = string.Join(" • ", new[] { jobTitle, org }.Where(s => !string.IsNullOrEmpty(s)));
                    if (LblOrgTitle != null) LblOrgTitle.Text = orgInfo;
                    if (pOrgTitle != null) pOrgTitle.Visible = true;
                }
                else if (pOrgTitle != null)
                {
                    pOrgTitle.Visible = false;
                }

                ShowProfileAlert(AuthMessages.Get("ProfileSaved", false), true);
            }
            catch (Exception ex)
            {
                AuthService.LogError("UpdateProfile", ex);
                ShowProfileAlert(AuthMessages.Get("GenericError", false), false);
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/Login");
                return;
            }

            string currentPass = TxtPassCurrent.Text ?? string.Empty;
            string newPass = TxtPass.Text ?? string.Empty;
            string newPassRe = TxtPassRe.Text ?? string.Empty;

            if (string.IsNullOrEmpty(currentPass))
            {
                ShowPasswordAlert(AuthMessages.Get("CurrentPasswordRequired", false), false);
                return;
            }

            var passErrs = AuthService.ValidatePasswordStrength(newPass, Ado.UserDetails.UserName, Ado.UserDetails.FullName);
            if (passErrs.Count > 0)
            {
                ShowPasswordAlert(AuthMessages.RenderHtml(passErrs, false), false, isRawHtml: true);
                return;
            }

            if (!string.Equals(newPass, newPassRe, StringComparison.Ordinal))
            {
                ShowPasswordAlert(AuthMessages.Get("PasswordMismatch", false), false);
                return;
            }

            try
            {
                List<string> changeErrors;
                bool ok = AuthService.ChangePassword(Ado.UserDetails.UserID, currentPass, newPass, out changeErrors);
                if (!ok)
                {
                    ShowPasswordAlert(AuthMessages.RenderHtml(changeErrors, false), false, isRawHtml: true);
                    return;
                }

                ShowPasswordAlert(AuthMessages.Get("PasswordChanged", false), true);
                TxtPassCurrent.Text = string.Empty;
                TxtPass.Text = string.Empty;
                TxtPassRe.Text = string.Empty;
            }
            catch (Exception ex)
            {
                AuthService.LogError("ChangePassword", ex);
                ShowPasswordAlert(AuthMessages.Get("GenericError", false), false);
            }
        }

        private void ShowProfileAlert(string msg, bool isSuccess)
        {
            divErrorProfile.Visible = true;
            divErrorProfile.Attributes["class"] = isSuccess ? "auth-alert alert alert-success" : "auth-alert alert alert-danger";
            divErrorProfile.InnerHtml = HttpUtility.HtmlEncode(msg);
        }

        private void ShowPasswordAlert(string htmlOrText, bool isSuccess, bool isRawHtml = false)
        {
            divError.Visible = true;
            divError.Attributes["class"] = isSuccess ? "auth-alert alert alert-success" : "auth-alert alert alert-danger";
            divError.InnerHtml = isRawHtml ? htmlOrText : HttpUtility.HtmlEncode(htmlOrText);
        }
    }
}