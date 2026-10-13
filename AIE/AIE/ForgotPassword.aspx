<%@ Page Title="Forgot Password - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="AIE.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="simpler-main-bg min-vh-100 d-flex align-items-center py-5" aria-label="Forgot Password">
        <div class="container py-5">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-5 text-light mb-5 mb-lg-0">
                    <div class="h1 text-light font-weight-bold mb-3">
                        Reset Your Password <br />
                        <span class="text-info">SAIRH 2026</span>
                    </div>
                    <p class="lead text-secondary" style="font-size: 1.15rem; line-height: 1.7;">
                        Enter your registered attendee email address and we'll generate a secure link to reset your password.
                    </p>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="login-glass-card">
                        <div class="text-center mb-4">
                            <div class="profile-avatar-circle mx-auto mb-3" style="width: 60px; height: 60px; font-size: 1.6rem;">
                                <i class="bi bi-shield-lock"></i>
                            </div>
                            <h3 class="text-white font-weight-bold mb-2">Forgot Password</h3>
                            <p class="text-secondary small mb-0">
                                Enter your account email to receive your password reset link.
                            </p>
                        </div>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form" id="pnlForm" runat="server">
                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope mr-1 text-info"></i> Registered Email Address
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="email" required="required"></asp:TextBox>
                                    </div>

                                    <div class="mt-2">
                                        <asp:Button ID="BtnSendReset" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="Generate Reset Link" OnClick="BtnSendReset_Click" data-loading-text="Processing..." />
                                    </div>

                                    <p class="auth-switch">
                                        Remember your password? <a href="Login" class="text-info font-weight-bold">Back to Sign In</a>
                                    </p>
                                </div>

                                <div id="pnlSuccess" runat="server" visible="false" class="text-center py-3">
                                    <div class="text-success mb-3" style="font-size: 3rem;">
                                        <i class="bi bi-check-circle-fill"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">Reset Link Ready</h4>
                                    <p class="text-secondary small mb-4">
                                        We have prepared your secure password reset session. Click below to enter your new password.
                                    </p>
                                    <asp:HyperLink ID="LnkResetAction" runat="server" CssClass="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-arrow-right-circle mr-1"></i> Proceed to Reset Password
                                    </asp:HyperLink>
                                    <div class="mt-4">
                                        <a href="Login" class="text-secondary small"><i class="bi bi-arrow-left"></i> Back to Sign In</a>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
