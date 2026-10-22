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
                                        <asp:TextBox ID="TxtFullName" runat="server" CssClass="form-control" placeholder="مثال: د. سارة الأحمد" autocomplete="name" required="required" MaxLength="100" pattern="^[a-zA-Z\u0600-\u06FF\s]+$" title="أحرف فقط (كبيرة وصغيرة)"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope ml-1 text-info"></i> البريد الإلكتروني
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="username" required="required" MaxLength="100" pattern="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$" title="عنوان بريد إلكتروني صالح"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtMobile.ClientID %>" class="auth-label">
                                                <i class="bi bi-telephone ml-1 text-info"></i> رقم الجوال
                                            </label>
                                            <span class="auth-optional">اختياري</span>
                                        </div>
                                        <div class="phone-input-group">
                                            <div class="phone-country-dropdown-wrap">
                                                <select id="DdlCountryCode" name="DdlCountryCode" class="phone-country-select" aria-label="رمز الدولة" autocomplete="tel-country-code">
                                                    <option value="+966" selected="selected">🇸🇦 +966 (السعودية)</option>
                                                    <option value="+971">🇦🇪 +971 (الإمارات)</option>
                                                    <option value="+965">🇰🇼 +965 (الكويت)</option>
                                                    <option value="+973">🇧🇭 +973 (البحرين)</option>
                                                    <option value="+974">🇶🇦 +974 (قطر)</option>
                                                    <option value="+968">🇴🇲 +968 (عُمان)</option>
                                                    <option value="+20">🇪🇬 +20 (مصر)</option>
                                                    <option value="+962">🇯🇴 +962 (الأردن)</option>
                                                    <option value="+961">🇱🇧 +961 (لبنان)</option>
                                                    <option value="+964">🇮🇶 +964 (العراق)</option>
                                                    <option value="+967">🇾🇪 +967 (اليمن)</option>
                                                    <option value="+44">🇬🇧 +44 (المملكة المتحدة)</option>
                                                    <option value="+1">🇺🇸 +1 (أمريكا / كندا)</option>
                                                    <option value="+49">🇩🇪 +49 (ألمانيا)</option>
                                                    <option value="+33">🇫🇷 +33 (فرنسا)</option>
                                                    <option value="+90">🇹🇷 +90 (تركيا)</option>
                                                    <option value="+91">🇮🇳 +91 (الهند)</option>
                                                    <option value="+92">🇵🇰 +92 (باكستان)</option>
                                                    <option value="+60">🇲🇾 +60 (ماليزيا)</option>
                                                    <option value="+65">🇸🇬 +65 (سنغافورة)</option>
                                                    <option value="+61">🇦🇺 +61 (أستراليا)</option>
                                                    <option value="">🌐 أخرى / دولي مخصص</option>
                                                </select>
                                                <i class="bi bi-chevron-down phone-dropdown-arrow" aria-hidden="true"></i>
                                            </div>
                                            <div class="phone-number-wrap">
                                                <asp:TextBox ID="TxtMobile" runat="server" TextMode="Phone" CssClass="form-control phone-number-input" placeholder="50 123 4567" autocomplete="tel-national" MaxLength="15"></asp:TextBox>
                                            </div>
                                        </div>
                                        <small class="auth-hint phone-hint" id="phoneHint">صيغة الجوال السعودي: 50 123 4567 (9 أرقام)</small>
                                        <div class="phone-validation-feedback" id="phoneFeedback" style="display: none;"></div>
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
                                                <asp:TextBox ID="TxtOrganization" runat="server" CssClass="form-control" placeholder="مستشفى / جامعة / شركة" autocomplete="organization" MaxLength="150" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="أحرف فقط (كبيرة وصغيرة)"></asp:TextBox>
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
                                                <asp:TextBox ID="TxtJobTitle" runat="server" CssClass="form-control" placeholder="مثال: طبيب أشعة، باحث ذكاء اصطناعي" MaxLength="100" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="أحرف فقط (كبيرة وصغيرة)"></asp:TextBox>
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
                                                    <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="8 أحرف كحد أدنى" autocomplete="new-password" required="required" MaxLength="128"></asp:TextBox>
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
                                                    <asp:TextBox ID="TxtPasswordAgain" runat="server" TextMode="Password" CssClass="form-control" placeholder="تأكيد كلمة المرور" autocomplete="new-password" required="required" MaxLength="128"></asp:TextBox>
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
