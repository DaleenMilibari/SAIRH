<%@ Page Title="Reset Password - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="AIE.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Reset Password Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Reset Account Password
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Section -->
    <section class="py-5" aria-label="Reset Password Form">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="register-glass-card">
                        <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                            <h3 class="text-white font-weight-bold mb-2">Set New Password</h3>
                            <p class="text-secondary mb-0">
                                Please create a strong, secure password for your account.
                            </p>
                        </div>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form" id="pnlForm" runat="server">
                                    <div class="auth-field">
                                        <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                            <i class="bi bi-lock mr-1 text-info"></i> New Password
                                        </label>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Min. 8 characters" autocomplete="new-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Interactive Password Strength Meter -->
                                    <div class="password-strength-container" id="pwdStrengthBox" style="display: none;">
                                        <div class="password-strength-label">
                                            <span>Password Strength:</span>
                                            <span class="password-strength-text" id="pwdStrengthText">Weak</span>
                                        </div>
                                        <div class="password-strength-bar-track">
                                            <div class="password-strength-bar" id="pwdStrengthBar"></div>
                                        </div>
                                        <ul class="password-req-list">
                                            <li class="password-req-item" id="reqLen"><i class="bi bi-circle"></i> 8+ characters</li>
                                            <li class="password-req-item" id="reqUpper"><i class="bi bi-circle"></i> Uppercase letter (A-Z)</li>
                                            <li class="password-req-item" id="reqLower"><i class="bi bi-circle"></i> Lowercase letter (a-z)</li>
                                            <li class="password-req-item" id="reqNum"><i class="bi bi-circle"></i> Number (0-9)</li>
                                            <li class="password-req-item" id="reqSpecial"><i class="bi bi-circle"></i> Symbol (!@#$%^&*...)</li>
                                        </ul>
                                    </div>

                                    <div class="auth-field">
                                        <label for="<%= TxtPasswordAgain.ClientID %>" class="auth-label">
                                            <i class="bi bi-check-all mr-1 text-info"></i> Confirm New Password
                                        </label>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPasswordAgain" runat="server" TextMode="Password" CssClass="form-control" placeholder="Re-enter new password" autocomplete="new-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPasswordAgain.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                    </div>

                                    <div class="mt-3">
                                        <asp:Button ID="BtnReset" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="Update Password" OnClick="BtnReset_Click" data-loading-text="Updating Password..." />
                                    </div>
                                </div>

                                <div id="pnlSuccess" runat="server" visible="false" class="text-center py-4">
                                    <div class="text-success mb-3" style="font-size: 3.5rem;">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">Password Successfully Reset!</h4>
                                    <p class="text-secondary mb-4">
                                        Your account credentials have been securely updated. You may now sign in using your new password.
                                    </p>
                                    <a href="Login" class="cyan-glow-btn d-inline-block px-5 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-box-arrow-in-right mr-1"></i> Sign In Now
                                    </a>
                                </div>

                                <div id="pnlInvalidToken" runat="server" visible="false" class="text-center py-4">
                                    <div class="text-warning mb-3" style="font-size: 3.5rem;">
                                        <i class="bi bi-exclamation-triangle-fill"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">Invalid or Expired Link</h4>
                                    <p class="text-secondary mb-4">
                                        This password reset session is no longer valid. For security purposes, reset links expire after 1 hour.
                                    </p>
                                    <a href="ForgotPassword" class="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-arrow-repeat mr-1"></i> Request a New Link
                                    </a>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <script src="<%= ResolveUrl("~/Scripts/auth.js") %>"></script>
</asp:Content>
