<%@ Page Title="Sign In - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AIE.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="simpler-main-bg min-vh-100 d-flex align-items-center py-5" aria-label="Sign In">
        <div class="container py-5">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-5 text-light mb-5 mb-lg-0">
                    <div class="d-inline-flex mb-3">
                    </div>
                    <div class="h1 text-light font-weight-bold mb-3">
                        Welcome <br />
                        <div class="typed-strings">
                            <p><span class="h1 text-white">Saudi First AI Summit in Radiology and Health Innovation</span></p>
                        </div>
                        <div class="typed text-info"></div>
                    </div>
                    <p class="lead text-secondary" style="font-size: 1.5rem; font-weight: 600;">2026</p>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="login-glass-card">
                        <h3 class="text-white font-weight-bold mb-2 text-center">Sign In</h3>
                        <p class="text-secondary text-center mb-4">
                            Sign in to your attendee account, or <a href="Register" class="text-info font-weight-bold">create a new account</a>.
                        </p>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert alert-danger" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form">
                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope mr-1 text-info"></i> Email Address
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="username" required="required"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                                <i class="bi bi-lock mr-1 text-info"></i> Password
                                            </label>
                                            <a href="ForgotPassword" class="auth-link small">Forgot password?</a>
                                        </div>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" autocomplete="current-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="form-check p-0">
                                            <asp:CheckBox ID="ChkRememberMe" runat="server" Text=" Remember me on this device" CssClass="text-secondary small font-weight-semibold" />
                                        </div>
                                    </div>

                                    <div class="mt-2">
                                        <asp:Button ID="BtnLogin" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="Sign In" OnClick="Login_Click" data-loading-text="Signing In..." />
                                    </div>

                                    <p class="auth-switch">
                                        Don't have an account? <a href="Register" class="text-info font-weight-bold">Register here</a>
                                    </p>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
