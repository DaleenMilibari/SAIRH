using DBFunction;
using System;
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

                if (LblLastLogin != null)
                {
                    LblLastLogin.Text = account.LastLoginAtUtc.HasValue 
                        ? account.LastLoginAtUtc.Value.ToLocalTime().ToString("MMM dd, yyyy HH:mm") 
                        : "Active Session";
                }

                if (LblPasswordAge != null)
                {
                    LblPasswordAge.Text = account.PasswordChangedAtUtc.HasValue 
                        ? account.PasswordChangedAtUtc.Value.ToLocalTime().ToString("MMM dd, yyyy") 
                        : "Secured";
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
                    LblSurveyBadge.Text = "Completed (" + roadmap.Count + " stops)";
                    LblSurveyBadge.CssClass = "badge badge-success";
                    pRoadmapDesc.InnerText = "Your personalized roadmap is active with " + roadmap.Count + " recommended booth and research stops.";
                    pnlSurveyStops.Visible = true;

                    var sb = new System.Text.StringBuilder();
                    foreach (var code in roadmap)
                    {
                        sb.AppendFormat("<span class=\"badge badge-primary mr-1 mb-1\" style=\"background:#0284c7;font-size:0.75rem;\">{0}</span>", HttpUtility.HtmlEncode(code));
                    }
                    pnlStopsChips.InnerHtml = sb.ToString();
                    lnkSurveyAction.InnerHtml = "<i class=\"bi bi-arrow-repeat mr-1\"></i> Retake Survey";
                }
                else
                {
                    LblSurveyBadge.Text = "Not Completed";
                    LblSurveyBadge.CssClass = "badge badge-warning";
                    pRoadmapDesc.InnerText = "Take our short 1-minute survey to get a tailored tour of sponsor booths and research displays.";
                    pnlSurveyStops.Visible = false;
                    lnkSurveyAction.InnerHtml = "<i class=\"bi bi-magic mr-1\"></i> Build My Roadmap";
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
                ShowPasswordAlert(AuthMessages.RenderHtml(passErrs, false), false);
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
                    ShowPasswordAlert(AuthMessages.RenderHtml(changeErrors, false), false);
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

        private void ShowPasswordAlert(string msg, bool isSuccess)
        {
            divError.Visible = true;
            divError.Attributes["class"] = isSuccess ? "auth-alert alert alert-success" : "auth-alert alert alert-danger";
            divError.InnerHtml = HttpUtility.HtmlEncode(msg);
        }
    }
}