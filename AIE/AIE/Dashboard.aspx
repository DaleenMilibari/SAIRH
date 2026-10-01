<%@ Page Title="Dashboard - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AIE.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Dashboard Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Dashboard
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
        </div>
    </section>

    <!-- Main Dashboard Tabs -->
    <section class="py-5" aria-label="Dashboard Tabs">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-4 mb-4">
                    <div class="nav flex-column dash-nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                        <a class="nav-link active" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home" role="tab" aria-controls="v-pills-home" aria-selected="true">
                            <i class="bi bi-house-door mr-2"></i> Home
                        </a>
                        <a class="nav-link" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false">
                            <i class="bi bi-person mr-2"></i> Profile
                        </a>
                        <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false">
                            <i class="bi bi-envelope mr-2"></i> Messages
                        </a>
                        <a class="nav-link" id="v-pills-settings-tab" data-toggle="pill" href="#v-pills-settings" role="tab" aria-controls="v-pills-settings" aria-selected="false">
                            <i class="bi bi-gear mr-2"></i> Settings
                        </a>
                    </div>
                </div>

                <div class="col-lg-9 col-md-8">
                    <div class="dash-content-card">
                        <div class="tab-content" id="v-pills-tabContent">
                            <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                <h3 class="text-white font-weight-bold mb-3">Home Overview</h3>
                                <p>Welcome to your summit dashboard. Access session agendas, track your registered workshops, and view live conference updates.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                                <h3 class="text-white font-weight-bold mb-3">Profile Information</h3>
                                <p>Manage your conference credentials, institutional affiliation, and specialty area in radiology and health innovation.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab">
                                <h3 class="text-white font-weight-bold mb-3">Notifications &amp; Messages</h3>
                                <p>Review official communications, program updates, and notifications regarding your summit participation.</p>
                            </div>
                            <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab">
                                <h3 class="text-white font-weight-bold mb-3">Account Settings</h3>
                                <p>Configure your notification preferences, privacy settings, and language choices.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
