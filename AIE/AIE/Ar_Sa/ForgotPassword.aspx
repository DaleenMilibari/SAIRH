<%@ Page Title="نسيت كلمة المرور - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="AIE.Ar_Sa.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="simpler-main-bg min-vh-100 d-flex align-items-center py-5" aria-label="استعادة كلمة المرور">
        <div class="container py-5">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-5 text-light mb-5 mb-lg-0 text-right">
                    <div class="h1 text-light font-weight-bold mb-3">
                        إعادة تعيين كلمة المرور <br />
                        <span class="text-info">SAIRH 2026</span>
                    </div>
                    <p class="lead text-secondary" style="font-size: 1.15rem; line-height: 1.8;">
                        أدخل عنوان بريدك الإلكتروني المسجل وسنقوم بإنشاء رابط آمن لتعيين كلمة مرور جديدة لحسابك.
                    </p>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="login-glass-card">
                        <div class="text-center mb-4">
                            <div class="profile-avatar-circle mx-auto mb-3" style="width: 60px; height: 60px; font-size: 1.6rem;">
                                <i class="bi bi-shield-lock"></i>
                            </div>
                            <h3 class="text-white font-weight-bold mb-2">استعادة كلمة المرور</h3>
                            <p class="text-secondary small mb-0">
                                أدخل بريدك الإلكتروني للحصول على رابط إعادة التعيين.
                            </p>
                        </div>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form" id="pnlForm" runat="server">
                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope ml-1 text-info"></i> البريد الإلكتروني المسجل
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="email" required="required"></asp:TextBox>
                                    </div>

                                    <div class="mt-2">
                                        <asp:Button ID="BtnSendReset" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="إنشاء رابط التعيين" OnClick="BtnSendReset_Click" data-loading-text="جارٍ المعالجة..." />
                                    </div>

                                    <p class="auth-switch">
                                        تتذكر كلمة المرور؟ <a href="Login" class="text-info font-weight-bold">العودة لتسجيل الدخول</a>
                                    </p>
                                </div>

                                <div id="pnlSuccess" runat="server" visible="false" class="text-center py-3">
                                    <div class="text-success mb-3" style="font-size: 3rem;">
                                        <i class="bi bi-check-circle-fill"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">تم تجهيز رابط إعادة التعيين</h4>
                                    <p class="text-secondary small mb-4">
                                        تم تجهيز جلسة إعادة تعيين كلمة المرور بأمان. انقر أدناه لإدخال كلمة المرور الجديدة.
                                    </p>
                                    <asp:HyperLink ID="LnkResetAction" runat="server" CssClass="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-arrow-left-circle ml-1"></i> الانتقال لتعيين كلمة المرور
                                    </asp:HyperLink>
                                    <div class="mt-4">
                                        <a href="Login" class="text-secondary small"><i class="bi bi-arrow-right"></i> العودة لتسجيل الدخول</a>
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
