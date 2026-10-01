<%@ Page Title="برنامج المؤتمر والمسارات - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Ceremony.aspx.cs" Inherits="AIE.Ar_Sa.Ceremony" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="ترويسة البرنامج والمسارات">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                برنامج المؤتمر والمسارات العلمية
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 780px; font-size: 1.2rem; line-height: 1.8;">
                استكشف المسارات العلمية التخصصية الثلاثة وجدول أعمال المؤتمر الشامل على مدار يومين، والذي يجمع رواد الذكاء الاصطناعي، وأطباء الأشعة، وقادة التعليم والابتكار الصحي.
            </p>
        </div>
    </section>

    <!-- 3 Specialized Summit Tracks (Consolidated Overview) -->
    <section class="py-5" id="tracks-overview" aria-label="المسارات العلمية">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-2">المسارات العلمية التخصصية</h2>
                <div style="width: 60px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 16px; border-radius: 2px;"></div>
                <p class="text-muted mx-auto" style="max-width: 680px; font-size: 1rem;">
                    اختر أي مسار لتصفية جلسات الأجندة العلمية أدناه مباشرة.
                </p>
            </div>

            <div class="track-deck-grid mb-4">
                <!-- المسار A -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-a"><i class="bi bi-cpu ml-1"></i> المسار A</span>
                        <h2 class="track-deck-title">
                            الذكاء الاصطناعي، والتحول الرقمي التكنولوجي، وRadBix
                        </h2>
                        <p class="track-deck-desc">
                            التركيز على الذكاء الاصطناعي في مجال التصوير، وأنظمة البيانات البيئية، وRadBix، وأتمتة سير العمل، والأمن السيبراني، وأطر عمل الذكاء الاصطناعي الوطنية.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-stars ml-1"></i> الذكاء الاصطناعي في التصوير</span>
                            <span class="modality-chip"><i class="bi bi-database ml-1"></i> أنظمة البيانات البيئية</span>
                            <span class="modality-chip"><i class="bi bi-server ml-1"></i> منظومة RadBix</span>
                            <span class="modality-chip"><i class="bi bi-gear ml-1"></i> أتمتة سير العمل</span>
                            <span class="modality-chip"><i class="bi bi-shield-check ml-1"></i> الأمن السيبراني</span>
                            <span class="modality-chip"><i class="bi bi-globe ml-1"></i> أطر العمل الوطنية</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-a')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel ml-1"></i> عرض جدول جلسات المسار A <i class="bi bi-arrow-down mr-1"></i>
                        </button>
                    </div>
                </div>

                <!-- المسار B -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-b"><i class="bi bi-activity ml-1"></i> المسار B</span>
                        <h2 class="track-deck-title">
                            الأشعة السريرية المتقدمة
                        </h2>
                        <p class="track-deck-desc">
                            تم تحديث التصوير بالرنين المغناطيسي، والتصوير المقطعي المحوسب، والموجات فوق الصوتية، والأشعة السينية، والتصوير الشعاعي داخل الأوعية الدموية، والتصوير النووي، والتصوير الشعاعي للثدي وفقًا لمعايير عام 2026.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-bandaid ml-1"></i> الرنين المغناطيسي (معايير 2026)</span>
                            <span class="modality-chip"><i class="bi bi-record-circle ml-1"></i> التصوير المقطعي المحوسب</span>
                            <span class="modality-chip"><i class="bi bi-broadcast ml-1"></i> الموجات فوق الصوتية</span>
                            <span class="modality-chip"><i class="bi bi-file-earmark-image ml-1"></i> الأشعة السينية</span>
                            <span class="modality-chip"><i class="bi bi-heart-pulse ml-1"></i> التصوير داخل الأوعية (IVR)</span>
                            <span class="modality-chip"><i class="bi bi-radioactive ml-1"></i> الطب النووي (NM)</span>
                            <span class="modality-chip"><i class="bi bi-gender-female ml-1"></i> التصوير الشعاعي للثدي</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-b')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel ml-1"></i> عرض جدول جلسات المسار B <i class="bi bi-arrow-down mr-1"></i>
                        </button>
                    </div>
                </div>

                <!-- المسار C -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-c"><i class="bi bi-mortarboard ml-1"></i> المسار C</span>
                        <h2 class="track-deck-title">
                            التعليم والجودة والبحث والابتكار
                        </h2>
                        <p class="track-deck-desc">
                            مناهج البحث، والنشر، ومعايير الجودة، والتدريب القائم على المحاكاة، ومختبرات الابتكار.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-search ml-1"></i> مناهج البحث العلمي</span>
                            <span class="modality-chip"><i class="bi bi-journal-text ml-1"></i> النشر في المجلات المرموقة</span>
                            <span class="modality-chip"><i class="bi bi-check-circle ml-1"></i> معايير الجودة</span>
                            <span class="modality-chip"><i class="bi bi-laptop ml-1"></i> التدريب بالمحاكاة</span>
                            <span class="modality-chip"><i class="bi bi-lightbulb ml-1"></i> مختبرات الابتكار</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-c')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel ml-1"></i> عرض جدول جلسات المسار C <i class="bi bi-arrow-down mr-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Interactive Schedule Section -->
    <section class="py-5" id="program-schedule" aria-label="الأجندة التفاعلية">
        <div class="container program-container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-2">الجدول العلمي على مدار يومين</h2>
                <div style="width: 60px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 20px; border-radius: 2px;"></div>
            </div>

            <!-- Day Selection Tabs -->
            <div class="agenda-day-tabs">
                <button type="button" class="agenda-day-btn active" onclick="selectDay('day1', this)">
                    <i class="bi bi-calendar2-check ml-1"></i> اليوم الأول – الذكاء الاصطناعي والتميز السريري وأسس الابتكار
                </button>
                <button type="button" class="agenda-day-btn" onclick="selectDay('day2', this)">
                    <i class="bi bi-calendar2-check ml-1"></i> اليوم الثاني – تطوير الأشعة وأنظمة الذكاء الاصطناعي والتميز البحثي
                </button>
            </div>

            <!-- Track Filter Pills -->
            <div class="track-filter-bar">
                <button type="button" class="track-filter-pill active" onclick="filterTrack('all', this)"><i class="bi bi-grid-3x3-gap ml-1"></i> جميع الجلسات</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-a', this)"><i class="bi bi-cpu ml-1"></i> المسار A: الذكاء الاصطناعي وRadBix</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-b', this)"><i class="bi bi-activity ml-1"></i> المسار B: الأشعة السريرية المتقدمة</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-c', this)"><i class="bi bi-mortarboard ml-1"></i> المسار C: التعليم والجودة والبحث</button>
            </div>

            <!-- DAY 1 CONTENT -->
            <div id="day1-panel" class="day-panel active">
                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 07:00–09:30</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-person-badge ml-2 text-info"></i> التسجيل والحفل الافتتاحي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-heart-pulse ml-2 text-primary"></i> التصوير العصبي المتقدم بالرنين المغناطيسي (fMRI وDTI)</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-shield-check ml-2 text-success"></i> سلامة التصوير الطبي للأطفال</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-people ml-2 text-info"></i> تدريب الكوادر العاملة في مجال الأشعة في عصر الذكاء الاصطناعي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:30–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-stars ml-2 text-info"></i> مستقبل الذكاء الاصطناعي في الأشعة</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-gear ml-2 text-info"></i> الذكاء الاصطناعي التوليدي لسير عمل التصوير الطبي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-truck ml-2 text-danger"></i> تحسين التصوير المقطعي المحوسب لحالات الإصابات</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-activity ml-2 text-primary"></i> التصوير بالرنين المغناطيسي المتقدم للعمود الفقري والكتف</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-check-circle ml-2 text-success"></i> مؤشرات الجودة والمعايير العالمية</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-globe ml-2 text-info"></i> إطار عمل الذكاء الاصطناعي الصحي الوطني</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-broadcast ml-2 text-primary"></i> تحديثات الموجات فوق الصوتية لحالات الطوارئ</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-journal-text ml-2 text-warning"></i> النشر في المجلات ذات التأثير العالي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-scale ml-2 text-warning"></i> أخلاقيات ولوائح الذكاء الاصطناعي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-gender-female ml-2 text-danger"></i> تصوير الثدي الشعاعي الرقمي والفحص بالذكاء الاصطناعي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lightbulb ml-2 text-warning"></i> الابتكار في الأشعة – مختبر توليد الأفكار</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>
            </div>

            <!-- DAY 2 CONTENT -->
            <div id="day2-panel" class="day-panel">
                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-server ml-2 text-info"></i> بنية RadBix التحتية والتوأم الرقمي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-heart ml-2 text-danger"></i> الرنين المغناطيسي للقلب – تقنيات مدعومة بالذكاء الاصطناعي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-graph-up ml-2 text-info"></i> التحليلات التنبؤية في الأشعة</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-display ml-2 text-warning"></i> التدريب على الأشعة القائم على المحاكاة</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-arrow-repeat ml-2 text-info"></i> أتمتة سير العمل بالذكاء الاصطناعي في الأشعة</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lightning-charge ml-2 text-primary"></i> التصوير المقطعي المحوسب مزدوج الطاقة: تطورات 2026</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-shield-check ml-2 text-success"></i> أطر عمل ضمان الجودة للذكاء الاصطناعي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lock ml-2 text-danger"></i> الأمن السيبراني في التصوير الطبي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-bandaid ml-2 text-primary"></i> ابتكارات الأشعة التداخلية لحالات الطوارئ</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-pencil-square ml-2 text-warning"></i> كتابة المقترحات للحصول على منح أبحاث التصوير</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-sliders ml-2 text-info"></i> بروتوكولات الذكاء الاصطناعي للتصوير المقطعي والرنين</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">المسار A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-exclamation-triangle ml-2 text-warning"></i> مكافحة التلوث والسلامة في الطب النووي</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">المسار B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-radioactive ml-2 text-success"></i> الابتكار والأبحاث الناشئة</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">المسار C</span></div>
                </div>

                <div class="session-item track-main">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 15:00–16:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-trophy ml-2 text-warning"></i> الحفل الختامي وتوقيع الشراكات الاستراتيجية</h3></div>
                    <div class="session-track-col"><span class="track-badge track-main-badge">القاعة الرئيسية</span></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Client-side Interactive Filter Script -->
    <script>
        function selectDay(dayId, btn) {
            document.querySelectorAll('.agenda-day-btn').forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');
            
            document.querySelectorAll('.day-panel').forEach(function(p) { p.classList.remove('active'); });
            var targetPanel = document.getElementById(dayId + '-panel');
            if (targetPanel) {
                targetPanel.classList.add('active');
            }
        }

        function filterTrack(trackClass, btn) {
            if (btn) {
                document.querySelectorAll('.track-filter-pill').forEach(function(b) { b.classList.remove('active'); });
                btn.classList.add('active');
            }

            var items = document.querySelectorAll('.session-item');
            items.forEach(function(item) {
                if (trackClass === 'all') {
                    item.style.display = 'flex';
                } else if (item.classList.contains(trackClass)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        function filterTrackAndScroll(trackClass) {
            var targetPill = document.querySelector('.track-filter-pill[onclick*="' + trackClass + '"]');
            if (targetPill) {
                filterTrack(trackClass, targetPill);
            }
            var scheduleSection = document.getElementById('program-schedule');
            if (scheduleSection) {
                scheduleSection.scrollIntoView({ behavior: 'smooth' });
            }
        }

        // Auto-select track from URL query parameter
        window.addEventListener('DOMContentLoaded', function() {
            var params = new URLSearchParams(window.location.search);
            var track = params.get('track');
            if (track) {
                var trackClass = 'track-' + track.toLowerCase();
                var targetPill = document.querySelector('.track-filter-pill[onclick*="' + trackClass + '"]');
                if (targetPill) {
                    filterTrack(trackClass, targetPill);
                    var scheduleSection = document.getElementById('program-schedule');
                    if (scheduleSection) {
                        scheduleSection.scrollIntoView({ behavior: 'smooth' });
                    }
                }
            }
        });
    </script>
</asp:Content>
