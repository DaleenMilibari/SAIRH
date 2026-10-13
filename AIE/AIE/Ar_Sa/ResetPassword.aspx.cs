using System;
using System.Collections.Generic;

namespace AIE.Ar_Sa
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        private string Token => Request.QueryString["token"] ?? string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                divError.Visible = false;
                pnlSuccess.Visible = false;

                if (string.IsNullOrEmpty(Token) || !AuthService.ValidatePasswordResetToken(Token, out _, out _))
                {
                    pnlForm.Visible = false;
                    pnlInvalidToken.Visible = true;
                }
                else
                {
                    pnlForm.Visible = true;
                    pnlInvalidToken.Visible = false;
                }
            }
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            string password = TxtPassword.Text ?? string.Empty;
            string passwordAgain = TxtPasswordAgain.Text ?? string.Empty;

            if (string.IsNullOrEmpty(password))
            {
                ShowError(AuthMessages.Get("PasswordRequired", true));
                return;
            }

            if (!string.Equals(password, passwordAgain, StringComparison.Ordinal))
            {
                ShowError(AuthMessages.Get("PasswordMismatch", true));
                return;
            }

            try
            {
                List<string> errors;
                bool ok = AuthService.ResetPasswordWithToken(Token, password, out errors);

                if (ok)
                {
                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                    pnlInvalidToken.Visible = false;
                    divError.Visible = false;
                }
                else
                {
                    if (errors != null && errors.Contains("ResetTokenInvalid"))
                    {
                        pnlForm.Visible = false;
                        pnlInvalidToken.Visible = true;
                        divError.Visible = false;
                    }
                    else
                    {
                        ShowError(AuthMessages.RenderHtml(errors, true));
                    }
                }
            }
            catch (Exception ex)
            {
                AuthService.LogError("Ar_Sa ResetPassword BtnReset_Click", ex);
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
