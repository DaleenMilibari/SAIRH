<%@ Page Title="Create Account - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AIE.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Register Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Create Your Account
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Registration Section -->
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <section class="py-5" aria-label="Registration Form">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-7 col-md-9">
                            <div class="register-glass-card">
                                <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                                    <h3 class="text-white font-weight-bold mb-2">Attendee Registration</h3>
                                    <p class="text-secondary mb-0">
                                        Already registered? <a href="Login" class="text-info font-weight-bold">Sign in here</a>.
                                    </p>
                                </div>

                                <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                <div class="auth-form">
                                    <div class="auth-field">
                                        <label for="<%= TxtFullName.ClientID %>" class="auth-label">
                                            <i class="bi bi-person mr-1 text-info"></i> Full Name
                                        </label>
                                        <asp:TextBox ID="TxtFullName" runat="server" CssClass="form-control" placeholder="e.g. Dr Sarah Al Ahmad" autocomplete="name" required="required" MaxLength="100" pattern="^[a-zA-Z\u0600-\u06FF\s]+$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <label for="<%= TxtEmail.ClientID %>" class="auth-label">
                                            <i class="bi bi-envelope mr-1 text-info"></i> Email Address
                                        </label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@domain.com" autocomplete="username" required="required" MaxLength="100" pattern="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$" title="Valid email address"></asp:TextBox>
                                    </div>

                                    <div class="auth-field">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtMobile.ClientID %>" class="auth-label">
                                                <i class="bi bi-telephone mr-1 text-info"></i> Mobile Number
                                            </label>
                                            <span class="auth-optional">Optional</span>
                                        </div>
                                        <div class="phone-input-group">
                                            <div class="phone-country-dropdown-wrap">
                                                <select id="DdlCountryCode" name="DdlCountryCode" class="phone-country-select" aria-label="Country calling code" autocomplete="tel-country-code">
                                                    <option value="+966" selected="selected">🇸🇦 +966 (KSA)</option>
                                                    <option value="+971">🇦🇪 +971 (UAE)</option>
                                                    <option value="+965">🇰🇼 +965 (Kuwait)</option>
                                                    <option value="+973">🇧🇭 +973 (Bahrain)</option>
                                                    <option value="+974">🇶🇦 +974 (Qatar)</option>
                                                    <option value="+968">🇴🇲 +968 (Oman)</option>
                                                    <option value="+20">🇪🇬 +20 (Egypt)</option>
                                                    <option value="+962">🇯🇴 +962 (Jordan)</option>
                                                    <option value="+961">🇱🇧 +961 (Lebanon)</option>
                                                    <option value="+964">🇮🇶 +964 (Iraq)</option>
                                                    <option value="+967">🇾🇪 +967 (Yemen)</option>
                                                    <option value="+44">🇬🇧 +44 (UK)</option>
                                                    <option value="+1">🇺🇸 +1 (US/CA)</option>
                                                    <option value="+49">🇩🇪 +49 (Germany)</option>
                                                    <option value="+33">🇫🇷 +33 (France)</option>
                                                    <option value="+90">🇹🇷 +90 (Turkey)</option>
                                                    <option value="+91">🇮🇳 +91 (India)</option>
                                                    <option value="+92">🇵🇰 +92 (Pakistan)</option>
                                                    <option value="+60">🇲🇾 +60 (Malaysia)</option>
                                                    <option value="+65">🇸🇬 +65 (Singapore)</option>
                                                    <option value="+61">🇦🇺 +61 (Australia)</option>
                                                    <option value="">🌐 Other / Custom</option>
                                                </select>
                                                <i class="bi bi-chevron-down phone-dropdown-arrow" aria-hidden="true"></i>
                                            </div>
                                            <div class="phone-number-wrap">
                                                <asp:TextBox ID="TxtMobile" runat="server" TextMode="Phone" CssClass="form-control phone-number-input" placeholder="50 123 4567" autocomplete="tel-national" MaxLength="15"></asp:TextBox>
                                            </div>
                                        </div>
                                        <small class="auth-hint phone-hint" id="phoneHint">Saudi mobile format: 50 123 4567 (9 digits)</small>
                                        <div class="phone-validation-feedback" id="phoneFeedback" style="display: none;"></div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <div class="auth-field">
                                                <div class="auth-row-between">
                                                    <label for="<%= TxtOrganization.ClientID %>" class="auth-label">
                                                        <i class="bi bi-building mr-1 text-info"></i> Organization
                                                    </label>
                                                    <span class="auth-optional">Optional</span>
                                                </div>
                                                <asp:TextBox ID="TxtOrganization" runat="server" CssClass="form-control" placeholder="Hospital / University / Company" autocomplete="organization" MaxLength="150" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <div class="auth-field">
                                                <div class="auth-row-between">
                                                    <label for="<%= TxtJobTitle.ClientID %>" class="auth-label">
                                                        <i class="bi bi-briefcase mr-1 text-info"></i> Job Title / Specialty
                                                    </label>
                                                    <span class="auth-optional">Optional</span>
                                                </div>
                                                <asp:TextBox ID="TxtJobTitle" runat="server" CssClass="form-control" placeholder="e.g. Radiologist, Researcher" MaxLength="100" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3 mb-md-0">
                                            <div class="auth-field">
                                                <label for="<%= TxtPassword.ClientID %>" class="auth-label">
                                                    <i class="bi bi-lock mr-1 text-info"></i> Password
                                                </label>
                                                <div class="auth-password">
                                                    <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Min. 8 characters" autocomplete="new-password" required="required" MaxLength="128"></asp:TextBox>
                                                    <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassword.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= TxtPasswordAgain.ClientID %>" class="auth-label">
                                                    <i class="bi bi-check-all mr-1 text-info"></i> Confirm Password
                                                </label>
                                                <div class="auth-password">
                                                    <asp:TextBox ID="TxtPasswordAgain" runat="server" TextMode="Password" CssClass="form-control" placeholder="Re-enter password" autocomplete="new-password" required="required" MaxLength="128"></asp:TextBox>
                                                    <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPasswordAgain.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                                <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                            </div>
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

                                    <div class="mt-3">
                                        <asp:Button ID="BtnRegister" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="Create Account" OnClick="BtnRegister_Click" data-loading-text="Creating Account..." />
                                    </div>

                                    <p class="auth-switch">
                                        Already have an account? <a href="Login" class="text-info font-weight-bold">Sign in here</a>
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
