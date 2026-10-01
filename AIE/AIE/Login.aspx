<%@ Page Title="Sign In - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AIE.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="simpler-main-bg min-vh-100 d-flex align-items-center py-5" aria-label="Sign In">
        <div class="container py-5">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-5 text-light mb-5 mb-lg-0">
                    <div class="d-inline-flex mb-3">
                    </div>
                    <div class="h1 text-light font-weight-bold mb-3">
                        Welcome <br />
                        <div class="typed-strings">
                            <p><span class="h1 text-white">Saudi First AI Summit in Radiology and Health Innovation</span></p>
                        </div>
                        <div class="typed text-info"></div>
                    </div>
                    <p class="lead text-secondary" style="font-size: 1.5rem; font-weight: 600;">2026</p>
                </div>

                <div class="col-lg-5 offset-lg-1">
                    <div class="login-glass-card">
                        <h3 class="text-white font-weight-bold mb-2 text-center">Sign In</h3>
                        <p class="text-secondary text-center mb-4">
                            Login using an existing account or create a new account <a href="Register" class="text-info font-weight-bold">here</a>.
                        </p>

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div class="form-border">
                                    <div class="field-set">
                                        <asp:TextBox ID="TxtUserName" runat="server" CssClass="form-control" placeholder="email"></asp:TextBox>
                                    </div>

                                    <div class="field-set">
                                        <asp:TextBox ID="TxtPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="password"></asp:TextBox>
                                    </div>

                                    <div class="field-set text-center mt-3">
                                        <asp:LinkButton ID="BtnLogin" runat="server" CssClass="cyan-glow-btn w-100 py-3" OnClick="Login_Click">Log In</asp:LinkButton>
                                    </div>

                                    <div id="divError" class="alert alert-danger text-danger mt-3" runat="server" visible="false">Test Messages</div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
