<%@ Page Title="المعرض ومشاركة الشركاء - SAIRH 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Schedules.aspx.cs" Inherits="AIE.Ar_Sa.Schedules" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* SiteMap & Exhibition Floor Custom Styles - Arabic RTL */
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
            text-align: right;
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
            border-right: 4px solid #0284c7;
            border-left: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 16px;
            transition: all 0.2s ease;
            text-align: right;
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
            direction: rtl;
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

        /* Detail Modal Dialog */
        .booth-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(6px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            direction: rtl;
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
            text-align: right;
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
            margin-left: 8px;
            margin-right: 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Exhibition Header">
        <div class="container text-center pt-4 pb-2">
            <span class="badge badge-info rounded-pill px-3 py-2 text-uppercase mb-3 font-weight-bold" style="letter-spacing: 1px;">
                المعرض وخريطة الأجنحة التفاعلية
            </span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                المعرض ومشاركة الشركاء والرعاة
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 800px; font-size: 1.15rem; line-height: 1.8;">
                منصة عالمية رائدة تجمع نخبة مزودي تقنيات الذكاء الاصطناعي والتصوير الطبي، والشركات الناشئة المبتكرة، والمؤسسات البحثية والجهات الصحية الوطنية لعرض أحدث الابتكارات وبناء الشراكات الاستراتيجية.
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
                        <div class="text-white font-weight-bold">مقر المعرض</div>
                        <div class="text-secondary small">مركز معارض جراند حياة الخبر</div>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <i class="bi bi-people text-info display-6"></i>
                    <div>
                        <div class="text-white font-weight-bold">نطاق المشاركة</div>
                        <div class="text-secondary small">15 جناحاً للرعاة و 30 منصة عرض بحثية</div>
                    </div>
                </div>
                <div>
                    <a href="Survey" class="btn btn-outline-info rounded-pill px-4 py-2 font-weight-bold">
                        <i class="bi bi-compass ml-1"></i> استبيان التخصيص
                    </a>
                </div>
            </div>

            <!-- Personalized Roadmap Section -->
            <div id="pnlRoadmap" runat="server" class="expo-roadmap-banner" visible="false">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <span class="badge badge-info px-3 py-1 rounded-pill mb-2"><i class="bi bi-stars ml-1"></i> مسارك الموصى به</span>
                        <h3 class="text-white font-weight-bold mb-1">المحطات المقترحة لزيارتك</h3>
                        <p class="text-light small mb-0" style="opacity: 0.9;">
                            بناءً على إجاباتك في الاستبيان، تم تمييز المواقع أدناه باللون <strong>الأزرق الملكي (Royal Blue)</strong> على خريطة المعرض.
                        </p>
                    </div>
                    <div>
                        <a href="Survey" class="btn btn-sm btn-outline-light rounded-pill px-3 py-2 font-weight-semibold">
                            <i class="bi bi-arrow-repeat ml-1"></i> إعادة الاستبيان
                        </a>
                    </div>
                </div>

                <div class="recommended-cards-grid" id="recCardsContainer" runat="server">
                    <!-- Recommended cards dynamically populated -->
                </div>
            </div>

            <!-- Survey CTA Banner for Guests or Users Without Survey -->
            <div id="pnlSurveyCTA" runat="server" class="roadmap-cta-banner">
                <h4 class="text-white font-weight-bold mb-2">هل ترغب في الحصول على مسار مخصص في المعرض؟</h4>
                <p class="text-secondary small mb-3">
                    أجب عن استبياننا السريع خلال دقيقة واحدة لتسليط الضوء على أجنحة الرعاة وشاشات الأبحاث التي تلائم اهتماماتك وتخصصك.
                </p>
                <a href="Survey" class="cyan-glow-btn d-inline-block px-4 py-2 text-white font-weight-bold text-decoration-none">
                    <i class="bi bi-magic ml-1"></i> بناء مساري المخصص
                </a>
            </div>

            <!-- Map Header & Legend -->
            <div class="d-flex justify-content-between align-items-end flex-wrap gap-3 mb-3">
                <div>
                    <h2 class="text-white font-weight-bold h3 mb-1">
                        <i class="bi bi-map text-info ml-2"></i> خريطة المعرض التفاعلية
                    </h2>
                    <p class="text-secondary small mb-0">
                        انقر على أي جناح أو شاشة عرض للاطلاع على تفاصيل الأبحاث، أو فترات الانتظار، أو محاكاة مسح بطاقة NFC.
                    </p>
                </div>
            </div>

            <!-- Legend Bar -->
            <div class="map-legend-bar">
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--research-color); border-color: var(--research-stroke);"></span>
                    <span>شاشات عرض الأبحاث (سماوي)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--sponsor-color); border-color: var(--sponsor-stroke);"></span>
                    <span>أجنحة الرعاة (أخضر فاتح)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--recommended-color);"></span>
                    <span class="text-info font-weight-bold">موصى بها (مسارك المخصص)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--visited-color);"></span>
                    <span>تمت الزيارة (مع علامة صح)</span>
                </div>
                <div class="legend-pill">
                    <span class="legend-swatch" style="background: var(--busy-color);"></span>
                    <span>مشغول (فترة انتظار 5 د)</span>
                </div>
            </div>

            <!-- SVG Floor Plan Canvas Card -->
            <div class="sitemap-canvas-card">
                <svg id="exhibition-map" class="floor-plan-svg" viewBox="0 0 1060 520">
                    <!-- Research Screen Hall Outer Frame -->
                    <rect x="20" y="20" width="670" height="240" rx="14" fill="#f8fafc" stroke="#1e293b" stroke-width="2.5" />
                    <text x="355" y="130" font-weight="800" font-size="18" fill="#1e293b" text-anchor="middle">قاعة شاشات الأبحاث</text>
                    <text x="355" y="152" font-weight="600" font-size="12" fill="#64748b" text-anchor="middle">30 منصة عرض للمشاريع البحثية</text>

                    <!-- Door Passageway Indicator -->
                    <line x1="690" y1="125" x2="730" y2="125" stroke="#0284c7" stroke-width="3" stroke-dasharray="3 3" />
                    <line x1="690" y1="155" x2="730" y2="155" stroke="#0284c7" stroke-width="3" stroke-dasharray="3 3" />
                    <text x="710" y="142" font-size="9" font-weight="700" fill="#0284c7" text-anchor="middle">بوابة</text>

                    <!-- Sponsor Hall Outer Frame -->
                    <rect x="730" y="20" width="310" height="470" rx="14" fill="#f8fafc" stroke="#1e293b" stroke-width="2.5" />
                    <text x="885" y="55" font-weight="800" font-size="18" fill="#1e293b" text-anchor="middle">قاعة الرعاة والشركاء</text>
                    <text x="885" y="75" font-weight="600" font-size="12" fill="#64748b" text-anchor="middle">15 جناحاً للرعاة</text>

                    <!-- Main Empty Hall -->
                    <rect x="20" y="280" width="670" height="210" rx="14" fill="#ffffff" stroke="#cbd5e1" stroke-width="2" />
                    <text x="355" y="375" font-weight="800" font-size="18" fill="#94a3b8" text-anchor="middle">القاعة الرئيسية</text>
                    <text x="355" y="398" font-weight="500" font-size="12" fill="#94a3b8" text-anchor="middle">لا توجد أجنحة عرض في هذه المساحة</text>

                    <!-- Entrance Arc -->
                    <g transform="translate(885, 490)">
                        <path d="M -35 -20 A 35 35 0 0 1 35 -20" fill="none" stroke="#0f172a" stroke-width="2.5" />
                        <text x="0" y="-30" font-size="11" font-weight="800" fill="#0f172a" text-anchor="middle">↑ المدخل الرئيسي</text>
                    </g>

                    <!-- Interactive SVG Booth Nodes Layer (R1-R30 & S1-S15) -->
                    <g id="booths-layer"></g>
                </svg>
            </div>

            <!-- 6 Pavilions Overview Section -->
            <div class="text-center mb-5 mt-4">
                <h2 class="text-white font-weight-bold display-6">
                    ستضم قاعة العرض ما يلي:
                </h2>
            </div>

            <div class="pavilion-grid">
                <!-- Pavilion 01 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-globe"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 01</span>
                        <h3 class="pavilion-title">الشركات الدولية المتخصصة في الذكاء الاصطناعي والأشعة</h3>
                        <p class="pavilion-desc">كبريات الشركات العالمية المستعرضة لأحدث خوارزميات التشخيص الطبي وأجهزة التصوير المتقدمة.</p>
                    </div>
                </div>

                <!-- Pavilion 02 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-rocket-takeoff"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 02</span>
                        <h3 class="pavilion-title">الشركات الناشئة في مجال الصحة الرقمية</h3>
                        <p class="pavilion-desc">المشاريع الريادية الصاعدة المقدمة لحلول برمجية مبتكرة في أتمتة سير العمل الطبي ورعاية المرضى.</p>
                    </div>
                </div>

                <!-- Pavilion 03 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-mortarboard"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 03</span>
                        <h3 class="pavilion-title">الجامعات ومراكز الأبحاث</h3>
                        <p class="pavilion-desc">المؤسسات الأكاديمية الرائدة ومراكز التميز البحثي لاستعراض الأبحاث السريرية وبراءات الاختراع.</p>
                    </div>
                </div>

                <!-- Pavilion 04 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-bank"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 04</span>
                        <h3 class="pavilion-title">المنظمات الوطنية</h3>
                        <p class="pavilion-desc">الجهات الحكومية والتنظيمية: سدايا، أرامكو الرقمية، وزارة الصحة، والهيئة العامة للغذاء والدواء.</p>
                    </div>
                </div>

                <!-- Pavilion 05 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-lightbulb"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 05</span>
                        <h3 class="pavilion-title">المبتكرون في مجال الرعاية الصحية</h3>
                        <p class="pavilion-desc">الأطباء المبتكرون ومهندسو الطب الحيوي وعلماء البيانات الذين يطورون مستقبل طب الأشعة.</p>
                    </div>
                </div>

                <!-- Pavilion 06 -->
                <div class="pavilion-card">
                    <div class="pavilion-icon-box"><i class="bi bi-heart-pulse"></i></div>
                    <div>
                        <span class="pavilion-badge">القطاع 06</span>
                        <h3 class="pavilion-title">المنظمات غير الربحية</h3>
                        <p class="pavilion-desc">الجمعيات العلمية والمؤسسات غير الربحية المعنية بسلامة المرضى وجودة الممارسات الطبية.</p>
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
                    <span class="booth-modal-badge" id="modalBadge">تفاصيل الجناح</span>
                    <h3 class="font-weight-bold m-0" id="modalTitle">رمز الجناح</h3>
                    <div class="text-secondary small font-weight-bold" id="modalOrg">الجهة العارضة</div>
                </div>
                <button type="button" class="close text-secondary" style="font-size: 1.6rem; cursor:pointer;" onclick="closeModal()" aria-label="إغلاق">
                    &times;
                </button>
            </div>

            <p class="text-secondary small mb-3" id="modalCategories" style="line-height: 1.5;"></p>

            <div class="booth-status-row">
                <span>حالة التوفر:</span>
                <div class="d-flex align-items-center">
                    <span class="booth-status-dot" id="modalStatusDot"></span>
                    <span id="modalStatusText">متاح للزيارة</span>
                </div>
            </div>

            <div id="modalVisitedNote" class="text-success small font-weight-bold mb-3" style="display:none;">
                <i class="bi bi-check-circle-fill ml-1"></i> لقد قمت بزيارة ومسح هذا الجناح مسبقاً!
            </div>

            <button type="button" class="cyan-glow-btn w-100 py-3 text-white font-weight-bold" id="btnScan" onclick="simulateNFCScan()">
                <i class="bi bi-broadcast ml-1"></i> محاكاة مسح بطاقة NFC
            </button>
        </div>
    </div>

    <!-- Interactive SiteMap Script (Arabic) -->
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
                const res = await fetch("/api/map/status?lang=ar");
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
            titleEl.innerText = b ? b.name : (isSponsor ? `جناح الراعي ${boothCode}` : `شاشة عرض أبحاث ${boothCode}`);
            orgEl.innerText = b && b.organization ? b.organization : (isSponsor ? "راعي القمة" : "مبادرة بحثية");
            catEl.innerText = b && b.categories ? b.categories.join("، ") : "الذكاء الاصطناعي، الأشعة والابتكار الصحي";

            if (isSponsor) {
                badgeEl.innerText = "قاعة الرعاة والشركاء";
                badgeEl.style.background = "#dcfce7";
                badgeEl.style.color = "#166534";
            } else {
                badgeEl.innerText = "قاعة شاشات الأبحاث";
                badgeEl.style.background = "#dbeafe";
                badgeEl.style.color = "#1e40af";
            }

            if (b && b.status === 1) {
                dotEl.style.background = "var(--busy-color)";
                statusEl.innerText = `مشغول (متبقي ~${Math.ceil(b.remainingBusySeconds / 60)} دقيقة)`;
            } else {
                dotEl.style.background = "var(--visited-color)";
                statusEl.innerText = "متاح للزيارة";
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
