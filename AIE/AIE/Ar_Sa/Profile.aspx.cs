using DBFunction;
using System;
using System.Linq;
using System.Web;

namespace AIE.Ar_Sa
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/Ar_Sa/Login");
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
                    LblUserRoleBadge.Text = string.Equals(account.UserLevel, "Admin", StringComparison.OrdinalIgnoreCase) 
                        ? "مدير النظام" : "مشترك";
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
                    pRoadmapDesc.InnerText = "مسارك المخصص نشط ويتضمن " + roadmap.Count + " محطة استكشافية موصى بها تناسب اهتماماتك.";
                    pnlSurveyStops.Visible = true;
                    pnlSurveyStops.Style["display"] = "block";

                    var sb = new System.Text.StringBuilder();
                    foreach (var code in roadmap)
                    {
                        sb.AppendFormat("<span class=\"roadmap-stop-chip ml-1 mb-1\">{0}</span>", HttpUtility.HtmlEncode(code));
                    }
                    pnlStopsChips.InnerHtml = sb.ToString();

                    if (pnlRoadmapActions != null)
                    {
                        pnlRoadmapActions.InnerHtml = "<a href=\"Schedules\" id=\"lnkFloorMapAction\" class=\"roadmap-highlight-cta\"><i class=\"bi bi-compass ml-2\"></i><span>عرض على خريطة المعرض</span><i class=\"bi bi-arrow-left mr-2 cta-arrow\"></i></a>\n<a href=\"Survey\" id=\"lnkSurveyAction\" class=\"roadmap-retake-btn\"><i class=\"bi bi-arrow-repeat ml-2\"></i><span>إعادة الاستبيان</span></a>";
                    }
                }
                else
                {
                    if (LblSurveyBadge != null)
                    {
                        LblSurveyBadge.Visible = false;
                        LblSurveyBadge.Text = string.Empty;
                    }
                    pRoadmapDesc.InnerText = "أجب عن 3 أسئلة سريعة للحصول على مسار ذكي ومخصص يوجهك لأجنحة المعرض وشاشات الأبحاث.";
                    pnlSurveyStops.Visible = false;
                    pnlSurveyStops.Style["display"] = "none";

                    if (pnlRoadmapActions != null)
                    {
                        pnlRoadmapActions.InnerHtml = "<a href=\"Survey\" id=\"lnkSurveyAction\" class=\"roadmap-highlight-cta\"><i class=\"bi bi-magic ml-2\"></i><span>بناء مساري المخصص</span><i class=\"bi bi-arrow-left mr-2 cta-arrow\"></i></a>";
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
                Response.Redirect("~/Ar_Sa/Login");
                return;
            }

            string name = AuthService.NormalizeName(TxtEditFullName.Text);
            string countryCode = Request.Form["DdlEditCountryCode"] ?? "+966";
            string mobile = AuthService.NormalizeMobile(countryCode, TxtEditMobile.Text);

            string nameErr = AuthService.ValidateFullName(name);
            if (nameErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(nameErr, true), false);
                return;
            }

            string mobileErr = AuthService.ValidateMobile(mobile);
            if (mobileErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(mobileErr, true), false);
                return;
            }

            string org = (TxtEditOrg?.Text ?? string.Empty).Trim();
            string jobTitle = (TxtEditJobTitle?.Text ?? string.Empty).Trim();
            string specialty = (TxtEditSpecialty?.Text ?? string.Empty).Trim();
            string linkedIn = (TxtEditLinkedIn?.Text ?? string.Empty).Trim();

            string orgErr = AuthService.ValidateOrganization(org);
            if (orgErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(orgErr, true), false);
                return;
            }

            string jobErr = AuthService.ValidatePosition(jobTitle);
            if (jobErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(jobErr, true), false);
                return;
            }

            string specErr = AuthService.ValidateField(specialty);
            if (specErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(specErr, true), false);
                return;
            }

            string linkedInErr = AuthService.ValidateLinkedIn(linkedIn);
            if (linkedInErr != null)
            {
                ShowProfileAlert(AuthMessages.Get(linkedInErr, true), false);
                return;
            }

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

                ShowProfileAlert(AuthMessages.Get("ProfileSaved", true), true);
            }
            catch (Exception ex)
            {
                AuthService.LogError("UpdateProfileAr", ex);
                ShowProfileAlert(AuthMessages.Get("GenericError", true), false);
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (Ado.UserDetails == null)
            {
                Response.Redirect("~/Ar_Sa/Login");
                return;
            }

            string currentPass = TxtPassCurrent.Text ?? string.Empty;
            string newPass = TxtPass.Text ?? string.Empty;
            string newPassRe = TxtPassRe.Text ?? string.Empty;

            if (string.IsNullOrEmpty(currentPass))
            {
                ShowPasswordAlert(AuthMessages.Get("CurrentPasswordRequired", true), false);
                return;
            }

            var passErrs = AuthService.ValidatePasswordStrength(newPass, Ado.UserDetails.UserName, Ado.UserDetails.FullName);
            if (passErrs.Count > 0)
            {
                ShowPasswordAlert(AuthMessages.RenderHtml(passErrs, true), false, isRawHtml: true);
                return;
            }

            if (!string.Equals(newPass, newPassRe, StringComparison.Ordinal))
            {
                ShowPasswordAlert(AuthMessages.Get("PasswordMismatch", true), false);
                return;
            }

            try
            {
                List<string> changeErrors;
                bool ok = AuthService.ChangePassword(Ado.UserDetails.UserID, currentPass, newPass, out changeErrors);
                if (!ok)
                {
                    ShowPasswordAlert(AuthMessages.RenderHtml(changeErrors, true), false, isRawHtml: true);
                    return;
                }

                ShowPasswordAlert(AuthMessages.Get("PasswordChanged", true), true);
                TxtPassCurrent.Text = string.Empty;
                TxtPass.Text = string.Empty;
                TxtPassRe.Text = string.Empty;
            }
            catch (Exception ex)
            {
                AuthService.LogError("ChangePasswordAr", ex);
                ShowPasswordAlert(AuthMessages.Get("GenericError", true), false);
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