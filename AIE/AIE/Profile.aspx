<%@ Page Title="Profile - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Profile Page Container -->
    <section class="profile-page-section" aria-label="Profile Management">
        <div class="container">
            <!-- Header Title -->
            <div class="profile-page-header text-center mb-4">
                <h1 class="text-white font-weight-bold mb-2">Account Profile</h1>
                <p class="text-secondary small mb-3">Manage your attendee credentials, contact details, and summit preferences.</p>
                <div style="width: 60px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row align-items-start">
                        <!-- Sidebar Card -->
                        <div class="col-lg-4 mb-4 mb-lg-0">
                            <div class="profile-user-card text-center">
                                <div class="profile-avatar-circle">
                                    <i class="bi bi-person"></i>
                                </div>
                                <asp:Label ID="LblId" runat="server" Text="" Visible="false"></asp:Label>
                                <h3 class="text-white font-weight-bold mb-1">
                                    <asp:Label ID="LblName" runat="server" Text="Attendee Name"></asp:Label>
                                </h3>
                                <div class="mb-3">
                                    <asp:Label ID="LblUserRoleBadge" runat="server" CssClass="profile-role-badge" Text="Attendee"></asp:Label>
                                </div>
                                <p class="text-info mb-1 font-weight-semibold small" id="pOrgTitle" runat="server" visible="false">
                                    <i class="bi bi-building mr-1"></i> <asp:Label ID="LblOrgTitle" runat="server" Text=""></asp:Label>
                                </p>
                                <p class="text-secondary mb-1 small d-flex align-items-center justify-content-center">
                                    <i class="bi bi-telephone mr-2 text-info"></i> <asp:Label ID="TxtMobile" runat="server" Text="-"></asp:Label>
                                </p>
                                <p class="text-secondary mb-3 small d-flex align-items-center justify-content-center">
                                    <i class="bi bi-envelope mr-2 text-info"></i> <asp:Label ID="TxtEmail" runat="server" Text="-"></asp:Label>
                                </p>

                                <div class="mt-4">
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="profile-nav-btn active" OnClick="BtnShowProfile_Click">
                                        <i class="bi bi-person-gear"></i> Edit Profile Information
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowChangePass_Click">
                                        <i class="bi bi-shield-lock"></i> Change Security Password
                                    </asp:LinkButton>
                                </div>

                                <!-- Exhibition Roadmap Box -->
                                <div class="expo-profile-roadmap-box mt-4 text-left">
                                    <div class="d-flex align-items-center mb-3 pb-2" style="border-bottom: 1px solid rgba(255, 255, 255, 0.08);">
                                        <div class="mr-2 d-flex align-items-center justify-content-center rounded" style="width: 28px; height: 28px; min-width: 28px; background: rgba(56, 189, 248, 0.15); border: 1px solid rgba(56, 189, 248, 0.3); color: #38bdf8; border-radius: 8px !important;">
                                            <i class="bi bi-compass" style="font-size: 0.95rem;"></i>
                                        </div>
                                        <span class="roadmap-header-title">Exhibition Roadmap</span>
                                        <asp:Label ID="LblSurveyBadge" runat="server" Visible="false" style="display:none;"></asp:Label>
                                    </div>
                                    <p class="small mb-3" id="pRoadmapDesc" runat="server" style="color: #94a3b8; font-size: 0.82rem; line-height: 1.45;">
                                        Answer 3 quick questions to generate a personalized tour of exhibitor booths and research showcases.
                                    </p>
                                    <div id="pnlSurveyStops" runat="server" class="roadmap-stops-panel" style="display:none;">
                                        <div class="small mb-2 d-flex align-items-center justify-content-between" style="color: #7dd3fc; font-weight: 600; font-size: 0.74rem;">
                                            <span><i class="bi bi-geo-alt-fill mr-1 text-info"></i> Recommended Stops</span>
                                        </div>
                                        <div id="pnlStopsChips" runat="server" class="d-flex flex-wrap" style="gap: 5px;"></div>
                                    </div>
                                    <div id="pnlRoadmapActions" runat="server" class="roadmap-actions-container">
                                        <a href="Survey" id="lnkSurveyAction" runat="server" class="roadmap-highlight-cta">
                                            <i class="bi bi-magic mr-2"></i>
                                            <span>Build My Roadmap</span>
                                            <i class="bi bi-arrow-right ml-2 cta-arrow"></i>
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
                                    <div class="d-flex align-items-center mb-4 pb-3" style="border-bottom: 1px solid rgba(56, 189, 248, 0.18);">
                                        <i class="bi bi-person-badge text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0" style="font-size: 1.35rem;">Edit Profile Information</h3>
                                    </div>

                                    <div id="divErrorProfile" class="auth-alert alert" runat="server" visible="false" role="alert" style="display:none;"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtEditFullName.ClientID %>" class="auth-label">
                                                <i class="bi bi-person mr-1 text-info"></i> Full Name
                                            </label>
                                            <asp:TextBox ID="TxtEditFullName" runat="server" CssClass="form-control" placeholder="Enter your full name" autocomplete="name" required="required" MaxLength="100" pattern="^[a-zA-Z\u0600-\u06FF\s]+$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                        </div>

                                        <div class="auth-field">
                                            <div class="auth-row-between">
                                                <label for="<%= TxtEditMobile.ClientID %>" class="auth-label">
                                                    <i class="bi bi-telephone mr-1 text-info"></i> Mobile Number
                                                </label>
                                                <span class="auth-optional">Optional</span>
                                            </div>
                                            <div class="phone-input-group">
                                                <div class="phone-country-dropdown-wrap">
                                                    <select id="DdlEditCountryCode" name="DdlEditCountryCode" class="phone-country-select" aria-label="Country calling code" autocomplete="tel-country-code">
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
                                                    <asp:TextBox ID="TxtEditMobile" runat="server" TextMode="Phone" CssClass="form-control phone-number-input" placeholder="50 123 4567" autocomplete="tel-national" MaxLength="15"></asp:TextBox>
                                                </div>
                                            </div>
                                            <small class="auth-hint phone-hint" id="phoneHintEdit">Saudi mobile format: 50 123 4567 (9 digits)</small>
                                            <div class="phone-validation-feedback" id="phoneFeedbackEdit" style="display: none;"></div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditOrg.ClientID %>" class="auth-label">
                                                        <i class="bi bi-building mr-1 text-info"></i> Organization / Workplace
                                                    </label>
                                                    <asp:TextBox ID="TxtEditOrg" runat="server" CssClass="form-control" placeholder="Hospital / University / Company" autocomplete="organization" MaxLength="200" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditJobTitle.ClientID %>" class="auth-label">
                                                        <i class="bi bi-briefcase mr-1 text-info"></i> Job Title / Role
                                                    </label>
                                                    <asp:TextBox ID="TxtEditJobTitle" runat="server" CssClass="form-control" placeholder="e.g. Consultant Radiologist" MaxLength="150" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditSpecialty.ClientID %>" class="auth-label">
                                                        <i class="bi bi-award mr-1 text-info"></i> Specialty / Field
                                                    </label>
                                                    <asp:TextBox ID="TxtEditSpecialty" runat="server" CssClass="form-control" placeholder="e.g. Neuroradiology, AI in Health" MaxLength="150" pattern="^[a-zA-Z\u0600-\u06FF\s]*$" title="Letters only (uppercase and lowercase)"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditLinkedIn.ClientID %>" class="auth-label">
                                                        <i class="bi bi-linkedin mr-1 text-info"></i> LinkedIn Profile
                                                    </label>
                                                    <asp:TextBox ID="TxtEditLinkedIn" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/username" MaxLength="300" pattern="^https?://([a-zA-Z0-9-]+\.)?linkedin\.com/.*$" title="Valid LinkedIn URL"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnPudateProfile" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="Save Changes" OnClick="BtnPudateProfile_Click" data-loading-text="Saving..." formnovalidate="formnovalidate" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Change Password Box -->
                                <div runat="server" id="div_changepasss" visible="false">
                                    <div class="d-flex align-items-center mb-4 pb-3" style="border-bottom: 1px solid rgba(56, 189, 248, 0.18);">
                                        <i class="bi bi-shield-lock text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0" style="font-size: 1.35rem;">Change Security Password</h3>
                                    </div>

                                    <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert" style="display:none;"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtPassCurrent.ClientID %>" class="auth-label">
                                                <i class="bi bi-key mr-1 text-info"></i> Current Password
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPassCurrent" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your current password" autocomplete="current-password"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassCurrent.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="auth-field">
                                            <label for="<%= TxtPass.ClientID %>" class="auth-label">
                                                <i class="bi bi-lock mr-1 text-info"></i> New Password
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter new password (min. 8 characters)" autocomplete="new-password"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPass.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
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
                                            <label for="<%= TxtPassRe.ClientID %>" class="auth-label">
                                                <i class="bi bi-check-all mr-1 text-info"></i> Confirm New Password
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPassRe" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm new password" autocomplete="new-password"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassRe.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </div>
                                            <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnUpdate" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="Update Password" OnClick="BtnUpdate_Click" data-loading-text="Updating..." formnovalidate="formnovalidate" />
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
