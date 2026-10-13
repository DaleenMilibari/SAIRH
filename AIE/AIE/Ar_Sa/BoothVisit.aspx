<%@ Page Title="زيارة الجناح | ملتقى الذكاء الاصطناعي في الأشعة 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="BoothVisit.aspx.cs" Inherits="AIE.Ar_Sa.BoothVisit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/booth-visit.css") %>" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="booth-visit-section" dir="rtl">
        <div class="booth-visit-card" id="cardBoothVisit">
            
            <!-- إشارة الاستشعار الذكية NFC Signal Pulse Beacon -->
            <div class="nfc-beacon-wrap">
                <div class="nfc-beacon-pulse"></div>
                <div class="nfc-beacon-core">
                    <i class="bi bi-broadcast"></i>
                </div>
            </div>

            <!-- معلومات التعرف على الجناح Booth Recognition Info -->
            <div id="pnlBoothInfo">
                <div class="booth-tag-badge" id="badgeBoothType">
                    <i class="bi bi-grid-fill"></i> <span id="lblBoothCode">S1</span> &bull; <span id="lblBoothTypeName">جناح الراعي</span>
                </div>

                <h1 class="booth-title" id="lblBoothName">راعي الذكاء الاصطناعي في التصوير الطبي</h1>
                <p class="booth-org" id="lblBoothOrg">
                    <i class="bi bi-building text-info"></i>
                    <span id="lblBoothOrgText">حلول الذكاء الاصطناعي للتصوير الطبي والرعاية الصحية</span>
                </p>

                <!-- شريط البيانات الوصفية Metadata Row -->
                <div class="booth-meta-row">
                    <span class="booth-meta-pill" id="lblHallPill">
                        <i class="bi bi-geo-alt-fill text-danger"></i> <span id="lblHallText">قاعة الرعاة</span>
                    </span>
                    <span class="booth-meta-pill highlight">
                        <i class="bi bi-clock-history"></i> <span id="lblAvgTimeText">5 دقائق - متوسط وقت الزيارة المتوقع</span>
                    </span>
                    <span class="booth-meta-pill" id="lblCategoryPill">
                        <i class="bi bi-cpu text-info"></i> <span id="lblCategoryText">الذكاء الاصطناعي والأشعة الرقمية</span>
                    </span>
                </div>

                <!-- إشعار التوصية المخصصة على مسار الملتقى -->
                <div class="roadmap-match-banner" id="pnlRoadmapMatch" style="display: none;">
                    <i class="bi bi-stars"></i>
                    <span>محطة موصى بها ضمن خارطة طريقك المخصصة للملتقى!</span>
                </div>

                <!-- الخطوة 1: زر بدء الزيارة الرئيسي Initial CTA View -->
                <div id="pnlStartView">
                    <button type="button" id="btnStartVisit" class="btn-start-visit" onclick="startBoothVisitTimer()">
                        <i class="bi bi-play-circle-fill"></i>
                        <span>سأقوم بزيارة هذا الجناح الآن</span>
                    </button>
                    <p class="btn-subtext">
                        اضغط عند وصولك للجناح لبدء العد التنازلي للوقت المتوقع (5 دقائق) وتسجيل زيارتك في بطاقتك.
                    </p>
                </div>
            </div>

            <!-- الخطوة 2: شاشة المؤقت النشط Active Countdown Timer View -->
            <div id="pnlTimerView" class="timer-container">
                <div class="visit-status-badge">
                    <span class="pulse-dot"></span>
                    <span>الزيارة جارية الآن &bull; الوقت المتوقع: <span id="lblTimerDurationMins">5</span> دقائق</span>
                </div>

                <!-- العداد الدائري المتحرك Circular Progress Timer -->
                <div class="timer-circle-wrap">
                    <svg class="timer-svg" viewBox="0 0 100 100">
                        <defs>
                            <linearGradient id="timerGradientAr" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" stop-color="#06b6d4" />
                                <stop offset="100%" stop-color="#10b981" />
                            </linearGradient>
                        </defs>
                        <circle class="timer-bg-circle" cx="50" cy="50" r="42" />
                        <circle class="timer-progress-circle" id="timerProgressCircle" cx="50" cy="50" r="42" stroke-dasharray="263.89" stroke-dashoffset="0" />
                    </svg>
                    <div class="timer-inner-content">
                        <div class="timer-digits" id="timerDisplay">05:00</div>
                        <div class="timer-label">المتبقي</div>
                    </div>
                </div>

                <!-- أزرار التفاعل أثناء الزيارة -->
                <div class="timer-actions">
                    <button type="button" class="btn-complete-visit" onclick="completeBoothVisit()">
                        <i class="bi bi-check-circle-fill ml-1"></i> أنهيت زيارتي للجناح
                    </button>
                    <a href="Schedules" class="btn-secondary-link" id="lnkFloorMap">
                        <i class="bi bi-map ml-1"></i> استعراض خريطة المعرض وقاعات الملتقى
                    </a>
                </div>
            </div>

            <!-- الخطوة 3: شاشة نجاح الزيارة Visit Completed View -->
            <div id="pnlSuccessView" class="visit-success-state">
                <div class="visit-success-icon">
                    <i class="bi bi-check2-circle"></i>
                </div>
                <h3 class="text-white font-weight-bold mb-2">تم تسجيل زيارة الجناح بنجاح!</h3>
                <p class="text-secondary small mb-4">
                    تم توثيق حضورك في هذا الجناح وتحديث سجلك في خريطة المعرض وخارطة طريقك التفاعلية.
                </p>
                <div class="d-flex flex-column gap-2">
                    <a href="Schedules" class="btn btn-primary rounded-pill py-3 font-weight-bold">
                        <i class="bi bi-map ml-1"></i> متابعة الاستكشاف على خريطة المعرض
                    </a>
                    <a href="Profile" class="btn btn-outline-light rounded-pill py-2 small font-weight-semibold">
                        <i class="bi bi-person-badge ml-1"></i> ملفي الشخصي وخارطة الطريق
                    </a>
                </div>
            </div>

            <!-- إدخال يدوي عند فتح الصفحة بدون رمز NFC -->
            <div class="manual-code-box" id="pnlManualInput" style="display: none;">
                <p class="small text-secondary mb-1">هل تبحث عن جناح أو شاشة بحثية محددة؟</p>
                <div class="manual-code-input-group">
                    <input type="text" id="txtManualCode" class="manual-code-input text-uppercase text-center" placeholder="مثال: S1 أو R4" maxlength="5" />
                    <button type="button" class="manual-code-btn" onclick="goToManualCode()">انتقال</button>
                </div>
            </div>

        </div>
    </section>

    <script>
        (function () {
            // مستودع بيانات أجنحة الرعاة والشاشات البحثية
            var BOOTHS_DATA = {
                "S1": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "راعي الذكاء الاصطناعي في التصوير الطبي S1", orgAr: "حلول التصوير الطبي الذكي", hallAr: "قاعة الرعاة", catAr: "الذكاء الاصطناعي والتقنية الرقمية", mins: 5 },
                "S2": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "تقنيات الأشعة والتشخيص S2", orgAr: "مجموعة تقنيات الرعاية الصحية", hallAr: "قاعة الرعاة", catAr: "التصوير الطبي والأشعة", mins: 5 },
                "S3": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "ابتكارات الرعاية الصحية S3", orgAr: "شركة الابتكار الصحي", hallAr: "قاعة الرعاة", catAr: "الابتكار في الرعاية الصحية", mins: 5 },
                "S4": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "حلول الذكاء الاصطناعي السريري S4", orgAr: "شريك الذكاء الاصطناعي الصحي", hallAr: "قاعة الرعاة", catAr: "الحلول والذكاء الاصطناعي", mins: 5 },
                "S5": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "أنظمة التصوير الطبي المتقدمة S5", orgAr: "الأنظمة العالمية للتصوير الطبي", hallAr: "قاعة الرعاة", catAr: "التصوير الطبي التشخيصي", mins: 5 },
                "S6": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "الشريك الأكاديمي والجامعي S6", orgAr: "كليات الطب والبحوث الصحية", hallAr: "قاعة الرعاة", catAr: "البحوث والتعليم الطبي", mins: 5 },
                "S7": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "مؤسسة الرعاية الصحية S7", orgAr: "التحالف الوطني للرعاية الصحية", hallAr: "قاعة الرعاة", catAr: "حلول الرعاية الصحية", mins: 5 },
                "S8": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "التقنيات الطبية المتقدمة S8", orgAr: "شركة التكنولوجيا الطبية المتقدمة", hallAr: "قاعة الرعاة", catAr: "التكنولوجيا الطبية", mins: 5 },
                "S9": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "حلول الذكاء الاصطناعي الطبي S9", orgAr: "مؤسسة سمارت هيلث للذكاء الاصطناعي", hallAr: "قاعة الرعاة", catAr: "الذكاء الاصطناعي الطبي", mins: 5 },
                "S10": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "حاضنة الشركات الناشئة S10", orgAr: "مسرعة التقنيات الصحية", hallAr: "قاعة الرعاة", catAr: "الشركات الناشئة والابتكار", mins: 5 },
                "S11": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "الصحة الرقمية والتطبيب عن بعد S11", orgAr: "مركز الصحة الرقمية المتقدمة", hallAr: "قاعة الرعاة", catAr: "الصحة الرقمية", mins: 5 },
                "S12": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "شريك البحوث والتجارب السريرية S12", orgAr: "المعهد الوطني لأبحاث الأشعة", hallAr: "قاعة الرعاة", catAr: "الأبحاث السريرية", mins: 5 },
                "S13": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "الأنظمة السريرية التخصصية S13", orgAr: "الأنظمة السريرية الدولية", hallAr: "قاعة الرعاة", catAr: "التصوير الطبي والأشعة", mins: 5 },
                "S14": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "مستقبل الأشعة والذكاء الاصطناعي S14", orgAr: "مجموعة مستقبل الأشعة للرعاية", hallAr: "قاعة الرعاة", catAr: "الابتكار الصحي", mins: 5 },
                "S15": { type: "SponsorBooth", typeAr: "جناح الراعي", nameAr: "أبحاث الذكاء الاصطناعي السريرية S15", orgAr: "تحالف أبحاث الذكاء الاصطناعي الصحي", hallAr: "قاعة الرعاة", catAr: "أبحاث الذكاء الاصطناعي", mins: 5 }
            };

            // إنشاء الشاشات البحثية R1 إلى R30
            for (var i = 1; i <= 30; i++) {
                var code = "R" + i;
                BOOTHS_DATA[code] = {
                    type: "ResearchScreen",
                    typeAr: "شاشة عرض بحثية",
                    nameAr: "شاشة العرض البحثي " + code,
                    orgAr: "برنامج البحوث السريرية التخصصية " + i,
                    hallAr: "قاعة الشاشات البحثية",
                    catAr: (i % 2 === 0 ? "الذكاء الاصطناعي والتصوير السريري" : "أبحاث الأشعة والتشخيص المتقدم"),
                    mins: 5
                };
            }

            // استخراج رمز الجناح من الرابط
            var urlParams = new URLSearchParams(window.location.search);
            var boothCode = (urlParams.get('code') || '').trim().toUpperCase();

            window.currentBoothCode = boothCode;
            var booth = BOOTHS_DATA[boothCode];

            if (!booth) {
                if (boothCode) {
                    booth = {
                        type: (boothCode.startsWith('S') ? "SponsorBooth" : "ResearchScreen"),
                        typeAr: (boothCode.startsWith('S') ? "جناح الراعي" : "شاشة عرض بحثية"),
                        nameAr: "معرض الملتقى " + boothCode,
                        orgAr: "شريك ملتقى الذكاء الاصطناعي في الأشعة",
                        hallAr: (boothCode.startsWith('S') ? "قاعة الرعاة" : "قاعة الشاشات البحثية"),
                        catAr: "الذكاء الاصطناعي والابتكار الصحي",
                        mins: 5
                    };
                } else {
                    document.getElementById('pnlManualInput').style.display = 'block';
                    boothCode = "S1";
                    booth = BOOTHS_DATA["S1"];
                }
            }

            // تحديث واجهة المستخدم
            document.getElementById('lblBoothCode').textContent = boothCode;
            document.getElementById('lblBoothTypeName').textContent = booth.typeAr;
            document.getElementById('lblBoothName').textContent = booth.nameAr;
            document.getElementById('lblBoothOrgText').textContent = booth.orgAr;
            document.getElementById('lblHallText').textContent = booth.hallAr;
            document.getElementById('lblCategoryText').textContent = booth.catAr;
            document.getElementById('lblAvgTimeText').textContent = booth.mins + " دقائق - متوسط وقت الزيارة المتوقع";
            document.getElementById('lblTimerDurationMins').textContent = booth.mins;

            // التحقق من تواجد الجناح في خارطة طريق المشترك
            try {
                var savedRoadmap = JSON.parse(localStorage.getItem('sairh_survey_roadmap') || '[]');
                if (savedRoadmap.indexOf(boothCode) !== -1) {
                    document.getElementById('pnlRoadmapMatch').style.display = 'flex';
                }
            } catch (e) {}

            // متغيرات المؤقت
            var timerInterval = null;
            var totalSeconds = (booth.mins || 5) * 60;
            var remainingSeconds = totalSeconds;
            var circleLength = 263.89;

            window.startBoothVisitTimer = function () {
                // إرسال طلب تسجيل الزيارة للواجهة الخلفية
                fetch('/api/booth/visit', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ boothCode: boothCode, action: 'start' })
                }).catch(function () {});
                fetch('/api/map/scan?boothCode=' + encodeURIComponent(boothCode), { method: 'POST' }).catch(function () {});

                // حفظ الزيارة محلياً
                try {
                    var visited = JSON.parse(localStorage.getItem('sairh_visited_booths') || '[]');
                    if (visited.indexOf(boothCode) === -1) {
                        visited.push(boothCode);
                        localStorage.setItem('sairh_visited_booths', JSON.stringify(visited));
                    }
                } catch (e) {}

                // الانتقال لشاشة العداد
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
