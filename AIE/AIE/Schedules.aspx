<%@ Page Title="Exhibition & Partner Participation - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Schedules.aspx.cs" Inherits="AIE.Schedules" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* SiteMap & Exhibition Floor Custom Styles */
        :root {
            --research-color: rgba(14, 165, 233, 0.22);
            --research-stroke: rgba(56, 189, 248, 0.65);
            --sponsor-color: rgba(16, 185, 129, 0.22);
            --sponsor-stroke: rgba(52, 211, 153, 0.65);
            --recommended-color: #0284c7;
            --recommended-stroke: #38bdf8;
            --visited-color: #10b981;
            --visited-stroke: #34d399;
            --busy-color: #f59e0b;
            --busy-stroke: #fbbf24;
        }

        .expo-roadmap-banner {
            background: linear-gradient(135deg, rgba(2, 132, 199, 0.25), rgba(15, 23, 42, 0.85));
            border: 1px solid rgba(56, 189, 248, 0.4);
            border-radius: 18px;
            padding: 20px 24px;
            margin-bottom: 24px;
            backdrop-filter: blur(14px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.35);
        }

        .roadmap-cta-banner {
            background: rgba(15, 23, 42, 0.75);
            border: 1px dashed rgba(56, 189, 248, 0.4);
            border-radius: 18px;
            padding: 24px 28px;
            margin-bottom: 24px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
        }

        /* Remove double border from map search input and chat input bar */
        .expo-search-box input,
        .expo-search-box input[type="text"],
        .expo-search-box #mapSearchInput,
        .sairh-chat-input-bar input,
        .sairh-chat-input-bar input[type="text"],
        .sairh-chat-input-bar #user-input,
        .sairh-chat-input {
            border: none !important;
            box-shadow: none !important;
            background: transparent !important;
            border-radius: 0 !important;
            padding: 4px 8px !important;
            outline: none !important;
        }

        .expo-search-box input:focus,
        .expo-search-box input[type="text"]:focus,
        .expo-search-box #mapSearchInput:focus,
        .sairh-chat-input-bar input:focus,
        .sairh-chat-input-bar input[type="text"]:focus,
        .sairh-chat-input-bar #user-input:focus,
        .sairh-chat-input:focus {
            border: none !important;
            box-shadow: none !important;
            background: transparent !important;
            outline: none !important;
        }

        /* Fixed High-Z Hover Tooltip (Never blocked by expo-map-toolbar) */
        .booth-hover-tooltip {
            position: fixed !important;
            z-index: 100000 !important;
            pointer-events: none !important;
            background: rgba(15, 23, 42, 0.96) !important;
            border: 1px solid rgba(56, 189, 248, 0.45) !important;
            border-radius: 12px !important;
            padding: 10px 14px !important;
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.65), 0 0 20px rgba(56, 189, 248, 0.25) !important;
            color: #ffffff !important;
            font-size: 0.8rem !important;
            max-width: 270px !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            transition: opacity 0.15s ease, transform 0.1s ease !important;
        }

        .recommended-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 14px;
            margin-top: 14px;
        }

        .recommended-stop-card {
            background: rgba(15, 23, 42, 0.85);
            border: 1px solid rgba(56, 189, 248, 0.25);
            border-left: 4px solid #38bdf8;
            border-radius: 14px;
            padding: 16px 18px;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.25);
        }

        .recommended-stop-card:hover {
            transform: translateY(-3px);
            border-color: rgba(56, 189, 248, 0.6);
            box-shadow: 0 12px 30px -8px rgba(2, 132, 199, 0.4);
            background: rgba(15, 23, 42, 0.95);
        }

        /* Detail Modal */
        .booth-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(8, 14, 28, 0.75);
            backdrop-filter: blur(10px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        @keyframes modalPopIn {
            from { transform: scale(0.92); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Exhibition Header">
        <div class="container text-center pt-4 pb-2">
            <span class="badge badge-info rounded-pill px-3 py-2 text-uppercase mb-3 font-weight-bold" style="letter-spacing: 1px;">
                Exhibition &amp; Floor Map
            </span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Exhibition &amp; Partner Participation
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 800px; font-size: 1.15rem; line-height: 1.8;">
                A premier global platform connecting leading medical technology providers, innovative startups, research institutions, and national healthcare organizations.
            </p>
        </div>
    </section>

    <!-- Main Exhibition Showcase & SiteMap -->
    <section class="py-5" aria-label="Exhibition Hall">
        <div class="container">
            <!-- Build / Retake Roadmap Action (Prominently Placed Above Meta Banner) -->
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3); font-size: 0.8rem; padding: 6px 14px; border-radius: 9999px;">
                        <i class="bi bi-compass mr-1"></i> Personalized Tour
                    </span>
                    <span class="text-secondary small">Custom-tailored exhibition navigation based on your clinical interests</span>
                </div>
                <div>
                    <a href="Survey" class="cyan-glow-btn d-inline-flex align-items-center px-4 py-2 text-white font-weight-bold text-decoration-none">
                        <i class="bi bi-compass mr-2"></i> Build / Retake Roadmap
                    </a>
                </div>
            </div>

            <!-- Expo Meta Banner (3 Balanced Columns) -->
            <div class="expo-meta-banner mb-4">
                <div class="expo-meta-item">
                    <div class="expo-meta-icon"><i class="bi bi-geo-alt"></i></div>
                    <div>
                        <div class="text-white font-weight-bold">Venue Center</div>
                        <div class="text-secondary small">Grand Hyatt Alkhobar Exhibition Hall</div>
                    </div>
                </div>
                <div class="expo-meta-item">
                    <div class="expo-meta-icon"><i class="bi bi-calendar3"></i></div>
                    <div>
                        <div class="text-white font-weight-bold">Summit Dates</div>
                        <div class="text-secondary small">12 – 13 December 2026 • 09:00 - 18:00</div>
                    </div>
                </div>
                <div class="expo-meta-item">
                    <div class="expo-meta-icon"><i class="bi bi-grid-3x3-gap"></i></div>
                    <div>
                        <div class="text-white font-weight-bold">Participation Scope</div>
                        <div class="text-secondary small">15 Sponsor Pavilions &amp; 30 Research Screens</div>
                    </div>
                </div>
            </div>

            <!-- Personalized Roadmap Section -->
            <div class="expo-roadmap-banner" id="pnlRoadmap" runat="server" visible="false">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-1">
                    <div>
                        <span class="badge badge-info px-3 py-1 rounded-pill mb-2"><i class="bi bi-stars mr-1"></i> Personalized Roadmap</span>
                        <h3 class="text-white font-weight-bold mb-1">Your Recommended Stops</h3>
                        <p class="text-light small mb-0" style="opacity: 0.9;">
                            Based on your survey responses, the locations below are highlighted in <strong>Royal Blue</strong> on the floor map.
                        </p>
                    </div>
                    <div>
                        <span class="badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3); padding: 6px 14px; border-radius: 9999px; font-size: 0.78rem;">
                            <i class="bi bi-bookmark-star mr-1"></i> Curated Itinerary
                        </span>
                    </div>
                </div>

                <div class="recommended-cards-grid" id="recCardsContainer" runat="server">
                    <!-- Recommended cards dynamically populated -->
                </div>
            </div>

            <!-- Survey CTA Placeholder (Hidden to avoid duplication with top Build / Retake Roadmap action) -->
            <div id="pnlSurveyCTA" runat="server" style="display:none;"></div>

            <!-- Map Header -->
            <div class="d-flex justify-content-between align-items-end flex-wrap gap-3 mb-3">
                <div>
                    <h2 class="text-white font-weight-bold h3 mb-1">
                        <i class="bi bi-map text-info mr-2"></i> Interactive Exhibition Floor Map
                    </h2>
                    <p class="text-secondary small mb-0">
                        Explore research project displays, sponsor pavilions, live availability cooldowns, and interactive NFC touchpoints.
                    </p>
                </div>
            </div>

            <!-- Interactive Map Toolbar -->
            <div class="expo-map-toolbar mb-4">
                <div class="row align-items-center g-3">
                    <!-- Live Search Bar -->
                    <div class="col-xl-4 col-lg-4 col-md-12 mb-2 mb-lg-0">
                        <div class="expo-search-box">
                            <i class="bi bi-search text-info mr-2"></i>
                            <input type="text" id="mapSearchInput" class="form-control bg-transparent text-white border-0 shadow-none p-0" placeholder="Search booth, company, or AI topic..." oninput="handleMapSearch(this.value)" />
                            <button type="button" id="btnClearMapSearch" class="btn btn-sm text-secondary p-0" style="display:none; font-size:1.2rem; line-height:1;" onclick="clearMapSearch()" title="Clear Search">&times;</button>
                        </div>
                    </div>
                    <!-- Filter Tabs with Integrated Color Swatches -->
                    <div class="col-xl-8 col-lg-8 col-md-12 d-flex align-items-center justify-content-lg-end flex-wrap gap-2">
                        <button type="button" class="expo-filter-pill active" id="fltAll" onclick="setMapFilter('all')">
                            <i class="bi bi-grid-fill mr-1"></i> All (<span id="cntAll">45</span>)
                        </button>
                        <button type="button" class="expo-filter-pill" id="fltRoadmap" onclick="setMapFilter('recommended')">
                            <span class="legend-swatch mr-1" style="background: var(--recommended-color); width: 8px; height: 8px; border-radius: 50%; display: inline-block;"></span> My Roadmap (<span id="cntRecommended">0</span>)
                        </button>
                        <button type="button" class="expo-filter-pill" id="fltSponsors" onclick="setMapFilter('sponsor')">
                            <span class="legend-swatch mr-1" style="background: var(--sponsor-color); border: 1px solid var(--sponsor-stroke); width: 8px; height: 8px; border-radius: 50%; display: inline-block;"></span> Sponsors (15)
                        </button>
                        <button type="button" class="expo-filter-pill" id="fltResearch" onclick="setMapFilter('research')">
                            <span class="legend-swatch mr-1" style="background: var(--research-color); border: 1px solid var(--research-stroke); width: 8px; height: 8px; border-radius: 50%; display: inline-block;"></span> Research (30)
                        </button>
                        <button type="button" class="expo-filter-pill" id="fltVisited" onclick="setMapFilter('visited')">
                            <span class="legend-swatch mr-1" style="background: var(--visited-color); width: 8px; height: 8px; border-radius: 50%; display: inline-block;"></span> Visited (<span id="cntVisited">0</span>)
                        </button>
                    </div>
                </div>

                <!-- Attendance Progress Bar, Live Status & Zoom Controls -->
                <div class="d-flex align-items-center justify-content-between mt-3 pt-3 flex-wrap gap-3" style="border-top: 1px solid rgba(255, 255, 255, 0.08);">
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <span class="badge" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.3); font-size: 0.75rem; padding: 4px 10px; border-radius: 9999px;">
                            <i class="bi bi-broadcast mr-1"></i> Live Floor Plan
                        </span>
                        <span class="badge" style="background: rgba(245, 158, 11, 0.15); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.3); font-size: 0.75rem; padding: 4px 10px; border-radius: 9999px;">
                            <span class="booth-status-dot mr-1" style="background: var(--busy-color); width: 7px; height: 7px; margin-right: 4px;"></span> Busy: 5m Cooldown
                        </span>
                        <span class="text-secondary small" id="searchMatchNotice" style="display:none;"></span>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-light small font-weight-semibold">
                            Visited: <span id="progressText" class="text-info font-weight-bold">0 / 45</span> (<span id="progressPct">0%</span>)
                        </span>
                        <div class="expo-progress-track">
                            <div class="expo-progress-fill" id="progressFill" style="width: 0%;"></div>
                        </div>
                        <!-- Zoom Controls -->
                        <div class="expo-zoom-group">
                            <button type="button" class="expo-zoom-btn" onclick="zoomMap(1.15)" title="Zoom In"><i class="bi bi-zoom-in"></i></button>
                            <button type="button" class="expo-zoom-btn" onclick="zoomMap(0.85)" title="Zoom Out"><i class="bi bi-zoom-out"></i></button>
                            <button type="button" class="expo-zoom-btn" onclick="resetMapZoom()" title="Reset View"><i class="bi bi-arrows-angle-contract"></i></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SVG Floor Plan Canvas Card -->
            <div class="sitemap-canvas-card" id="sitemapCanvasCard">
                <div id="boothHoverTooltip" class="booth-hover-tooltip" style="display:none;">
                    <div class="tooltip-header">
                        <span class="tooltip-code" id="tooltipCode">R-01</span>
                        <span class="tooltip-hall" id="tooltipHall">Research Hall</span>
                    </div>
                    <div class="tooltip-name" id="tooltipName">Project Title</div>
                    <div class="tooltip-org" id="tooltipOrg">Organization</div>
                    <div class="tooltip-status" id="tooltipStatus">
                        <span class="booth-status-dot" id="tooltipDot"></span> <span id="tooltipStatusText">Available</span>
                    </div>
                </div>

                <svg id="exhibition-map" class="floor-plan-svg" viewBox="0 0 1060 520">
                    <defs>
                        <!-- Blueprint Grid Pattern -->
                        <pattern id="blueprint-grid" width="24" height="24" patternUnits="userSpaceOnUse">
                            <path d="M 24 0 L 0 0 0 24" fill="none" stroke="rgba(56, 189, 248, 0.04)" stroke-width="1" />
                        </pattern>
                        <!-- Hall Gradients -->
                        <linearGradient id="research-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="rgba(14, 165, 233, 0.12)" />
                            <stop offset="100%" stop-color="rgba(15, 23, 42, 0.95)" />
                        </linearGradient>
                        <linearGradient id="sponsor-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="rgba(16, 185, 129, 0.12)" />
                            <stop offset="100%" stop-color="rgba(15, 23, 42, 0.95)" />
                        </linearGradient>
                        <linearGradient id="plaza-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="rgba(30, 41, 59, 0.4)" />
                            <stop offset="100%" stop-color="rgba(15, 23, 42, 0.85)" />
                        </linearGradient>
                        <linearGradient id="entrance-grad" x1="0%" y1="0%" x2="100%" y2="0%">
                            <stop offset="0%" stop-color="#0284c7" />
                            <stop offset="50%" stop-color="#38bdf8" />
                            <stop offset="100%" stop-color="#0284c7" />
                        </linearGradient>
                    </defs>

                    <!-- Research Screen Hall Outer Frame -->
                    <rect x="20" y="20" width="670" height="240" rx="16" fill="url(#research-grad)" stroke="rgba(56, 189, 248, 0.4)" stroke-width="2" />
                    <rect x="20" y="20" width="670" height="240" rx="16" fill="url(#blueprint-grid)" opacity="0.7" />
                    
                    <!-- Research Hall Label -->
                    <rect x="225" y="105" width="260" height="54" rx="10" fill="rgba(10, 15, 30, 0.75)" stroke="rgba(56, 189, 248, 0.25)" stroke-width="1" />
                    <text x="355" y="126" font-weight="800" font-size="15" fill="#f8fafc" text-anchor="middle" letter-spacing="1">RESEARCH SCREEN HALL</text>
                    <text x="355" y="146" font-weight="600" font-size="11" fill="#38bdf8" text-anchor="middle">30 Clinical AI &amp; Diagnostic Showcases</text>

                    <!-- Door Passageway Indicator -->
                    <line x1="690" y1="125" x2="730" y2="125" stroke="#38bdf8" stroke-width="2.5" stroke-dasharray="4 4" />
                    <line x1="690" y1="155" x2="730" y2="155" stroke="#38bdf8" stroke-width="2.5" stroke-dasharray="4 4" />
                    <rect x="696" y="130" width="28" height="20" rx="4" fill="rgba(14, 165, 233, 0.3)" stroke="#38bdf8" stroke-width="1" />
                    <text x="710" y="143" font-size="8" font-weight="800" fill="#bae6fd" text-anchor="middle">DOOR</text>

                    <!-- Sponsor Hall Outer Frame -->
                    <rect x="730" y="20" width="310" height="470" rx="16" fill="url(#sponsor-grad)" stroke="rgba(52, 211, 153, 0.4)" stroke-width="2" />
                    <rect x="730" y="20" width="310" height="470" rx="16" fill="url(#blueprint-grid)" opacity="0.7" />

                    <!-- Sponsor Hall Label -->
                    <rect x="765" y="38" width="240" height="50" rx="10" fill="rgba(10, 15, 30, 0.75)" stroke="rgba(52, 211, 153, 0.25)" stroke-width="1" />
                    <text x="885" y="58" font-weight="800" font-size="15" fill="#f8fafc" text-anchor="middle" letter-spacing="1">SPONSOR HALL</text>
                    <text x="885" y="76" font-weight="600" font-size="11" fill="#34d399" text-anchor="middle">15 Industry Leader Pavilions</text>

                    <!-- Main Hall / Central Networking Plaza -->
                    <rect x="20" y="280" width="670" height="210" rx="16" fill="url(#plaza-grad)" stroke="rgba(255, 255, 255, 0.12)" stroke-width="1.5" />
                    <rect x="20" y="280" width="670" height="210" rx="16" fill="url(#blueprint-grid)" opacity="0.4" />
                    <text x="355" y="375" font-weight="800" font-size="16" fill="#cbd5e1" text-anchor="middle" letter-spacing="1">MAIN NETWORKING PLAZA</text>
                    <text x="355" y="398" font-weight="500" font-size="11" fill="#64748b" text-anchor="middle">Open Lounge, Coffee Bar &amp; Direct Hall Passage</text>

                    <!-- Entrance Arc with Neon Glow -->
                    <g transform="translate(885, 490)">
                        <path d="M -45 -12 A 45 45 0 0 1 45 -12" fill="none" stroke="url(#entrance-grad)" stroke-width="3" />
                        <rect x="-65" y="-36" width="130" height="24" rx="12" fill="rgba(10, 15, 30, 0.85)" stroke="rgba(56, 189, 248, 0.6)" stroke-width="1.5" />
                        <text x="0" y="-20" font-size="11" font-weight="800" fill="#38bdf8" text-anchor="middle" letter-spacing="1">↑ MAIN ENTRANCE</text>
                    </g>

                    <!-- Interactive SVG Booth Nodes Layer (R1-R30 & S1-S15) -->
                    <g id="booths-layer"></g>
                </svg>
            </div>

            <!-- 6 Pavilions Overview Section -->
            <div class="text-center mb-5 mt-4">
                <h2 class="text-white font-weight-bold display-6">
                    A dedicated exhibition hall will feature:
                </h2>
            </div>

            <div class="pavilion-grid">
                <!-- Pavilion 01 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-globe"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 01</span>
                        <h3 class="pavilion-title">International AI &amp; Radiology Companies</h3>
                        <p class="pavilion-desc">Global leaders showcasing cutting-edge diagnostic algorithms, modality hardware, and AI workflow suites.</p>
                    </div>
                </div>

                <!-- Pavilion 02 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-rocket-takeoff"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 02</span>
                        <h3 class="pavilion-title">Digital Health Startups</h3>
                        <p class="pavilion-desc">High-growth health tech ventures presenting disruptive solutions in medical imaging automation.</p>
                    </div>
                </div>

                <!-- Pavilion 03 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-mortarboard"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 03</span>
                        <h3 class="pavilion-title">Universities &amp; Research Centers</h3>
                        <p class="pavilion-desc">Academic powerhouses presenting breakthrough medical research, peer-reviewed clinical data, and pilot trials.</p>
                    </div>
                </div>

                <!-- Pavilion 04 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-bank"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 04</span>
                        <h3 class="pavilion-title">National Organizations</h3>
                        <p class="pavilion-desc">Strategic regulatory and national entities: SDAIA, Aramco Digital, Ministry of Health (MOH), and SFDA.</p>
                    </div>
                </div>

                <!-- Pavilion 05 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-lightbulb"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 05</span>
                        <h3 class="pavilion-title">Healthcare Innovators</h3>
                        <p class="pavilion-desc">Visionary clinical practitioners, biomedical engineers, and radiologic data pioneers driving healthcare transformation.</p>
                    </div>
                </div>

                <!-- Pavilion 06 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-heart-pulse"></i></div>
                    <div>
                        <span class="pavilion-badge">SECTOR 06</span>
                        <h3 class="pavilion-title">Non-Profit Organizations</h3>
                        <p class="pavilion-desc">Societies, medical foundations, and non-profit healthcare bodies dedicated to patient safety and quality standards.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Detail Modal Dialog -->
    <div class="booth-modal-backdrop" id="boothModal" onclick="if(event.target===this)closeModal();">
        <div class="booth-modal-box">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <span class="booth-modal-badge" id="modalBadge">Hall Badge</span>
                    <h3 class="font-weight-bold m-0 text-white" id="modalTitle">Booth Code</h3>
                    <div class="text-info small font-weight-bold mt-1" id="modalOrg">Organization</div>
                </div>
                <button type="button" class="close text-secondary" style="font-size: 1.8rem; cursor:pointer; opacity: 0.8; transition: opacity 0.2s;" onclick="closeModal()" aria-label="Close">
                    &times;
                </button>
            </div>

            <div class="mb-3">
                <div class="text-secondary small font-weight-bold mb-1"><i class="bi bi-tags text-info mr-1"></i> Focus Categories:</div>
                <div class="text-light small mb-0 d-flex flex-wrap" id="modalCategories" style="line-height: 1.5; gap: 4px;"></div>
            </div>

            <div class="booth-status-row">
                <span>Availability Status:</span>
                <div class="d-flex align-items-center">
                    <span class="booth-status-dot" id="modalStatusDot"></span>
                    <span id="modalStatusText" class="text-white">Available for Visit</span>
                </div>
            </div>

            <div id="modalVisitedNote" class="text-success small font-weight-bold mb-3" style="display:none; background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.3); padding: 8px 12px; border-radius: 8px;">
                <i class="bi bi-check-circle-fill mr-1"></i> You have already visited and checked in at this booth!
            </div>

            <button type="button" class="cyan-glow-btn w-100 py-3 text-white font-weight-bold border-0" id="btnScan" onclick="simulateNFCScan()">
                <i class="bi bi-broadcast mr-1"></i> Simulate NFC Smart Tag Tap
            </button>
        </div>
    </div>

    <!-- Interactive SiteMap Script -->
    <script>
        const boothLayout = {
            // Top row R1 to R12
            R1: { x: 90, y: 35 },  R2: { x: 140, y: 35 }, R3: { x: 190, y: 35 }, R4: { x: 240, y: 35 },
            R5: { x: 290, y: 35 }, R6: { x: 340, y: 35 }, R7: { x: 390, y: 35 }, R8: { x: 440, y: 35 },
            R9: { x: 490, y: 35 }, R10: { x: 540, y: 35 }, R11: { x: 590, y: 35 }, R12: { x: 640, y: 35 },

            // Left column R13 to R18
            R13: { x: 35, y: 70 },  R14: { x: 35, y: 98 },  R15: { x: 35, y: 126 },
            R16: { x: 35, y: 154 }, R17: { x: 35, y: 182 }, R18: { x: 35, y: 210 },

            // Bottom row R19 to R30
            R19: { x: 90, y: 220 },  R20: { x: 140, y: 220 }, R21: { x: 190, y: 220 }, R22: { x: 240, y: 220 },
            R23: { x: 290, y: 220 }, R24: { x: 340, y: 220 }, R25: { x: 390, y: 220 }, R26: { x: 440, y: 220 },
            R27: { x: 490, y: 220 }, R28: { x: 540, y: 220 }, R29: { x: 590, y: 220 }, R30: { x: 640, y: 220 },

            // Sponsor Hall: Left column (S1 - S7)
            S1: { x: 755, y: 195 }, S2: { x: 755, y: 235 }, S3: { x: 755, y: 275 },
            S4: { x: 755, y: 315 }, S5: { x: 755, y: 355 }, S6: { x: 755, y: 395 }, S7: { x: 755, y: 435 },

            // Sponsor Hall: Right column (S8 - S15)
            S8:  { x: 920, y: 115 }, S9:  { x: 920, y: 155 }, S10: { x: 920, y: 195 }, S11: { x: 920, y: 235 },
            S12: { x: 920, y: 275 }, S13: { x: 920, y: 315 }, S14: { x: 920, y: 355 }, S15: { x: 920, y: 395 }
        };

        let activeSelectedBooth = null;
        let localBoothsCache = [];
        let currentFilter = 'all';
        let activeSearchQuery = '';
        let currentZoom = 1.0;

        function initSVGFloorPlan() {
            // Attach tooltip to document.body so it is never clipped by parent overflow or obscured by toolbar
            const tooltip = document.getElementById("boothHoverTooltip");
            if (tooltip && tooltip.parentElement !== document.body) {
                document.body.appendChild(tooltip);
            }

            const container = document.getElementById("booths-layer");
            if (!container) return;
            let markup = "";

            for (const [code, pos] of Object.entries(boothLayout)) {
                const isSponsor = code.startsWith("S");
                const w = isSponsor ? 64 : 42;
                const h = isSponsor ? 30 : 22;

                markup += `
                  <g id="group-${code}" onclick="handleBoothClick(event, '${code}')" onmouseenter="showBoothTooltip(event, '${code}')" onmousemove="moveBoothTooltip(event)" onmouseleave="hideBoothTooltip()">
                    <rect id="rect-${code}" class="booth-rect" x="${pos.x}" y="${pos.y}" width="${w}" height="${h}" rx="6" />
                    <text id="text-${code}" class="booth-label" x="${pos.x + w / 2}" y="${pos.y + h / 2}">${code}</text>
                    <circle id="check-bg-${code}" cx="${pos.x + w - 4}" cy="${pos.y + 4}" r="6" fill="#10b981" stroke="#064e3b" stroke-width="1" style="display:none;" />
                    <text id="check-icon-${code}" class="check-badge" x="${pos.x + w - 4}" y="${pos.y + 5}" style="display:none;">✓</text>
                  </g>
                `;
            }
            container.innerHTML = markup;
        }

        async function loadFloorPlanState() {
            try {
                const res = await fetch("/api/map/status");
                if (!res.ok) return;
                const booths = await res.json();
                localBoothsCache = booths;

                let recommendedCount = 0;
                let visitedCount = 0;
                const totalCount = booths.length || 45;

                booths.forEach(b => {
                    const rect = document.getElementById(`rect-${b.boothCode}`);
                    const text = document.getElementById(`text-${b.boothCode}`);
                    const checkBg = document.getElementById(`check-bg-${b.boothCode}`);
                    const checkIcon = document.getElementById(`check-icon-${b.boothCode}`);

                    if (b.isRecommended) recommendedCount++;
                    if (b.isVisitedByCurrentUser) visitedCount++;

                    if (!rect) return;

                    const isSponsor = b.boothCode.startsWith("S");

                    // Visual Priority:
                    // 1. Visited (Emerald green with check mark)
                    // 2. Busy (Orange/Amber)
                    // 3. Recommended (Royal Blue Glow)
                    // 4. Default Category Tint (Research: Cyan-Blue, Sponsor: Emerald-Mint)
                    if (b.isVisitedByCurrentUser) {
                        rect.setAttribute("fill", "var(--visited-color)");
                        rect.setAttribute("stroke", "var(--visited-stroke)");
                        rect.setAttribute("stroke-width", "2");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "block";
                        if (checkIcon) checkIcon.style.display = "block";
                    } else if (b.status === 1) { // 1 = Busy
                        rect.setAttribute("fill", "var(--busy-color)");
                        rect.setAttribute("stroke", "var(--busy-stroke)");
                        rect.setAttribute("stroke-width", "2");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    } else if (b.isRecommended) {
                        rect.setAttribute("fill", "var(--recommended-color)");
                        rect.setAttribute("stroke", "var(--recommended-stroke)");
                        rect.setAttribute("stroke-width", "2.5");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    } else {
                        rect.setAttribute("fill", isSponsor ? "var(--sponsor-color)" : "var(--research-color)");
                        rect.setAttribute("stroke", isSponsor ? "var(--sponsor-stroke)" : "var(--research-stroke)");
                        rect.setAttribute("stroke-width", "1.5");
                        text.classList.remove("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    }
                });

                // Update Counters & Progress Bar
                const cntAllEl = document.getElementById("cntAll");
                const cntRecEl = document.getElementById("cntRecommended");
                const cntVisEl = document.getElementById("cntVisited");
                const progressTextEl = document.getElementById("progressText");
                const progressPctEl = document.getElementById("progressPct");
                const progressFillEl = document.getElementById("progressFill");

                if (cntAllEl) cntAllEl.innerText = totalCount;
                if (cntRecEl) cntRecEl.innerText = recommendedCount;
                if (cntVisEl) cntVisEl.innerText = visitedCount;

                const pct = Math.round((visitedCount / totalCount) * 100);
                if (progressTextEl) progressTextEl.innerText = `${visitedCount} / ${totalCount}`;
                if (progressPctEl) progressPctEl.innerText = `${pct}%`;
                if (progressFillEl) progressFillEl.style.width = `${pct}%`;

                applyFilterAndSearch();
            } catch (err) {
                console.error("Failed to refresh floor plan:", err);
            }
        }

        function setMapFilter(filterType) {
            currentFilter = filterType;
            const pills = document.querySelectorAll(".expo-filter-pill");
            pills.forEach(p => p.classList.remove("active"));
            
            const targetMap = {
                'all': 'fltAll',
                'recommended': 'fltRoadmap',
                'sponsor': 'fltSponsors',
                'research': 'fltResearch',
                'visited': 'fltVisited'
            };
            const btn = document.getElementById(targetMap[filterType]);
            if (btn) btn.classList.add("active");

            applyFilterAndSearch();
        }

        function handleMapSearch(val) {
            activeSearchQuery = (val || "").trim().toLowerCase();
            const btnClear = document.getElementById("btnClearMapSearch");
            if (btnClear) btnClear.style.display = activeSearchQuery ? "inline-block" : "none";
            applyFilterAndSearch();
        }

        function clearMapSearch() {
            const input = document.getElementById("mapSearchInput");
            if (input) input.value = "";
            activeSearchQuery = "";
            const btnClear = document.getElementById("btnClearMapSearch");
            if (btnClear) btnClear.style.display = "none";
            applyFilterAndSearch();
        }

        function applyFilterAndSearch() {
            let matchCount = 0;
            const noticeEl = document.getElementById("searchMatchNotice");

            for (const [code] of Object.entries(boothLayout)) {
                const rect = document.getElementById(`rect-${code}`);
                const b = localBoothsCache.find(x => x.boothCode === code);
                if (!rect) continue;

                let matchesFilter = true;
                if (currentFilter === 'recommended') {
                    matchesFilter = b ? b.isRecommended : false;
                } else if (currentFilter === 'sponsor') {
                    matchesFilter = code.startsWith('S');
                } else if (currentFilter === 'research') {
                    matchesFilter = code.startsWith('R');
                } else if (currentFilter === 'visited') {
                    matchesFilter = b ? b.isVisitedByCurrentUser : false;
                }

                let matchesSearch = true;
                if (activeSearchQuery) {
                    const searchStr = `${code} ${b ? b.name : ''} ${b && b.organization ? b.organization : ''} ${(b && b.categories) ? b.categories.join(' ') : ''}`.toLowerCase();
                    matchesSearch = searchStr.includes(activeSearchQuery);
                }

                if (matchesFilter && matchesSearch) {
                    rect.classList.remove("dimmed");
                    if (activeSearchQuery) {
                        rect.classList.add("highlighted-match");
                    } else {
                        rect.classList.remove("highlighted-match");
                    }
                    matchCount++;
                } else {
                    rect.classList.add("dimmed");
                    rect.classList.remove("highlighted-match");
                }
            }

            if (noticeEl) {
                if (activeSearchQuery) {
                    noticeEl.style.display = "inline";
                    noticeEl.innerText = `Matches: ${matchCount} booth${matchCount === 1 ? '' : 's'}`;
                } else {
                    noticeEl.style.display = "none";
                }
            }
        }

        function handleBoothClick(e, boothCode) {
            showBoothTooltip(e, boothCode);
            openBoothModal(boothCode);
        }

        // Tooltip Handlers
        function showBoothTooltip(e, boothCode) {
            const tooltip = document.getElementById("boothHoverTooltip");
            const b = localBoothsCache.find(x => x.boothCode === boothCode);
            if (!tooltip) return;

            const isSponsor = boothCode.startsWith("S");
            document.getElementById("tooltipCode").innerText = boothCode;
            document.getElementById("tooltipHall").innerText = isSponsor ? "Sponsor Hall" : "Research Hall";
            document.getElementById("tooltipName").innerText = b ? b.name : (isSponsor ? `Sponsor Booth ${boothCode}` : `Research Display ${boothCode}`);
            document.getElementById("tooltipOrg").innerText = b && b.organization ? b.organization : (isSponsor ? "Exhibitor Partner" : "Research Project");

            const dot = document.getElementById("tooltipDot");
            const stText = document.getElementById("tooltipStatusText");
            if (b && b.isVisitedByCurrentUser) {
                dot.style.background = "#10b981";
                stText.innerText = "Visited";
            } else if (b && b.status === 1) {
                dot.style.background = "#f59e0b";
                stText.innerText = "Busy";
            } else {
                dot.style.background = "#38bdf8";
                stText.innerText = "Available";
            }

            tooltip.style.display = "block";
            moveBoothTooltip(e);
        }

        function moveBoothTooltip(e) {
            const tooltip = document.getElementById("boothHoverTooltip");
            if (!tooltip) return;

            let x = e.clientX;
            let y = e.clientY;

            // Keep within horizontal viewport bounds
            const tooltipWidth = 270;
            if (x < tooltipWidth / 2 + 12) {
                x = tooltipWidth / 2 + 12;
            } else if (x > window.innerWidth - tooltipWidth / 2 - 12) {
                x = window.innerWidth - tooltipWidth / 2 - 12;
            }

            tooltip.style.left = `${x}px`;
            tooltip.style.top = `${y}px`;

            // Display on top (above booth) with high z-index over toolbar; flip down if near viewport top
            if (y < 130) {
                tooltip.style.transform = "translate(-50%, 25px)";
            } else {
                tooltip.style.transform = "translate(-50%, -120%)";
            }
        }

        function hideBoothTooltip() {
            const tooltip = document.getElementById("boothHoverTooltip");
            if (tooltip) tooltip.style.display = "none";
        }

        // Map Zoom Controls
        function zoomMap(factor) {
            currentZoom = Math.max(0.75, Math.min(2.0, currentZoom * factor));
            const svg = document.getElementById("exhibition-map");
            if (svg) {
                svg.style.transform = `scale(${currentZoom})`;
                svg.style.transformOrigin = "center center";
            }
        }

        function resetMapZoom() {
            currentZoom = 1.0;
            const svg = document.getElementById("exhibition-map");
            if (svg) {
                svg.style.transform = "scale(1)";
            }
        }

        function highlightBooth(code) {
            const card = document.getElementById("sitemapCanvasCard");
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            openBoothModal(code);
        }

        function openBoothModal(boothCode) {
            hideBoothTooltip();
            activeSelectedBooth = boothCode;
            const b = localBoothsCache.find(x => x.boothCode === boothCode);

            const titleEl = document.getElementById("modalTitle");
            const badgeEl = document.getElementById("modalBadge");
            const orgEl = document.getElementById("modalOrg");
            const catEl = document.getElementById("modalCategories");
            const dotEl = document.getElementById("modalStatusDot");
            const statusEl = document.getElementById("modalStatusText");
            const visitedNoteEl = document.getElementById("modalVisitedNote");

            const isSponsor = boothCode.startsWith("S");
            titleEl.innerText = b ? b.name : (isSponsor ? `Sponsor Booth ${boothCode}` : `Research Display ${boothCode}`);
            orgEl.innerText = b && b.organization ? b.organization : (isSponsor ? "Summit Sponsor" : "Research Initiative");

            if (b && b.categories && b.categories.length > 0) {
                catEl.innerHTML = b.categories.map(c => `<span class="badge mr-1 mb-1" style="background: rgba(56, 189, 248, 0.15); color: #bae6fd; border: 1px solid rgba(56, 189, 248, 0.3); font-size: 0.72rem; padding: 4px 8px; border-radius: 6px;">${c}</span>`).join('');
            } else {
                catEl.innerHTML = `<span class="badge" style="background: rgba(56, 189, 248, 0.15); color: #bae6fd; border: 1px solid rgba(56, 189, 248, 0.3); font-size: 0.72rem; padding: 4px 8px; border-radius: 6px;">AI, Radiology & Digital Health</span>`;
            }

            if (isSponsor) {
                badgeEl.innerText = "Sponsor Innovation Hall";
                badgeEl.style.background = "rgba(16, 185, 129, 0.18)";
                badgeEl.style.border = "1px solid rgba(52, 211, 153, 0.4)";
                badgeEl.style.color = "#34d399";
            } else {
                badgeEl.innerText = "Research Screen Hall";
                badgeEl.style.background = "rgba(14, 165, 233, 0.18)";
                badgeEl.style.border = "1px solid rgba(56, 189, 248, 0.4)";
                badgeEl.style.color = "#38bdf8";
            }

            if (b && b.status === 1) {
                dotEl.style.background = "var(--busy-color)";
                statusEl.innerText = `Busy (~${Math.ceil(b.remainingBusySeconds / 60)} min cooldown remaining)`;
            } else {
                dotEl.style.background = "var(--visited-color)";
                statusEl.innerText = "Available for Visit";
            }

            if (b && b.isVisitedByCurrentUser) {
                visitedNoteEl.style.display = "block";
            } else {
                visitedNoteEl.style.display = "none";
            }

            document.getElementById("boothModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("boothModal").style.display = "none";
            hideBoothTooltip();
        }

        async function simulateNFCScan() {
            if (!activeSelectedBooth) return;
            const btn = document.getElementById("btnScan");
            if (btn) {
                btn.innerHTML = `<i class="bi bi-arrow-repeat mr-1" style="animation: spin 1s infinite linear;"></i> Logging Smart Tag Check-in...`;
                btn.disabled = true;
            }
            try {
                await fetch(`/api/map/scan?boothCode=${encodeURIComponent(activeSelectedBooth)}`, { method: "POST" });
            } catch (e) {
                console.warn(e);
            }
            if (btn) {
                btn.innerHTML = `<i class="bi bi-broadcast mr-1"></i> Simulate NFC Smart Tag Tap`;
                btn.disabled = false;
            }
            closeModal();
            await loadFloorPlanState();
        }

        // Initialize and setup live polling loop
        document.addEventListener("DOMContentLoaded", function () {
            initSVGFloorPlan();
            loadFloorPlanState();
            setInterval(loadFloorPlanState, 3500);
        });
    </script>
</asp:Content>
