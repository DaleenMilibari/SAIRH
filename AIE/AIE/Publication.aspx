<%@ Page Title="Conference Track Overview - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Publication.aspx.cs" Inherits="AIE.Publication" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Tracks Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Conference Track Overview
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            <p class="text-secondary mx-auto mt-4" style="max-width: 750px; font-size: 1.15rem; line-height: 1.8;">
                Explore the three specialized summit tracks uniting artificial intelligence pioneers, clinical imaging specialists, and healthcare education leaders.
            </p>
        </div>
    </section>

    <!-- 3 Tracks Interactive Deck -->
    <section class="py-5" aria-label="Track Cards">
        <div class="container">
            <div class="track-deck-grid">
                <!-- Track A -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-a">Track A</span>
                        <h2 class="track-deck-title">
                            Artificial Intelligence, Digital Technology Transformation &amp; RadBix
                        </h2>
                        <p class="track-deck-desc">
                            Focus on AI in imaging, data ecosystems, RadBix, workflow automation, cybersecurity, and national AI frameworks.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">AI in Imaging</span>
                            <span class="modality-chip">Data Ecosystems</span>
                            <span class="modality-chip">RadBix Platform</span>
                            <span class="modality-chip">Workflow Automation</span>
                            <span class="modality-chip">Cybersecurity</span>
                            <span class="modality-chip">National AI Frameworks</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=A" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            View Track A Program <i class="bi bi-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Track B -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-b">Track B</span>
                        <h2 class="track-deck-title">
                            Advanced Clinical Radiology
                        </h2>
                        <p class="track-deck-desc">
                            MRI, CT, Ultrasound, X-Ray, IVR, NM, Mammography updated to 2026 standards.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">MRI (2026 Standards)</span>
                            <span class="modality-chip">CT Imaging</span>
                            <span class="modality-chip">Ultrasound</span>
                            <span class="modality-chip">X-Ray</span>
                            <span class="modality-chip">Interventional Radiology (IVR)</span>
                            <span class="modality-chip">Nuclear Medicine (NM)</span>
                            <span class="modality-chip">Mammography</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=B" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            View Track B Program <i class="bi bi-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Track C -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-c">Track C</span>
                        <h2 class="track-deck-title">
                            Education, Quality, Research &amp; Innovation
                        </h2>
                        <p class="track-deck-desc">
                            Research methods, publishing, quality standards, simulation-based training, and innovation labs.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">Research Methods</span>
                            <span class="modality-chip">High-Impact Publishing</span>
                            <span class="modality-chip">Quality Standards</span>
                            <span class="modality-chip">Simulation-Based Training</span>
                            <span class="modality-chip">Innovation Labs</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=C" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            View Track C Program <i class="bi bi-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
