<%@ Page Title="Exhibition & Partner Participation - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Schedules.aspx.cs" Inherits="AIE.Schedules" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* SiteMap & Exhibition Floor Custom Styles */
        :root {
            --research-color: #dbeafe;
            --research-stroke: #93c5fd;
            --sponsor-color: #dcfce7;
            --sponsor-stroke: #86efac;
            --recommended-color: #0284c7;
            --visited-color: #10b981;
            --busy-color: #f59e0b;
        }

        .expo-roadmap-banner {
            background: linear-gradient(135deg, rgba(2, 132, 199, 0.25), rgba(15, 23, 42, 0.8));
            border: 1px solid rgba(56, 189, 248, 0.4);
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 30px;
            backdrop-filter: blur(12px);
        }

        .roadmap-cta-banner {
            background: rgba(15, 23, 42, 0.7);
            border: 1px dashed rgba(56, 189, 248, 0.4);
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 30px;
            text-align: center;
        }

        .recommended-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 14px;
            margin-top: 18px;
        }

        .recommended-stop-card {
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-left: 4px solid #0284c7;
            border-radius: 12px;
            padding: 16px;
            transition: all 0.2s ease;
        }

        .recommended-stop-card:hover {
            transform: translateY(-2px);
            border-color: rgba(56, 189, 248, 0.4);
            box-shadow: 0 10px 25px -10px rgba(2, 132, 199, 0.3);
        }

        .map-legend-bar {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            background: rgba(15, 23, 42, 0.8);
            padding: 14px 24px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            flex-wrap: wrap;
        }

        .legend-pill {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #cbd5e1;
        }

        .legend-swatch {
            width: 18px;
            height: 18px;
            border-radius: 6px;
            border: 1.5px solid transparent;
            display: inline-block;
        }

        .sitemap-canvas-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.15);
            padding: 24px;
            position: relative;
            overflow-x: auto;
            margin-bottom: 40px;
        }

        svg.floor-plan-svg {
            width: 100%;
            height: auto;
            min-width: 960px;
            user-select: none;
            display: block;
        }

        .booth-rect {
            cursor: pointer;
            transition: transform 0.15s ease, filter 0.15s ease, stroke-width 0.15s;
        }

        .booth-rect:hover {
            filter: brightness(0.92);
            stroke: #0f172a !important;
            stroke-width: 2.5px !important;
        }

        .booth-label {
            font-weight: 700;
            font-size: 11px;
            fill: #1e293b;
            pointer-events: none;
            text-anchor: middle;
            dominant-baseline: central;
        }

        .booth-label.light-text {
            fill: #ffffff !important;
        }

        .check-badge {
            pointer-events: none;
            fill: #ffffff;
            font-size: 11px;
            font-weight: 900;
            text-anchor: middle;
            dominant-baseline: central;
        }

        /* Detail Modal */
        .booth-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(6px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .booth-modal-box {
            background: #ffffff;
            color: #0f172a;
            width: 90%;
            max-width: 460px;
            border-radius: 18px;
            padding: 28px;
            box-shadow: 0 25px 35px -5px rgba(0,0,0,0.25);
            animation: modalPopIn 0.2s ease-out;
            position: relative;
        }

        @keyframes modalPopIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .booth-modal-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .booth-status-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #f1f5f9;
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .booth-status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 6px;
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
            <!-- Expo Meta Banner -->
            <div class="expo-meta-banner mb-4">
                <div class="d-flex align-items-center gap-3">
                    <i class="bi bi-geo-alt text-info display-6"></i>
                    <div>
                        <div class="text-white font-weight-bold">Venue Hall</div>
                        <div class="text-secondary small">Grand Hyatt Alkhobar Exhibition Center</div>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <i class="bi bi-people text-info display-6"></i>
                    <div>
                        <div class="text-white font-weight-bold">Participation Scope</div>
                        <div class="text-secondary small">15 Sponsor Booths &amp; 30 Research Screens</div>
                    </div>
                </div>
                <div>
                    <a href="Survey" class="btn btn-outline-info rounded-pill px-4 py-2 font-weight-bold">
                        <i class="bi bi-compass mr-1"></i> Personalized Survey
                    </a>
                </div>
            </div>

            <!-- Personalized Roadmap Section -->
            <div id="pnlRoadmap" runat="server" class="expo-roadmap-banner" visible="false">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <span class="badge badge-info px-3 py-1 rounded-pill mb-2"><i class="bi bi-stars mr-1"></i> Personalized Roadmap</span>
                        <h3 class="text-white font-weight-bold mb-1">Your Recommended Stops</h3>
                        <p class="text-light small mb-0" style="opacity: 0.9;">
                            Based on your survey responses, the locations below are highlighted in <strong>Royal Blue</strong> on the floor map.
                        </p>
                    </div>
                    <div>
                        <a href="Survey" class="btn btn-sm btn-outline-light rounded-pill px-3 py-2 font-weight-semibold">
                            <i class="bi bi-arrow-repeat mr-1"></i> Retake Survey
                        </a>
                    </div>
                </div>

                <div class="recommended-cards-grid" id="recCardsContainer" runat="server">
                    <!-- Recommended cards dynamically populated -->
                </div>
            </div>

            <!-- Survey CTA Banner for Guests or Users Without Survey -->
            <div id="pnlSurveyCTA" runat="server" class="roadmap-cta-banner">
                <h4 class="text-white font-weight-bold mb-2">Want a Personalized Exhibition Roadmap?</h4>
                <p class="text-secondary small mb-3">
                    Take our quick 1-minute survey to highlight the sponsor booths and research displays that match your specific interests.
                </p>
                <a href="Survey" class="cyan-glow-btn d-inline-block px-4 py-2 text-white font-weight-bold text-decoration-none">
                    <i class="bi bi-magic mr-1"></i> Build My Roadmap
                </a>
            </div>

            <!-- Map Header & Legend -->
            <div class="d-flex justify-content-between align-items-end flex-wrap gap-3 mb-3">
                <div>
                    <h2 class="text-white font-weight-bold h3 mb-1">
                        <i class="bi bi-map text-info mr-2"></i> Interactive Exhibition Floor Map
                    </h2>
                    <p class="text-secondary small mb-0">
                        Click any booth to inspect research details, availability cooldowns, or simulate NFC scans.
                    </p>
                </div>
            </div>

            <!-- Legend Bar -->
            <div class="map-legend-bar">
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--research-color); border-color: var(--research-stroke);"></span>
                    <span>Research Displays (Baby Blue)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--sponsor-color); border-color: var(--sponsor-stroke);"></span>
                    <span>Sponsor Booths (Light Green)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--recommended-color);"></span>
                    <span class="text-info font-weight-bold">Recommended (Your Roadmap)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--visited-color);"></span>
                    <span>Visited (Checked)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--busy-color);"></span>
                    <span>Busy (5m Cooldown)</span>
                </div>
            </div>

            <!-- SVG Floor Plan Canvas Card -->
            <div class="sitemap-canvas-card">
                <svg id="exhibition-map" class="floor-plan-svg" viewBox="0 0 1060 520">
                    <!-- Research Screen Hall Outer Frame -->
                    <rect x="20" y="20" width="670" height="240" rx="14" fill="#f8fafc" stroke="#1e293b" stroke-width="2.5" />
                    <text x="355" y="130" font-weight="800" font-size="18" fill="#1e293b" text-anchor="middle">Research Screen Hall</text>
                    <text x="355" y="152" font-weight="600" font-size="12" fill="#64748b" text-anchor="middle">30 Research Project Displays</text>

                    <!-- Door Passageway Indicator -->
                    <line x1="690" y1="125" x2="730" y2="125" stroke="#0284c7" stroke-width="3" stroke-dasharray="3 3" />
                    <line x1="690" y1="155" x2="730" y2="155" stroke="#0284c7" stroke-width="3" stroke-dasharray="3 3" />
                    <text x="710" y="142" font-size="9" font-weight="700" fill="#0284c7" text-anchor="middle">DOOR</text>

                    <!-- Sponsor Hall Outer Frame -->
                    <rect x="730" y="20" width="310" height="470" rx="14" fill="#f8fafc" stroke="#1e293b" stroke-width="2.5" />
                    <text x="885" y="55" font-weight="800" font-size="18" fill="#1e293b" text-anchor="middle">Sponsor Hall</text>
                    <text x="885" y="75" font-weight="600" font-size="12" fill="#64748b" text-anchor="middle">15 Sponsor Booths</text>

                    <!-- Main Empty Hall -->
                    <rect x="20" y="280" width="670" height="210" rx="14" fill="#ffffff" stroke="#cbd5e1" stroke-width="2" />
                    <text x="355" y="375" font-weight="800" font-size="18" fill="#94a3b8" text-anchor="middle">Main Hall</text>
                    <text x="355" y="398" font-weight="500" font-size="12" fill="#94a3b8" text-anchor="middle">No exhibition booths in this area</text>

                    <!-- Entrance Arc -->
                    <g transform="translate(885, 490)">
                        <path d="M -35 -20 A 35 35 0 0 1 35 -20" fill="none" stroke="#0f172a" stroke-width="2.5" />
                        <text x="0" y="-30" font-size="11" font-weight="800" fill="#0f172a" text-anchor="middle">↑ ENTRANCE</text>
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
                    <h3 class="font-weight-bold m-0" id="modalTitle">Booth Code</h3>
                    <div class="text-secondary small font-weight-bold" id="modalOrg">Organization</div>
                </div>
                <button type="button" class="close text-secondary" style="font-size: 1.6rem; cursor:pointer;" onclick="closeModal()" aria-label="Close">
                    &times;
                </button>
            </div>

            <p class="text-secondary small mb-3" id="modalCategories" style="line-height: 1.5;"></p>

            <div class="booth-status-row">
                <span>Availability Status:</span>
                <div class="d-flex align-items-center">
                    <span class="booth-status-dot" id="modalStatusDot"></span>
                    <span id="modalStatusText">Available</span>
                </div>
            </div>

            <div id="modalVisitedNote" class="text-success small font-weight-bold mb-3" style="display:none;">
                <i class="bi bi-check-circle-fill mr-1"></i> You have already visited and scanned this booth!
            </div>

            <button type="button" class="cyan-glow-btn w-100 py-3 text-white font-weight-bold" id="btnScan" onclick="simulateNFCScan()">
                <i class="bi bi-broadcast mr-1"></i> Simulate NFC Tag Tap
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

        function initSVGFloorPlan() {
            const container = document.getElementById("booths-layer");
            if (!container) return;
            let markup = "";

            for (const [code, pos] of Object.entries(boothLayout)) {
                const isSponsor = code.startsWith("S");
                const w = isSponsor ? 64 : 42;
                const h = isSponsor ? 30 : 22;

                markup += `
                  <g id="group-${code}" onclick="openBoothModal('${code}')">
                    <rect id="rect-${code}" class="booth-rect" x="${pos.x}" y="${pos.y}" width="${w}" height="${h}" rx="6" />
                    <text id="text-${code}" class="booth-label" x="${pos.x + w / 2}" y="${pos.y + h / 2}">${code}</text>
                    <circle id="check-bg-${code}" cx="${pos.x + w - 4}" cy="${pos.y + 4}" r="6" fill="#10b981" style="display:none;" />
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

                booths.forEach(b => {
                    const rect = document.getElementById(`rect-${b.boothCode}`);
                    const text = document.getElementById(`text-${b.boothCode}`);
                    const checkBg = document.getElementById(`check-bg-${b.boothCode}`);
                    const checkIcon = document.getElementById(`check-icon-${b.boothCode}`);

                    if (!rect) return;

                    const isSponsor = b.boothCode.startsWith("S");

                    // Visual Priority:
                    // 1. Visited (Bright green with check mark)
                    // 2. Busy (Orange/Amber)
                    // 3. Recommended (Deep Royal Blue Highlight)
                    // 4. Default Category Tint (Research: Baby Blue, Sponsor: Light Green)
                    if (b.isVisitedByCurrentUser) {
                        rect.setAttribute("fill", "var(--visited-color)");
                        rect.setAttribute("stroke", "#059669");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "block";
                        if (checkIcon) checkIcon.style.display = "block";
                    } else if (b.status === 1) { // 1 = Busy
                        rect.setAttribute("fill", "var(--busy-color)");
                        rect.setAttribute("stroke", "#d97706");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    } else if (b.isRecommended) {
                        rect.setAttribute("fill", "var(--recommended-color)");
                        rect.setAttribute("stroke", "#0369a1");
                        text.classList.add("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    } else {
                        rect.setAttribute("fill", isSponsor ? "var(--sponsor-color)" : "var(--research-color)");
                        rect.setAttribute("stroke", isSponsor ? "var(--sponsor-stroke)" : "var(--research-stroke)");
                        text.classList.remove("light-text");
                        if (checkBg) checkBg.style.display = "none";
                        if (checkIcon) checkIcon.style.display = "none";
                    }
                });
            } catch (err) {
                console.error("Failed to refresh floor plan:", err);
            }
        }

        function openBoothModal(boothCode) {
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
            catEl.innerText = b && b.categories ? b.categories.join(", ") : "AI, Radiology & Digital Health";

            if (isSponsor) {
                badgeEl.innerText = "Sponsor Hall";
                badgeEl.style.background = "#dcfce7";
                badgeEl.style.color = "#166534";
            } else {
                badgeEl.innerText = "Research Screen Hall";
                badgeEl.style.background = "#dbeafe";
                badgeEl.style.color = "#1e40af";
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
        }

        async function simulateNFCScan() {
            if (!activeSelectedBooth) return;
            try {
                await fetch(`/api/map/scan?boothCode=${encodeURIComponent(activeSelectedBooth)}`, { method: "POST" });
            } catch (e) {
                console.warn(e);
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
