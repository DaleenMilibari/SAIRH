<%@ Page Title="الرعاة - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Sponsors.aspx.cs" Inherits="AIE.Ar_Sa.Sponsors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="الرعاة">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                الرعاة
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 850px; font-size: 1.2rem; line-height: 1.8;">
                تقدم رعاية القمة السعودية للذكاء الاصطناعي في الاشعة والابتكار الصحي للمنظمات فرصة فريدة لعرض التزامها بالابتكار والتعليم وتطوير المجتمع. من خلال التوافق مع هذا الحدث، يمكن للرعاة تعزيز رؤيتهم وسمعتهم في المنطقة.
            </p>
        </div>
    </section>

    <!-- Partners Blocks -->
    <section class="py-5" aria-label="منظومة الشركاء">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <!-- 1. السلطات الوطنية -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">الفئة 1</span>
                            السلطات الوطنية والشركاء الحكوميون
                        </h2>
                        <ul class="partner-entity-list">
                            <li>هيئة البحث والتطوير والابتكار (RDIA)</li>
                            <li>هيئة الحكومة الرقمية (DGA)</li>
                            <li>مستشفى الصحة الافتراضي (VHH)</li>
                            <li>الهيئة الوطنية للأمن السيبراني</li>
                            <li>الهيئة السعودية للمواصفات والمقاييس والجودة (SASO)</li>
                            <li>الهيئة العامة للغذاء والدواء (SFDA)</li>
                            <li>هيئة الرقابة النووية والإشعاعية (NRRC)</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners77.png") %>" alt="RDIA"><span class="logo-label">هيئة البحث والابتكار RDIA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners1.jpeg") %>" alt="DGA"><span class="logo-label">هيئة الحكومة الرقمية DGA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners6.jpeg") %>" alt="Aramco Digital"><span class="logo-label">أرامكو الرقمية</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner20.jpeg") %>" alt="Ministry of Health"><span class="logo-label">وزارة الصحة MOH</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners9.png") %>" alt="Cybersecurity"><span class="logo-label">الأمن السيبراني</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners8.png") %>" alt="SASO"><span class="logo-label">المواصفات والمقاييس SASO</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners12.jpeg") %>" alt="SFDA"><span class="logo-label">الغذاء والدواء SFDA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners14.jpeg") %>" alt="NRRC"><span class="logo-label">الرقابة النووية NRRC</span></div>
                        </div>
                    </div>

                    <!-- 2. المنظومة الوطنية -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">الفئة 2</span>
                            المنظومة الوطنية للابتكار والتكنولوجيا
                        </h2>
                        <ul class="partner-entity-list">
                            <li>وادي الظهران للتقنية</li>
                            <li>مدينة الملك عبدالعزيز للعلوم والتقنية (KACST)</li>
                            <li>غرفة الشرقية</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners11.png") %>" alt="وادي الظهران"><span class="logo-label">وادي الظهران للتقنية</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners13.png") %>" alt="KACST"><span class="logo-label">مدينة الملك عبدالعزيز KACST</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners.jpeg") %>" alt="غرفة الشرقية"><span class="logo-label">غرفة الشرقية</span></div>
                        </div>
                    </div>

                    <!-- 3. المؤسسات الأكاديمية -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">الفئة 3</span>
                            المؤسسات الأكاديمية والبحثية
                        </h2>
                        <ul class="partner-entity-list">
                            <li>جامعة الملك فهد للبترول والمعادن (KFUPM)</li>
                            <li>المراكز البحثية والكليات الجامعية</li>
                            <li>كليات علوم الحاسب</li>
                            <li>كليات الهندسة</li>
                            <li>كليات العلوم الطبية</li>
                            <li>كليات الطب</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners5.png") %>" alt="KFUPM"><span class="logo-label">جامعة الملك فهد KFUPM</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners10.png") %>" alt="سدايا"><span class="logo-label">سدايا SDAIA</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/PARTNER21.jpeg") %>" alt="جامعة الإمام عبدالرحمن بن فيصل"><span class="logo-label">جامعة الإمام عبدالرحمن IAU</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partners4.png") %>" alt="برنامج جودة الحياة"><span class="logo-label">برنامج جودة الحياة</span></div>
                        </div>
                    </div>

                    <!-- 4. الشركاء في قطاع الصناعة -->
                    <div class="partner-block">
                        <h2 class="partner-block-title">
                            <span class="pillar-number mb-0">الفئة 4</span>
                            الشركاء في قطاعي الصناعة والتكنولوجيا الطبية
                        </h2>
                        <ul class="partner-entity-list">
                            <li>جي إي للرعاية الصحية (GE Healthcare)</li>
                            <li>فيليبس للرعاية الصحية (Philips Healthcare)</li>
                            <li>سيمنز هيلثينيرز (Siemens Healthineers)</li>
                            <li>شركات الأجهزة الطبية وتقنيات التصوير</li>
                            <li>مزودو حلول الذكاء الاصطناعي والصحة الرقمية</li>
                        </ul>
                        <div class="logo-cards-grid">
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner18.png") %>" alt="GE"><span class="logo-label">GE Healthcare</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/5.-Philips-Healthcare.png") %>" alt="Philips"><span class="logo-label">Philips Healthcare</span></div>
                            <div class="logo-card-item"><img src="<%= ResolveUrl("~/Content/images/sponser/partner17.png") %>" alt="Siemens"><span class="logo-label">Siemens Healthineers</span></div>
                        </div>
                    </div>

                    <!-- دور التحالفات الاستراتيجية -->
                    <div class="alliances-ribbon">
                        <h3 class="text-white font-weight-bold mb-2">دور التحالفات الاستراتيجية</h3>
                        <p class="text-secondary mb-4" style="font-size: 1.15rem;">ستدعم هذه التحالفات القمة من خلال:</p>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-radioactive"></i></div>
                            <span>التعاون العلمي والمساهمة في المحتوى.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-shield-check"></i></div>
                            <span>مواءمة السياسات والأطر التنظيمية.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-display"></i></div>
                            <span>عروض تقنية وتوضيحات عملية مباشرة.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-rocket-takeoff"></i></div>
                            <span>الابتكار وإشراك الشركات الناشئة.</span>
                        </div>

                        <div class="alliance-point-item">
                            <div class="alliance-point-icon"><i class="bi bi-award"></i></div>
                            <span>الشراكات البحثية والمبادرات المستقبلية.</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
