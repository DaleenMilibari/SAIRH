<%@ Page Title="Profile - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Profile" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-user-card {
            background: rgba(14, 28, 66, 0.5);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 22px;
            padding: 30px;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
        }
        .profile-avatar-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(2, 132, 199, 0.3), rgba(37, 99, 235, 0.3));
            border: 2px solid rgba(56, 189, 248, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #38bdf8;
            font-size: 2.2rem;
            margin: 0 auto 16px auto;
            box-shadow: 0 0 25px rgba(56, 189, 248, 0.25);
        }
        .profile-nav-btn {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 12px;
            padding: 14px 20px;
            background: rgba(4, 8, 22, 0.45);
            border: 1px solid rgba(56, 189, 248, 0.18);
            border-radius: 14px;
            color: #ffffff !important;
            font-weight: 600;
            text-decoration: none !important;
            transition: all 0.25s ease;
            margin-bottom: 12px;
            width: 100%;
        }
        .profile-nav-btn:hover {
            background: rgba(56, 189, 248, 0.2);
            border-color: #38bdf8;
            box-shadow: 0 0 20px rgba(56, 189, 248, 0.25);
        }
        .profile-nav-btn i {
            color: #38bdf8;
            font-size: 1.1rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Profile Header">
        <div class="container text-center pt-4 pb-2">
            <span class="glass-pill glass-pill-cyan mb-3">User Portal</span>
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
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:Label ID="LblId" runat="server" Text="" Style="visibility: hidden"></asp:Label>
                                <h3 class="text-white font-weight-bold mb-2">
                                    <asp:Label ID="LblName" runat="server" Text="User Name"></asp:Label>
                                </h3>
                                <p class="text-info mb-1 font-weight-semibold">
                                    <i class="fa fa-phone mr-1"></i> <asp:Label ID="TxtMobile" runat="server" Text=""></asp:Label>
                                </p>
                                <p class="text-secondary mb-4 small">
                                    <i class="fa fa-envelope mr-1"></i> <asp:Label ID="TxtEmail" runat="server" Text=""></asp:Label>
                                </p>

                                <div class="mt-4">
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowProfile_Click">
                                        <i class="fa fa-user-edit"></i> Edit Profile Information
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="profile-nav-btn" OnClick="BtnShowChangePass_Click">
                                        <i class="fa fa-key"></i> Change Security Password
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>

                        <!-- Main Form Card -->
                        <div class="col-lg-8">
                            <div id="contact_form1" class="glass-card p-4">
                                <!-- Edit Profile Box -->
                                <div runat="server" id="div_editprofile" visible="true">
                                    <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-secondary">
                                        <i class="fa fa-id-card text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">Edit Profile Information</h3>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label class="text-secondary font-weight-semibold">Mobile Number</label>
                                        <asp:TextBox ID="TxtEditMobile" runat="server" CssClass="form-control" placeholder="Enter mobile number"></asp:TextBox>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label class="text-secondary font-weight-semibold">Gender</label>
                                        <dx:ASPxRadioButtonList ID="TxtGender" runat="server" ValueType="System.String" Theme="Material" Width="100%" RepeatDirection="Horizontal" Height="40px">
                                            <Items>
                                                <dx:ListEditItem Value="Male" Text="Male" />
                                                <dx:ListEditItem Value="Female" Text="Female" />
                                            </Items>
                                        </dx:ASPxRadioButtonList>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label class="text-secondary font-weight-semibold">Nationality</label>
                                        <dx:BootstrapComboBox ID="Nationality" runat="server" DataSourceID="ds_Countries" EnableTheming="true" 
                                            ValueField="CountryID" ValueType="System.String" CssClass="form-control">
                                            <Fields>
                                                <dx:BootstrapListBoxField FieldName="NationalityEn"></dx:BootstrapListBoxField>
                                            </Fields>
                                        </dx:BootstrapComboBox>
                                        <asp:SqlDataSource runat="server" ID="ds_Countries" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                            SelectCommand="SELECT [CountryID], [NationalityEn], [PathLocation] FROM [qryCountries] ORDER BY [Sorting]"></asp:SqlDataSource>
                                    </div>

                                    <div class="form-group mb-4">
                                        <label class="text-secondary font-weight-semibold">LinkedIn Profile URL</label>
                                        <asp:TextBox ID="TxtLinkedin" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/username"></asp:TextBox>
                                    </div>

                                    <div class="d-flex justify-content-end">
                                        <asp:LinkButton runat="server" ID="BtnPudateProfile" CssClass="cyan-glow-btn px-4 py-2" OnClick="BtnPudateProfile_Click">
                                            <i class="fa fa-save mr-1"></i> Save Changes
                                        </asp:LinkButton>
                                    </div>

                                    <div id="divErrorProfile" class="text-danger mt-3" runat="server"></div>
                                </div>

                                <!-- Change Password Box -->
                                <div runat="server" id="div_changepasss" visible="false">
                                    <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-secondary">
                                        <i class="fa fa-lock text-info mr-2" style="font-size: 1.4rem;"></i>
                                        <h3 class="text-white font-weight-bold m-0">Update Password</h3>
                                    </div>

                                    <div class="form-group mb-3">
                                        <label class="text-secondary font-weight-semibold">New Password</label>
                                        <asp:TextBox ID="TxtPass" runat="server" CssClass="form-control" TextMode="Password" AutoComplete="false" placeholder="Enter new password"></asp:TextBox>
                                    </div>

                                    <div class="form-group mb-4">
                                        <label class="text-secondary font-weight-semibold">Confirm Password</label>
                                        <asp:TextBox ID="TxtPassRe" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                                    </div>

                                    <div class="d-flex justify-content-end">
                                        <asp:LinkButton runat="server" ID="BtnUpdate" CssClass="cyan-glow-btn px-4 py-2" OnClick="BtnUpdate_Click">
                                            <i class="fa fa-shield-alt mr-1"></i> Update Password
                                        </asp:LinkButton>
                                    </div>

                                    <div id="divError" class="text-danger mt-3" runat="server"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </section>
</asp:Content>
