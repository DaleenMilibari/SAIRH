<%@ Page Title="المتحدثون والخبراء - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="Speakers.aspx.cs" Inherits="AIE.Ar_Sa.Speakers" %>

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
        /* Search Box & Centered Icon Fix */
        .speakers-search-box {
            position: relative !important;
            width: 100% !important;
            display: flex !important;
            align-items: center !important;
        }
        .speakers-search-box .search-icon {
            position: absolute !important;
            top: 50% !important;
            transform: translateY(-50%) !important;
            right: 20px !important;
            left: auto !important;
            color: #38bdf8 !important;
            font-size: 1.15rem !important;
            line-height: 1 !important;
            pointer-events: none !important;
            z-index: 5 !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            width: 20px !important;
            height: 20px !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        .speakers-search-input {
            width: 100% !important;
            height: 52px !important;
            background: rgba(4, 8, 22, 0.75) !important;
            border: 1px solid var(--lg-glass-border) !important;
            border-radius: 16px !important;
            color: #ffffff !important;
            padding-right: 54px !important;
            padding-left: 48px !important;
            padding-top: 12px !important;
            padding-bottom: 12px !important;
            font-size: 0.98rem !important;
            transition: var(--lg-transition) !important;
            outline: none !important;
            box-sizing: border-box !important;
            text-align: right !important;
        }
        .speakers-search-clear {
            position: absolute !important;
            top: 50% !important;
            transform: translateY(-50%) !important;
            left: 18px !important;
            right: auto !important;
            background: transparent !important;
            border: none !important;
            color: var(--lg-text-muted) !important;
            cursor: pointer !important;
            padding: 0 !important;
            width: 24px !important;
            height: 24px !important;
            display: none;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.25rem !important;
            line-height: 1 !important;
            z-index: 5 !important;
            transition: color 0.2s ease !important;
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
    <section class="py-5 hero-no-reveal" aria-label="دليل المتحدثين">
        <div class="container">

            <!-- Filter Toolbar -->
            <div class="speakers-filter-container" id="speakersFilterSection">
                <!-- Search Bar (Searches by Speaker Name, Session Title, Track) -->
                <div class="speakers-search-box">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" id="speakerSearch" class="speakers-search-input" placeholder="ابحث باسم المتحدث، أو عنوان الجلسة، أو المسار..." aria-label="بحث المتحدثين" />
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
                        عرض <strong id="speakersCount" class="text-white">30</strong> من أصل <span id="speakersTotalCount">30</span> متحدثاً
                    </div>
                    <div>
                        <button type="button" id="btnResetFilters" class="btn-reset-filters" style="display:none;">
                            <i class="bi bi-arrow-counterclockwise"></i> إعادة ضبط التصفية
                        </button>
                    </div>
                </div>
            </div>

            <!-- Speakers Grid (Dynamically rendered from Database) -->
            <div id="speakersGrid" class="speakers-grid">
                <asp:Repeater ID="rptSpeakers" runat="server">
                    <ItemTemplate>
                        <article class='<%# "speaker-card " + Eval("TrackCssClass") %>'
                                 data-photo='<%# ResolveSpeakerUrl(Eval("ImagePath")) %>'
                                 data-cv='<%# ResolveSpeakerUrl(Eval("CvPdfPath")) %>'
                                 data-track='<%# Eval("Track") %>'
                                 data-sector='<%# Eval("Sector") %>'
                                 data-region='<%# Eval("Region") %>'
                                 data-name='<%# HttpUtility.HtmlAttributeEncode(Eval("Name") as string ?? "") %>'
                                 data-role='<%# HttpUtility.HtmlAttributeEncode(Eval("JobTitle") as string ?? "") %>'
                                 data-org='<%# HttpUtility.HtmlAttributeEncode(Eval("Organization") as string ?? "") %>'
                                 data-lecture='<%# HttpUtility.HtmlAttributeEncode(Eval("LectureTitle") as string ?? "") %>'
                                 data-track-name='<%# HttpUtility.HtmlAttributeEncode(Eval("TrackName") as string ?? "") %>'
                                 data-sector-name='<%# HttpUtility.HtmlAttributeEncode(Eval("SectorName") as string ?? "") %>'
                                 data-region-name='<%# HttpUtility.HtmlAttributeEncode(Eval("RegionName") as string ?? "") %>'
                                 data-flag='<%# Eval("Flag") %>'
                                 data-initials='<%# Eval("Initials") %>'
                                 data-room='<%# HttpUtility.HtmlAttributeEncode(Eval("Room") as string ?? "") %>'
                                 data-time='<%# HttpUtility.HtmlAttributeEncode(Eval("SessionTime") as string ?? "") %>'
                                 data-day='<%# Eval("DayNumber") %>'
                                 data-session-role='<%# HttpUtility.HtmlAttributeEncode(Eval("Role") as string ?? "") %>'>
                            <div class="speaker-card-header">
                                <span class='<%# "speaker-track-tag tag-" + Eval("Track") %>' onclick='filterToTrack("<%# Eval("Track") %>")' style="cursor:pointer;" title="تصفية حسب هذا المسار">
                                    <i class='<%# Eval("TrackIcon") %>'></i> <%# Eval("TrackBadge") %>
                                </span>
                                <span class="speaker-sector-tag">
                                    <i class='<%# Eval("SectorIcon") %>'></i> <%# Eval("SectorBadge") %>
                                </span>
                            </div>
                            <div class="speaker-avatar-wrap">
                                <img src='<%# ResolveSpeakerUrl(Eval("ImagePath")) %>' alt='<%# HttpUtility.HtmlAttributeEncode(Eval("Name") as string ?? "") %>' class="speaker-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="speaker-monogram" style="display:none;"><%# Eval("Initials") %></div>
                                <span class="speaker-badge-flag" title='<%# Eval("RegionName") %>'><%# Eval("Flag") %></span>
                            </div>
                            <div class="speaker-body">
                                <h3 class="speaker-name"><%# Eval("Name") %></h3>
                                <p class="speaker-title"><%# Eval("JobTitle") %></p>
                                <p class="speaker-org">
                                    <i class="bi bi-bank sairh-organization-icon"></i>
                                    <span><%# Eval("Organization") %></span>
                                </p>
                                <%# RenderLectureHtml(Eval("LectureTitle") as string, Eval("LectureLabel") as string) %>
                            </div>
                            <div class="speaker-card-actions">
                                <button type="button" class="btn-speaker-detail" onclick="openSpeakerModal(this.closest('.speaker-card'))">
                                    <i class="bi bi-info-circle"></i> <%# Eval("QuickOverviewText") %>
                                </button>
                            </div>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
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

    <!-- نافذة تفاصيل المتحدث (نظرة سريعة) -->
    <div id="speakerModal" class="speaker-modal-backdrop" onclick="if(event.target===this)closeSpeakerModal()">
        <div class="speaker-modal-window" style="max-width: 480px; text-align: center; padding: 36px 30px;">
            <button type="button" class="speaker-modal-close" onclick="closeSpeakerModal()" aria-label="إغلاق النافذة">&times;</button>
            
            <!-- صورة المتحدث -->
            <div class="speaker-avatar-wrap mx-auto mb-3" style="width: 105px; height: 105px;">
                <img id="modalSpeakerPhoto" src="" alt="المتحدث" class="speaker-avatar-img" style="width: 105px; height: 105px; display: none;" />
                <div id="modalSpeakerInitials" class="speaker-monogram" style="width: 105px; height: 105px; font-size: 1.8rem;">م.ت</div>
                <span id="modalSpeakerFlag" class="speaker-badge-flag" style="font-size: 1.25rem;">🇸🇦</span>
            </div>

            <!-- الاسم الكامل -->
            <h3 id="modalSpeakerName" class="text-white font-weight-bold mb-1" style="font-size: 1.45rem;">اسم المتحدث</h3>

            <!-- المسمى والصفة -->
            <p id="modalSpeakerRole" class="text-info font-weight-600 mb-1" style="font-size: 0.95rem;">المنصب والصفة</p>

            <!-- جهة العمل -->
            <p id="modalSpeakerOrg" class="text-secondary small mb-3" style="font-size: 0.88rem;">
                <i class="bi bi-bank ml-1 text-secondary"></i> <span>جهة العمل</span>
            </p>

            <!-- عنوان الجلسة / المحاضرة -->
            <div id="modalLectureWrapper" class="speaker-lecture-card text-right my-3" style="background: rgba(4, 8, 22, 0.7); padding: 14px 18px; border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.08); text-align: right;">
                <div class="speaker-lecture-label" style="font-size: 0.76rem; margin-bottom: 6px; color: #38bdf8;">
                    <i class="bi bi-mic-fill ml-1"></i> الجلسة والمحاضرة العلمية
                </div>
                <h4 id="modalLectureTitle" class="text-white font-weight-600 mb-0" style="font-size: 0.98rem; line-height: 1.5;">
                    عنوان المحاضرة
                </h4>
            </div>

            <!-- الإجراءات: عرض السيرة الذاتية PDF -->
            <div class="d-flex flex-column align-items-center mt-3 pt-3 border-top border-secondary" style="gap: 10px;">
                <a id="modalCvBtn" href="#" target="_blank" rel="noopener noreferrer" class="btn btn-info rounded-pill px-4 py-2 font-weight-bold w-100" style="display:none; max-width: 260px;">
                    <i class="bi bi-file-earmark-pdf ml-1"></i> عرض السيرة الذاتية (PDF)
                </a>
                <span id="modalNoCvMsg" class="text-secondary small" style="display:none;">السيرة الذاتية غير متوفرة حالياً</span>
                <button type="button" class="btn btn-outline-secondary rounded-pill px-4 py-2 font-weight-bold" onclick="closeSpeakerModal()">
                    إغلاق
                </button>
            </div>
        </div>
    </div>

    <!-- Interactive Scripts -->
    <script src="<%= ResolveUrl("~/Scripts/speakers.js") %>"></script>
    <script>
        (function() {
            var isDb = <%= IsLoadedFromDatabase ? "true" : "false" %>;
            var err = "<%= HttpUtility.JavaScriptStringEncode(DatabaseErrorMessage ?? "") %>";
            if (isDb) {
                console.info("[SAIRH Speakers Ar] Successfully loaded live from database.");
            } else {
                console.warn("[SAIRH Speakers Ar] Loaded from static cache. Database info: " + (err || "fallback"));
            }
        })();
    </script>
</asp:Content>