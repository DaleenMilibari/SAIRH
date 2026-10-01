<%@ Page Title="المسارات - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Publication.aspx.cs" Inherits="AIE.Ar_Sa.Publication" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                المسارات
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            <p class="text-secondary mx-auto mt-4" style="max-width: 750px; font-size: 1.2rem; line-height: 1.8;">
                استكشف المسارات العلمية الثلاثة التي تجمع رواد الذكاء الاصطناعي، وخبراء التصوير الطبي، وقادة التعليم والابتكار الصحي.
            </p>
        </div>
    </section>

    <!-- 3 Tracks Interactive Deck -->
    <section class="py-5" aria-label="المسارات">
        <div class="container">
            <div class="track-deck-grid">
                <!-- المسار A -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-a">المسار A</span>
                        <h2 class="track-deck-title">
                            الذكاء الاصطناعي، والتحول الرقمي التكنولوجي، وRadBix
                        </h2>
                        <p class="track-deck-desc">
                            التركيز على الذكاء الاصطناعي في مجال التصوير، وأنظمة البيانات البيئية، وRadBix، وأتمتة سير العمل، والأمن السيبراني، وأطر عمل الذكاء الاصطناعي الوطنية.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">الذكاء الاصطناعي في التصوير</span>
                            <span class="modality-chip">أنظمة البيانات البيئية</span>
                            <span class="modality-chip">منظومة RadBix</span>
                            <span class="modality-chip">أتمتة سير العمل</span>
                            <span class="modality-chip">الأمن السيبراني</span>
                            <span class="modality-chip">أطر العمل الوطنية</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=A" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            جدول جلسات المسار A <i class="bi bi-arrow-left mr-1"></i>
                        </a>
                    </div>
                </div>

                <!-- المسار B -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-b">المسار B</span>
                        <h2 class="track-deck-title">
                            الأشعة السريرية المتقدمة
                        </h2>
                        <p class="track-deck-desc">
                            تم تحديث التصوير بالرنين المغناطيسي، والتصوير المقطعي المحوسب، والموجات فوق الصوتية، والأشعة السينية، والتصوير الشعاعي داخل الأوعية الدموية، والتصوير النووي، والتصوير الشعاعي للثدي وفقًا لمعايير عام 2026.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">الرنين المغناطيسي (معايير 2026)</span>
                            <span class="modality-chip">التصوير المقطعي المحوسب</span>
                            <span class="modality-chip">الموجات فوق الصوتية</span>
                            <span class="modality-chip">الأشعة السينية</span>
                            <span class="modality-chip">التصوير داخل الأوعية (IVR)</span>
                            <span class="modality-chip">الطب النووي (NM)</span>
                            <span class="modality-chip">التصوير الشعاعي للثدي</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=B" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            جدول جلسات المسار B <i class="bi bi-arrow-left mr-1"></i>
                        </a>
                    </div>
                </div>

                <!-- المسار C -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-c">المسار C</span>
                        <h2 class="track-deck-title">
                            التعليم والجودة والبحث والابتكار
                        </h2>
                        <p class="track-deck-desc">
                            مناهج البحث، والنشر، ومعايير الجودة، والتدريب القائم على المحاكاة، ومختبرات الابتكار.
                        </p>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip">مناهج البحث العلمي</span>
                            <span class="modality-chip">النشر في المجلات المرموقة</span>
                            <span class="modality-chip">معايير الجودة</span>
                            <span class="modality-chip">التدريب القائم على المحاكاة</span>
                            <span class="modality-chip">مختبرات الابتكار</span>
                        </div>
                    </div>
                    <div>
                        <a href="Ceremony?track=C" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            جدول جلسات المسار C <i class="bi bi-arrow-left mr-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
