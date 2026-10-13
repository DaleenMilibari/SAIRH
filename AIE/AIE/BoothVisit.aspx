<%@ Page Title="Booth Visit | SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="BoothVisit.aspx.cs" Inherits="AIE.BoothVisit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/booth-visit.css") %>" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="booth-visit-section">
        <div class="booth-visit-card" id="cardBoothVisit">
            
            <!-- NFC Signal Pulse Beacon -->
            <div class="nfc-beacon-wrap">
                <div class="nfc-beacon-pulse"></div>
                <div class="nfc-beacon-core">
                    <i class="bi bi-broadcast"></i>
                </div>
            </div>

            <!-- Booth Recognition Info -->
            <div id="pnlBoothInfo">
                <div class="booth-tag-badge" id="badgeBoothType">
                    <i class="bi bi-grid-fill"></i> <span id="lblBoothCode">S1</span> &bull; <span id="lblBoothTypeName">Sponsor Booth</span>
                </div>

                <h1 class="booth-title" id="lblBoothName">AI Imaging Sponsor</h1>
                <p class="booth-org" id="lblBoothOrg">
                    <i class="bi bi-building text-info"></i>
                    <span id="lblBoothOrgText">AI Imaging Solutions & Healthcare</span>
                </p>

                <!-- Metadata Row -->
                <div class="booth-meta-row">
                    <span class="booth-meta-pill" id="lblHallPill">
                        <i class="bi bi-geo-alt-fill text-danger"></i> <span id="lblHallText">Sponsor Hall</span>
                    </span>
                    <span class="booth-meta-pill highlight">
                        <i class="bi bi-clock-history"></i> <span id="lblAvgTimeText">5 Min Projected Visit</span>
                    </span>
                    <span class="booth-meta-pill" id="lblCategoryPill">
                        <i class="bi bi-cpu text-info"></i> <span id="lblCategoryText">AI & Medical Imaging</span>
                    </span>
                </div>

                <!-- Personalized Roadmap Match Banner (If applicable) -->
                <div class="roadmap-match-banner" id="pnlRoadmapMatch" style="display: none;">
                    <i class="bi bi-stars"></i>
                    <span>Recommended Stop on Your Personalized Summit Roadmap!</span>
                </div>

                <!-- Step 1: Initial CTA View -->
                <div id="pnlStartView">
                    <button type="button" id="btnStartVisit" class="btn-start-visit" onclick="startBoothVisitTimer()">
                        <i class="bi bi-play-circle-fill"></i>
                        <span>I'm about to visit this booth</span>
                    </button>
                    <p class="btn-subtext">
                        Tap when arriving at the booth to start your projected 5-minute timer and record your visit.
                    </p>
                </div>
            </div>

            <!-- Step 2: Active Countdown Timer View (Appears on click) -->
            <div id="pnlTimerView" class="timer-container">
                <div class="visit-status-badge">
                    <span class="pulse-dot"></span>
                    <span>Visit in Progress &bull; Projected Time: <span id="lblTimerDurationMins">5</span> Min</span>
                </div>

                <!-- Circular Progress Timer -->
                <div class="timer-circle-wrap">
                    <svg class="timer-svg" viewBox="0 0 100 100">
                        <defs>
                            <linearGradient id="timerGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" stop-color="#06b6d4" />
                                <stop offset="100%" stop-color="#10b981" />
                            </linearGradient>
                        </defs>
                        <circle class="timer-bg-circle" cx="50" cy="50" r="42" />
                        <circle class="timer-progress-circle" id="timerProgressCircle" cx="50" cy="50" r="42" stroke-dasharray="263.89" stroke-dashoffset="0" />
                    </svg>
                    <div class="timer-inner-content">
                        <div class="timer-digits" id="timerDisplay">05:00</div>
                        <div class="timer-label">Remaining</div>
                    </div>
                </div>

                <!-- Active Actions -->
                <div class="timer-actions">
                    <button type="button" class="btn-complete-visit" onclick="completeBoothVisit()">
                        <i class="bi bi-check-circle-fill mr-1"></i> I Have Finished My Visit
                    </button>
                    <a href="Schedules" class="btn-secondary-link" id="lnkFloorMap">
                        <i class="bi bi-map mr-1"></i> View on Exhibition Floor Map
                    </a>
                </div>
            </div>

            <!-- Step 3: Visit Completed Celebration View -->
            <div id="pnlSuccessView" class="visit-success-state">
                <div class="visit-success-icon">
                    <i class="bi bi-check2-circle"></i>
                </div>
                <h3 class="text-white font-weight-bold mb-2">Booth Visit Recorded!</h3>
                <p class="text-secondary small mb-4">
                    Your visit has been logged to your attendance record and updated on your Exhibition Map.
                </p>
                <div class="d-flex flex-column gap-2">
                    <a href="Schedules" class="btn btn-primary rounded-pill py-3 font-weight-bold">
                        <i class="bi bi-map mr-1"></i> Continue on Exhibition Map
                    </a>
                    <a href="Profile" class="btn btn-outline-light rounded-pill py-2 small font-weight-semibold">
                        <i class="bi bi-person-badge mr-1"></i> My Profile & Roadmap
                    </a>
                </div>
            </div>

            <!-- Fallback: Manual Code Input if Scanned Without Code -->
            <div class="manual-code-box" id="pnlManualInput" style="display: none;">
                <p class="small text-secondary mb-1">Looking for a specific booth?</p>
                <div class="manual-code-input-group">
                    <input type="text" id="txtManualCode" class="manual-code-input" placeholder="e.g. S1 or R4" maxlength="5" />
                    <button type="button" class="manual-code-btn" onclick="goToManualCode()">Go</button>
                </div>
            </div>

        </div>
    </section>

    <script>
        (function () {
            // Booth data repository
            var BOOTHS_DATA = {
                "S1": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "AI Imaging Sponsor S1", orgEn: "AI Imaging Solutions", hallEn: "Sponsor Hall", catEn: "AI & Digital Technology", mins: 5 },
                "S2": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Radiology Technology S2", orgEn: "Healthcare Tech Group", hallEn: "Sponsor Hall", catEn: "Medical Imaging", mins: 5 },
                "S3": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Healthcare Innovation S3", orgEn: "Health Innovation Corp", hallEn: "Sponsor Hall", catEn: "Health Innovation", mins: 5 },
                "S4": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "AI Solutions Sponsor S4", orgEn: "AI Health Partner", hallEn: "Sponsor Hall", catEn: "AI & Solutions", mins: 5 },
                "S5": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Medical Imaging Sponsor S5", orgEn: "Global Med Imaging", hallEn: "Sponsor Hall", catEn: "Medical Imaging", mins: 5 },
                "S6": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "University Partner S6", orgEn: "Academic & Medical Faculty", hallEn: "Sponsor Hall", catEn: "Research & Education", mins: 5 },
                "S7": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Health Organization S7", orgEn: "National Health Alliance", hallEn: "Sponsor Hall", catEn: "Healthcare Solutions", mins: 5 },
                "S8": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Medical Technology S8", orgEn: "Advanced Tech Healthcare", hallEn: "Sponsor Hall", catEn: "Healthcare Technology", mins: 5 },
                "S9": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "AI Healthcare Sponsor S9", orgEn: "Smart Health AI Corp", hallEn: "Sponsor Hall", catEn: "AI Healthcare", mins: 5 },
                "S10": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Startup Sponsor S10", orgEn: "HealthTech Accelerator", hallEn: "Sponsor Hall", catEn: "Startups & Innovation", mins: 5 },
                "S11": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Digital Health Sponsor S11", orgEn: "Digital Health Hub", hallEn: "Sponsor Hall", catEn: "Digital Health", mins: 5 },
                "S12": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Research Partner S12", orgEn: "National Radiology Institute", hallEn: "Sponsor Hall", catEn: "Clinical Research", mins: 5 },
                "S13": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Clinical Tech Sponsor S13", orgEn: "Clinical Systems International", hallEn: "Sponsor Hall", catEn: "Medical Imaging", mins: 5 },
                "S14": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "Innovation Sponsor S14", orgEn: "Future Radiology Group", hallEn: "Sponsor Hall", catEn: "Health Innovation", mins: 5 },
                "S15": { type: "SponsorBooth", typeEn: "Sponsor Booth", nameEn: "AI Research Sponsor S15", orgEn: "AI Clinical Trials Alliance", hallEn: "Sponsor Hall", catEn: "AI Research", mins: 5 }
            };

            // Generate research screens R1 to R30
            for (var i = 1; i <= 30; i++) {
                var code = "R" + i;
                BOOTHS_DATA[code] = {
                    type: "ResearchScreen",
                    typeEn: "Research Display Screen",
                    nameEn: "Research Display Screen " + code,
                    orgEn: "Clinical Research Program " + i,
                    hallEn: "Research Screen Hall",
                    catEn: (i % 2 === 0 ? "AI & Clinical Imaging" : "Radiology Research & Diagnostics"),
                    mins: 5
                };
            }

            // Extract 'code' parameter
            var urlParams = new URLSearchParams(window.location.search);
            var boothCode = (urlParams.get('code') || '').trim().toUpperCase();

            window.currentBoothCode = boothCode;
            var booth = BOOTHS_DATA[boothCode];

            if (!booth) {
                // If invalid or missing, fallback to S1 or show manual input
                if (boothCode) {
                    booth = {
                        type: (boothCode.startsWith('S') ? "SponsorBooth" : "ResearchScreen"),
                        typeEn: (boothCode.startsWith('S') ? "Sponsor Booth" : "Research Display Screen"),
                        nameEn: "Summit Exhibition " + boothCode,
                        orgEn: "SAIRH Healthcare Partner",
                        hallEn: (boothCode.startsWith('S') ? "Sponsor Hall" : "Research Screen Hall"),
                        catEn: "AI & Health Innovation",
                        mins: 5
                    };
                } else {
                    document.getElementById('pnlManualInput').style.display = 'block';
                    boothCode = "S1";
                    booth = BOOTHS_DATA["S1"];
                }
            }

            // Hydrate UI elements
            document.getElementById('lblBoothCode').textContent = boothCode;
            document.getElementById('lblBoothTypeName').textContent = booth.typeEn;
            document.getElementById('lblBoothName').textContent = booth.nameEn;
            document.getElementById('lblBoothOrgText').textContent = booth.orgEn;
            document.getElementById('lblHallText').textContent = booth.hallEn;
            document.getElementById('lblCategoryText').textContent = booth.catEn;
            document.getElementById('lblAvgTimeText').textContent = booth.mins + " Min Projected Visit";
            document.getElementById('lblTimerDurationMins').textContent = booth.mins;

            // Check if recommended on roadmap (stored in localStorage or cookie)
            try {
                var savedRoadmap = JSON.parse(localStorage.getItem('sairh_survey_roadmap') || '[]');
                if (savedRoadmap.indexOf(boothCode) !== -1) {
                    document.getElementById('pnlRoadmapMatch').style.display = 'flex';
                }
            } catch (e) {}

            // Timer state variables
            var timerInterval = null;
            var totalSeconds = (booth.mins || 5) * 60;
            var remainingSeconds = totalSeconds;
            var circleLength = 263.89; // 2 * pi * 42

            window.startBoothVisitTimer = function () {
                // Register visit in backend DB / API
                fetch('/api/booth/visit', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ boothCode: boothCode, action: 'start' })
                }).catch(function () {});
                fetch('/api/map/scan?boothCode=' + encodeURIComponent(boothCode), { method: 'POST' }).catch(function () {});

                // Store in localStorage for visited markers
                try {
                    var visited = JSON.parse(localStorage.getItem('sairh_visited_booths') || '[]');
                    if (visited.indexOf(boothCode) === -1) {
                        visited.push(boothCode);
                        localStorage.setItem('sairh_visited_booths', JSON.stringify(visited));
                    }
                } catch (e) {}

                // Switch UI to timer view
                document.getElementById('pnlStartView').style.display = 'none';
                document.getElementById('pnlTimerView').style.display = 'block';

                updateTimerDisplay();

                timerInterval = setInterval(function () {
                    remainingSeconds--;
                    if (remainingSeconds <= 0) {
                        clearInterval(timerInterval);
                        remainingSeconds = 0;
                        updateTimerDisplay();
                        onTimerComplete();
                    } else {
                        updateTimerDisplay();
                    }
                }, 1000);
            };

            function updateTimerDisplay() {
                var m = Math.floor(remainingSeconds / 60);
                var s = remainingSeconds % 60;
                var formatted = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
                document.getElementById('timerDisplay').textContent = formatted;

                // Update circular progress offset
                var progressFraction = (totalSeconds - remainingSeconds) / totalSeconds;
                var offset = circleLength * (1 - progressFraction);
                document.getElementById('timerProgressCircle').style.strokeDashoffset = offset;
            }

            window.completeBoothVisit = function () {
                if (timerInterval) clearInterval(timerInterval);
                fetch('/api/booth/visit', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ boothCode: boothCode, action: 'complete' })
                }).catch(function () {});
                document.getElementById('pnlTimerView').style.display = 'none';
                document.getElementById('pnlBoothInfo').style.display = 'none';
                document.getElementById('pnlSuccessView').style.display = 'block';
            };

            function onTimerComplete() {
                document.getElementById('timerDisplay').textContent = "00:00";
                document.getElementById('timerProgressCircle').style.stroke = "#10b981";
            }

            window.goToManualCode = function () {
                var val = (document.getElementById('txtManualCode').value || '').trim().toUpperCase();
                if (val) {
                    window.location.href = 'BoothVisit?code=' + encodeURIComponent(val);
                }
            };
        })();
    </script>
</asp:Content>
