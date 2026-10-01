<%@ Page Title="Summit Partners - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Sponsors.aspx.cs" Inherits="AIE.Sponsors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Partners Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Summit Partners
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 850px; font-size: 1.2rem; line-height: 1.8;">
                The Summit aims to establish strategic alliances with national authorities, innovation hubs, academic institutions, and leading industry partners to ensure scientific excellence, regulatory alignment, and sustainable impact.
            </p>
        </div>
    </section>

    <!-- Partners Blocks -->
    <section class="py-5" aria-label="Partner Ecosystem">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <!-- 1. National Authorities -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">CATEGORY 1</span>
                            National Authorities &amp; Government Partners
                        </h2>
                        <ul class="partner-entity-list">
                            <li>Research, Development and Innovation Authority (RDIA)</li>
                            <li>Digital Government Authority (DGA)</li>
                            <li>Virtual Health Hospital (VHH)</li>
                            <li>Saudi National Cybersecurity Authority</li>
                            <li>Saudi Standards, Metrology and Quality Organization (SASO)</li>
                            <li>Saudi Food and Drug Authority (SFDA)</li>
                            <li>Nuclear and Radiological Regulatory Commission (NRRC)</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners77.png") %>" alt="RDIA"><span class="logo-label">RDIA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners1.jpeg") %>" alt="DGA"><span class="logo-label">DGA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners6.jpeg") %>" alt="Aramco Digital"><span class="logo-label">Aramco Digital</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner20.jpeg") %>" alt="Ministry of Health"><span class="logo-label">MOH</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners9.png") %>" alt="Cybersecurity"><span class="logo-label">Cybersecurity</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners8.png") %>" alt="SASO"><span class="logo-label">SASO</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners12.jpeg") %>" alt="SFDA"><span class="logo-label">SFDA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners14.jpeg") %>" alt="NRRC"><span class="logo-label">NRRC</span></div>
                        </div>
                    </div>

                    <!-- 2. National Innovation -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">CATEGORY 2</span>
                            National Innovation &amp; Technology Ecosystem
                        </h2>
                        <ul class="partner-entity-list">
                            <li>Dhahran Techno Valley</li>
                            <li>King Abdulaziz City for Science and Technology (KACST)</li>
                            <li>AlSharqi Chamber</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners11.png") %>" alt="Dhahran Techno Valley"><span class="logo-label">Dhahran Techno Valley</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners13.png") %>" alt="KACST"><span class="logo-label">KACST</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners.jpeg") %>" alt="AlSharqi Chamber"><span class="logo-label">AlSharqi Chamber</span></div>
                        </div>
                    </div>

                    <!-- 3. Academic -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">CATEGORY 3</span>
                            Academic &amp; Research Institutions
                        </h2>
                        <ul class="partner-entity-list">
                            <li>King Fahd University of Petroleum and Minerals (KFUPM)</li>
                            <li>University Research Centers &amp; Colleges</li>
                            <li>Colleges of Computer Science</li>
                            <li>Colleges of Engineering</li>
                            <li>Colleges of Medical Sciences</li>
                            <li>Colleges of Medicine</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners5.png") %>" alt="KFUPM"><span class="logo-label">KFUPM</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners10.png") %>" alt="SDAIA"><span class="logo-label">SDAIA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/PARTNER21.jpeg") %>" alt="IAU"><span class="logo-label">IAU</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners4.png") %>" alt="Quality Program"><span class="logo-label">Quality Program</span></div>
                        </div>
                    </div>

                    <!-- 4. Industry -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">CATEGORY 4</span>
                            Industry &amp; Medical Technology Partners
                        </h2>
                        <ul class="partner-entity-list">
                            <li>GE Healthcare</li>
                            <li>Philips Healthcare</li>
                            <li>Siemens Healthineers</li>
                            <li>Medical Device &amp; Imaging Technology Companies</li>
                            <li>AI &amp; Digital Health Solution Providers</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner18.png") %>" alt="GE Healthcare"><span class="logo-label">GE Healthcare</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/5.-Philips-Healthcare.png") %>" alt="Philips Healthcare"><span class="logo-label">Philips Healthcare</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner17.png") %>" alt="Siemens Healthineers"><span class="logo-label">Siemens Healthineers</span></div>
                        </div>
                    </div>

                    <!-- Role of Strategic Alliances -->
                    <div class="alliances-ribbon">
                        <h3 class="text-white font-weight-bold mb-2">Role of Strategic Alliances</h3>
                        <p class="text-secondary mb-4" style="font-size: 1.1rem;">These alliances will support the Summit through:</p>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-radioactive"></i></div>
                            <span>Scientific collaboration and content contribution.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-shield-check"></i></div>
                            <span>Policy and regulatory alignment.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-display"></i></div>
                            <span>Technology showcases and live demonstrations.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-rocket-takeoff"></i></div>
                            <span>Innovation and startup engagement.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-award"></i></div>
                            <span>Research partnerships and future initiatives.</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
