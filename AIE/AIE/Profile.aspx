<%@ Page Title="Profile - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Profile Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Account Profile
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Content -->
    <section class="py-5" aria-label="Profile Management">
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
                                    <asp:Label ID="LblName" runat="server" Text="Attendee Name"></asp:Label>
                                </h3>
                                <div class="mb-2">
                                    <asp:Label ID="LblUserRoleBadge" runat="server" CssClass="badge badge-info" Text="Attendee"></asp:Label>
                                </div>
                                <p class="text-info mb-1 font-weight-semibold small" id="pOrgTitle" runat="server" visible="false">
                                    <i class="bi bi-building mr-1"></i> <asp:Label ID="LblOrgTitle" runat="server" Text=""></asp:Label>
                                </p>
                                <p class="text-secondary mb-1 small">
                                    <i class="bi bi-telephone mr-1"></i> <asp:Label ID="TxtMobile" runat="server" Text="-"></asp:Label>
                                </p>
                                <p class="text-secondary mb-3 small">
                                    <i class="bi bi-envelope mr-1"></i> <asp:Label ID="TxtEmail" runat="server" Text="-"></asp:Label>
                                </p>

                                <div class="mt-4">
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowProfile_Click">
                                        <i class="bi bi-person-gear"></i> Edit Profile Information
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowChangePass_Click">
                                        <i class="bi bi-shield-lock"></i> Change Security Password
                                    </asp:LinkButton>
                                </div>

                                <!-- Security Status Box -->
                                <div class="mt-4 p-3 text-left" style="background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 14px;">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <span class="text-white font-weight-bold small"><i class="bi bi-shield-check text-success mr-1"></i> Security Status</span>
                                        <span class="badge badge-success">Protected</span>
                                    </div>
                                    <div class="text-secondary small mb-1">
                                        <i class="bi bi-clock-history mr-1"></i> Last Sign-in: <asp:Label ID="LblLastLogin" runat="server" CssClass="text-light" Text="Active Session"></asp:Label>
                                    </div>
                                    <div class="text-secondary small">
                                        <i class="bi bi-key mr-1"></i> Password Updated: <asp:Label ID="LblPasswordAge" runat="server" CssClass="text-light" Text="Secured"></asp:Label>
                                    </div>
                                </div>

                                <!-- Exhibition Roadmap Box -->
                                <div class="expo-profile-roadmap-box mt-4 p-3 text-left" style="background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(56, 189, 248, 0.25); border-radius: 14px;">
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <span class="text-white font-weight-bold small"><i class="bi bi-map text-info mr-1"></i> Exhibition Roadmap</span>
                                        <asp:Label ID="LblSurveyBadge" runat="server" CssClass="badge badge-warning" Text="Not Completed"></asp:Label>
                                    </div>
                                    <p class="text-secondary small mb-3" id="pRoadmapDesc" runat="server">
                                        Take our short survey to get a tailored tour of sponsor booths and research displays on the Exhibition Map.
                                    </p>
                                    <div id="pnlSurveyStops" runat="server" class="mb-3" visible="false">
                                        <div class="text-secondary small mb-1">Recommended Stops:</div>
                                        <div id="pnlStopsChips" runat="server" class="d-flex flex-wrap gap-1"></div>
                                    </div>
                                    <div class="d-flex flex-column gap-2">
                                        <a href="Schedules" class="btn btn-sm btn-info rounded-pill font-weight-bold">
                                            <i class="bi bi-compass mr-1"></i> View on Floor Map
                                        </a>
                                        <a href="Survey" id="lnkSurveyAction" runat="server" class="btn btn-sm btn-outline-light rounded-pill font-weight-semibold">
                                            <i class="bi bi-magic mr-1"></i> Build My Roadmap
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
                                        <i class="bi bi-person-badge text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">Edit Profile Information</h3>
                                    </div>

                                    <div id="divErrorProfile" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtEditFullName.ClientID %>" class="auth-label">
                                                <i class="bi bi-person mr-1 text-info"></i> Full Name
                                            </label>
                                            <asp:TextBox ID="TxtEditFullName" runat="server" CssClass="form-control" placeholder="Enter your full name" autocomplete="name" required="required"></asp:TextBox>
                                        </div>

                                        <div class="auth-field">
                                            <label for="<%= TxtEditMobile.ClientID %>" class="auth-label">
                                                <i class="bi bi-telephone mr-1 text-info"></i> Mobile Number
                                            </label>
                                            <asp:TextBox ID="TxtEditMobile" runat="server" TextMode="Phone" CssClass="form-control" placeholder="Enter mobile number" autocomplete="tel"></asp:TextBox>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditOrg.ClientID %>" class="auth-label">
                                                        <i class="bi bi-building mr-1 text-info"></i> Organization / Workplace
                                                    </label>
                                                    <asp:TextBox ID="TxtEditOrg" runat="server" CssClass="form-control" placeholder="Hospital / University / Company" autocomplete="organization"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditJobTitle.ClientID %>" class="auth-label">
                                                        <i class="bi bi-briefcase mr-1 text-info"></i> Job Title / Role
                                                    </label>
                                                    <asp:TextBox ID="TxtEditJobTitle" runat="server" CssClass="form-control" placeholder="e.g. Consultant Radiologist"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditSpecialty.ClientID %>" class="auth-label">
                                                        <i class="bi bi-award mr-1 text-info"></i> Specialty / Field
                                                    </label>
                                                    <asp:TextBox ID="TxtEditSpecialty" runat="server" CssClass="form-control" placeholder="e.g. Neuroradiology, AI in Health"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="auth-field">
                                                    <label for="<%= TxtEditLinkedIn.ClientID %>" class="auth-label">
                                                        <i class="bi bi-linkedin mr-1 text-info"></i> LinkedIn Profile
                                                    </label>
                                                    <asp:TextBox ID="TxtEditLinkedIn" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/..."></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnPudateProfile" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="Save Changes" OnClick="BtnPudateProfile_Click" data-loading-text="Saving..." />
                                        </div>
                                    </div>
                                </div>

                                <!-- Change Password Box -->
                                <div runat="server" id="div_changepasss" visible="false">
                                    <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-secondary">
                                        <i class="bi bi-shield-lock text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">Change Security Password</h3>
                                    </div>

                                    <div id="divError" class="auth-alert alert" runat="server" visible="false" role="alert"></div>

                                    <div class="auth-form">
                                        <div class="auth-field">
                                            <label for="<%= TxtPassCurrent.ClientID %>" class="auth-label">
                                                <i class="bi bi-key mr-1 text-info"></i> Current Password
                                            </label>
                                            <div class="auth-password">
                                                <asp:TextBox ID="TxtPassCurrent" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your current password" autocomplete="current-password" required="required"></asp:TextBox>
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
                                                <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter new password (min. 8 characters)" autocomplete="new-password" required="required"></asp:TextBox>
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
                                                <asp:TextBox ID="TxtPassRe" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm new password" autocomplete="new-password" required="required"></asp:TextBox>
                                                <button type="button" class="auth-password-toggle" data-toggle-password="<%= TxtPassRe.ClientID %>" aria-label="Show password" data-label-show="Show password" data-label-hide="Hide password" aria-pressed="false">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </div>
                                            <div id="pwdMatchMsg" class="password-match-status" style="display: none;"></div>
                                        </div>

                                        <div class="d-flex justify-content-end mt-3">
                                            <asp:Button runat="server" ID="BtnUpdate" CssClass="cyan-glow-btn px-4 py-2 text-white font-weight-bold" Text="Update Password" OnClick="BtnUpdate_Click" data-loading-text="Updating..." />
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
