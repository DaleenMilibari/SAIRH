using DBFunction;
using System;
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

                if (LblLastLogin != null)
                {
                    LblLastLogin.Text = account.LastLoginAtUtc.HasValue 
                        ? account.LastLoginAtUtc.Value.ToLocalTime().ToString("yyyy/MM/dd HH:mm") 
                        : "جلسة نشطة";
                }

                if (LblPasswordAge != null)
                {
                    LblPasswordAge.Text = account.PasswordChangedAtUtc.HasValue 
                        ? account.PasswordChangedAtUtc.Value.ToLocalTime().ToString("yyyy/MM/dd") 
                        : "مؤمّنة";
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
                    LblSurveyBadge.Text = "مكتمل (" + roadmap.Count + " محطات)";
                    LblSurveyBadge.CssClass = "badge badge-success";
                    pRoadmapDesc.InnerText = "مسارك المخصص في المعرض نشط ويتضمن " + roadmap.Count + " محطة استكشافية موصى بها.";
                    pnlSurveyStops.Visible = true;

                    var sb = new System.Text.StringBuilder();
                    foreach (var code in roadmap)
                    {
                        sb.AppendFormat("<span class=\"badge badge-primary ml-1 mb-1\" style=\"background:#0284c7;font-size:0.75rem;\">{0}</span>", HttpUtility.HtmlEncode(code));
                    }
                    pnlStopsChips.InnerHtml = sb.ToString();
                    lnkSurveyAction.InnerHtml = "<i class=\"bi bi-arrow-repeat ml-1\"></i> إعادة الاستبيان";
                }
                else
                {
                    LblSurveyBadge.Text = "لم يكتمل بعد";
                    LblSurveyBadge.CssClass = "badge badge-warning";
                    pRoadmapDesc.InnerText = "أكمل استبيان التخصيص القصير خلال دقيقة للحصول على جولة مخصصة للأجنحة وشاشات الأبحاث.";
                    pnlSurveyStops.Visible = false;
                    lnkSurveyAction.InnerHtml = "<i class=\"bi bi-magic ml-1\"></i> بناء مساري المخصص";
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
            string mobile = AuthService.NormalizeMobile(TxtEditMobile.Text);

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
                ShowPasswordAlert(AuthMessages.RenderHtml(passErrs, true), false);
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
                    ShowPasswordAlert(AuthMessages.RenderHtml(changeErrors, true), false);
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

        private void ShowPasswordAlert(string msg, bool isSuccess)
        {
            divError.Visible = true;
            divError.Attributes["class"] = isSuccess ? "auth-alert alert alert-success" : "auth-alert alert alert-danger";
            divError.InnerHtml = HttpUtility.HtmlEncode(msg);
        }
    }
}