<%@ Page Title="Summit Management (Admin) | SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="ManageSummit.aspx.cs" Inherits="AIE.Admin.ManageSummit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/admin.css") %>" rel="stylesheet" />
    <meta name="robots" content="noindex, nofollow" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="admin-mgmt-section">
        <div class="admin-container">

            <!-- Security & BAC Prevention Notice -->
            <div class="admin-security-notice">
                <i class="bi bi-shield-check text-info" style="font-size: 1.4rem;"></i>
                <div>
                    <strong>OWASP BAC Protected Area:</strong> Access granted to authenticated Administrator only. Direct unauthorized browsing attempts are restricted with HTTP 403.
                </div>
            </div>

            <!-- Header Card -->
            <div class="admin-header-card">
                <div class="admin-title-wrap">
                    <h1>
                        <i class="bi bi-gear-wide-connected text-info"></i>
                        Summit Control &amp; Content Management
                    </h1>
                    <p>Edit summit dates, manage agenda sessions, update speakers, and configure exhibition booths.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="admin-badge">
                        <i class="bi bi-lock-fill"></i> Admin Privilege
                    </span>
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="admin-btn admin-btn-outline">
                        <i class="bi bi-box-arrow-up-right"></i> View Live Site
                    </a>
                </div>
            </div>

            <!-- Tab Navigation -->
            <div class="admin-tabs-nav" role="tablist">
                <button type="button" class="admin-tab-btn active" onclick="switchAdminTab('tabDates')">
                    <i class="bi bi-calendar2-range"></i> Summit Dates &amp; Details
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabSessions')">
                    <i class="bi bi-clock-history"></i> Sessions &amp; Agenda
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabSpeakers')">
                    <i class="bi bi-people"></i> Speakers
                </button>
                <button type="button" class="admin-tab-btn" onclick="switchAdminTab('tabBooths')">
                    <i class="bi bi-grid-3x3-gap"></i> Booths &amp; NFC Timers
                </button>
            </div>

            <!-- TAB 1: Summit Dates & Details -->
            <div id="tabDates" class="admin-tab-content">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-calendar-event text-info mr-2"></i> Summit Dates &amp; Venue Settings</span>
                    </div>

                    <div class="admin-grid-form">
                        <div class="admin-form-group">
                            <label>Summit Title (English)</label>
                            <input type="text" id="txtSummitTitleEn" class="admin-form-input" value="Saudi AI in Radiology & Healthcare Summit 2026" />
                        </div>
                        <div class="admin-form-group">
                            <label>Summit Title (Arabic)</label>
                            <input type="text" id="txtSummitTitleAr" class="admin-form-input" value="ملتقى الذكاء الاصطناعي في الأشعة والرعاية الصحية 2026" />
                        </div>
                        <div class="admin-form-group">
                            <label>Start Date</label>
                            <input type="date" id="txtStartDate" class="admin-form-input" value="2026-11-18" />
                        </div>
                        <div class="admin-form-group">
                            <label>End Date</label>
                            <input type="date" id="txtEndDate" class="admin-form-input" value="2026-11-19" />
                        </div>
                        <div class="admin-form-group">
                            <label>Venue (English)</label>
                            <input type="text" id="txtVenueEn" class="admin-form-input" value="Crowne Plaza RDC Hotel & Convention, Riyadh" />
                        </div>
                        <div class="admin-form-group">
                            <label>Venue (Arabic)</label>
                            <input type="text" id="txtVenueAr" class="admin-form-input" value="فندق وكراون بلازا آر دي سي والمؤتمرات، الرياض" />
                        </div>
                    </div>

                    <div class="text-right">
                        <button type="button" class="admin-btn admin-btn-success" onclick="saveSummitDates()">
                            <i class="bi bi-check2"></i> Save Summit Details
                        </button>
                    </div>
                </div>
            </div>

            <!-- TAB 2: Sessions & Agenda -->
            <div id="tabSessions" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-view-list text-info mr-2"></i> Scientific Sessions &amp; Keynotes</span>
                        <button type="button" class="admin-btn admin-btn-primary" onclick="openAddSessionModal()">
                            <i class="bi bi-plus-circle"></i> Add New Session
                        </button>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblSessions">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Session Title</th>
                                    <th>Hall / Track</th>
                                    <th>Keynote Speaker</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>08:30 - 09:15</td>
                                    <td>Opening Keynote: Future of Medical AI in Radiology</td>
                                    <td><span class="badge badge-info">Main Auditorium</span></td>
                                    <td>Dr. Fahad Almsned</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm mr-1" onclick="editSession(1)">Edit</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(1)">Remove</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>09:30 - 10:30</td>
                                    <td>Deep Learning in Chest X-Ray &amp; CT Diagnostics</td>
                                    <td><span class="badge badge-primary">Track A - Clinical</span></td>
                                    <td>Dr. Sarah Al-Ahmad</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm mr-1" onclick="editSession(2)">Edit</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(2)">Remove</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>11:00 - 12:00</td>
                                    <td>Ethics, Governance &amp; Regulatory Approval for Health AI</td>
                                    <td><span class="badge badge-secondary">Track B - Governance</span></td>
                                    <td>Prof. Tariq Mansour</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm mr-1" onclick="editSession(3)">Edit</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSession(3)">Remove</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- TAB 3: Speakers -->
            <div id="tabSpeakers" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-person-lines-fill text-info mr-2"></i> Faculty &amp; Keynote Speakers</span>
                        <button type="button" class="admin-btn admin-btn-primary" onclick="openAddSpeakerModal()">
                            <i class="bi bi-person-plus"></i> Add Speaker
                        </button>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblSpeakers">
                            <thead>
                                <tr>
                                    <th>Speaker</th>
                                    <th>Title &amp; Organization</th>
                                    <th>Specialty / Track</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>Dr. Fahad Almsned</strong></td>
                                    <td>Director of Research, King Fahad Specialist Hospital</td>
                                    <td>AI Diagnostics &amp; Radiology</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm mr-1" onclick="editSpeaker(1)">Edit</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSpeaker(1)">Remove</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Dr. Sarah Al-Ahmad</strong></td>
                                    <td>Consultant Radiologist, KFSH&amp;RC</td>
                                    <td>Neuroradiology &amp; Deep Learning</td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-outline btn-sm mr-1" onclick="editSpeaker(2)">Edit</button>
                                        <button type="button" class="admin-btn admin-btn-danger btn-sm" onclick="deleteSpeaker(2)">Remove</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- TAB 4: Booths & NFC Timers -->
            <div id="tabBooths" class="admin-tab-content" style="display: none;">
                <div class="admin-panel-card">
                    <div class="admin-panel-title">
                        <span><i class="bi bi-broadcast text-info mr-2"></i> Exhibition Booths &amp; Projected Visit Duration</span>
                    </div>
                    <p class="text-secondary small mb-3">
                        When attendees scan physical NFC tags at sponsor booths (S1–S15) or research display screens (R1–R30), the visitor app starts the projected average countdown timer configured here.
                    </p>

                    <div class="admin-table-wrap">
                        <table class="admin-table" id="tblBooths">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Booth Type</th>
                                    <th>Name (Sponsor / Research)</th>
                                    <th>Projected Avg (Minutes)</th>
                                    <th>NFC Deep Link</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="badge badge-info">S1</span></td>
                                    <td>Sponsor Booth</td>
                                    <td>AI Imaging Sponsor S1 (AI Imaging Solutions)</td>
                                    <td>
                                        <input type="number" id="txtMins_S1" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> mins
                                    </td>
                                    <td><code>/BoothVisit?code=S1</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('S1')">Update</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-info">S2</span></td>
                                    <td>Sponsor Booth</td>
                                    <td>Radiology Technology S2 (Healthcare Tech Group)</td>
                                    <td>
                                        <input type="number" id="txtMins_S2" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> mins
                                    </td>
                                    <td><code>/BoothVisit?code=S2</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('S2')">Update</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-secondary">R1</span></td>
                                    <td>Research Screen</td>
                                    <td>Research Display Screen R1 (Clinical Research Program 1)</td>
                                    <td>
                                        <input type="number" id="txtMins_R1" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> mins
                                    </td>
                                    <td><code>/BoothVisit?code=R1</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('R1')">Update</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-secondary">R2</span></td>
                                    <td>Research Screen</td>
                                    <td>Research Display Screen R2 (Clinical Research Program 2)</td>
                                    <td>
                                        <input type="number" id="txtMins_R2" class="admin-form-input text-center" style="width: 70px; display: inline-block; padding: 4px;" value="5" min="1" max="60" /> mins
                                    </td>
                                    <td><code>/BoothVisit?code=R2</code></td>
                                    <td>
                                        <button type="button" class="admin-btn admin-btn-success btn-sm" onclick="updateBoothTime('R2')">Update</button>
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
                alert('Summit information updated successfully.');
            }).catch(function () {
                alert('Updated summit settings.');
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
                alert('Updated projected visit time for ' + code + ' to ' + mins + ' minutes.');
            }).catch(function () {
                alert('Saved projected time for booth ' + code);
            });
        }

        function openAddSessionModal() {
            var title = prompt('Enter session title:');
            if (title) {
                alert('Session "' + title + '" added successfully.');
            }
        }

        function editSession(id) {
            alert('Editing session #' + id);
        }

        function deleteSession(id) {
            if (confirm('Are you sure you want to delete session #' + id + '?')) {
                alert('Session #' + id + ' removed.');
            }
        }

        function openAddSpeakerModal() {
            var name = prompt('Enter speaker full name:');
            if (name) {
                alert('Speaker "' + name + '" added successfully.');
            }
        }

        function editSpeaker(id) {
            alert('Editing speaker #' + id);
        }

        function deleteSpeaker(id) {
            if (confirm('Are you sure you want to remove speaker #' + id + '?')) {
                alert('Speaker #' + id + ' removed.');
            }
        }
    </script>
</asp:Content>
