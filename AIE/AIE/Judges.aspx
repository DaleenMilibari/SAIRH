<%@ Page Title="Speakers & Faculty - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Judges.aspx.cs" Inherits="AIE.Judges" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .speakers-modal-meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin: 20px 0;
        }
        .speakers-modal-meta-item {
            background: rgba(4, 8, 22, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px 16px;
        }
        .speakers-modal-meta-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--lg-cyan);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
        }
        .speakers-modal-meta-val {
            font-size: 0.92rem;
            color: #ffffff;
            font-weight: 600;
            margin: 0;
        }

        /* Enforce 3 cards per row on desktop */
        .speakers-grid {
            display: grid !important;
            grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
            gap: 28px !important;
            margin-bottom: 50px !important;
        }
        @media (max-width: 991px) {
            .speakers-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
                gap: 24px !important;
            }
        }
        @media (max-width: 640px) {
            .speakers-grid {
                grid-template-columns: 1fr !important;
                gap: 20px !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Speakers Header">
        <div class="container text-center pt-4 pb-2">
            <span class="speakers-hero-badge">
                <i class="bi bi-people-fill"></i> World-Class Faculty &amp; Industry Leaders
            </span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Summit Speakers
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            <p class="text-secondary mx-auto mt-4" style="max-width: 780px; font-size: 1.15rem; line-height: 1.8;">
                Meet the leading clinical radiologists, artificial intelligence pioneers, and healthcare innovators delivering keynotes and scientific presentations across our three summit tracks.
            </p>
        </div>
    </section>

    <!-- Main Content & Filters -->
    <section class="py-5" aria-label="Speakers Directory">
        <div class="container">
            <!-- Filter Toolbar -->
            <div class="speakers-filter-container">
                <!-- Search Bar First -->
                <div class="speakers-search-box">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" id="speakerSearch" class="speakers-search-input" placeholder="Search by speaker name, role, institution, or lecture topic..." aria-label="Search speakers" />
                    <button type="button" id="clearSearchBtn" class="speakers-search-clear" aria-label="Clear search">&times;</button>
                </div>

                <!-- Track Filters Below It -->
                <div class="speakers-track-tabs" role="tablist" aria-label="Filter by Track">
                    <button type="button" class="track-tab-btn active" data-track="all">
                        <i class="bi bi-grid-fill"></i> All Tracks <span class="tab-count">30</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-a">
                        <i class="bi bi-cpu"></i> Track A: AI &amp; Transformation <span class="tab-count">10</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-b">
                        <i class="bi bi-activity"></i> Track B: Advanced Radiology <span class="tab-count">13</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-c">
                        <i class="bi bi-lightbulb"></i> Track C: Health Innovation <span class="tab-count">7</span>
                    </button>
                </div>

                <!-- Status & Reset Bar -->
                <div class="speakers-status-bar">
                    <div>
                        Showing <strong id="speakersCount" class="text-white">30</strong> of 30 Speakers
                    </div>
                    <div>
                        <button type="button" id="btnResetFilters" class="btn-reset-filters" style="display:none;">
                            <i class="bi bi-arrow-counterclockwise"></i> Reset Filters
                        </button>
                    </div>
                </div>
            </div>

            <!-- Speakers Grid -->
            <div id="speakersGrid" class="speakers-grid">

                <!-- ========================================== -->
                <!-- TRACK A: AI & Digital Technology Transformation (10) -->
                <!-- ========================================== -->

                <!-- 1. Dr. Fahad Almsned -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Fahad-Almsned-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Fahad-Almsned-CV.pdf"
                         data-track="track-a"
                         data-sector="clinical"
                         data-region="national"
                         data-name="Dr. Fahad Almsned"
                         data-role="Director of Research Operations"
                         data-org="King Fahad Specialist Hospital - Dammam"
                         data-lecture="THE FUTURE OF DATA-DRIVEN MEDICINE IS BEING WRITTEN TODAY &mdash; Moving from 'AI Hype' to 'Integrated Clinical Reality'"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Hospitals &amp; Healthcare"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="FA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> Clinical
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fahad-Almsned-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">FA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Fahad Almsned</h3>
                        <p class="speaker-title">Director of Research Operations</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>King Fahad Specialist Hospital - Dammam</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                &ldquo;THE FUTURE OF DATA-DRIVEN MEDICINE IS BEING WRITTEN TODAY&rdquo; &mdash; Moving from &lsquo;AI Hype&rsquo; to &lsquo;Integrated Clinical Reality&rsquo;
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 2. Dr. Eman Alshehri -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Eman-Alshehri-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Eman Alshehri"
                         data-role="Assistant Professor, Computer Department"
                         data-org="Imam Abdulrahman Bin Faisal University"
                         data-lecture="Artificial Intelligence in Medical Imaging: From Data-Driven Insights to Clinical Impact"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="EA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">EA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Eman Alshehri</h3>
                        <p class="speaker-title">Assistant Professor, Computer Department</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Imam Abdulrahman Bin Faisal University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Artificial Intelligence in Medical Imaging: From Data-Driven Insights to Clinical Impact
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 3. Ms. Fadwa AlBawardi Msc -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg"
                         data-cv="/Content/docs/speakers/Fadwa-AlBawardi-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="Ms. Fadwa AlBawardi, MSc"
                         data-role="Founder and CEO"
                         data-org="FSAB Consulting"
                         data-lecture="AI vs. The Human Eye: Spotting Hidden Fractures"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Industry &amp; HealthTech"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="FB">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> Industry
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">FB</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Ms. Fadwa AlBawardi, MSc</h3>
                        <p class="speaker-title">Founder and CEO</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>FSAB Consulting</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                AI vs. The Human Eye: Spotting Hidden Fractures
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 4. Dr. Aseel Aldawood -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Aseel-Addawood-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="Dr. Aseel Aldawood"
                         data-role="KSA Leader, EMEA AI Center of Excellence"
                         data-org="EMEA AI Center of Excellence"
                         data-lecture="From AI Pilots to Clinical Impact"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Industry &amp; HealthTech"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> Industry
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Aseel Aldawood</h3>
                        <p class="speaker-title">KSA Leader, EMEA AI Center of Excellence</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>EMEA AI Center of Excellence</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                From AI Pilots to Clinical Impact
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 5. Dr. Mostafa Youldash -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Mustafa-Yoldash-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Mostafa Youldash"
                         data-role="Assistant Professor &amp; Department Chairperson (Computer Engineering)"
                         data-org="Imam Abdulrahman Bin Faisal University, Dammam"
                         data-lecture="Transforming Radiology with AI and Agentic AI"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="MY">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MY</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Mostafa Youldash</h3>
                        <p class="speaker-title">Assistant Professor &amp; Department Chairperson</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Imam Abdulrahman Bin Faisal University, Dammam</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Transforming Radiology with AI and Agentic AI
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 6. Mr. Yazeed Alsudays MBA -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Yazeed-Alsudays-Photo.jpg"
                         data-cv="/Content/docs/speakers/Yazeed-Alsudays-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="Mr. Yazeed Alsudays, MBA"
                         data-role="Strategic Account Manager"
                         data-org="Solventum"
                         data-lecture="Practical Use of AI in Dental Panoramic Imaging"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Industry &amp; HealthTech"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="YA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> Industry
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Yazeed-Alsudays-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">YA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Mr. Yazeed Alsudays, MBA</h3>
                        <p class="speaker-title">Strategic Account Manager</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Solventum</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Practical Use of AI in Dental Panoramic Imaging
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 7. Dr. Abeer Alalmaie -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Abeer-Alalmaie-Photo.png"
                         data-cv="/Content/docs/speakers/Abeer-Alalmaie-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Abeer Alalmaie"
                         data-role="Advisor to the President of King Khalid University for IP Commercialization"
                         data-org="King Khalid University"
                         data-lecture="Integrating Neuro-AI for Brain and Behaviour Analysis"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abeer-Alalmaie-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Abeer Alalmaie</h3>
                        <p class="speaker-title">Advisor to the President for IP Commercialization</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>King Khalid University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Integrating Neuro-AI for Brain and Behaviour Analysis
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 8. Dr. Clare Rainey -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Clare-Rainey-Photo.jpg.png"
                         data-cv="/Content/docs/speakers/Clare-Rainey-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Clare Rainey"
                         data-role="Lecturer in Medical Imaging and Radiation Therapy"
                         data-org="University College Cork, Ireland"
                         data-lecture="Human-Computer Collaboration and Ethical AI Principles"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Ireland"
                         data-flag="🇮🇪"
                         data-initials="CR">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Clare-Rainey-Photo.jpg.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">CR</div>
                        <span class="speaker-badge-flag" title="Ireland">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Clare Rainey</h3>
                        <p class="speaker-title">Lecturer in Medical Imaging &amp; Radiation Therapy</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University College Cork, Ireland</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Human-Computer Collaboration and Ethical AI Principles
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 9. Dr. Rebecca Vaz -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Rebeca-Queiroz-Photo.JPG"
                         data-cv="/Content/docs/speakers/Rebeca-Queiroz-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="international"
                         data-name="Dr. Rebecca Vaz"
                         data-role="Clinical Research Officer"
                         data-org="Voithy"
                         data-lecture="Convolutional Neural Networks as a Tool for Oral Cancer Diagnosis"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Industry &amp; HealthTech"
                         data-region-name="International"
                         data-flag="🌐"
                         data-initials="RV">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> Industry
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Rebeca-Queiroz-Photo.JPG" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">RV</div>
                        <span class="speaker-badge-flag" title="International">🌐</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Rebecca Vaz</h3>
                        <p class="speaker-title">Clinical Research Officer</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Voithy</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Convolutional Neural Networks as a Tool for Oral Cancer Diagnosis
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 10. Moath Ameer -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="Moath Ameer"
                         data-role="Medical Student &amp; AI Innovator"
                         data-org="Imam Abdulrahman Bin Faisal University (IAU)"
                         data-lecture="Student Innovations in AI"
                         data-track-name="Track A &ndash; AI &amp; Digital Technology Transformation"
                         data-sector-name="Academic &amp; Student Innovators"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="MA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> Track A
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-stars"></i> Innovator
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Moath Ameer</h3>
                        <p class="speaker-title">Medical Student &amp; AI Innovator</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>IAU College of Medicine</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Student Innovations in AI
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- ========================================== -->
                <!-- TRACK B: Advanced Clinical Radiology (13) -->
                <!-- ========================================== -->

                <!-- 11. Dr. Amna Kashgari -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Amna-Kashgari-Photo.jpg"
                         data-cv="/Content/docs/speakers/Amna-Kashgari-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="Dr. Amna Kashgari"
                         data-role="Head of Radiology AI Transformation, Medical Imaging Department"
                         data-org="King Abdulaziz Medical City (MNGHA)"
                         data-lecture="Radiology AI Adaptations: From Dependency to Empowerment"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Hospitals &amp; Healthcare"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AK">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> Clinical
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Amna-Kashgari-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AK</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Amna Kashgari</h3>
                        <p class="speaker-title">Head of Radiology AI Transformation</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>King Abdulaziz Medical City (MNGHA)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Radiology AI Adaptations: From Dependency to Empowerment
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 12. Prof. Karen Knapp -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Karen-Knapp-Photo.jpg"
                         data-cv="/Content/docs/speakers/Karen-Knapp-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="Prof. Karen Knapp"
                         data-role="Professor of Musculoskeletal Imaging, Head of Health &amp; Care Professions"
                         data-org="University of Exeter, United Kingdom"
                         data-lecture="Clinical Risk Factors for Fracture Prediction"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="United Kingdom"
                         data-flag="🇬🇧"
                         data-initials="KK">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Karen-Knapp-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">KK</div>
                        <span class="speaker-badge-flag" title="United Kingdom">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Prof. Karen Knapp</h3>
                        <p class="speaker-title">Professor of Musculoskeletal Imaging</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University of Exeter, UK</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Clinical Risk Factors for Fracture Prediction
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 13. Dr. Mohammed Asiri -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Mohammed-Asiri-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mohammed-Asiri-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Mohammed Asiri"
                         data-role="Assistant Professor"
                         data-org="Taif University"
                         data-lecture="Advanced Ultrasound Applications in Bone Health Assessment"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="MA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mohammed-Asiri-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Mohammed Asiri</h3>
                        <p class="speaker-title">Assistant Professor</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Taif University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Advanced Ultrasound Applications in Bone Health Assessment
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 14. Dr. Yasser Hadi -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Yasser-Hadi-Photo.JPG"
                         data-cv="/Content/docs/speakers/Yasser-Hadi.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="Dr. Yasser Hadi"
                         data-role="Senior CT Technologist"
                         data-org="King Abdullah Medical City (KAMC)"
                         data-lecture="Positioning in CT: Is Automation Likely to be Helpful?"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Hospitals &amp; Healthcare"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="YH">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> Clinical
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Yasser-Hadi-Photo.JPG" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">YH</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Yasser Hadi</h3>
                        <p class="speaker-title">Senior CT Technologist</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>King Abdullah Medical City (KAMC)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Positioning in CT: Is Automation Likely to be Helpful?
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 15. Dr. Abdulkarem Alqahtani -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Abdulkareem-Alqahtani-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Abdulkarem Alqahtani"
                         data-role="Lecturer in Medical Ultrasound"
                         data-org="Taibah University"
                         data-lecture="The Future of AI-Driven Ultrasound"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Abdulkarem Alqahtani</h3>
                        <p class="speaker-title">Lecturer in Medical Ultrasound</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Taibah University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                The Future of AI-Driven Ultrasound
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 16. Dr. Abdulaziz Almulhim -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Abdulaziz-Almulhim-Photo.png"
                         data-cv="/Content/docs/speakers/Abdulaziz-AlMulhim-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="Dr. Abdulaziz Almulhim"
                         data-role="Vascular &amp; Interventional Radiology Consultant"
                         data-org="Eastern Province &ndash; Alahsa Health Cluster"
                         data-lecture="The Smart Angio Suite with AI for Interventional Radiologists"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Hospitals &amp; Healthcare"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> Clinical
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abdulaziz-Almulhim-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Abdulaziz Almulhim</h3>
                        <p class="speaker-title">Vascular &amp; Interventional Radiology Consultant</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Eastern Province &ndash; Alahsa Health Cluster</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                The Smart Angio Suite with AI for Interventional Radiologists
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 17. Dr. Sonyia McFadden -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Sonyia-McFadden-Photo.jpg"
                         data-cv="/Content/docs/speakers/Sonyia-McFadden-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Sonyia McFadden"
                         data-role="Senior Lecturer (Diagnostic Imaging)"
                         data-org="Ulster University, United Kingdom"
                         data-lecture="AI in the lung cancer pathway: a cross sectional survey and interview study"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="United Kingdom"
                         data-flag="🇬🇧"
                         data-initials="SM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Sonyia-McFadden-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">SM</div>
                        <span class="speaker-badge-flag" title="United Kingdom">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Sonyia McFadden</h3>
                        <p class="speaker-title">Senior Lecturer (Diagnostic Imaging)</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Ulster University, UK</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                AI in the lung cancer pathway: a cross sectional survey and interview study
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 18. Dr. Raid Alshinibr -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Raid-Alshinibr-Photo.png"
                         data-cv="/Content/docs/speakers/Raid-Alshinibr-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="Dr. Raid Alshinibr"
                         data-role="Head of Radiology"
                         data-org="Care Medical Group - AlSalam Hospital"
                         data-lecture="Beyond Automation: Integrating AI into Clinical Radiology Workflows"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Hospitals &amp; Healthcare"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="RA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> Clinical
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Raid-Alshinibr-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">RA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Raid Alshinibr</h3>
                        <p class="speaker-title">Head of Radiology</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Care Medical Group - AlSalam Hospital</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Beyond Automation: Integrating AI into Clinical Radiology Workflows
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 19. Prof. Minyar Sassi -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Minyar-Hidr-Photo.jpg"
                         data-cv="/Content/docs/speakers/Minyar-Hidr-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="Prof. Minyar Sassi"
                         data-role="Full Professor in Computer Science, National Engineering School of Tunis"
                         data-org="Tunis El Manar University, Tunisia"
                         data-lecture="AI Ethics, Bias, and Governance in Radiology AI"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Tunisia"
                         data-flag="🇹🇳"
                         data-initials="MS">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Minyar-Hidr-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MS</div>
                        <span class="speaker-badge-flag" title="Tunisia">🇹🇳</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Prof. Minyar Sassi</h3>
                        <p class="speaker-title">Full Professor in Computer Science</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Tunis El Manar University, Tunisia</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                AI Ethics, Bias, and Governance in Radiology AI
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 20. Dr. Abdul Razak Hairil -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg"
                         data-cv="/Content/docs/speakers/Hairil-AbdulRazak-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Abdul Razak Hairil"
                         data-role="Senior Lecturer, Medical Imaging"
                         data-org="University of Exeter, United Kingdom"
                         data-lecture="The Role of FDG PET/CT Imaging in Detecting Air-Borne Diseases"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="United Kingdom"
                         data-flag="🇬🇧"
                         data-initials="AH">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AH</div>
                        <span class="speaker-badge-flag" title="United Kingdom">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Abdul Razak Hairil</h3>
                        <p class="speaker-title">Senior Lecturer, Medical Imaging</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University of Exeter, UK</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                The Role of FDG PET/CT Imaging in Detecting Air-Borne Diseases
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 21. Dr. Abdulaziz M. Al-Sharydah -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Abdulaziz M. Al-Sharydah"
                         data-role="Associate Professor &amp; Chairman of Radiology Department"
                         data-org="Imam Abdulrahman Bin Faisal University"
                         data-lecture="Current State and Future of Artificial Intelligence in Pediatric Interventional Radiology: A Narrative Review"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Abdulaziz M. Al-Sharydah</h3>
                        <p class="speaker-title">Associate Professor &amp; Chairman of Radiology</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Imam Abdulrahman Bin Faisal University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Current State and Future of Artificial Intelligence in Pediatric Interventional Radiology: A Narrative Review
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 22. Dr. Mohammed Alsaadi -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Mohammed-Saadi-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mohammed-Saadi-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Mohammed Alsaadi"
                         data-role="Associate Professor in Radiology and Medical Imaging"
                         data-org="Prince Sattam bin Abdulaziz University"
                         data-lecture="Updates in Emergency Ultrasound"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="MA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mohammed-Saadi-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Mohammed Alsaadi</h3>
                        <p class="speaker-title">Associate Professor in Radiology</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Prince Sattam bin Abdulaziz University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Updates in Emergency Ultrasound
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 23. Dr. Oun Al-iedani -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Oun-Aliedani-Photo.jpg"
                         data-cv="/Content/docs/speakers/Oun-Aliedani-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Oun Al-iedani"
                         data-role="Postdoctoral Researcher, MS Fellow, School of Biomedical Sciences &amp; Pharmacy"
                         data-org="University of Newcastle, Australia"
                         data-lecture="Multi-Modal MRI Post-Processing Method for AI-Driven Prediction of Multiple Sclerosis Progression: A Translational Imaging Framework"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Australia"
                         data-flag="🇦🇺"
                         data-initials="OA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Oun-Aliedani-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">OA</div>
                        <span class="speaker-badge-flag" title="Australia">🇦🇺</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Oun Al-iedani</h3>
                        <p class="speaker-title">Postdoctoral Researcher &amp; MS Fellow</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University of Newcastle, Australia</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Multi-Modal MRI Post-Processing Method for AI-Driven Prediction of Multiple Sclerosis Progression
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 23b. Dr. Hussain Alarfaj -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Hussain-Alarfaj-Photo.jpg"
                         data-cv="/Content/docs/speakers/Hussain-Alarfaj-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Hussain Alarfaj"
                         data-role="Consultant Clinical Radiologist"
                         data-org="Imam Abdulrahman Bin Faisal University"
                         data-lecture="Advances in Clinical Radiology and AI Integration"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="HA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Hussain-Alarfaj-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">HA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Hussain Alarfaj</h3>
                        <p class="speaker-title">Consultant Clinical Radiologist</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Imam Abdulrahman Bin Faisal University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Advances in Clinical Radiology and AI Integration
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 23c. Dr. Qurain Alqurain -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Qurain-Alqurain-Photo.png"
                         data-cv="/Content/docs/speakers/Qurain-Alqurain-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Qurain Alqurain"
                         data-role="Consultant Radiologist"
                         data-org="Imam Abdulrahman Bin Faisal University"
                         data-lecture="AI Diagnostic Precision in Modern Radiology"
                         data-track-name="Track B &ndash; Advanced Clinical Radiology"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="QA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> Track B
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Qurain-Alqurain-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">QA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Qurain Alqurain</h3>
                        <p class="speaker-title">Consultant Radiologist</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Imam Abdulrahman Bin Faisal University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                AI Diagnostic Precision in Modern Radiology
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- ========================================== -->
                <!-- TRACK C: Health Innovation (7) -->
                <!-- ========================================== -->

                <!-- 24. Dr. Amal Alsalamah -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Amal-Alsalamah-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Amal-Alsalamah-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Amal Alsalamah"
                         data-role="Head of Radiological Sciences Program"
                         data-org="Batterjee Medical College"
                         data-lecture="Evaluation of the Face Validity of a Smart MRI Simulator"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Amal-Alsalamah-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Amal Alsalamah</h3>
                        <p class="speaker-title">Head of Radiological Sciences Program</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Batterjee Medical College</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Evaluation of the Face Validity of a Smart MRI Simulator
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 25. Dr. Rasha Alafaleg -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Rasha-Alafaleg-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Rasha Alafaleg"
                         data-role="Assistant Professor of Dental Education &amp; Basic Oral Medical Science"
                         data-org="University of Qassim"
                         data-lecture="The Role of AI in Dental Imaging in Education"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="RA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">RA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Rasha Alafaleg</h3>
                        <p class="speaker-title">Assistant Professor of Dental Education</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University of Qassim</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                The Role of AI in Dental Imaging in Education
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 26. Dr. Ali Alhailiy -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Ali-Alhaili-Photo.jpg"
                         data-cv="/Content/docs/speakers/Ali-Alhailiy-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="Dr. Ali Alhailiy"
                         data-role="Head of Radiology and Medical Imaging Department"
                         data-org="Prince Sattam Bin AbdulAziz University"
                         data-lecture="Functional and Radiomic Biomarkers in Virtual Colonoscopy"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="AA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> Academic
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Ali-Alhaili-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Ali Alhailiy</h3>
                        <p class="speaker-title">Head of Radiology and Medical Imaging Department</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Prince Sattam Bin AbdulAziz University</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Functional and Radiomic Biomarkers in Virtual Colonoscopy
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 27. Mr. Fahad Alsadan, MSc -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Fahad-Alsadan-Photo.jpg"
                         data-cv="/Content/docs/speakers/Fahad-Alsadan-CV.pdf"
                         data-track="track-c"
                         data-sector="industry"
                         data-region="national"
                         data-name="Mr. Fahad Alsadan, MSc"
                         data-role="Innovation &amp; Scientific Partnership, Innovation Center Manager"
                         data-org="Siemens Healthineers"
                         data-lecture="Barriers and Opportunities in Scaling Innovation in Saudi Arabia"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Industry &amp; HealthTech"
                         data-region-name="Saudi Arabia"
                         data-flag="🇸🇦"
                         data-initials="FA">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> Industry
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fahad-Alsadan-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">FA</div>
                        <span class="speaker-badge-flag" title="Saudi Arabia">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Mr. Fahad Alsadan, MSc</h3>
                        <p class="speaker-title">Innovation Center Manager</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Siemens Healthineers</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Barriers and Opportunities in Scaling Innovation in Saudi Arabia
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 28. Prof. Mark McEntee -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Mark-McEntee-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mark-McEntee-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="Prof. Mark McEntee"
                         data-role="Vice Head of Learning and Teaching, UCC College of Medicine and Health"
                         data-org="University College Cork (UCC), Ireland"
                         data-lecture="AI and the Future Challenges for Medical Imaging Education"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Ireland"
                         data-flag="🇮🇪"
                         data-initials="MM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mark-McEntee-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MM</div>
                        <span class="speaker-badge-flag" title="Ireland">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Prof. Mark McEntee</h3>
                        <p class="speaker-title">Vice Head of Learning &amp; Teaching</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University College Cork (UCC), Ireland</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                AI and the Future Challenges for Medical Imaging Education
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 29. Dr. Laura McLaughlin -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Laura-McLaughlin-Photo.jpg"
                         data-cv="/Content/docs/speakers/Laura-McLaughlin-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Laura McLaughlin"
                         data-role="Lecturer in Diagnostic Radiography and Imaging"
                         data-org="Ulster University, United Kingdom"
                         data-lecture="Research AI and MRI Tools for Image Interpretation"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="United Kingdom"
                         data-flag="🇬🇧"
                         data-initials="LM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Laura-McLaughlin-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">LM</div>
                        <span class="speaker-badge-flag" title="United Kingdom">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Laura McLaughlin</h3>
                        <p class="speaker-title">Lecturer in Diagnostic Radiography &amp; Imaging</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>Ulster University, UK</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Research AI and MRI Tools for Image Interpretation
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

                <!-- 30. Dr. Andrew England -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Andrew-England-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="Dr. Andrew England"
                         data-role="Senior Lecturer in Medical Imaging / Radiation Therapy"
                         data-org="University College Cork, Ireland"
                         data-lecture="Grant Writing, Publishing &amp; Research Innovation"
                         data-track-name="Track C &ndash; Health Innovation"
                         data-sector-name="Academic &amp; Universities"
                         data-region-name="Ireland"
                         data-flag="🇮🇪"
                         data-initials="AE">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> Track C
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> International
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AE</div>
                        <span class="speaker-badge-flag" title="Ireland">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">Dr. Andrew England</h3>
                        <p class="speaker-title">Senior Lecturer in Medical Imaging</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>University College Cork, Ireland</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> Lecture Presentation
                            </div>
                            <p class="speaker-lecture-title">
                                Grant Writing, Publishing &amp; Research Innovation
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> Quick Overview
                        </button>
                    </div>
                </article>

            </div>

            <!-- Empty Search State -->
            <div id="speakersEmptyState" class="speakers-empty-state">
                <i class="bi bi-search speakers-empty-icon"></i>
                <h3 class="text-white font-weight-bold mb-2">No Speakers Found</h3>
                <p class="text-secondary mx-auto mb-4" style="max-width: 500px;">
                    We couldn't find any speakers matching your current search or filter combination.
                </p>
                <button type="button" onclick="resetAllFilters()" class="btn btn-outline-info rounded-pill px-4 py-2 font-weight-bold">
                    <i class="bi bi-arrow-counterclockwise mr-1"></i> Reset All Filters
                </button>
            </div>

        </div>
    </section>

    <!-- Speaker Details Modal -->
    <div id="speakerModal" class="speaker-modal-backdrop" onclick="if(event.target===this)closeSpeakerModal()">
        <div class="speaker-modal-window">
            <button type="button" class="speaker-modal-close" onclick="closeSpeakerModal()" aria-label="Close modal">&times;</button>
            
            <div class="d-flex align-items-center mb-4" style="gap: 18px;">
                <div class="speaker-avatar-wrap m-0" style="width: 80px; height: 80px;">
                    <img id="modalSpeakerPhoto" src="" alt="Speaker" class="speaker-avatar-img" style="width: 80px; height: 80px; display: none;" />
                    <div id="modalSpeakerInitials" class="speaker-monogram" style="width: 80px; height: 80px; font-size: 1.4rem;">SP</div>
                    <span id="modalSpeakerFlag" class="speaker-badge-flag">🇸🇦</span>
                </div>
                <div>
                    <h3 id="modalSpeakerName" class="text-white font-weight-bold mb-1" style="font-size: 1.4rem;">Speaker Name</h3>
                    <p id="modalSpeakerRole" class="text-info font-weight-600 mb-0" style="font-size: 0.95rem;">Speaker Role</p>
                </div>
            </div>

            <!-- Meta Grid -->
            <div class="speakers-modal-meta-grid">
                <div class="speakers-modal-meta-item">
                    <div class="speakers-modal-meta-label"><i class="bi bi-bank"></i> Affiliation &amp; Organization</div>
                    <p id="modalSpeakerOrg" class="speakers-modal-meta-val">Organization Name</p>
                </div>
                <div class="speakers-modal-meta-item">
                    <div class="speakers-modal-meta-label"><i class="bi bi-geo-alt"></i> Geographic Region</div>
                    <p id="modalMetaRegion" class="speakers-modal-meta-val">Saudi Arabia</p>
                </div>
            </div>

            <!-- Lecture Callout -->
            <div class="speaker-lecture-card mt-3 mb-4" style="background: rgba(4, 8, 22, 0.85); padding: 18px 20px;">
                <div class="speaker-lecture-label" style="font-size: 0.8rem; margin-bottom: 8px;">
                    <i class="bi bi-mic-fill"></i> Scientific Presentation Title
                </div>
                <h4 id="modalLectureTitle" class="text-white font-weight-bold mb-0" style="font-size: 1.1rem; line-height: 1.6;">
                    Presentation Title
                </h4>
            </div>

            <div class="d-flex flex-wrap justify-content-end align-items-center pt-3 border-top border-secondary" style="gap: 12px;">
                <a id="modalCvBtn" href="#" target="_blank" class="btn btn-info rounded-pill px-4 py-2 font-weight-bold" style="display:none;">
                    <i class="bi bi-file-earmark-pdf mr-1"></i> View Speaker CV (PDF)
                </a>
                <button type="button" class="btn btn-secondary rounded-pill px-4 py-2 font-weight-bold" onclick="closeSpeakerModal()">
                    Close
                </button>
            </div>
        </div>
    </div>

    <!-- Interactive Scripts -->
    <script src="<%= ResolveUrl("~/Scripts/speakers.js") %>"></script>
</asp:Content>
