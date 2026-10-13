<%@ Page Title="تعيين كلمة المرور - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="AIE.Ar_Sa.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="تعيين كلمة المرور">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                تعيين كلمة المرور الجديدة
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Section -->
    <section class="py-5" aria-label="نموذج تعيين كلمة المرور">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="register-glass-card">
                        <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                            <h3 class="text-white font-weight-bold mb-2">كلمة مرور جديدة</h3>
                            <p class="text-secondary mb-0">
                                يرجى إنشاء كلمة مرور قوية وآمنة لحسابك.
                            </p>
                        </div>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form" id="pnlForm" runat="server">
                                    <div class="auth-field">
                                        <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                            <i class="bi bi-lock ml-1 text-info"></i> كلمة المرور الجديدة
                                        </label>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="8 أحرف كحد أدنى" autocomplete="new-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Interactive Password Strength Meter -->
                                    <div class="password-strength-container" id="pwdStrengthBox" style="display: none;">
                                        <div class="password-strength-label">
                                            <span>قوة كلمة المرور:</span>
                                            <span class="password-strength-text" id="pwdStrengthText">ضعيفة</span>
                                        </div>
                                        <div class="password-strength-bar-track">
                                            <div class="password-strength-bar" id="pwdStrengthBar"></div>
                                        </div>
                                        <ul class="password-req-list">
                                            <li class="password-req-item" id="reqLen"><i class="bi bi-circle"></i> 8+ أحرف</li>
                                            <li class="password-req-item" id="reqUpper"><i class="bi bi-circle"></i> حرف كبير (A-Z)</li>
                                            <li class="password-req-item" id="reqLower"><i class="bi bi-circle"></i> حرف صغير (a-z)</li>
                                            <li class="password-req-item" id="reqNum"><i class="bi bi-circle"></i> رقم (0-9)</li>
                                            <li class="password-req-item" id="reqSpecial"><i class="bi bi-circle"></i> رمز خاص (!@#$%^&*...)</li>
                                        </ul>
                                    </div>

                                    <div class="auth-field">
                                        <label for="<%= TxtPasswordAgain.ClientID %>" class="auth-label">
                                            <i class="bi bi-check-all ml-1 text-info"></i> تأكيد كلمة المرور الجديدة
                                        </label>
                                        <div class="auth-password">
                                            <asp:TextBox ID="TxtPasswordAgain" runat="server" TextMode="Password" CssClass="form-control" placeholder="أعد إدخال كلمة المرور" autocomplete="new-password" required="required"></asp:TextBox>
                                            <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPasswordAgain.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                    </div>

                                    <div class="mt-3">
                                        <asp:Button ID="BtnReset" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="حفظ كلمة المرور" OnClick="BtnReset_Click" data-loading-text="جارٍ الحفظ..." />
                                    </div>
                                </div>

                                <div id="pnlSuccess" runat="server" visible="false" class="text-center py-4">
                                    <div class="text-success mb-3" style="font-size: 3.5rem;">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">تم تعيين كلمة المرور بنجاح!</h4>
                                    <p class="text-secondary mb-4">
                                        تم تحديث كلمة المرور الخاصة بحسابك بأمان. يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.
                                    </p>
                                    <a href="Login" class="cyan-glow-btn d-inline-block px-5 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-box-arrow-in-right ml-1"></i> تسجيل الدخول الآن
                                    </a>
                                </div>

                                <div id="pnlInvalidToken" runat="server" visible="false" class="text-center py-4">
                                    <div class="text-warning mb-3" style="font-size: 3.5rem;">
                                        <i class="bi bi-exclamation-triangle-fill"></i>
                                    </div>
                                    <h4 class="text-white font-weight-bold mb-2">الرابط غير صالح أو منتهي الصلاحية</h4>
                                    <p class="text-secondary mb-4">
                                        جلسة إعادة تعيين كلمة المرور هذه لم تعد صالحة. لأسباب أمنية تنتهي صلاحية الروابط بعد ساعة واحدة.
                                    </p>
                                    <a href="ForgotPassword" class="cyan-glow-btn d-inline-block px-4 py-3 text-white font-weight-bold text-decoration-none">
                                        <i class="bi bi-arrow-repeat ml-1"></i> طلب رابط جديد
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
