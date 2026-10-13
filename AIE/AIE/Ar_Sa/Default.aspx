<%@ Page Title="القمة السعودية للذكاء الاصطناعي في الاشعة والابتكار الصحي" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AIE.Ar_Sa.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section (Arabic, AI-Powered Liquid Glass Hero) -->
    <section aria-label="Summit Hero" class="landing-hero-section text-light" style="background-image: linear-gradient(to left, rgba(4, 8, 22, 0.75) 0%, rgba(4, 8, 22, 0.45) 35%, rgba(4, 8, 22, 0.05) 65%, transparent 100%), linear-gradient(to bottom, transparent 80%, #040816 100%), url('<%= ResolveUrl("~/Content/images/background/hero-ai-ar-bg.png") %>') !important; background-position: left center !important; background-size: cover !important; background-repeat: no-repeat !important;">
        <button type="button" class="hero-arrow-btn hero-arrow-left" aria-label="الشريحة السابقة">
            <i class="bi bi-chevron-left"></i>
        </button>
        <button type="button" class="hero-arrow-btn hero-arrow-right" aria-label="الشريحة التالية">
            <i class="bi bi-chevron-right"></i>
        </button>

        <div class="container">
            <div id="heroSummitCarousel" class="carousel slide carousel-fade hero-carousel" data-ride="carousel" data-interval="6000" data-pause="hover">
                <div class="carousel-inner">
                    <!-- Slide 1: Main Summit Overview (Existing Hero with Typed 2026 Effect) -->
                    <div class="carousel-item active" data-slide-index="0">
                        <div class="row align-items-center justify-content-start">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-right">
                                <div class="hero-slide-stage">
                                    <h1 class="hero-slide-title font-weight-bold text-white mb-2">
                                        القمة السعودية للذكاء الاصطناعي في الاشعة والابتكار الصحي
                                    </h1>

                                    <div class="hero-typed-wrap">
                                        <div class="typed-strings">
                                            <p>2026</p>
                                        </div>
                                        <div class="typed display-4 font-weight-bold text-info"></div>
                                    </div>

                                    <!-- Summit Quick Info Strip -->
                                    <div class="hero-meta-strip">
                                        <div class="hero-meta-item">
                                            <i class="bi bi-geo-alt"></i>
                                            <span>جراند حياة الخبر</span>
                                        </div>
                                        <div class="hero-meta-item">
                                            <i class="bi bi-calendar3"></i>
                                            <span>13 ديسمبر 2026</span>
                                        </div>
                                        <div class="hero-meta-item">
                                            <i class="bi bi-stack"></i>
                                            <span>3 مسارات علمية</span>
                                        </div>
                                    </div>

                                    <!-- Main Action CTAs -->
                                    <div class="hero-cta-group">
                                        <a href="Ceremony" class="cyan-glow-btn">
                                            <i class="bi bi-calendar2-check ml-1"></i> البرنامج والمسارات
                                        </a>
                                        <a href="#qr-section" class="action-pill text-white">
                                            <i class="bi bi-qr-code ml-1"></i> بطاقة المشاركة
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Slide 2: Summit Inauguration Live Countdown Timer (13 December, 09:00 AM AST) -->
                    <div class="carousel-item" data-slide-index="1">
                        <div class="row align-items-center justify-content-start">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-right">
                                <div class="hero-slide-stage">
                                    <h2 class="hero-slide-title font-weight-bold text-white mb-2">
                                        العد التنازلي لانطلاق عصر جديد في ذكاء الأشعة
                                    </h2>

                                    <!-- Live Liquid-Glass Countdown Display -->
                                    <div class="hero-countdown-grid" role="timer" aria-label="العد التنازلي لانطلاق القمة">
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-days" aria-label="أيام">--</div>
                                            <div class="hero-countdown-label">أيام</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-hours" aria-label="ساعات">--</div>
                                            <div class="hero-countdown-label">ساعات</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-minutes" aria-label="دقائق">--</div>
                                            <div class="hero-countdown-label">دقائق</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-seconds" aria-label="ثوانٍ">--</div>
                                            <div class="hero-countdown-label">ثوانٍ</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Slide 3: Royal Quote & Portrait of HRH Crown Prince Mohammed bin Salman -->
                    <div class="carousel-item" data-slide-index="2">
                        <div class="row align-items-center justify-content-start">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-right">
                                <div class="hero-slide-stage">
                                    <div class="royal-quote-wrapper">
                                        <div class="royal-portrait-frame">
                                            <img src="<%= ResolveUrl("~/Content/images/mbs-portrait.jpg") %>" alt="صاحب السمو الملكي الأمير محمد بن سلمان بن عبدالعزيز آل سعود" class="royal-portrait-img" />
                                        </div>
                                        <div class="royal-content-col">
                                            <div class="royal-quote-box">
                                                <i class="bi bi-quote royal-quote-icon"></i>
                                                <blockquote class="royal-quote-text royal-quote-text-ar">
                                                    «أدعوكم جميعًا للعمل بروح التعاون لنرسم معًا مستقبل الذكاء الاصطناعي بما يخدم المجتمعات كافة، ويقدم المشاركة على التنافس، ويركز على سبل الاستخدام الموثوق والمسؤول للذكاء الاصطناعي وتطبيقاته، خدمةً للبشرية»
                                                </blockquote>
                                            </div>
                                            <div class="royal-attribution">
                                                <h3 class="royal-author-name">
                                                    صاحب السمو الملكي الأمير محمد بن سلمان بن عبدالعزيز آل سعود <span class="royal-blessing">- حفظه الله -</span>
                                                </h3>
                                                <div class="royal-author-title">
                                                    <i class="bi bi-patch-check-fill ml-1"></i>
                                                    <span>ولي العهد رئيس مجلس الوزراء</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Centered Liquid Glass Indicators at Bottom -->
                <div class="hero-carousel-indicators" role="tablist" aria-label="اختيار الشريحة">
                    <button type="button" class="hero-indicator-dot active" data-slide-to="0" aria-label="الشريحة 1: نظرة عامة"></button>
                    <button type="button" class="hero-indicator-dot" data-slide-to="1" aria-label="الشريحة 2: العد التنازلي"></button>
                    <button type="button" class="hero-indicator-dot" data-slide-to="2" aria-label="الشريحة 3: الرؤية الملكية"></button>
                </div>
            </div>
        </div>
    </section>

    <!-- Dedicated Live Summit Telemetry & Session Hub (Identical to LiveDashboard Mini-Project) -->
    <section id="dashboard-section" aria-label="البوابة المباشرة للقمة" class="py-5">
        <div class="container">
            <!-- Section Title -->
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">لوحة المتابعة الحية للمؤتمر</h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 20px; border-radius: 2px;"></div>
            </div>

            <!-- Complete Live Dashboard Widget (Exact Replica of Mini-Project in Arabic) -->
            <div class="sairh-live-widget" lang="ar" dir="rtl">
                <div class="sairh-background-pattern" aria-hidden="true">
                    <span class="sairh-orb sairh-orb-one"></span>
                    <span class="sairh-orb sairh-orb-two"></span>
                    <span class="sairh-grid-glow"></span>
                </div>

                <!-- شريط الحالة المباشر (توقيت حي ومؤشر البث بدون ترويسة مكررة) -->
                <div class="sairh-telemetry-bar">
                    <div class="sairh-telemetry-left">
                        <span class="sairh-telemetry-badge">
                            <i class="bi bi-circle-fill text-danger"></i> جدول القمة الحي
                        </span>
                        <span class="sairh-track-tag">
                            <i class="bi bi-calendar2-check"></i> اليوم الأول &bull; 8 جلسات علمية
                        </span>
                    </div>
                    <div class="sairh-current-time" data-locale="ar-SA"></div>
                </div>

                <!-- Slider with all 8 Sessions from sessions.json in Arabic -->
                <div class="sairh-slider">
                    <!-- الجلسة 1 -->
                    <article class="sairh-session-slide active"
                             data-start="2026-10-01T07:00:00"
                             data-end="2026-10-01T07:45:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. أحمد القحطاني"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. أحمد القحطاني</h3>
                            <p class="sairh-speaker-role">استشاري أشعة</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>جامعة الإمام عبدالرحمن بن فيصل</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار الأشعة التشخيصية
                                </span>
                                <div class="sairh-status live">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">يعرض الآن</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">الذكاء الاصطناعي في الأشعة التشخيصية</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">القاعة الرئيسية</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">07:00 AM &ndash; 07:45 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">متبقي على نهاية الجلسة</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">جلسة حية</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 75%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 2 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T08:00:00"
                             data-end="2026-10-01T08:45:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. سارة محمد"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. سارة محمد</h3>
                            <p class="sairh-speaker-role">أستاذ مساعد في الذكاء الاصطناعي</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>مستشفى الملك فهد الجامعي</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار التعلم العميق
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">تطبيقات التعلم العميق في التصوير الطبي</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">القاعة ب</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">08:00 AM &ndash; 08:45 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 3 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T09:00:00"
                             data-end="2026-10-01T09:50:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. ريم الحربي"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. ريم الحربي</h3>
                            <p class="sairh-speaker-role">استشارية أشعة تشخيصية</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>مستشفى الملك فهد التخصصي</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار التطبيقات السريرية
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">الذكاء الاصطناعي التوليدي في تقارير الأشعة</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">القاعة ج</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">09:00 AM &ndash; 09:50 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 4 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T10:15:00"
                             data-end="2026-10-01T11:00:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. فهد الزهراني"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. فهد الزهراني</h3>
                            <p class="sairh-speaker-role">باحث في معالجة الصور الطبية</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>مدينة الملك عبدالعزيز للعلوم والتقنية</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار تقنيات التصوير الطبي
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">تحسين جودة صور الأشعة باستخدام الذكاء الاصطناعي</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">القاعة د</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">10:15 AM &ndash; 11:00 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 5 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T11:30:00"
                             data-end="2026-10-01T12:15:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. نورة الدوسري"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. نورة الدوسري</h3>
                            <p class="sairh-speaker-role">باحثة في أخلاقيات الذكاء الاصطناعي</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>جامعة الملك سعود</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار أخلاقيات الذكاء الاصطناعي
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">الذكاء الاصطناعي المسؤول في المجال الصحي</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">قاعة الورش</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">11:30 AM &ndash; 12:15 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 6 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T13:00:00"
                             data-end="2026-10-01T13:50:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. ليان الغامدي"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. ليان الغامدي</h3>
                            <p class="sairh-speaker-role">استشارية أشعة أورام</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>مركز الملك فهد للأورام</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار الأورام والذكاء الاصطناعي
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">استخدام الذكاء الاصطناعي في الكشف المبكر عن الأورام</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">القاعة الرئيسية</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">01:00 PM &ndash; 01:50 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 7 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T14:15:00"
                             data-end="2026-10-01T15:00:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="د. يوسف السالم"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">د. يوسف السالم</h3>
                            <p class="sairh-speaker-role">أستاذ المعلوماتية الصحية</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>جامعة الملك فيصل</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار المعلوماتية الصحية
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">دور البيانات متعددة الوسائط في دعم القرار الطبي</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">قاعة المؤتمرات</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">02:15 PM &ndash; 03:00 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <!-- الجلسة 8 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T16:00:00"
                             data-end="2026-10-01T16:45:00"
                             data-language="ar">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="م. خالد العتيبي"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='../Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">متحدث</span>
                            </div>
                            <h3 class="sairh-speaker-name">م. خالد العتيبي</h3>
                            <p class="sairh-speaker-role">مختص ابتكار صحي</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>مركز الابتكار الصحي</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> مسار الابتكار الصحي
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">الجلسة القادمة</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">مستقبل الابتكار الصحي المدعوم بالذكاء الاصطناعي</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">القاعة</span>
                                        <strong class="sairh-meta-value">قاعة الابتكار</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">الوقت</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">04:00 PM &ndash; 04:45 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">تبدأ الجلسة بعد</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">قريبًا</strong>
                                    </div>
                                </div>
                            </div>

                            <div class="sairh-progress-wrap">
                                <div class="sairh-progress-track" aria-hidden="true">
                                    <div class="sairh-progress-fill" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </article>
                </div>

                <!-- عناصر التحكم في العرض: أسهم التبديل والنقاط التفاعلية للجلسات -->
                <div class="sairh-slider-controls">
                    <button type="button"
                            class="sairh-slider-arrow previous"
                            aria-label="الجلسة السابقة">
                        <i class="bi bi-chevron-right" aria-hidden="true"></i>
                    </button>

                    <div class="sairh-slider-dots" role="tablist" aria-label="مؤشرات الجلسات">
                        <button type="button" class="sairh-slider-dot active" data-index="0" aria-label="عرض الجلسة رقم 1"></button>
                        <button type="button" class="sairh-slider-dot" data-index="1" aria-label="عرض الجلسة رقم 2"></button>
                        <button type="button" class="sairh-slider-dot" data-index="2" aria-label="عرض الجلسة رقم 3"></button>
                        <button type="button" class="sairh-slider-dot" data-index="3" aria-label="عرض الجلسة رقم 4"></button>
                        <button type="button" class="sairh-slider-dot" data-index="4" aria-label="عرض الجلسة رقم 5"></button>
                        <button type="button" class="sairh-slider-dot" data-index="5" aria-label="عرض الجلسة رقم 6"></button>
                        <button type="button" class="sairh-slider-dot" data-index="6" aria-label="عرض الجلسة رقم 7"></button>
                        <button type="button" class="sairh-slider-dot" data-index="7" aria-label="عرض الجلسة رقم 8"></button>
                    </div>

                    <button type="button"
                            class="sairh-slider-arrow next"
                            aria-label="الجلسة التالية">
                        <i class="bi bi-chevron-left" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- الأهداف والمواءمة مع رؤية السعودية 2030 (Vision 2030 5-Pillar Matrix) -->
    <section aria-label="Strategic Goals" class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    الأهداف والمواءمة مع رؤية السعودية 2030
                </h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <div class="vision-pillar-grid">
                <!-- الركيزة 01 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">الركيزة 01</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-heart-pulse"></i></div>
                    </div>
                    <h3 class="pillar-title">التصوير التشخيصي بالذكاء الاصطناعي</h3>
                    <p class="pillar-text">
                        تعزيز الابتكار في الرعاية الصحية من خلال التصوير التشخيصي المدعوم بالذكاء الاصطناعي.
                    </p>
                </div>

                <!-- الركيزة 02 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">الركيزة 02</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-gear"></i></div>
                    </div>
                    <h3 class="pillar-title">التحول الرقمي لأقسام الأشعة</h3>
                    <p class="pillar-text">
                        دعم التحول الرقمي الوطني في سير عمل أقسام الأشعة.
                    </p>
                </div>

                <!-- الركيزة 03 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">الركيزة 03</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-globe"></i></div>
                    </div>
                    <h3 class="pillar-title">التعاون العالمي الرائد</h3>
                    <p class="pillar-text">
                        توطيد التعاون العالمي مع المؤسسات الرائدة في مجالي الأشعة والذكاء الاصطناعي.
                    </p>
                </div>

                <!-- الركيزة 04 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">الركيزة 04</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-radioactive"></i></div>
                    </div>
                    <h3 class="pillar-title">البحث والابتكار الصحي</h3>
                    <p class="pillar-text">
                        دفع عجلة البحث والابتكار وتطوير الذكاء الاصطناعي في قطاع الرعاية الصحية.
                    </p>
                </div>

                <!-- الركيزة 05 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">الركيزة 05</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-people"></i></div>
                    </div>
                    <h3 class="pillar-title">بناء الكوادر الوطنية</h3>
                    <p class="pillar-text">
                        بناء كوادر مؤهلة ومستعدة للمستقبل تضم أطباء أشعة، وفنيين، وعلماء بيانات.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- رمز الإستجابة السريعة للمشاركة في القمة -->
    <section id="qr-section" aria-label="QR Code" class="py-5">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    رمز الإستجابة السريعة للمشاركة في القمة
                </h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="qr-pass-container text-center">
                        <div class="qr-box-inner">
                            <svg viewBox="0 0 100 100" fill="#040816">
                                <rect x="5" y="5" width="25" height="25" fill="#040816" />
                                <rect x="9" y="9" width="17" height="17" fill="#ffffff" />
                                <rect x="13" y="13" width="9" height="9" fill="#040816" />
                                <rect x="70" y="5" width="25" height="25" fill="#040816" />
                                <rect x="74" y="9" width="17" height="17" fill="#ffffff" />
                                <rect x="78" y="13" width="9" height="9" fill="#040816" />
                                <rect x="5" y="70" width="25" height="25" fill="#040816" />
                                <rect x="9" y="74" width="17" height="17" fill="#ffffff" />
                                <rect x="13" y="78" width="9" height="9" fill="#040816" />
                                <rect x="35" y="10" width="8" height="8" fill="#040816" />
                                <rect x="48" y="10" width="14" height="8" fill="#040816" />
                                <rect x="35" y="25" width="14" height="8" fill="#040816" />
                                <rect x="10" y="35" width="8" height="14" fill="#040816" />
                                <rect x="25" y="40" width="14" height="14" fill="#040816" />
                                <rect x="45" y="35" width="12" height="12" fill="#040816" />
                                <rect x="65" y="35" width="10" height="8" fill="#040816" />
                                <rect x="82" y="35" width="8" height="14" fill="#040816" />
                                <rect x="35" y="55" width="18" height="8" fill="#040816" />
                                <rect x="60" y="50" width="15" height="15" fill="#040816" />
                                <rect x="80" y="55" width="10" height="10" fill="#040816" />
                                <rect x="35" y="70" width="10" height="20" fill="#040816" />
                                <rect x="52" y="72" width="18" height="10" fill="#040816" />
                                <rect x="75" y="75" width="15" height="15" fill="#040816" />
                            </svg>
                        </div>
                        <h4 class="text-white font-weight-bold mb-2">امسح الرمز للمشاركة وتنزيل تطبيق SRAS</h4>
                        <p class="text-secondary mb-4 mx-auto" style="max-width: 540px; font-size: 1.05rem; line-height: 1.7;">
                            قم بتنزيل تطبيق الفعالية الرسمي للاطلاع على جدول الجلسات، وتصاريح الحضور، والمشاركة التفاعلية في كافة مسارات القمة.
                        </p>
                        <div class="d-flex justify-content-center gap-3 flex-wrap">
                            <a href="https://apps.apple.com/us/app/annual-innovation-event/id6475714056" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                                <i class="bi bi-apple ml-1"></i> متجر آبل App Store
                            </a>
                            <a href="https://play.google.com/store/apps/details?id=sa.edu.iau.annualinnovationevent" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                                <i class="bi bi-google-play ml-1"></i> متجر جوجل Google Play
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- موقع الفعالية -->
    <section aria-label="موقع الفعالية" class="py-5 mb-4">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    موقع الفعالية
                </h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="venue-showcase-card">
                        <img src="<%= ResolveUrl("~/Content/images/Home-Image/Grand Hyatt Alkhobar logo.svg") %>"
                             class="d-block img-fluid mx-auto mb-4"
                             alt="جراند حياة الخبر">
                        <h3 class="text-white font-weight-bold mb-2">فندق ومساكن جراند حياة الخبر</h3>
                        <p class="text-secondary mb-4" style="font-size: 1.15rem;">
                            حي العليا، الخبر، المنطقة الشرقية، المملكة العربية السعودية
                        </p>
                        <a href="https://maps.google.com/?q=Grand+Hyatt+Alkhobar" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                            <i class="bi bi-geo-alt ml-1"></i> فتح في خرائط جوجل Google Maps
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
