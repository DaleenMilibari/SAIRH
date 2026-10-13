<%@ Page Title="" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AIE.Ar_Sa.Profile" %>
<%@ Register Assembly="DevExpress.Web.Bootstrap.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <section id="subheader" class="text-light" data-bgimage="url('<%= ResolveUrl("~/Content/images/background/background.png") %>') bottom">
        <h1>ملفي</h1>
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
                                    <asp:LinkButton ID="BtnShowProfile" runat="server" CssClass="btn btn-secondary btn-sm text-right mb-2 droidkufiregular" Width="100%" Height="50"
                                        OnClick="BtnShowProfile_Click"> <i class=" i-circle fa fa-user"></i> معلومات اضافية </asp:LinkButton>
                                    <br />
                                    <asp:LinkButton ID="BtnShowChangePass" runat="server" CssClass="btn btn-secondary btn-sm text-right mb-2 droidkufiregular" Width="100%" Height="50"
                                        OnClick="BtnShowChangePass_Click"> <i class=" i-circle fa fa-key"></i> تغيير كلمة المرور </asp:LinkButton>
                                    <br />
                                    <asp:LinkButton ID="BtnShowSurvey" runat="server" CssClass="btn btn-secondary btn-sm text-right droidkufiregular" Width="100%" Height="50"
                                        OnClientClick="window.open('https://ud.questionpro.com/a/TakeSurvey?tt=neb%2Bv7we7FsECHrPeIW9eQ%3D%3D', '_blank'); return false;">
                                        <i class=" i-circle fa fa-list-check"></i>  استبيان استطلاعي </asp:LinkButton>

                                </div>

                            </div>
                        </div>

                        <div class="col-md-8 mb30">
                            <div id="contact_form1" class="form-border mt-2">

                                <div class="card" runat="server" id="div_editprofile" visible="true">
                                    <div class="card-header  droidkufiregular">معلومات اضافية</div>
                                    <div class="form-border card-body">
                                        <div class="field-set">
                                            <label class="droidkufiregular">رقم الهاتف المحمول</label>
                                            <asp:TextBox ID="TxtEditMobile" runat="server" CssClass="form-control" ></asp:TextBox>
                                        </div>
                                      
                                        <div class="field-set">
                                            <label class="droidkufiregular">الجنس</label>
                                           <asp:RadioButtonList ID="TxtGender" runat="server" CssClass="form-control droidkufiregular" RepeatDirection="Horizontal" Height="43px">
                                                    <asp:ListItem Value="Male">ذكر</asp:ListItem>
                                                    <asp:ListItem Value="Female">انثى</asp:ListItem>
                                                </asp:RadioButtonList>
                                        </div>
                                        <div class="field-set">
                                            <label class="droidkufiregular">الجنسية</label>
                                            
                                            <dx:BootstrapComboBox ID="Nationality" runat="server" DataSourceID="ds_Countries" EnableTheming="true" 
                                                ValueField="CountryID" ValueType="System.String" CssClasses-ListBox="droidkufiregular">

                                                <Fields>
                                                    <dx:BootstrapListBoxField FieldName="NationalityEn"></dx:BootstrapListBoxField>
                                                </Fields>
                                            </dx:BootstrapComboBox>
                                            <asp:SqlDataSource runat="server" ID="ds_Countries" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>' 
                                                SelectCommand="SELECT [CountryID], [NationalityEn], [PathLocation] FROM [qryCountries] ORDER BY [Sorting]"></asp:SqlDataSource>
                                        </div>
                                        <div class="field-set">
                                            <label class="droidkufiregular">حساب اللينكدن</label>
                                            <asp:TextBox ID="TxtLinkedin" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="field-set">
                                            <asp:LinkButton runat="server" ID="BtnPudateProfile" CssClass="btn btn-primary float-right droidkufiregular" OnClick="BtnPudateProfile_Click">تحديث</asp:LinkButton>

                                        </div>
                                        <div class="clearfix"></div>

                                        <div class="spacer-single"></div>
                                        <div id="divErrorProfile" class="error_input" runat="server"></div>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>


                                <div class="card" runat="server" id="div_changepasss" visible="false">
                                    <div class="card-header btn-primary droidkufiregular" >تحديث كلمة المرور</div>
                                    <div class="form-border card-body">
                                        <div class="field-set">
                                            <label class="droidkufiregular">كلمة المرور الحالية</label>
                                            <asp:TextBox ID="TxtCurrentPass" runat="server" CssClass="form-control" TextMode="Password" AutoComplete="false"></asp:TextBox>
                                        </div>

                                        <div class="field-set">
                                            <label class="droidkufiregular">كلمة مرور جديدة</label>
                                            <asp:TextBox ID="TxtPass" runat="server" CssClass="form-control" TextMode="Password" AutoComplete="false"></asp:TextBox>
                                        </div>

                                        <div class="field-set">
                                            <label class="droidkufiregular">تأكيد كلمة المرور</label>
                                            <asp:TextBox ID="TxtPassRe" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>

                                        </div>
                                        <div class="field-set">
                                            <asp:LinkButton runat="server" ID="BtnUpdate" CssClass="btn btn-primary float-right droidkufiregular" OnClick="BtnUpdate_Click">تحديث</asp:LinkButton>

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
