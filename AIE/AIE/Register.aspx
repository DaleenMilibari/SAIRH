<%@ Page Title="Register - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AIE.Register" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .register-glass-card {
            background: rgba(14, 28, 66, 0.55);
            border: 1px solid rgba(56, 189, 248, 0.2);
            border-radius: 22px;
            padding: 40px;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.45);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Register Header">
        <div class="container text-center pt-4 pb-2">
            <span class="glass-pill glass-pill-cyan mb-3">Delegate Account</span>
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
                        <div class="col-lg-8">
                            <div class="register-glass-card">
                                <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                                    <h3 class="text-white font-weight-bold mb-2">Registration Details</h3>
                                    <p class="text-secondary mb-0">
                                        Already registered? <a href="Login" class="text-info font-weight-bold">Sign in here</a>.
                                    </p>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-user mr-1 text-info"></i> Full Name</label>
                                            <asp:TextBox ID="TxtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-phone mr-1 text-info"></i> Mobile Number</label>
                                            <asp:TextBox ID="TxtMobile" runat="server" CssClass="form-control" placeholder="Enter mobile number"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-venus-mars mr-1 text-info"></i> Gender</label>
                                            <dx:ASPxRadioButtonList ID="TxtGender" runat="server" ValueType="System.String" Width="100%" RepeatDirection="Horizontal" Height="40px">
                                                <Items>
                                                    <dx:ListEditItem Value="Male" Text="Male" />
                                                    <dx:ListEditItem Value="Female" Text="Female" />
                                                </Items>
                                            </dx:ASPxRadioButtonList>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-flag mr-1 text-info"></i> Nationality</label>
                                            <dx:BootstrapComboBox ID="Nationality" runat="server" DataSourceID="ds_Countries" EnableTheming="true" CssClass="form-control"
                                                ValueField="CountryID" ValueType="System.String">
                                                <Fields>
                                                    <dx:BootstrapListBoxField FieldName="NationalityEn"></dx:BootstrapListBoxField>
                                                </Fields>
                                            </dx:BootstrapComboBox>
                                            <asp:SqlDataSource runat="server" ID="ds_Countries" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>' 
                                                SelectCommand="SELECT [CountryID], [NationalityEn], [PathLocation] FROM [qryCountries] ORDER BY [Sorting]"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-envelope mr-1 text-info"></i> Email Address</label>
                                            <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control" placeholder="name@domain.com"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa-brands fa-linkedin mr-1 text-info"></i> LinkedIn Account</label>
                                            <asp:TextBox ID="TxtLinkedin" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/username"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-lock mr-1 text-info"></i> Password</label>
                                            <asp:TextBox ID="TxtPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="Create password"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-4">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-check-double mr-1 text-info"></i> Re-enter Password</label>
                                            <asp:TextBox ID="TxtPasswordAgain" TextMode="Password" runat="server" CssClass="form-control" placeholder="Confirm password"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-12 mt-2">
                                        <div class="d-flex justify-content-center">
                                            <asp:LinkButton ID="BtnRegister" runat="server" CssClass="cyan-glow-btn px-5 py-3 text-white font-weight-bold" OnClick="BtnRegister_Click">
                                                <i class="fa fa-user-plus mr-1"></i> Register Account
                                            </asp:LinkButton>
                                        </div>

                                        <div id="divError" class="text-danger text-center mt-3" runat="server"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
