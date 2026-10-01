<%@ Page Title="لوحة التحكم - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AIE.Ar_Sa.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="لوحة التحكم">
        <div class="container text-center pt-4 pb-2">
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
                            <i class="bi bi-house-door ml-2"></i> الرئيسية
                        </a>
                        <a class="nav-link" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false">
                            <i class="bi bi-person ml-2"></i> الملف الشخصي
                        </a>
                        <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false">
                            <i class="bi bi-envelope ml-2"></i> الرسائل والإشعارات
                        </a>
                        <a class="nav-link" id="v-pills-settings-tab" data-toggle="pill" href="#v-pills-settings" role="tab" aria-controls="v-pills-settings" aria-selected="false">
                            <i class="bi bi-gear ml-2"></i> الإعدادات
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
