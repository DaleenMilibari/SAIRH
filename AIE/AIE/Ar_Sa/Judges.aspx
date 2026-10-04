<%@ Page Title="المتحدثون والخبراء - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Judges.aspx.cs" Inherits="AIE.Ar_Sa.Judges" %>

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
    <section class="py-5 simpler-main-bg" aria-label="ترويسة المتحدثين">
        <div class="container text-center pt-4 pb-2">
            <span class="speakers-hero-badge">
                <i class="bi bi-people-fill"></i> نخبة من الخبراء والاستشاريين وقادة الابتكار
            </span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                المتحدثون في القمة
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            <p class="text-secondary mx-auto mt-4" style="max-width: 780px; font-size: 1.15rem; line-height: 1.8;">
                تضم القمة السعودية الأولى للذكاء الاصطناعي في الأشعة والابتكار الصحي نخبة متميزة من أعضاء هيئة التدريس وقادة الصناعة واستشاريي الأشعة لتقديم محاضرات علمية متخصصة عبر المسارات الثلاثة.
            </p>
        </div>
    </section>

    <!-- Main Content & Filters -->
    <section class="py-5" aria-label="دليل المتحدثين">
        <div class="container">
            <!-- Filter Toolbar -->
            <div class="speakers-filter-container">
                <!-- Search Bar First -->
                <div class="speakers-search-box">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" id="speakerSearch" class="speakers-search-input" placeholder="ابحث باسم المتحدث، أو الجهة، أو عنوان المحاضرة..." aria-label="بحث المتحدثين" />
                    <button type="button" id="clearSearchBtn" class="speakers-search-clear" aria-label="مسح البحث">&times;</button>
                </div>

                <!-- Track Filters Below It -->
                <div class="speakers-track-tabs" role="tablist" aria-label="تصفية حسب المسار">
                    <button type="button" class="track-tab-btn active" data-track="all">
                        <i class="bi bi-grid-fill"></i> جميع المسارات <span class="tab-count">30</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-a">
                        <i class="bi bi-cpu"></i> المسار أ: الذكاء الاصطناعي والتحول الرقمي <span class="tab-count">10</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-b">
                        <i class="bi bi-activity"></i> المسار ب: الأشعة السريرية المتقدمة <span class="tab-count">13</span>
                    </button>
                    <button type="button" class="track-tab-btn" data-track="track-c">
                        <i class="bi bi-lightbulb"></i> المسار ج: الابتكار الصحي <span class="tab-count">7</span>
                    </button>
                </div>

                <!-- Status & Reset Bar -->
                <div class="speakers-status-bar">
                    <div>
                        عرض <strong id="speakersCount" class="text-white">30</strong> من أصل 30 متحدثاً
                    </div>
                    <div>
                        <button type="button" id="btnResetFilters" class="btn-reset-filters" style="display:none;">
                            <i class="bi bi-arrow-counterclockwise"></i> إعادة ضبط التصفية
                        </button>
                    </div>
                </div>
            </div>

            <!-- Speakers Grid -->
            <div id="speakersGrid" class="speakers-grid">

                <!-- ========================================== -->
                <!-- TRACK A: AI & Digital Technology Transformation (10) -->
                <!-- ========================================== -->

                <!-- 1. د. فهد المسند -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Fahad-Almsned-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Fahad-Almsned-CV.pdf"
                         data-track="track-a"
                         data-sector="clinical"
                         data-region="national"
                         data-name="د. فهد المسند"
                         data-role="مدير العمليات البحثية"
                         data-org="مستشفى الملك فهد التخصصي - الدمام"
                         data-lecture="مستقبل الطب المبني على البيانات يُكتب اليوم &mdash; الانتقال من ضجيج الذكاء الاصطناعي إلى واقع سريري متكامل"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="رعاية صحية ومستشفيات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ف.م">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> قطاع سريري
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fahad-Almsned-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ف.م</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. فهد المسند</h3>
                        <p class="speaker-title">مدير العمليات البحثية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>مستشفى الملك فهد التخصصي - الدمام</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                "مستقبل الطب المبني على البيانات يُكتب اليوم" &mdash; "الانتقال من ضجيج الذكاء الاصطناعي إلى واقع سريري متكامل"
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 2. د. إيمان الشهري -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Eman-Alshehri-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. إيمان الشهري"
                         data-role="أستاذ مساعد، قسم الحاسب الآلي"
                         data-org="جامعة الإمام عبدالرحمن بن فيصل"
                         data-lecture="الذكاء الاصطناعي في التصوير الطبي: من الرؤى المعتمدة على البيانات إلى التأثير السريري"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="إ.ش">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">إ.ش</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. إيمان الشهري</h3>
                        <p class="speaker-title">أستاذ مساعد، قسم الحاسب الآلي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الإمام عبدالرحمن بن فيصل</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Artificial Intelligence in Medical Imaging: From Data-Driven Insights to Clinical Impact
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 3. أ. فدوى البواردي -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg"
                         data-cv="/Content/docs/speakers/Fadwa-AlBawardi-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="أ. فدوى البواردي"
                         data-role="المؤسس والرئيس التنفيذي، استشارات FSAB"
                         data-org="FSAB Consulting"
                         data-lecture="الذكاء الاصطناعي مقابل العين البشرية: رصد الكسور الخفية"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="قطاع صناعي وتقني"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ف.ب">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> أعمال واستشارات
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fadwa-AlBawardi-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ف.ب</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">أ. فدوى البواردي (ماجستير)</h3>
                        <p class="speaker-title">المؤسس والرئيس التنفيذي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>استشارات FSAB</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                AI vs. The Human Eye: Spotting Hidden Fractures
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 4. د. أصيل الداوود -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Aseel-Addawood-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="د. أصيل الداوود"
                         data-role="قائد مركز التميز للذكاء الاصطناعي في أوروبا والشرق الأوسط وأفريقيا بالمملكة"
                         data-org="EMEA AI Center of Excellence"
                         data-lecture="من المشاريع التجريبية للذكاء الاصطناعي إلى الأثر السريري"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="قطاع تقني وصناعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="أ.د">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> قطاع تقني
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">أ.د</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. أصيل الداوود</h3>
                        <p class="speaker-title">قائد مركز التميز للذكاء الاصطناعي (EMEA) بالمملكة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>مركز التميز للذكاء الاصطناعي (EMEA)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                From AI Pilots to Clinical Impact (من التجارب إلى الأثر السريري)
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 5. د. مصطفى يلدش -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Mustafa-Yoldash-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. مصطفى يلدش"
                         data-role="أستاذ مساعد ورئيس قسم هندسة الحاسب"
                         data-org="جامعة الإمام عبدالرحمن بن فيصل، الدمام"
                         data-lecture="إحداث تحول في علم الأشعة باستخدام الذكاء الاصطناعي والوكلاء الأذكياء (Agentic AI)"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="م.ي">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">م.ي</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. مصطفى يلدش</h3>
                        <p class="speaker-title">أستاذ مساعد ورئيس قسم هندسة الحاسب</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الإمام عبدالرحمن بن فيصل، الدمام</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Transforming Radiology with AI and Agentic AI
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 6. أ. يزيد السديس -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Yazeed-Alsudays-Photo.jpg"
                         data-cv="/Content/docs/speakers/Yazeed-Alsudays-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="national"
                         data-name="أ. يزيد السديس"
                         data-role="مدير الحسابات الاستراتيجية، سولفنتوم"
                         data-org="Solventum"
                         data-lecture="الاستخدام العملي للذكاء الاصطناعي في التصوير البانورامي للأسنان"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="قطاع تقني وصناعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ي.س">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> قطاع صناعي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Yazeed-Alsudays-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ي.س</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">أ. يزيد السديس (ماجستير إدارة الأعمال)</h3>
                        <p class="speaker-title">مدير الحسابات الاستراتيجية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>شركة سولفنتوم (Solventum)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Practical Use of AI in Dental Panoramic Imaging
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 7. د. عبير الألمعي -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Abeer-Alalmaie-Photo.png"
                         data-cv="/Content/docs/speakers/Abeer-Alalmaie-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. عبير الألمعي"
                         data-role="مستشارة رئيس جامعة الملك خالد لتسويق الملكية الفكرية"
                         data-org="جامعة الملك خالد"
                         data-lecture="دمج الذكاء العصبي الحوسبي (Neuro-AI) لتحليل الدماغ والسلوك"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ع.أ">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abeer-Alalmaie-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.أ</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عبير الألمعي</h3>
                        <p class="speaker-title">مستشارة رئيس الجامعة لتسويق الملكية الفكرية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الملك خالد</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Integrating Neuro-AI for Brain and Behaviour Analysis
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 8. د. كلير ريني -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Clare-Rainey-Photo.jpg.png"
                         data-cv="/Content/docs/speakers/Clare-Rainey-CV.pdf"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. كلير ريني"
                         data-role="محاضرة في التصوير الطبي والعلاج الإشعاعي"
                         data-org="جامعة كلية كورك، أيرلندا"
                         data-lecture="التعاون بين الإنسان والحاسوب والمبادئ الأخلاقية للذكاء الاصطناعي"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="أيرلندا"
                         data-flag="🇮🇪"
                         data-initials="CR">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Clare-Rainey-Photo.jpg.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">CR</div>
                        <span class="speaker-badge-flag" title="أيرلندا">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. كلير ريني (Dr. Clare Rainey)</h3>
                        <p class="speaker-title">محاضرة في التصوير الطبي والعلاج الإشعاعي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة كلية كورك، أيرلندا (UCC)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Human-Computer Collaboration and Ethical AI Principles
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 9. د. ريبيكا فاز -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Rebeca-Queiroz-Photo.JPG"
                         data-cv="/Content/docs/speakers/Rebeca-Queiroz-CV.pdf"
                         data-track="track-a"
                         data-sector="industry"
                         data-region="international"
                         data-name="د. ريبيكا فاز"
                         data-role="مسؤولة الأبحاث السريرية، فويثي"
                         data-org="Voithy"
                         data-lecture="الشبكات العصبية الالتفافية كأداة لتشخيص سرطان الفم"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="قطاع تقني وصناعي"
                         data-region-name="دولي"
                         data-flag="🌐"
                         data-initials="RV">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> قطاع صناعي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Rebeca-Queiroz-Photo.JPG" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">RV</div>
                        <span class="speaker-badge-flag" title="دولي">🌐</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. ريبيكا فاز (Dr. Rebecca Vaz)</h3>
                        <p class="speaker-title">مسؤولة الأبحاث السريرية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>فويثي (Voithy)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Convolutional Neural Networks as a Tool for Oral Cancer Diagnosis
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 10. معاذ أمير -->
                <article class="speaker-card track-a"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-track="track-a"
                         data-sector="academic"
                         data-region="national"
                         data-name="معاذ أمير"
                         data-role="طالب طب ومبتكر في الذكاء الاصطناعي"
                         data-org="كلية الطب - جامعة الإمام عبدالرحمن بن فيصل"
                         data-lecture="ابتكارات الطلاب في الذكاء الاصطناعي"
                         data-track-name="المسار أ &ndash; الذكاء الاصطناعي والتحول التقني الرقمي"
                         data-sector-name="ابتكارات طلابية وبحثية"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="م.أ">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-a">
                            <i class="bi bi-cpu"></i> المسار أ
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-stars"></i> ابتكار شبابي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">م.أ</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">معاذ أمير</h3>
                        <p class="speaker-title">طالب طب وباحث مبتكر</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>كلية الطب - جامعة الإمام عبدالرحمن بن فيصل</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Student innovations in AI (ابتكارات الطلاب في الذكاء الاصطناعي)
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- ========================================== -->
                <!-- TRACK B: Advanced Clinical Radiology (13) -->
                <!-- ========================================== -->

                <!-- 11. د. آمنة كاشغري -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Amna-Kashgari-Photo.jpg"
                         data-cv="/Content/docs/speakers/Amna-Kashgari-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="د. آمنة كاشغري"
                         data-role="رئيسة التحول بالذكاء الاصطناعي في الأشعة، قسم التصوير الطبي"
                         data-org="مدينة الملك عبدالعزيز الطبية (الشؤون الصحية بوزارة الحرس الوطني)"
                         data-lecture="تبني الذكاء الاصطناعي في الأشعة: من التبعية إلى التمكين"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="رعاية صحية ومستشفيات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="آ.ك">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> قطاع سريري
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Amna-Kashgari-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">آ.ك</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. آمنة كاشغري</h3>
                        <p class="speaker-title">رئيسة التحول بالذكاء الاصطناعي في الأشعة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>مدينة الملك عبدالعزيز الطبية (الحرس الوطني)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Radiology AI Adaptations: From Dependency to Empowerment
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 12. بروفيسور كارين ناب -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Karen-Knapp-Photo.jpg"
                         data-cv="/Content/docs/speakers/Karen-Knapp-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="بروفيسور كارين ناب"
                         data-role="أستاذة تصوير الجهاز العضلي الهيكلي، ورئيسة مهن الرعاية الصحية"
                         data-org="جامعة إكستر، المملكة المتحدة"
                         data-lecture="عوامل الخطر السريرية للتنبؤ بالكسور"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة المتحدة"
                         data-flag="🇬🇧"
                         data-initials="KK">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Karen-Knapp-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">KK</div>
                        <span class="speaker-badge-flag" title="بريطانيا">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">بروفيسور كارين ناب (Prof. Karen Knapp)</h3>
                        <p class="speaker-title">أستاذة تصوير الجهاز العضلي ورئيسة مهن الرعاية الصحية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة إكستر، المملكة المتحدة</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Clinical Risk Factors for Fracture Prediction
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 13. د. محمد عسيري -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Mohammed-Asiri-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mohammed-Asiri-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. محمد عسيري"
                         data-role="أستاذ مساعد"
                         data-org="جامعة الطائف"
                         data-lecture="تطبيقات الموجات فوق الصوتية المتقدمة في تقييم صحة العظام"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="م.ع">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mohammed-Asiri-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">م.ع</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. محمد عسيري</h3>
                        <p class="speaker-title">أستاذ مساعد</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الطائف</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Advanced Ultrasound Applications in Bone Health Assessment
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 14. د. ياسر هادي -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Yasser-Hadi-Photo.JPG"
                         data-cv="/Content/docs/speakers/Yasser-Hadi.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="د. ياسر هادي"
                         data-role="أخصائي أول تقنية الأشعة المقطعية"
                         data-org="مدينة الملك عبدالله الطبية بمكة المكرمة"
                         data-lecture="الوضعيات في الأشعة المقطعية: هل يمكن للأتمتة أن تكون مفيدة؟"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="رعاية صحية ومستشفيات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ي.هـ">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> قطاع سريري
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Yasser-Hadi-Photo.JPG" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ي.هـ</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. ياسر هادي</h3>
                        <p class="speaker-title">أخصائي أول تقنية الأشعة المقطعية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>مدينة الملك عبدالله الطبية (KAMC)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Positioning in CT: Is Automation Likely to be Helpful?
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 15. د. عبدالكريم القحطاني -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Abdulkareem-Alqahtani-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. عبدالكريم القحطاني"
                         data-role="محاضر في الموجات فوق الصوتية الطبية"
                         data-org="جامعة طيبة"
                         data-lecture="مستقبل الموجات فوق الصوتية المدعومة بالذكاء الاصطناعي"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ع.ق">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abdulkareem-Alqahtani-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.ق</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عبدالكريم القحطاني</h3>
                        <p class="speaker-title">محاضر في الموجات فوق الصوتية الطبية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة طيبة</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                The Future of AI-Driven Ultrasound
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 16. د. عبدالعزيز الملحم -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Abdulaziz-Almulhim-Photo.png"
                         data-cv="/Content/docs/speakers/Abdulaziz-AlMulhim-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="د. عبدالعزيز الملحم"
                         data-role="استشاري الأشعة التداخلية والأوعية الدموية"
                         data-org="المنطقة الشرقية - تجمع الأحساء الصحي"
                         data-lecture="جناح القسطرة الذكي المدعوم بالذكاء الاصطناعي لأطباء الأشعة التداخلية"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="رعاية صحية ومستشفيات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ع.م">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> قطاع سريري
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Abdulaziz-Almulhim-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.م</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عبدالعزيز الملحم</h3>
                        <p class="speaker-title">استشاري الأشعة التداخلية والأوعية الدموية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>تجمع الأحساء الصحي - المنطقة الشرقية</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                The Smart Angio Suite with AI for Interventional Radiologists
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 17. د. سونيا مكفادين -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Sonyia-McFadden-Photo.jpg"
                         data-cv="/Content/docs/speakers/Sonyia-McFadden-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. سونيا مكفادين"
                         data-role="محاضرة أولى (التصوير التشخيصي)"
                         data-org="جامعة أولستر، المملكة المتحدة"
                         data-lecture="الذكاء الاصطناعي في مسار سرطان الرئة: مسح مقطعي ودراسة مقابلة"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة المتحدة"
                         data-flag="🇬🇧"
                         data-initials="SM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Sonyia-McFadden-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">SM</div>
                        <span class="speaker-badge-flag" title="المملكة المتحدة">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. سونيا مكفادين (Dr. Sonyia McFadden)</h3>
                        <p class="speaker-title">محاضرة أولى في التصوير التشخيصي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة أولستر، المملكة المتحدة</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                AI in the lung cancer pathway: a cross sectional survey and interview study
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 18. د. رائد الشنيبر -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Raid-Alshinibr-Photo.png"
                         data-cv="/Content/docs/speakers/Raid-Alshinibr-CV.pdf"
                         data-track="track-b"
                         data-sector="clinical"
                         data-region="national"
                         data-name="د. رائد الشنيبر"
                         data-role="رئيس قسم الأشعة"
                         data-org="مجموعة رعاية الطبية - مستشفى السلام"
                         data-lecture="ما بعد الأتمتة: دمج الذكاء الاصطناعي في مسارات العمل السريرية للأشعة"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="رعاية صحية ومستشفيات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ر.ش">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-hospital"></i> قطاع سريري
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Raid-Alshinibr-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ر.ش</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. رائد الشنيبر</h3>
                        <p class="speaker-title">رئيس قسم الأشعة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>مجموعة رعاية الطبية - مستشفى السلام</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Beyond Automation: Integrating AI into Clinical Radiology Workflows
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 19. بروفيسور منيار ساسي -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Minyar-Hidr-Photo.jpg"
                         data-cv="/Content/docs/speakers/Minyar-Hidr-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="بروفيسور منيار ساسي"
                         data-role="أستاذة في علوم الحاسب، المدرسة الوطنية للمهندسين بتونس"
                         data-org="جامعة تونس المنار، تونس"
                         data-lecture="أخلاقيات الذكاء الاصطناعي والتحيز والحوكمة في أشعة الذكاء الاصطناعي"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="تونس"
                         data-flag="🇹🇳"
                         data-initials="MS">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Minyar-Hidr-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MS</div>
                        <span class="speaker-badge-flag" title="تونس">🇹🇳</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">بروفيسور منيار ساسي (Prof. Minyar Sassi)</h3>
                        <p class="speaker-title">أستاذة في علوم الحاسب، المدرسة الوطنية للمهندسين</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة تونس المنار، تونس</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                AI Ethics, Bias, and Governance in Radiology AI
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 20. د. عبد الرزاق هيريل -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg"
                         data-cv="/Content/docs/speakers/Hairil-AbdulRazak-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. عبد الرزاق هيريل"
                         data-role="محاضر أول في التصوير الطبي"
                         data-org="جامعة إكستر، المملكة المتحدة"
                         data-lecture="دور التصوير المقطعي بالإصدار البوزيتروني (FDG PET/CT) في الكشف عن الأمراض المنقولة بالهواء"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة المتحدة"
                         data-flag="🇬🇧"
                         data-initials="AH">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Hairil-AbdulRazak-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AH</div>
                        <span class="speaker-badge-flag" title="المملكة المتحدة">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عبد الرزاق هيريل (Dr. Abdul Razak Hairil)</h3>
                        <p class="speaker-title">محاضر أول في التصوير الطبي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة إكستر، المملكة المتحدة</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                The Role of FDG PET/CT Imaging in Detecting Air-Borne Diseases
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 21. د. عبدالعزيز محمد الشريدة -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. عبدالعزيز محمد الشريدة"
                         data-role="أستاذ مشارك ورئيس قسم الأشعة"
                         data-org="جامعة الإمام عبدالرحمن بن فيصل"
                         data-lecture="الوضع الحالي ومستقبل الذكاء الاصطناعي في الأشعة التداخلية للأطفال: مراجعة سردية"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ع.ش">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.ش</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عبدالعزيز محمد الشريدة</h3>
                        <p class="speaker-title">أستاذ مشارك ورئيس قسم الأشعة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الإمام عبدالرحمن بن فيصل</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Current State &amp; Future of AI in Pediatric Interventional Radiology: A Narrative Review
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 22. د. محمد السعدي -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Mohammed-Saadi-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mohammed-Saadi-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. محمد السعدي"
                         data-role="أستاذ مشارك في الأشعة والتصوير الطبي"
                         data-org="جامعة الأمير سطام بن عبدالعزيز"
                         data-lecture="أحدث المستجدات في الموجات فوق الصوتية لحالات الطوارئ"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="م.س">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mohammed-Saadi-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">م.س</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. محمد السعدي</h3>
                        <p class="speaker-title">أستاذ مشارك في الأشعة والتصوير الطبي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الأمير سطام بن عبدالعزيز</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Updates in Emergency Ultrasound (مستجدات الموجات الصوتية الإسعافية)
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 23. د. عون العيداني -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Oun-Aliedani-Photo.jpg"
                         data-cv="/Content/docs/speakers/Oun-Aliedani-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. عون العيداني"
                         data-role="باحث ما بعد الدكتوراه وزميل التصلب المتعدد"
                         data-org="جامعة نيوكاسل، أستراليا"
                         data-lecture="طريقة معالجة الرنين المغناطيسي متعدد الوسائط للتنبؤ بتطور التصلب المتعدد عبر الذكاء الاصطناعي"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وبحثي"
                         data-region-name="أستراليا"
                         data-flag="🇦🇺"
                         data-initials="ع.ع">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Oun-Aliedani-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.ع</div>
                        <span class="speaker-badge-flag" title="أستراليا">🇦🇺</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. عون العيداني (Dr. Oun Al-iedani)</h3>
                        <p class="speaker-title">باحث ما بعد الدكتوراه وزميل التصلب المتعدد</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة نيوكاسل، أستراليا</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Multi-Modal MRI Post-Processing Method for AI-Driven Prediction of Multiple Sclerosis Progression
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 23b. د. حسين العرفج -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Hussain-Alarfaj-Photo.jpg"
                         data-cv="/Content/docs/speakers/Hussain-Alarfaj-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. حسين العرفج"
                         data-role="استشاري أشعة سريرية"
                         data-org="جامعة الإمام عبدالرحمن بن فيصل"
                         data-lecture="التطورات في الأشعة السريرية وتكامل الذكاء الاصطناعي"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ح.ع">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Hussain-Alarfaj-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ح.ع</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. حسين العرفج (Dr. Hussain Alarfaj)</h3>
                        <p class="speaker-title">استشاري أشعة سريرية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الإمام عبدالرحمن بن فيصل</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                التطورات في الأشعة السريرية وتكامل الذكاء الاصطناعي
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 23c. د. قرين القرين -->
                <article class="speaker-card track-b"
                         data-photo="/Content/images/speakers/Qurain-Alqurain-Photo.png"
                         data-cv="/Content/docs/speakers/Qurain-Alqurain-CV.pdf"
                         data-track="track-b"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. قرين القرين"
                         data-role="استشاري أشعة"
                         data-org="جامعة الإمام عبدالرحمن بن فيصل"
                         data-lecture="الدقة التشخيصية للذكاء الاصطناعي في الأشعة الحديثة"
                         data-track-name="المسار ب &ndash; الأشعة السريرية المتقدمة"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ق.ق">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-b">
                            <i class="bi bi-activity"></i> المسار ب
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Qurain-Alqurain-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ق.ق</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. قرين القرين (Dr. Qurain Alqurain)</h3>
                        <p class="speaker-title">استشاري أشعة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الإمام عبدالرحمن بن فيصل</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                الدقة التشخيصية للذكاء الاصطناعي في الأشعة الحديثة
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- ========================================== -->
                <!-- TRACK C: Health Innovation (7) -->
                <!-- ========================================== -->

                <!-- 24. د. أمل السلامة -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Amal-Alsalamah-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Amal-Alsalamah-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. أمل السلامة"
                         data-role="رئيسة برنامج العلوم الإشعاعية"
                         data-org="كلية البترجي الطبية"
                         data-lecture="تقييم الصدق الظاهري لمحاكي الرنين المغناطيسي الذكي"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="أ.س">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Amal-Alsalamah-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">أ.س</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. أمل السلامة</h3>
                        <p class="speaker-title">رئيسة برنامج العلوم الإشعاعية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>كلية البترجي الطبية</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Evaluation of the Face Validity of a Smart MRI Simulator
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 25. د. رشا العفالق -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Rasha-Alafaleg-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. رشا العفالق"
                         data-role="أستاذ مساعد في تعليم طب الأسنان والعلوم الطبية الأساسية للفم"
                         data-org="جامعة القصيم"
                         data-lecture="دور الذكاء الاصطناعي في تصوير الأسنان في التعليم"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ر.ع">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Rasha-Alafaleg-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ر.ع</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. رشا العفالق</h3>
                        <p class="speaker-title">أستاذ مساعد في تعليم طب الأسنان والعلوم الطبية للفم</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة القصيم</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                The Role of AI in Dental Imaging in Education
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 26. د. علي الهيلي -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Ali-Alhaili-Photo.jpg"
                         data-cv="/Content/docs/speakers/Ali-Alhailiy-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="national"
                         data-name="د. علي الهيلي"
                         data-role="رئيس قسم الأشعة والتصوير الطبي"
                         data-org="جامعة الأمير سطام بن عبدالعزيز"
                         data-lecture="المؤشرات الحيوية الوظيفية والإشعاعية في تنظير القولون الافتراضي"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ع.هـ">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-mortarboard"></i> أكاديمي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Ali-Alhaili-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ع.هـ</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. علي الهيلي</h3>
                        <p class="speaker-title">رئيس قسم الأشعة والتصوير الطبي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة الأمير سطام بن عبدالعزيز</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Functional and Radiomic Biomarkers in Virtual Colonoscopy
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 27. أ. فهد السعدان -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Fahad-Alsadan-Photo.jpg"
                         data-cv="/Content/docs/speakers/Fahad-Alsadan-CV.pdf"
                         data-track="track-c"
                         data-sector="industry"
                         data-region="national"
                         data-name="أ. فهد السعدان"
                         data-role="مدير مركز الابتكار والشراكات العلمية"
                         data-org="سيمنز هيلثينيرز"
                         data-lecture="العوائق والفرص في توسيع نطاق الابتكار في المملكة العربية السعودية"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="قطاع صناعي وشراكات"
                         data-region-name="المملكة العربية السعودية"
                         data-flag="🇸🇦"
                         data-initials="ف.س">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-briefcase"></i> قطاع صناعي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Fahad-Alsadan-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">ف.س</div>
                        <span class="speaker-badge-flag" title="السعودية">🇸🇦</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">أ. فهد السعدان (ماجستير)</h3>
                        <p class="speaker-title">مدير مركز الابتكار والشراكات العلمية</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>سيمنز هيلثينيرز (Siemens Healthineers)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Barriers and Opportunities in Scaling Innovation in Saudi Arabia
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 28. بروفيسور مارك ماكنتي -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Mark-McEntee-Photo.jpeg"
                         data-cv="/Content/docs/speakers/Mark-McEntee-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="بروفيسور مارك ماكنتي"
                         data-role="نائب رئيس التعليم والتعلم، كلية الطب والصحة"
                         data-org="جامعة كلية كورك (UCC)، أيرلندا"
                         data-lecture="الذكاء الاصطناعي والتحديات المستقبلية لتعليم التصوير الطبي"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="أيرلندا"
                         data-flag="🇮🇪"
                         data-initials="MM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Mark-McEntee-Photo.jpeg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">MM</div>
                        <span class="speaker-badge-flag" title="أيرلندا">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">بروفيسور مارك ماكنتي (Prof. Mark McEntee)</h3>
                        <p class="speaker-title">نائب رئيس التعليم والتعلم، كلية الطب والصحة</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة كلية كورك (UCC)، أيرلندا</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                AI and the Future Challenges for Medical Imaging Education
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 29. د. لورا ماكلوغلين -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Laura-McLaughlin-Photo.jpg"
                         data-cv="/Content/docs/speakers/Laura-McLaughlin-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. لورا ماكلوغلين"
                         data-role="محاضرة في التصوير الإشعاعي التشخيصي"
                         data-org="جامعة أولستر، المملكة المتحدة"
                         data-lecture="أدوات الذكاء الاصطناعي والرنين المغناطيسي البحثية لتفسير الصور"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="المملكة المتحدة"
                         data-flag="🇬🇧"
                         data-initials="LM">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Laura-McLaughlin-Photo.jpg" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">LM</div>
                        <span class="speaker-badge-flag" title="المملكة المتحدة">🇬🇧</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. لورا ماكلوغلين (Dr. Laura McLaughlin)</h3>
                        <p class="speaker-title">محاضرة في التصوير الإشعاعي التشخيصي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة أولستر، المملكة المتحدة</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Research AI and MRI Tools for Image Interpretation
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

                <!-- 30. د. أندرو إنجلاند -->
                <article class="speaker-card track-c"
                         data-photo="/Content/images/speakers/Speaker-Photo.png"
                         data-cv="/Content/docs/speakers/Andrew-England-CV.pdf"
                         data-track="track-c"
                         data-sector="academic"
                         data-region="international"
                         data-name="د. أندرو إنجلاند"
                         data-role="محاضر أول في التصوير الطبي والعلاج الإشعاعي"
                         data-org="جامعة كلية كورك، أيرلندا"
                         data-lecture="كتابة المنح والنشر والابتكار البحثي"
                         data-track-name="المسار ج &ndash; الابتكار الصحي"
                         data-sector-name="أكاديمي وجامعي"
                         data-region-name="أيرلندا"
                         data-flag="🇮🇪"
                         data-initials="AE">
                    <div class="speaker-card-header">
                        <span class="speaker-track-tag tag-track-c">
                            <i class="bi bi-lightbulb"></i> المسار ج
                        </span>
                        <span class="speaker-sector-tag">
                            <i class="bi bi-globe"></i> دولي
                        </span>
                    </div>
                    <div class="speaker-avatar-wrap">
                        <img src="/Content/images/speakers/Speaker-Photo.png" alt="Speaker" class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        <div class="speaker-monogram" style="display:none;">AE</div>
                        <span class="speaker-badge-flag" title="أيرلندا">🇮🇪</span>
                    </div>
                    <div class="speaker-body">
                        <h3 class="speaker-name">د. أندرو إنجلاند (Dr. Andrew England)</h3>
                        <p class="speaker-title">محاضر أول في التصوير الطبي والعلاج الإشعاعي</p>
                        <p class="speaker-org">
                            <i class="bi bi-bank sairh-organization-icon"></i>
                            <span>جامعة كلية كورك، أيرلندا (UCC)</span>
                        </p>
                        <div class="speaker-lecture-card">
                            <div class="speaker-lecture-label">
                                <i class="bi bi-mic-fill"></i> عنوان المحاضرة
                            </div>
                            <p class="speaker-lecture-title">
                                Grant Writing, Publishing &amp; Research Innovation
                            </p>
                        </div>
                    </div>
                    <div class="speaker-card-actions">
                        <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                            <i class="bi bi-info-circle"></i> تفاصيل المحاضرة
                        </button>
                    </div>
                </article>

            </div>

            <!-- Empty Search State -->
            <div id="speakersEmptyState" class="speakers-empty-state">
                <i class="bi bi-search speakers-empty-icon"></i>
                <h3 class="text-white font-weight-bold mb-2">لم يتم العثور على متحدثين</h3>
                <p class="text-secondary mx-auto mb-4" style="max-width: 500px;">
                    لم نتمكن من العثور على أي متحدث يطابق معايير البحث أو التصفية المحددة.
                </p>
                <button type="button" onclick="resetAllFilters()" class="btn btn-outline-info rounded-pill px-4 py-2 font-weight-bold">
                    <i class="bi bi-arrow-counterclockwise mr-1"></i> إعادة ضبط كافة عوامل التصفية
                </button>
            </div>

        </div>
    </section>

    <!-- Speaker Details Modal -->
    <div id="speakerModal" class="speaker-modal-backdrop" onclick="if(event.target===this)closeSpeakerModal()">
        <div class="speaker-modal-window">
            <button type="button" class="speaker-modal-close" onclick="closeSpeakerModal()" aria-label="إغلاق النافذة">&times;</button>
            
            <div class="d-flex align-items-center mb-4" style="gap: 18px;">
                <div class="speaker-avatar-wrap m-0" style="width: 80px; height: 80px;">
                    <img id="modalSpeakerPhoto" src="" alt="Speaker" class="speaker-avatar-img" style="width: 80px; height: 80px; display: none;" />
                    <div id="modalSpeakerInitials" class="speaker-monogram" style="width: 80px; height: 80px; font-size: 1.4rem;">م.ت</div>
                    <span id="modalSpeakerFlag" class="speaker-badge-flag">🇸🇦</span>
                </div>
                <div>
                    <h3 id="modalSpeakerName" class="text-white font-weight-bold mb-1" style="font-size: 1.4rem;">اسم المتحدث</h3>
                    <p id="modalSpeakerRole" class="text-info font-weight-600 mb-0" style="font-size: 0.95rem;">المنصب والصفة</p>
                </div>
            </div>

            <!-- Meta Grid -->
            <div class="speakers-modal-meta-grid">
                <div class="speakers-modal-meta-item">
                    <div class="speakers-modal-meta-label"><i class="bi bi-bank"></i> الجهة والارتباط الأكاديمي/المهني</div>
                    <p id="modalSpeakerOrg" class="speakers-modal-meta-val">اسم الجهة أو المستشفى</p>
                </div>
                <div class="speakers-modal-meta-item">
                    <div class="speakers-modal-meta-label"><i class="bi bi-geo-alt"></i> النطاق الجغرافي</div>
                    <p id="modalMetaRegion" class="speakers-modal-meta-val">المملكة العربية السعودية</p>
                </div>
            </div>

            <!-- Lecture Callout -->
            <div class="speaker-lecture-card mt-3 mb-4" style="background: rgba(4, 8, 22, 0.85); padding: 18px 20px;">
                <div class="speaker-lecture-label" style="font-size: 0.8rem; margin-bottom: 8px;">
                    <i class="bi bi-mic-fill"></i> عنوان المحاضرة العلمية
                </div>
                <h4 id="modalLectureTitle" class="text-white font-weight-bold mb-0" style="font-size: 1.1rem; line-height: 1.6;">
                    عنوان المحاضرة
                </h4>
            </div>

            <div class="d-flex flex-wrap justify-content-end align-items-center pt-3 border-top border-secondary" style="gap: 12px;">
                <a id="modalCvBtn" href="#" target="_blank" class="btn btn-info rounded-pill px-4 py-2 font-weight-bold" style="display:none;">
                    <i class="bi bi-file-earmark-pdf ml-1"></i> عرض السيرة الذاتية (PDF)
                </a>
                <button type="button" class="btn btn-secondary rounded-pill px-4 py-2 font-weight-bold" onclick="closeSpeakerModal()">
                    إغلاق
                </button>
            </div>
        </div>
    </div>

    <!-- Interactive Scripts -->
    <script src="<%= ResolveUrl("~/Scripts/speakers.js") %>"></script>
</asp:Content>
