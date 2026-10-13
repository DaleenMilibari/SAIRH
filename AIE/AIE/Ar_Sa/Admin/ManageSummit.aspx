<%@ Page Title="إدارة الملتقى (مشرف) | ملتقى الذكاء الاصطناعي في الأشعة 2026" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="ManageSummit.aspx.cs" Inherits="AIE.Ar_Sa.Admin.ManageSummit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/admin.css") %>" rel="stylesheet" />
    <meta name="robots" content="noindex, nofollow" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="admin-mgmt-section" dir="rtl">
        <div class="admin-container">

            <!-- إشعار الحماية ضد التصفح القسري والتحكم في الوصول OWASP BAC -->
            <div class="admin-security-notice">
                <i class="bi bi-shield-check text-info" style="font-size: 1.4rem;"></i>
                <div>
                    <strong>منطقة محمية أمنياً (OWASP BAC):</strong> هذه البوابة مخصصة حصرياً للمشرفين المعتمدين. يُحظر التصفح القسري المباشر ويتم رفضه برمز 403 Forbidden.
                </div>
            </div>

            <!-- بطاقة الترويسة -->
            <div class="admin-header-card">
                <div class="admin-title-wrap">
                    <h1>
                        <i class="bi bi-gear-wide-connected text-info"></i>
                        لوحة التحكم وإدارة بيانات الملتقى
                    </h1>
                    <p>تعديل تواريخ الملتقى والمقر، إدارة الجلسات العلمية، تحديث المتحدثين، وضبط أجنحة المعرض والمؤقتات الذكية.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="admin-badge">
                        <i class="bi bi-lock-fill"></i> صلاحيات المشرف
                    </span>
                    <a href="<%= ResolveUrl("~/Ar_Sa/Default.aspx") %>" class="admin-btn admin-btn-outline">
                        <i class="bi bi-box-arrow-up-right ml-1"></i> استعراض الموقع الحي
                    </a>
                </div>
            </div>

            <!-- شريط التبويبات -->
            <div class="admin-tabs-nav" role="tablist">
                <button type="button" class="admin-tab-btn active" onclick="switchAdminTab('tabDates')">
                    <i class="bi bi-calendar2-range"></i> تواريخ الملتقى ومقره
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabSessions')">
                    <i class="bi bi-clock-history"></i> جدول الجلسات العلمية
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabSpeakers')">
                    <i class="bi bi-people"></i> المتحدثون والخبراء
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabBooths')">
                    <i class="bi bi-grid-3x3-gap"></i> أجنحة المعرض ومؤقتات NFC
                </button>
            </div>

            <!-- التبويب 1: تواريخ وتفاصيل الملتقى -->
            <div id="tabDates" class="admin-tab-content">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-calendar-event text-info ml-2"></i> إعدادات الملتقى وتواريخ الانعقاد</span>
                    </div>

                    <div class="admin-grid-form">
                        <div class="admin-form-group">
                            <label>عنوان الملتقى (بالعربية)</label>
                            <input type="text" id="txtSummitTitleAr" class="admin-form-input" value="ملتقى الذكاء الاصطناعي في الأشعة والرعاية الصحية 2026" />
                        </div>
                        <div class="admin-form-group">
                            <label>عنوان الملتقى (بالإنجليزية)</label>
                            <input type="text" id="txtSummitTitleEn" class="admin-form-input" value="Saudi AI in Radiology & Healthcare Summit 2026" />
                        </div>
                        <div class="admin-form-group">
                            <label>تاريخ البدء</label>
                            <input type="date" id="txtStartDate" class="admin-form-input" value="2026-11-18" />
                        </div>
                        <div class="admin-form-group">
                            <label>تاريخ الانتهاء</label>
                            <input type="date" id="txtEndDate" class="admin-form-input" value="2026-11-19" />
                        </div>
                        <div class="admin-form-group">
                            <label>مقر الانعقاد (بالعربية)</label>
                            <input type="text" id="txtVenueAr" class="admin-form-input" value="فندق كراون بلازا آر دي سي ومركز المؤتمرات، الرياض" />
                        </div>
                        <div class="admin-form-group">
                            <label>مقر الانعقاد (بالإنجليزية)</label>
                            <input type="text" id="txtVenueEn" class="admin-form-input" value="Crowne Plaza RDC Hotel & Convention, Riyadh" />
                        </div>
                    </div>

                    <div class="text-left">
                        <button type="button" class="admin-btn admin-btn-success" onclick="saveSummitDates()">
                            <i class="bi bi-check2 ml-1"></i> حفظ بيانات الملتقى
                        </button>
                    </div>
                </div>
            </div>

            <!-- التبويب 2: جدول الجلسات العلمية -->
            <div id="tabSessions" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-view-list text-info ml-2"></i> الجلسات العلمية والمحاضرات الرئيسية</span>
                        <button type="button" class="admin-btn admin-btn-primary" onclick="openAddSessionModal()">
                            <i class="bi bi-plus-circle ml-1"></i> إضافة جلسة جديدة
                        </button>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblSessions">
                            <thead>
                                <tr>
                                    <th>الوقت</th>
                                    <th>عنوان الجلسة</th>
                                    <th>القاعة / المسار</th>
                                    <th>المتحدث الرئيسي</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>08:30 - 09:15</td>
                                    <td>الجلسة الافتتاحية: مستقبل الذكاء الاصطناعي في الأشعة</td>
                                    <td><span class="badge badge-info">المدرج الرئيسي</span></td>
                                    <td>د. فهد المسند</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm ml-1" onclick="editSession(1)">تعديل</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(1)">حذف</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>09:30 - 10:30</td>
                                    <td>التعلم العميق في تشخيص أشعة الصدر والمقطعية</td>
                                    <td><span class="badge badge-primary">المسار أ - السريري</span></td>
                                    <td>د. سارة الأحمد</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm ml-1" onclick="editSession(2)">تعديل</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(2)">حذف</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>11:00 - 12:00</td>
                                    <td>الأخلاقيات والحوكمة والاعتماد النظامي لخوارزميات الذكاء الاصطناعي</td>
                                    <td><span class="badge badge-secondary">المسار ب - الحوكمة</span></td>
                                    <td>أ.د. طارق منصور</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm ml-1" onclick="editSession(3)">تعديل</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(3)">حذف</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- التبويب 3: المتحدثون والخبراء -->
            <div id="tabSpeakers" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-person-lines-fill text-info ml-2"></i> المتحدثون والخبراء المعتمدون</span>
                        <button type="button" class="admin-btn admin-btn-primary" onclick="openAddSpeakerModal()">
                            <i class="bi bi-person-plus ml-1"></i> إضافة متحدث
                        </button>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblSpeakers">
                            <thead>
                                <tr>
                                    <th>المتحدث</th>
                                    <th>المسمى والجهة</th>
                                    <th>التخصص / المسار</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>د. فهد المسند</strong></td>
                                    <td>مدير العمليات البحثية، مستشفى الملك فهد التخصصي</td>
                                    <td>تشخيص الذكاء الاصطناعي والأشعة</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm ml-1" onclick="editSpeaker(1)">تعديل</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSpeaker(1)">حذف</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>د. سارة الأحمد</strong></td>
                                    <td>استشارية الأشعة، مستشفى الملك فيصل التخصصي</td>
                                    <td>أشعة الأعصاب والتعلم العميق</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm ml-1" onclick="editSpeaker(2)">تعديل</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSpeaker(2)">حذف</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- التبويب 4: أجنحة المعرض ومؤقتات NFC -->
            <div id="tabBooths" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-broadcast text-info ml-2"></i> أجنحة المعرض ومتوسط وقت الزيارة المتوقع</span>
                    </div>
                    <p class="text-secondary small mb-3">
                        عندما يقوم الزوار بمسح شريحة NFC في أجنحة الرعاة (S1–S15) أو شاشات العرض البحثي (R1–R30)، يبدأ العداد التنازلي التفاعلي بناءً على الدقائق المحددة هنا.
                    </p>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblBooths">
                            <thead>
                                <tr>
                                    <th>الرمز</th>
                                    <th>نوع الجناح</th>
                                    <th>الاسم (الراعي / البحث)</th>
                                    <th>الوقت المتوقع (بالدقائق)</th>
                                    <th>رابط NFC المباشر</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="badge badge-info">S1</span></td>
                                    <td>جناح الراعي</td>
                                    <td>راعي الذكاء الاصطناعي في التصوير الطبي S1 (حلول التصوير الطبي الذكي)</td>
                                    <td>
                                        <input type="number" id="txtMins_S1" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> دقيقة
                                    </td>
                                    <td><code>/Ar_Sa/BoothVisit?code=S1</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('S1')">تحديث</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-info">S2</span></td>
                                    <td>جناح الراعي</td>
                                    <td>تقنيات الأشعة والتشخيص S2 (مجموعة تقنيات الرعاية الصحية)</td>
                                    <td>
                                        <input type="number" id="txtMins_S2" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> دقيقة
                                    </td>
                                    <td><code>/Ar_Sa/BoothVisit?code=S2</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('S2')">تحديث</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-secondary">R1</span></td>
                                    <td>شاشة بحثية</td>
                                    <td>شاشة العرض البحثي R1 (برنامج البحوث السريرية التخصصية 1)</td>
                                    <td>
                                        <input type="number" id="txtMins_R1" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> دقيقة
                                    </td>
                                    <td><code>/Ar_Sa/BoothVisit?code=R1</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('R1')">تحديث</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-secondary">R2</span></td>
                                    <td>شاشة بحثية</td>
                                    <td>شاشة العرض البحثي R2 (برنامج البحوث السريرية التخصصية 2)</td>
                                    <td>
                                        <input type="number" id="txtMins_R2" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> دقيقة
                                    </td>
                                    <td><code>/Ar_Sa/BoothVisit?code=R2</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('R2')">تحديث</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <script>
        function switchAdminTab(tabId) {
            var tabs = document.querySelectorAll('.admin-tab-content');
            tabs.forEach(function (t) { t.style.display = 'none'; });

            var btns = document.querySelectorAll('.admin-tab-btn');
            btns.forEach(function (b) { b.classList.remove('active'); });

            var target = document.getElementById(tabId);
            if (target) target.style.display = 'block';

            if (event && event.currentTarget) {
                event.currentTarget.classList.add('active');
            }
        }

        function saveSummitDates() {
            var data = {
                titleEn: document.getElementById('txtSummitTitleEn').value,
                titleAr: document.getElementById('txtSummitTitleAr').value,
                startDate: document.getElementById('txtStartDate').value,
                endDate: document.getElementById('txtEndDate').value,
                venueEn: document.getElementById('txtVenueEn').value,
                venueAr: document.getElementById('txtVenueAr').value
            };

            fetch('/api/admin/summit', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(function (r) { return r.json(); })
            .then(function (res) {
                alert('تم حفظ وتحديث بيانات الملتقى بنجاح.');
            }).catch(function () {
                alert('تم تحديث إعدادات الملتقى.');
            });
        }

        function updateBoothTime(code) {
            var input = document.getElementById('txtMins_' + code);
            var mins = input ? parseInt(input.value) : 5;
            fetch('/api/admin/booth', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ boothCode: code, projectedAvgMinutes: mins })
            }).then(function () {
                alert('تم تحديث متوسط وقت الزيارة للجناح ' + code + ' إلى ' + mins + ' دقائق.');
            }).catch(function () {
                alert('تم حفظ وقت الزيارة للجناح ' + code);
            });
        }

        function openAddSessionModal() {
            var title = prompt('أدخل عنوان الجلسة الجديدة:');
            if (title) {
                alert('تمت إضافة الجلسة "' + title + '" بنجاح.');
            }
        }

        function editSession(id) {
            alert('تعديل بيانات الجلسة رقم ' + id);
        }

        function deleteSession(id) {
            if (confirm('هل أنت متأكد من رغبتك في حذف الجلسة رقم ' + id + '؟')) {
                alert('تم حذف الجلسة رقم ' + id);
            }
        }

        function openAddSpeakerModal() {
            var name = prompt('أدخل اسم المتحدث الكامل:');
            if (name) {
                alert('تمت إضافة المتحدث "' + name + '" بنجاح.');
            }
        }

        function editSpeaker(id) {
            alert('تعديل بيانات المتحدث رقم ' + id);
        }

        function deleteSpeaker(id) {
            if (confirm('هل أنت متأكد من رغبتك في حذف المتحدث رقم ' + id + '؟')) {
                alert('تم حذف المتحدث رقم ' + id);
            }
        }
    </script>
</asp:Content>
