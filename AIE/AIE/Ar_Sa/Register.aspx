<%@ Page Title="تسجيل حساب - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AIE.Ar_Sa.Register" %>

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
    <section class="py-5 simpler-main-bg" aria-label="تسجيل حساب جديد">
        <div class="container text-center pt-4 pb-2">
            <span class="glass-pill glass-pill-cyan mb-3">حساب المشاركين</span>
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
                        <div class="col-lg-8">
                            <div class="register-glass-card">
                                <div class="text-center mb-4 pb-3 border-bottom border-secondary">
                                    <h3 class="text-white font-weight-bold mb-2">بيانات التسجيل</h3>
                                    <p class="text-secondary mb-0">
                                        لديك حساب بالفعل؟ <a href="Login" class="text-info font-weight-bold">سجّل دخولك من هنا</a>.
                                    </p>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-user ml-1 text-info"></i> الاسم الكامل</label>
                                            <asp:TextBox ID="TxtFullName" runat="server" CssClass="form-control" placeholder="أدخل اسمك الكامل"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-phone ml-1 text-info"></i> رقم الجوال</label>
                                            <asp:TextBox ID="TxtMobile" runat="server" CssClass="form-control" placeholder="أدخل رقم الجوال"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-venus-mars ml-1 text-info"></i> الجنس</label>
                                            <asp:RadioButtonList ID="TxtGender" runat="server" CssClass="form-control radio-list" RepeatDirection="Horizontal" Height="40px">
                                                <asp:ListItem Value="Male">ذكر</asp:ListItem>
                                                <asp:ListItem Value="Female">أنثى</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-flag ml-1 text-info"></i> الجنسية</label>
                                            <dx:BootstrapComboBox ID="Nationality" runat="server" DataSourceID="ds_Countries" EnableTheming="true" CssClass="form-control"
                                                ValueField="CountryID" ValueType="System.String">
                                                <Fields>
                                                    <dx:BootstrapListBoxField FieldName="NationalityAr"></dx:BootstrapListBoxField>
                                                </Fields>
                                            </dx:BootstrapComboBox>
                                            <asp:SqlDataSource runat="server" ID="ds_Countries" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>' 
                                                SelectCommand="SELECT [CountryID], [NationalityAr], [PathLocation] FROM [qryCountries] ORDER BY [Sorting]"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-envelope ml-1 text-info"></i> البريد الإلكتروني</label>
                                            <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control" placeholder="name@domain.com"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa-brands fa-linkedin ml-1 text-info"></i> حساب LinkedIn</label>
                                            <asp:TextBox ID="TxtLinkedin" runat="server" CssClass="form-control" placeholder="https://linkedin.com/in/username"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-lock ml-1 text-info"></i> كلمة المرور</label>
                                            <asp:TextBox ID="TxtPassword" TextMode="Password" runat="server" CssClass="form-control" placeholder="أدخل كلمة المرور"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-4">
                                        <div class="form-group">
                                            <label class="text-secondary font-weight-semibold"><i class="fa fa-check-double ml-1 text-info"></i> تأكيد كلمة المرور</label>
                                            <asp:TextBox ID="TxtPasswordAgain" TextMode="Password" runat="server" CssClass="form-control" placeholder="تأكيد كلمة المرور"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-12 mt-2">
                                        <div class="d-flex justify-content-center">
                                            <asp:LinkButton ID="BtnRegister" runat="server" CssClass="cyan-glow-btn px-5 py-3 text-white font-weight-bold" OnClick="BtnRegister_Click">
                                                <i class="fa fa-user-plus ml-1"></i> تسجيل الحساب الآن
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
