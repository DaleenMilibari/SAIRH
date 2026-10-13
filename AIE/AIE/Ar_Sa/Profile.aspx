<%@ Page Title="الملف الشخصي - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Ar_Sa.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="الملف الشخصي">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                الملف الشخصي
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Content -->
    <section class="py-5" aria-label="إدارة الحساب">
        <div class="container">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row">
                        <!-- Sidebar Card -->
                        <div class="col-lg-4 mb-4 mb-lg-0">
                            <div class="profile-user-card text-center">
                                <div class="profile-avatar-circle">
                                    <i class="bi bi-person"></i>
                                </div>
                                <asp:Label ID="LblId" runat="server" Text="" Visible="false"></asp:Label>
                                <h3 class="text-white font-weight-bold mb-1">
                                    <asp:Label ID="LblName" runat="server" Text="اسم المشترك"></asp:Label>
                                </h3>
                                <div class="mb-2">
                                    <asp:Label ID="LblUserRoleBadge" runat="server" CssClass="badge badge-info" Text="مشترك"></asp:Label>
                                </div>
                                <p class="text-info mb-1 font-weight-semibold small" id="pOrgTitle" runat="server" visible="false">
                                    <i class="bi bi-building ml-1"></i> <asp:Label ID="LblOrgTitle" runat="server" Text=""></asp:Label>
                                </p>
                                <p class="text-secondary mb-1 small">
                                    <i class="bi bi-telephone ml-1"></i> <asp:Label ID="TxtMobile" runat="server" Text="-"></asp:Label>
                                </p>
                                <p class="text-secondary mb-3 small">
                                    <i class="bi bi-envelope ml-1"></i> <asp:Label ID="TxtEmail" runat="server" Text="-"></asp:Label>
                                </p>

                                <div class="mt-4">
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowProfile_Click">
                                        <i class="bi bi-person-gear"></i> تعديل البيانات الشخصية
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowChangePass_Click">
                                        <i class="bi bi-shield-lock"></i> تغيير كلمة المرور
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnShowSurvey" runat="server" CssClass="profile-nav-btn" OnClientClick="window.open('https://ud.questionpro.com/a/TakeSurvey?tt=neb%2Bv7we7FsECHrPeIW9eQ%3D%3D', '_blank'); return false;">
                                        <i class="bi bi-card-checklist"></i> استبيان تقييم القمة
                                    </asp:LinkButton>
                                </div>

                                <!-- Security Status Box -->
                                <div class="mt-4 p-3 text-right" style="background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 14px;">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <span class="text-white font-weight-bold small"><i class="bi bi-shield-check text-success ml-1"></i> حالة الأمان</span>
                                        <span class="badge badge-success">حساب محمي</span>
                                    </div>
                                    <div class="text-secondary small mb-1">
                                        <i class="bi bi-clock-history ml-1"></i> آخر تسجيل دخول: <asp:Label ID="LblLastLogin" runat="server" CssClass="text-light" Text="جلسة نشطة"></asp:Label>
                                    </div>
                                    <div class="text-secondary small">
                                        <i class="bi bi-key ml-1"></i> تحديث كلمة المرور: <asp:Label ID="LblPasswordAge" runat="server" CssClass="text-light" Text="مؤمّنة"></asp:Label>
                                    </div>
                                </div>

                                <!-- Exhibition Roadmap Box -->
                                <div class="expo-profile-roadmap-box mt-4 p-3 text-right" style="background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(56, 189, 248, 0.25); border-radius: 14px;">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <span class="text-white font-weight-bold small"><i class="bi bi-map text-info ml-1"></i> مسار المعرض المخصص</span>
                                        <asp:Label ID="LblSurveyBadge" runat="server" CssClass="badge badge-warning" Text="لم يكتمل بعد"></asp:Label>
                                    </div>
                                    <p class="text-secondary small mb-3" id="pRoadmapDesc" runat="server">
                                        أكمل استبيان التخصيص القصير للحصول على جولة مخصصة للأجنحة وشاشات الأبحاث على خريطة المعرض.
                                    </p>
                                    <div id="pnlSurveyStops" runat="server" class="mb-3" visible="false">
                                        <div class="text-secondary small mb-1">المحطات المقترحة لزيارتك:</div>
                                        <div id="pnlStopsChips" runat="server" class="d-flex flex-wrap gap-1"></div>
                                    </div>
                                    <div class="d-flex flex-column gap-2">
                                        <a href="Schedules" class="btn btn-sm btn-info rounded-pill font-weight-bold">
                                            <i class="bi bi-compass ml-1"></i> عرض على خريطة المعرض
                                        </a>
                                        <a href="Survey" id="lnkSurveyAction" runat="server" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">
                                            <i class="bi bi-magic ml-1"></i> بناء مساري المخصص
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Main Form Card -->
                        <div class="col-lg-8">
                            <div class="glass-card p-4">
                                <!-- Edit Profile Box -->
                                <div runat="server" id="div_editprofile" visible="true">
                                    <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-secondary">
                                        <i class="bi bi-person-badge text-info ml-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">تعديل البيانات الشخصية</h3>
                                    </div>

                                    <div id="divErrorProfile" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtEditFullName.ClientID %>" class="auth-label">
                                                <i class="bi bi-person ml-1 text-info"></i> الاسم الكامل
                                            </label>
                                            <asp:TextBox ID="TxtEditFullName" runat="server" CssClass="form-control" placeholder="أدخل اسمك الكامل" autocomplete="name" required="required"></asp:TextBox>
                                        </div>

                                        <div class="auth-field">
                                            <label for="<%= TxtEditMobile.ClientID %>" class="auth-label">
                                                <i class="bi bi-telephone ml-1 text-info"></i> رقم الجوال
                                            </label>
                                            <asp:TextBox ID="TxtEditMobile" runat="server" TextMode="Phone" CssClass="form-control" placeholder="أدخل رقم الجوال" autocomplete="tel"></asp:TextBox>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditOrg.ClientID %>" class="auth-label">
                                                        <i class="bi bi-building ml-1 text-info"></i> جهة العمل / المنظمة
                                                    </label>
                                                    <asp:TextBox ID="TxtEditOrg" runat="server" CssClass="form-control" placeholder="مستشفى / جامعة / شركة" autocomplete="organization"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditJobTitle.ClientID %>" class="auth-label">
                                                        <i class="bi bi-briefcase ml-1 text-info"></i> المسمى الوظيفي / الدور
                                                    </label>
                                                    <asp:TextBox ID="TxtEditJobTitle" runat="server" CssClass="form-control" placeholder="مثال: استشاري أشعة"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditSpecialty.ClientID %>" class="auth-label">
                                                        <i class="bi bi-award ml-1 text-info"></i> التخصص / المجال الدقيق
                                                    </label>
                                                    <asp:TextBox ID="TxtEditSpecialty" runat="server" CssClass="form-control" placeholder="مثال: أشعة الأعصاب، الذكاء الاصطناعي الصحي"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditLinkedIn.ClientID %>" class="auth-label">
                                                        <i class="bi bi-linkedin ml-1 text-info"></i> رابط حساب لينكد إن
                                                    </label>
                                                    <asp:TextBox ID="TxtEditLinkedIn" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/..."></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnPudateProfile" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="حفظ التعديلات" OnClick="BtnPudateProfile_Click" data-loading-text="جارٍ الحفظ..." />
                                        </div>
                                    </div>
                                </div>

                                <!-- Change Password Box -->
                                <div runat="server" id="div_changepasss" visible="false">
                                    <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-secondary">
                                        <i class="bi bi-shield-lock text-info ml-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">تغيير كلمة المرور</h3>
                                    </div>

                                    <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtPassCurrent.ClientID %>" class="auth-label">
                                                <i class="bi bi-key ml-1 text-info"></i> كلمة المرور الحالية
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPassCurrent" runat="server" TextMode="Password" CssClass="form-control" placeholder="أدخل كلمة المرور الحالية" autocomplete="current-password" required="required"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassCurrent.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="auth-field">
                                            <label for="<%= TxtPass.ClientID %>" class="auth-label">
                                                <i class="bi bi-lock ml-1 text-info"></i> كلمة المرور الجديدة
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" CssClass="form-control" placeholder="أدخل كلمة المرور الجديدة (8 أحرف على الأقل)" autocomplete="new-password" required="required"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPass.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
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

                                        <div class="auth-field">
                                            <label for="<%= TxtPassRe.ClientID %>" class="auth-label">
                                                <i class="bi bi-check-all ml-1 text-info"></i> تأكيد كلمة المرور الجديدة
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPassRe" runat="server" TextMode="Password" CssClass="form-control" placeholder="تأكيد كلمة المرور الجديدة" autocomplete="new-password" required="required"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassRe.ClientID %>" aria-label="إظهار كلمة المرور" data-label-show="إظهار كلمة المرور" data-label-hide="إخفاء كلمة المرور" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </div>
                                            <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnUpdate" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="تحديث كلمة المرور" OnClick="BtnUpdate_Click" data-loading-text="جارٍ التحديث..." />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </section>
</asp:Content>
