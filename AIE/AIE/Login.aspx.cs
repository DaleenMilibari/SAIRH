using DBFunction;
using System;
using System.Web;

namespace AIE
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Ado.UserDetails != null)
            {
                string returnUrl = Request.QueryString["ReturnUrl"];
                Response.Redirect(AuthService.GetSafeReturnUrl(returnUrl, "~/"));
                return;
            }

            divError.Visible = false;
        }

        protected void Login_Click(object sender, EventArgs e)
        {
            string email = AuthService.NormalizeEmail(TxtEmail.Text);
            string password = TxtPassword.Text ?? string.Empty;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError(AuthMessages.Get("CredentialsRequired", false));
                return;
            }

            try
            {
                bool rememberMe = ChkRememberMe != null && ChkRememberMe.Checked;
                AuthService.Account account;
                AuthService.SignInStatus status = AuthService.SignIn(email, password, out account, rememberMe);

                switch (status)
                {
                    case AuthService.SignInStatus.Success:
                        AuthService.StartSession(account, rememberMe);
                        string returnUrl = Request.QueryString["ReturnUrl"];
                        Response.Redirect(AuthService.GetSafeReturnUrl(returnUrl, "~/"));
                        break;

                    case AuthService.SignInStatus.LockedOut:
                        ShowError(AuthMessages.Get("LockedOut", false));
                        break;

                    case AuthService.SignInStatus.Blocked:
                        ShowError(AuthMessages.Get("Blocked", false));
                        break;

                    case AuthService.SignInStatus.InvalidCredentials:
                    default:
                        ShowError(AuthMessages.Get("InvalidCredentials", false));
                        break;
                }
            }
            catch (Exception ex)
            {
                AuthService.LogError("Login_Click", ex);
                ShowError(AuthMessages.Get("GenericError", false));
            }
        }

        private void ShowError(string message)
        {
            divError.Visible = true;
            divError.InnerHtml = HttpUtility.HtmlEncode(message);
        }
    }
}