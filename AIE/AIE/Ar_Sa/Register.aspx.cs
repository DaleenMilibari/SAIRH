using DBFunction;
using System;
using System.Collections.Generic;

namespace AIE.Ar_Sa
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Ado.UserDetails != null)
            {
                Response.Redirect("~/Ar_Sa/Profile.aspx");
                return;
            }

            divError.Visible = false;
        }

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            string fullName = AuthService.NormalizeName(TxtFullName.Text);
            string email = AuthService.NormalizeEmail(TxtEmail.Text);
            string mobile = AuthService.NormalizeMobile(TxtMobile.Text);
            string password = TxtPassword.Text ?? string.Empty;
            string passwordAgain = TxtPasswordAgain.Text ?? string.Empty;

            List<string> errors = AuthService.ValidateRegistration(fullName, email, mobile, password, passwordAgain);
            if (errors.Count > 0)
            {
                ShowError(AuthMessages.RenderHtml(errors, true));
                return;
            }

            string organization = (TxtOrganization?.Text ?? string.Empty).Trim();
            string jobTitle = (TxtJobTitle?.Text ?? string.Empty).Trim();

            try
            {
                AuthService.Account account;
                AuthService.RegisterStatus status = AuthService.Register(
                    fullName, email, mobile, password,
                    organization, jobTitle, null, null, null,
                    out account);

                if (status == AuthService.RegisterStatus.EmailTaken)
                {
                    ShowError(AuthMessages.Get("EmailTaken", true));
                    return;
                }

                if (status == AuthService.RegisterStatus.Success && account != null)
                {
                    AuthService.StartSession(account);
                    Response.Redirect("~/Ar_Sa/Survey.aspx?first=1");
                    return;
                }

                ShowError(AuthMessages.Get("GenericError", true));
            }
            catch (Exception ex)
            {
                AuthService.LogError("Ar_Sa Register_Click", ex);
                ShowError(AuthMessages.Get("GenericError", true));
            }
        }

        private void ShowError(string html)
        {
            divError.Visible = true;
            divError.Attributes["class"] = "auth-alert alert alert-danger";
            divError.InnerHtml = html;
        }
    }
}