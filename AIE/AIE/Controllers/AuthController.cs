using DBFunction;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace AIE.Controllers
{
    [RoutePrefix("api/auth")]
    public class AuthController : ApiController
    {
        // ------------------------------------------------------------------
        // DTOs
        // ------------------------------------------------------------------

        public class RegisterRequest
        {
            public string FullName { get; set; }
            public string Email { get; set; }
            public string MobileNo { get; set; }
            public string Password { get; set; }
            public string ConfirmPassword { get; set; }
            public string Organization { get; set; }
            public string JobTitle { get; set; }
            public string Specialty { get; set; }
            public string LinkedInUrl { get; set; }
            public int? CountryID { get; set; }
        }

        public class LoginRequest
        {
            public string Email { get; set; }
            public string Password { get; set; }
            public bool RememberMe { get; set; }
        }

        public class ProfileUpdateRequest
        {
            public string FullName { get; set; }
            public string MobileNo { get; set; }
            public string Organization { get; set; }
            public string JobTitle { get; set; }
            public string Specialty { get; set; }
            public string LinkedInUrl { get; set; }
            public int? CountryID { get; set; }
        }

        public class ChangePasswordRequest
        {
            public string CurrentPassword { get; set; }
            public string NewPassword { get; set; }
            public string ConfirmPassword { get; set; }
        }

        public class ForgotPasswordRequest
        {
            public string Email { get; set; }
        }

        public class ResetPasswordRequest
        {
            public string Token { get; set; }
            public string NewPassword { get; set; }
            public string ConfirmPassword { get; set; }
        }

        // ------------------------------------------------------------------
        // Endpoints
        // ------------------------------------------------------------------

        [HttpPost]
        [Route("register")]
        public HttpResponseMessage Register([FromBody] RegisterRequest req)
        {
            if (req == null)
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = "Request body is required." });

            string fullName = AuthService.NormalizeName(req.FullName);
            string email = AuthService.NormalizeEmail(req.Email);
            string mobile = AuthService.NormalizeMobile(req.MobileNo);
            string password = req.Password ?? string.Empty;
            string confirmPassword = req.ConfirmPassword ?? string.Empty;

            List<string> errors = AuthService.ValidateRegistration(fullName, email, mobile, password, confirmPassword);
            if (errors.Count > 0)
            {
                var errorTexts = new List<string>();
                foreach (var code in errors) errorTexts.Add(AuthMessages.Get(code, false));
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { success = false, errors = errorTexts, codes = errors });
            }

            try
            {
                AuthService.Account account;
                var status = AuthService.Register(
                    fullName, email, mobile, password,
                    req.Organization, req.JobTitle, req.Specialty, req.LinkedInUrl, req.CountryID,
                    out account);

                if (status == AuthService.RegisterStatus.EmailTaken)
                {
                    return Request.CreateResponse(HttpStatusCode.Conflict, new {
                        success = false,
                        error = AuthMessages.Get("EmailTaken", false),
                        code = "EmailTaken"
                    });
                }

                if (status == AuthService.RegisterStatus.Success && account != null)
                {
                    AuthService.StartSession(account, false);
                    return Request.CreateResponse(HttpStatusCode.Created, new {
                        success = true,
                        message = AuthMessages.Get("Welcome", false),
                        user = account
                    });
                }

                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
            catch (Exception ex)
            {
                AuthService.LogError("API Register", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }

        [HttpPost]
        [Route("login")]
        public HttpResponseMessage Login([FromBody] LoginRequest req)
        {
            if (req == null)
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = "Request body is required." });

            string email = AuthService.NormalizeEmail(req.Email);
            string password = req.Password ?? string.Empty;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new {
                    success = false,
                    error = AuthMessages.Get("CredentialsRequired", false)
                });
            }

            try
            {
                AuthService.Account account;
                var status = AuthService.SignIn(email, password, out account, req.RememberMe);

                switch (status)
                {
                    case AuthService.SignInStatus.Success:
                        AuthService.StartSession(account, req.RememberMe);
                        return Request.CreateResponse(HttpStatusCode.OK, new {
                            success = true,
                            message = "Sign in successful.",
                            user = account
                        });

                    case AuthService.SignInStatus.LockedOut:
                        return Request.CreateResponse(HttpStatusCode.Forbidden, new {
                            success = false,
                            error = AuthMessages.Get("LockedOut", false),
                            code = "LockedOut"
                        });

                    case AuthService.SignInStatus.Blocked:
                        return Request.CreateResponse(HttpStatusCode.Forbidden, new {
                            success = false,
                            error = AuthMessages.Get("Blocked", false),
                            code = "Blocked"
                        });

                    case AuthService.SignInStatus.InvalidCredentials:
                    default:
                        return Request.CreateResponse(HttpStatusCode.Unauthorized, new {
                            success = false,
                            error = AuthMessages.Get("InvalidCredentials", false),
                            code = "InvalidCredentials"
                        });
                }
            }
            catch (Exception ex)
            {
                AuthService.LogError("API Login", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }

        [HttpPost]
        [Route("logout")]
        public HttpResponseMessage Logout()
        {
            AuthService.EndSession();
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, message = "Successfully logged out." });
        }

        [HttpGet]
        [Route("status")]
        public HttpResponseMessage GetStatus()
        {
            var user = Ado.UserDetails;
            if (user == null)
            {
                return Request.CreateResponse(HttpStatusCode.OK, new { isAuthenticated = false });
            }

            var account = AuthService.GetById(user.UserID);
            return Request.CreateResponse(HttpStatusCode.OK, new {
                isAuthenticated = true,
                user = account ?? (object)user
            });
        }

        [HttpGet]
        [Route("profile")]
        public HttpResponseMessage GetProfile()
        {
            var user = Ado.UserDetails;
            if (user == null)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "Authentication required." });
            }

            var account = AuthService.GetById(user.UserID);
            if (account == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, new { error = "User not found." });
            }

            return Request.CreateResponse(HttpStatusCode.OK, account);
        }

        [HttpPut]
        [Route("profile")]
        public HttpResponseMessage UpdateProfile([FromBody] ProfileUpdateRequest req)
        {
            var user = Ado.UserDetails;
            if (user == null)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "Authentication required." });
            }

            if (req == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = "Request body is required." });
            }

            string name = AuthService.NormalizeName(req.FullName);
            string mobile = AuthService.NormalizeMobile(req.MobileNo);

            string nameErr = AuthService.ValidateFullName(name);
            if (nameErr != null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get(nameErr, false) });
            }

            string mobileErr = AuthService.ValidateMobile(mobile);
            if (mobileErr != null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get(mobileErr, false) });
            }

            try
            {
                AuthService.UpdateProfile(
                    user.UserID, name, mobile,
                    req.Organization, req.JobTitle, req.Specialty, req.LinkedInUrl, req.CountryID);

                var updated = AuthService.GetById(user.UserID);
                return Request.CreateResponse(HttpStatusCode.OK, new {
                    success = true,
                    message = AuthMessages.Get("ProfileSaved", false),
                    user = updated
                });
            }
            catch (Exception ex)
            {
                AuthService.LogError("API UpdateProfile", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }

        [HttpPost]
        [Route("change-password")]
        public HttpResponseMessage ChangePassword([FromBody] ChangePasswordRequest req)
        {
            var user = Ado.UserDetails;
            if (user == null)
            {
                return Request.CreateResponse(HttpStatusCode.Unauthorized, new { error = "Authentication required." });
            }

            if (req == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = "Request body is required." });
            }

            string currentPassword = req.CurrentPassword ?? string.Empty;
            string newPassword = req.NewPassword ?? string.Empty;
            string confirmPassword = req.ConfirmPassword ?? string.Empty;

            if (string.IsNullOrEmpty(currentPassword))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("CurrentPasswordRequired", false) });
            }

            if (string.IsNullOrEmpty(newPassword))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("PasswordRequired", false) });
            }

            if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("PasswordMismatch", false) });
            }

            try
            {
                List<string> errors;
                bool ok = AuthService.ChangePassword(user.UserID, currentPassword, newPassword, out errors);

                if (ok)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new {
                        success = true,
                        message = AuthMessages.Get("PasswordChanged", false)
                    });
                }

                var errorTexts = new List<string>();
                if (errors != null)
                {
                    foreach (var code in errors) errorTexts.Add(AuthMessages.Get(code, false));
                }

                return Request.CreateResponse(HttpStatusCode.BadRequest, new {
                    success = false,
                    errors = errorTexts,
                    codes = errors
                });
            }
            catch (Exception ex)
            {
                AuthService.LogError("API ChangePassword", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }

        [HttpPost]
        [Route("forgot-password")]
        public HttpResponseMessage ForgotPassword([FromBody] ForgotPasswordRequest req)
        {
            if (req == null || string.IsNullOrEmpty(req.Email))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("EmailRequired", false) });
            }

            string email = AuthService.NormalizeEmail(req.Email);
            string emailErr = AuthService.ValidateEmail(email);
            if (emailErr != null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get(emailErr, false) });
            }

            try
            {
                string token;
                string resetUrl;
                AuthService.CreatePasswordResetToken(email, out token, out resetUrl);

                return Request.CreateResponse(HttpStatusCode.OK, new {
                    success = true,
                    message = AuthMessages.Get("ResetLinkSent", false),
                    token = token,
                    resetUrl = resetUrl
                });
            }
            catch (Exception ex)
            {
                AuthService.LogError("API ForgotPassword", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }

        [HttpPost]
        [Route("reset-password")]
        public HttpResponseMessage ResetPassword([FromBody] ResetPasswordRequest req)
        {
            if (req == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = "Request body is required." });
            }

            string token = (req.Token ?? string.Empty).Trim();
            string newPassword = req.NewPassword ?? string.Empty;
            string confirmPassword = req.ConfirmPassword ?? string.Empty;

            if (string.IsNullOrEmpty(token))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("ResetTokenInvalid", false) });
            }

            if (string.IsNullOrEmpty(newPassword))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("PasswordRequired", false) });
            }

            if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { error = AuthMessages.Get("PasswordMismatch", false) });
            }

            try
            {
                List<string> errors;
                bool ok = AuthService.ResetPasswordWithToken(token, newPassword, out errors);

                if (ok)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new {
                        success = true,
                        message = AuthMessages.Get("PasswordResetSuccess", false)
                    });
                }

                var errorTexts = new List<string>();
                if (errors != null)
                {
                    foreach (var code in errors) errorTexts.Add(AuthMessages.Get(code, false));
                }

                return Request.CreateResponse(HttpStatusCode.BadRequest, new {
                    success = false,
                    errors = errorTexts,
                    codes = errors
                });
            }
            catch (Exception ex)
            {
                AuthService.LogError("API ResetPassword", ex);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new {
                    success = false,
                    error = AuthMessages.Get("GenericError", false)
                });
            }
        }
    }
}
