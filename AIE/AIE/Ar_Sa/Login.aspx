<%@ Page Title="تسجيل الدخول - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AIE.Ar_Sa.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="simpler-main-bg min-vh-100 d-flex align-items-center py-5" aria-label="تسجيل الدخول">
        <div class="container py-5">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-5 text-light mb-5 mb-lg-0">
                    <div class="d-inline-flex mb-3">
                    </div>
                    <div class="h1 text-light font-weight-bold mb-3">
                        مرحباً بكم <br />
                        <div class="typed-strings">
                            <p><span class="h1 text-white">القمة السعودية الأولى للذكاء الاصطناعي في الأشعة والابتكار الصحي</span></p>
                        </div>
                        <div class="typed text-info"></div>
                    </div>
                    <p class="lead text-secondary" style="font-size: 1.5rem; font-weight: 600;">2026</p>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="login-glass-card">
                        <h3 class="text-white font-weight-bold mb-2 text-center">تسجيل الدخول</h3>
                        <p class="text-secondary text-center mb-4">
                            سجّل الدخول إلى حسابك، أو <a href="Register" class="text-info font-weight-bold">أنشئ حساباً جديداً</a>.
                        </p>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert alert-danger" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form">
                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope ml-1 text-info"></i> البريد الإلكتروني
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="username" required="required"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                                <i class="bi bi-lock ml-1 text-info"></i> كلمة المرور
                                            </label>
                                            <a href="ForgotPassword" class="auth-link small">نسيت كلمة المرور؟</a>
                                        </div>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="أدخل كلمة المرور" autocomplete="current-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    <div class="d-flex justify-content-between align-items-center mb-3 text-right">
                                        <div class="form-check p-0">
                                            <asp:CheckBox ID="ChkRememberMe" runat="server" Text=" تذكرني على هذا الجهاز" CssClass="text-secondary small font-weight-semibold" />
                                        </div>
                                    </div>

                                    <div class="mt-2">
                                        <asp:Button ID="BtnLogin" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="تسجيل الدخول" OnClick="Login_Click" data-loading-text="جارٍ تسجيل الدخول..." />
                                    </div>

                                    <p class="auth-switch">
                                        ليس لديك حساب بعد؟ <a href="Register" class="text-info font-weight-bold">سجّل الآن</a>
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
