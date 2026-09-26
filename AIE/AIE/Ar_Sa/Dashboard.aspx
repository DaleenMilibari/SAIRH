<%@ Page Title="لوحة التحكم - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AIE.Ar_Sa.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dash-nav-pills .nav-link {
            background: rgba(14, 28, 66, 0.45);
            border: 1px solid rgba(56, 189, 248, 0.16);
            border-radius: 12px;
            color: #cbd5e1;
            padding: 14px 20px;
            margin-bottom: 12px;
            font-weight: 600;
            transition: all 0.25s ease;
        }
        .dash-nav-pills .nav-link:hover {
            background: rgba(14, 28, 66, 0.7);
            border-color: rgba(56, 189, 248, 0.35);
            color: #ffffff;
        }
        .dash-nav-pills .nav-link.active {
            background: linear-gradient(135deg, rgba(2, 132, 199, 0.4), rgba(37, 99, 235, 0.4)) !important;
            border-color: #38bdf8 !important;
            color: #ffffff !important;
            box-shadow: 0 0 20px rgba(56, 189, 248, 0.25);
        }
        .dash-content-card {
            background: rgba(14, 28, 66, 0.5);
            border: 1px solid rgba(56, 189, 248, 0.18);
            border-radius: 18px;
            padding: 35px;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            color: #e2e8f0;
            font-size: 1.05rem;
            line-height: 1.8;
            min-height: 380px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="لوحة التحكم">
        <div class="container text-center pt-4 pb-2">
            <span class="glass-pill glass-pill-cyan mb-3">بوابة المشاركين</span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                لوحة التحكم
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Dashboard Tabs -->
    <section class="py-5" aria-label="أقسام لوحة التحكم">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-4 mb-4">
                    <div class="nav flex-column dash-nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <a class="nav-link active" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home" role="tab" aria-controls="v-pills-home" aria-selected="true">
                            <i class="fa fa-home ml-2"></i> الرئيسية
                        </a>
                        <a class="nav-link" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false">
                            <i class="fa fa-user ml-2"></i> الملف الشخصي
                        </a>
                        <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false">
                            <i class="fa fa-envelope ml-2"></i> الرسائل والإشعارات
                        </a>
                        <a class="nav-link" id="v-pills-settings-tab" data-toggle="pill" href="#v-pills-settings" role="tab" aria-controls="v-pills-settings" aria-selected="false">
                            <i class="fa fa-cog ml-2"></i> الإعدادات
                        </a>
                    </div>
                </div>

                <div class="col-lg-9 col-md-8">
                    <div class="dash-content-card">
                        <div class="tab-content" id="v-pills-tabContent">
                            <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                <h3 class="text-white font-weight-bold mb-3">نظرة عامة على لوحة التحكم</h3>
                                <p>مرحباً بك في لوحة تحكم المشاركين بالقمة السعودية للذكاء الاصطناعي في الأشعة. يمكنك متابعة جدول الجلسات، واستعراض الورش المسجلة، والاطلاع على التحديثات الحية للمؤتمر.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                                <h3 class="text-white font-weight-bold mb-3">بيانات الحساب والاعتماد</h3>
                                <p>إدارة بيانات الاعتماد الخاصة بالمؤتمر، والانتماء المؤسسي، والتخصص العلمي في مجال الأشعة والابتكار الصحي.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab">
                                <h3 class="text-white font-weight-bold mb-3">الإشعارات والتعميمات</h3>
                                <p>استعراض الإشعارات الرسمية، وتحديثات جدول الأعمال، والتنبيهات الخاصة بمشاركتك في القمة.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab">
                                <h3 class="text-white font-weight-bold mb-3">إعدادات الحساب واللغة</h3>
                                <p>تخصيص تفضيلات الإشعارات، وإعدادات الخصوصية، واللغة المفضلة للتواصل.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
