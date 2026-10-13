using System;
using System.Web;

namespace AIE.Ar_Sa
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                divError.Visible = false;
                pnlSuccess.Visible = false;
                pnlForm.Visible = true;
            }
        }

        protected void BtnSendReset_Click(object sender, EventArgs e)
        {
            string email = AuthService.NormalizeEmail(TxtEmail.Text);

            string emailError = AuthService.ValidateEmail(email);
            if (emailError != null)
            {
                ShowError(AuthMessages.Get(emailError, true));
                return;
            }

            try
            {
                string token;
                string resetUrl;
                bool created = AuthService.CreatePasswordResetToken(email, out token, out resetUrl);

                if (created && !string.IsNullOrEmpty(token))
                {
                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                    divError.Visible = false;
                    LnkResetAction.NavigateUrl = ResolveUrl("~/Ar_Sa/ResetPassword.aspx?token=" + HttpUtility.UrlEncode(token));
                }
                else
                {
                    ShowError(AuthMessages.Get("GenericError", true));
                }
            }
            catch (Exception ex)
            {
                AuthService.LogError("Ar_Sa ForgotPassword BtnSendReset_Click", ex);
                ShowError(AuthMessages.Get("GenericError", true));
            }
        }

        private void ShowError(string message)
        {
            divError.Visible = true;
            divError.Attributes["class"] = "auth-alert alert alert-danger";
            divError.InnerHtml = HttpUtility.HtmlEncode(message);
        }
    }
}
