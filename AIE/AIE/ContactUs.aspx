<%@ Page Title="Contact Us - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="AIE.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Contact Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Get in touch
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 800px; font-size: 1.2rem; line-height: 1.8;">
                For more information about Saudi First AI Summit in Radiology and Health Innovation, including details on participation, sponsorship opportunities, and general inquiries, please contact us:
            </p>
        </div>
    </section>

    <!-- 2-Column Contact Section -->
    <section class="py-5" aria-label="Contact Information and Form">
        <div class="container">
            <div class="row g-4 justify-content-center">
                <!-- Left Column: Contact Channels -->
                <div class="col-lg-5 mb-4 mb-lg-0">
                    <div class="contact-info-card">
                        <h3 class="text-white font-weight-bold mb-4" style="font-size: 1.35rem;">
                            Summit Coordination Office
                        </h3>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-envelope"></i></div>
                            <div>
                                <div class="contact-channel-label">Official Inquiries Email</div>
                                <div class="contact-channel-val"><a href="mailto:iie@iau.edu.sa">iie@iau.edu.sa</a></div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-twitter-x"></i></div>
                            <div>
                                <div class="contact-channel-label">X (Twitter) Official Handle</div>
                                <div class="contact-channel-val"><a href="https://twitter.com/IAU_VPSRI" target="_blank">@IAU_VPSRI</a></div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-geo-alt"></i></div>
                            <div>
                                <div class="contact-channel-label">Summit Location</div>
                                <div class="contact-channel-val">Grand Hyatt Alkhobar Hotel and Residences</div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-phone"></i></div>
                            <div>
                                <div class="contact-channel-label">Official Apps</div>
                                <div class="contact-channel-val">SRAS-IAU (iOS &amp; Android)</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Form -->
                <div class="col-lg-6">
                    <div class="contact-form-glass">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="contact_form">
                                    <div class="form-group">
                                        <label for="<%= TxtName.ClientID %>">Your Full Name</label>
                                        <asp:TextBox ID="TxtName" runat="server" CssClass="form-control" placeholder="e.g. Dr. Abdullah Al-Ghamdi"></asp:TextBox>
                                    </div>

                                    <div class="form-group">
                                        <label for="<%= TxtEmail.ClientID %>">Your Email Address</label>
                                        <asp:TextBox ID="TxtEmail" runat="server" CssClass="form-control" placeholder="name@institution.edu.sa"></asp:TextBox>
                                    </div>

                                    <div class="form-group">
                                        <label for="<%= TxtMobile.ClientID %>">Your Mobile Number</label>
                                        <asp:TextBox ID="TxtMobile" runat="server" CssClass="form-control" placeholder="+966 5X XXX XXXX"></asp:TextBox>
                                    </div>

                                    <div class="form-group">
                                        <label for="<%= TxtMessage.ClientID %>">Your Message</label>
                                        <asp:TextBox ID="TxtMessage" runat="server" CssClass="form-control" placeholder="How can we assist you regarding the summit?" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                    </div>

                                    <div id="submit" class="mt-4">
                                        <asp:LinkButton ID="BtnSubmit" runat="server" CssClass="cyan-glow-btn w-100 py-3" OnClick="BtnSubmit_Click">
                                            <i class="bi bi-send mr-2"></i> Submit Message
                                        </asp:LinkButton>
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

    <!-- Concluding Note -->
    <section class="py-5" aria-label="Closing Statement">
        <div class="container text-center">
            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="glass-card p-4" style="border-radius: 20px;">
                        <p class="text-light mb-0" style="font-size: 1.15rem; line-height: 1.8;">
                            We encourage all interested parties to reach out with questions or requests for further
                            information. We look forward to collaborating with you to make the Annual Innovation
                            Event a resounding success, empowering the next generation of innovators and
                            contributing to the sustainable future of Saudi Arabia’s economy.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
