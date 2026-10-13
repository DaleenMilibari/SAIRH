<%@ Page Title="تسجيل حساب - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AIE.Ar_Sa.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="تسجيل حساب جديد">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                إنشاء حساب جديد
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Registration Section -->
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <section class="py-5" aria-label="نموذج التسجيل">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-7 col-md-9">
                            <div class="register-glass-card">
                                <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                                    <h3 class="text-white font-weight-bold mb-2">تسجيل المشتركين</h3>
                                    <p class="text-secondary mb-0">
                                        لديك حساب بالفعل؟ <a href="Login" class="text-info font-weight-bold">سجّل دخولك من هنا</a>.
                                    </p>
                                </div>

                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form">
                                    <div class="auth-field">
                                        <label for="<%= TxtFullName.ClientID %>" class="auth-label">
                                            <i class="bi bi-person ml-1 text-info"></i> الاسم الكامل
                                        </label>
                                        <asp:TextBox ID="TxtFullName" runat="server" CssClass="form-control" placeholder="مثال: د. سارة الأحمد" autocomplete="name" required="required"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope ml-1 text-info"></i> البريد الإلكتروني
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="username" required="required"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtMobile.ClientID %>" class="auth-label">
                                                <i class="bi bi-telephone ml-1 text-info"></i> رقم الجوال
                                            </label>
                                            <span class="auth-optional">اختياري</span>
                                        </div>
                                        <asp:TextBox ID="TxtMobile" runat="server" TextMode="Phone" CssClass="form-control" placeholder="مثال: 0501234567" autocomplete="tel"></asp:TextBox>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <div class="auth-field">
                                                <div class="auth-row-between">
                                                    <label for="<%= TxtOrganization.ClientID %>" class="auth-label">
                                                        <i class="bi bi-building ml-1 text-info"></i> جهة العمل / المنظمة
                                                    </label>
                                                    <span class="auth-optional">اختياري</span>
                                                </div>
                                                <asp:TextBox ID="TxtOrganization" runat="server" CssClass="form-control" placeholder="مستشفى / جامعة / شركة" autocomplete="organization"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <div class="auth-field">
                                                <div class="auth-row-between">
                                                    <label for="<%= TxtJobTitle.ClientID %>" class="auth-label">
                                                        <i class="bi bi-briefcase ml-1 text-info"></i> المسمى الوظيفي / التخصص
                                                    </label>
                                                    <span class="auth-optional">اختياري</span>
                                                </div>
                                                <asp:TextBox ID="TxtJobTitle" runat="server" CssClass="form-control" placeholder="مثال: طبيب أشعة، باحث ذكاء اصطناعي"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3 mb-md-0">
                                            <div class="auth-field">
                                                <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                                    <i class="bi bi-lock ml-1 text-info"></i> كلمة المرور
                                                </label>
                                                <div class="auth-password">
                                                    <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="8 أحرف كحد أدنى" autocomplete="new-password" required="required"></asp:TextBox>
                                                    <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= TxtPasswordAgain.ClientID %>" class="auth-label">
                                                    <i class="bi bi-check-all ml-1 text-info"></i> تأكيد كلمة المرور
                                                </label>
                                                <div class="auth-password">
                                                    <asp:TextBox ID="TxtPasswordAgain" runat="server" TextMode="Password" CssClass="form-control" placeholder="تأكيد كلمة المرور" autocomplete="new-password" required="required"></asp:TextBox>
                                                    <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPasswordAgain.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                                <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Interactive Password Strength Meter (Arabic) -->
                                    <div class="password-strength-container" id="pwdStrengthBox" style="display: none;">
                                        <div class="password-strength-label">
                                            <span>قوة كلمة المرور:</span>
                                            <span class="password-strength-text" id="pwdStrengthText">ضعيفة</span>
                                        </div>
                                        <div class="password-strength-bar-track">
                                            <div class="password-strength-bar" id="pwdStrengthBar"></div>
                                        </div>
                                        <ul class="password-req-list">
                                            <li class="password-req-item" id="reqLen"><i class="bi bi-circle"></i> 8 أحرف على الأقل</li>
                                            <li class="password-req-item" id="reqUpper"><i class="bi bi-circle"></i> حرف كبير (A-Z)</li>
                                            <li class="password-req-item" id="reqLower"><i class="bi bi-circle"></i> حرف صغير (a-z)</li>
                                            <li class="password-req-item" id="reqNum"><i class="bi bi-circle"></i> رقم (0-9)</li>
                                            <li class="password-req-item" id="reqSpecial"><i class="bi bi-circle"></i> رمز خاص (!@#$%^&*...)</li>
                                        </ul>
                                    </div>

                                    <div class="mt-3">
                                        <asp:Button ID="BtnRegister" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="تسجيل الحساب الآن" OnClick="BtnRegister_Click" data-loading-text="جارٍ إنشاء الحساب..." />
                                    </div>

                                    <p class="auth-switch">
                                        لديك حساب بالفعل؟ <a href="Login" class="text-info font-weight-bold">سجّل دخولك من هنا</a>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
