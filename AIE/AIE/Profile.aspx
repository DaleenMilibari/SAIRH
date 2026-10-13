<%@ Page Title="" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Profile" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section id="subheader" class="text-light" data-bgimage="url(Content/images/background/background.png) bottom">
        <h1>Profile</h1>
    </section>
    <section id="section-highlight">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="row sequence">
                        <div class="col-md-4 mb10">
                            <div class="card-body">

                                <div class="text">
                                    <asp:Label ID="LblId" runat="server" Text="" Style="visibility: hidden"></asp:Label>
                                    <h4>
                                        <asp:Label ID="LblName" runat="server" Text=""></asp:Label></h4>

                                    <asp:Label ID="TxtMobile" runat="server" Text=""></asp:Label>
                                    <br />
                                    <asp:Label ID="TxtEmail" runat="server" Text=""></asp:Label>
                                    <br />
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="btn btn-secondary btn-sm text-left mb-2" Width="100%" Height="50"
                                        OnClick="BtnShowProfile_Click"> <i class="i-circle fa fa-user"></i> Edit Profile </asp:LinkButton>
                                    <br />
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="btn btn-secondary btn-sm text-left mb-2" Width="100%" Height="50"
                                        OnClick="BtnShowChangePass_Click"> <i class=" i-circle fa fa-key"></i> Change Password </asp:LinkButton>
                                    <br />
                                    <%-- <asp:LinkButton 
                                        ID="BtnShowSurvey" 
                                        runat="server" 
                                        CssClass="btn btn-secondary btn-sm text-left" 
                                        Width="100%" 
                                        Height="50"
                                        OnClientClick="window.open('https://ud.questionpro.com/a/TakeSurvey?tt=neb%2Bv7we7FsECHrPeIW9eQ%3D%3D', '_blank'); return false;">
                                        <i class="i-circle fa fa-list-check"></i> Satisfaction Evaluation
                                    </asp:LinkButton> --%>

                                </div>


                            </div>
                        </div>

                        <div class="col-md-8 mb30">
                            <div id="contact_form1" class="form-border mt-2">

                                <div class="card" runat="server" id="div_editprofile" visible="true">
                                    <div class="card-header">Edit Profile</div>
                                    <div class="form-border card-body">
                                        <div class="field-set">
                                            <label>Mobile No</label>
                                            <asp:TextBox ID="TxtEditMobile" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>

                                        <div class="field-set">
                                            <label>Gender:</label>
                                            <dx:ASPxRadioButtonList ID="TxtGender" runat="server" ValueType="System.String" Theme="Material" Width="100%" RepeatDirection="Horizontal" Height="40px">
                                                <Items>
                                                    <dx:ListEditItem Value="Male" Text="Male" />
                                                    <dx:ListEditItem Value="Female" Text="Female" />
                                                </Items>
                                            </dx:ASPxRadioButtonList>
                                        </div>
                                        <div class="field-set">
                                            <label>Nationality:</label>

                                            <dx:BootstrapComboBox ID="Nationality" runat="server" DataSourceID="ds_Countries" EnableTheming="true" 
                                                ValueField="CountryID" ValueType="System.String">

                                                <Fields>
                                                    <dx:BootstrapListBoxField FieldName="NationalityEn"></dx:BootstrapListBoxField>
                                                </Fields>
                                            </dx:BootstrapComboBox>
                                            <asp:SqlDataSource runat="server" ID="ds_Countries" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [CountryID], [NationalityEn], [PathLocation] FROM [qryCountries] ORDER BY [Sorting]"></asp:SqlDataSource>
                                        </div>
                                        <div class="field-set">
                                            <label>LinkedIn Account:</label>
                                            <asp:TextBox ID="TxtLinkedin" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="field-set">
                                            <asp:LinkButton runat="server" ID="BtnPudateProfile" CssClass="btn btn-primary float-right" OnClick="BtnPudateProfile_Click">Update</asp:LinkButton>

                                        </div>
                                        <div class="clearfix"></div>

                                        <div class="spacer-single"></div>
                                        <div id="divErrorProfile" class="error_input" runat="server"></div>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>


                                <div class="card" runat="server" id="div_changepasss" visible="false">
                                    <div class="card-header">Update Password</div>
                                    <div class="form-border card-body">
                                        <div class="field-set">
                                            <label>Current Password:</label>
                                            <asp:TextBox ID="TxtCurrentPass" runat="server" CssClass="form-control" TextMode="Password" AutoComplete="false"></asp:TextBox>
                                        </div>

                                        <div class="field-set">
                                            <label>New Password:</label>
                                            <asp:TextBox ID="TxtPass" runat="server" CssClass="form-control" TextMode="Password" AutoComplete="false"></asp:TextBox>
                                        </div>

                                        <div class="field-set">
                                            <label>Confirm Password:</label>
                                            <asp:TextBox ID="TxtPassRe" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>

                                        </div>
                                        <div class="field-set">
                                            <asp:LinkButton runat="server" ID="BtnUpdate" CssClass="btn btn-primary float-right" OnClick="BtnUpdate_Click">Update</asp:LinkButton>

                                        </div>
                                        <div class="clearfix"></div>

                                        <div class="spacer-single"></div>
                                        <div id="divError" class="error_input" runat="server">Test Messages</div>
                                        <div class="clearfix"></div>
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
