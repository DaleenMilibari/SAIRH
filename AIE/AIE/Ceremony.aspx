<%@ Page Title="Conference Program & Tracks - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Ceremony.aspx.cs" Inherits="AIE.Ceremony" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Program &amp; Tracks Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Conference Program &amp; Tracks
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 780px; font-size: 1.15rem; line-height: 1.8;">
                Explore the three specialized summit tracks and comprehensive 2-day conference agenda uniting artificial intelligence pioneers, clinical imaging specialists, and healthcare education leaders.
            </p>
        </div>
    </section>

    <!-- 3 Specialized Summit Tracks (Consolidated Overview) -->
    <section class="py-5" id="tracks-overview" aria-label="Conference Tracks">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-2">Specialized Summit Tracks</h2>
                <div style="width: 60px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 16px; border-radius: 2px;"></div>
                <p class="text-muted mx-auto" style="max-width: 680px; font-size: 1rem;">
                    Select a track to immediately filter the scientific agenda sessions below.
                </p>
            </div>

            <div class="track-deck-grid mb-4">
                <!-- Track A -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-a"><i class="bi bi-cpu mr-1"></i> Track A</span>
                        <h2 class="track-deck-title">
                            Artificial Intelligence, Digital Technology Transformation &amp; RadBix
                        </h2>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-stars mr-1"></i> AI in Imaging</span>
                            <span class="modality-chip"><i class="bi bi-database mr-1"></i> Data Ecosystems</span>
                            <span class="modality-chip"><i class="bi bi-server mr-1"></i> RadBix Platform</span>
                            <span class="modality-chip"><i class="bi bi-gear mr-1"></i> Workflow Automation</span>
                            <span class="modality-chip"><i class="bi bi-shield-check mr-1"></i> Cybersecurity</span>
                            <span class="modality-chip"><i class="bi bi-globe mr-1"></i> National AI Frameworks</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-a')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel mr-1"></i> View Track A Sessions <i class="bi bi-arrow-down ml-1"></i>
                        </button>
                    </div>
                </div>

                <!-- Track B -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-b"><i class="bi bi-activity mr-1"></i> Track B</span>
                        <h2 class="track-deck-title">
                            Advanced Clinical Radiology
                        </h2>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-bandaid mr-1"></i> MRI (2026 Standards)</span>
                            <span class="modality-chip"><i class="bi bi-record-circle mr-1"></i> CT Imaging</span>
                            <span class="modality-chip"><i class="bi bi-broadcast mr-1"></i> Ultrasound</span>
                            <span class="modality-chip"><i class="bi bi-file-earmark-image mr-1"></i> X-Ray</span>
                            <span class="modality-chip"><i class="bi bi-heart-pulse mr-1"></i> Interventional (IVR)</span>
                            <span class="modality-chip"><i class="bi bi-radioactive mr-1"></i> Nuclear Medicine (NM)</span>
                            <span class="modality-chip"><i class="bi bi-gender-female mr-1"></i> Mammography</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-b')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel mr-1"></i> View Track B Sessions <i class="bi bi-arrow-down ml-1"></i>
                        </button>
                    </div>
                </div>

                <!-- Track C -->
                <div class="track-deck-card">
                    <div>
                        <span class="track-deck-pill pill-c"><i class="bi bi-mortarboard mr-1"></i> Track C</span>
                        <h2 class="track-deck-title">
                            Education, Quality, Research &amp; Innovation
                        </h2>
                        <div class="modality-chip-list mb-4">
                            <span class="modality-chip"><i class="bi bi-search mr-1"></i> Research Methods</span>
                            <span class="modality-chip"><i class="bi bi-journal-text mr-1"></i> High-Impact Publishing</span>
                            <span class="modality-chip"><i class="bi bi-check-circle mr-1"></i> Quality Standards</span>
                            <span class="modality-chip"><i class="bi bi-laptop mr-1"></i> Simulation Training</span>
                            <span class="modality-chip"><i class="bi bi-lightbulb mr-1"></i> Innovation Labs</span>
                        </div>
                    </div>
                    <div>
                        <button type="button" onclick="filterTrackAndScroll('track-c')" class="btn btn-outline-info rounded-pill w-100 py-2 font-weight-bold">
                            <i class="bi bi-funnel mr-1"></i> View Track C Sessions <i class="bi bi-arrow-down ml-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Interactive Schedule Section -->
    <section class="py-5" id="program-schedule" aria-label="Interactive Scientific Agenda">
        <div class="container program-container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-2">2-Day Scientific Agenda</h2>
                <div style="width: 60px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 20px; border-radius: 2px;"></div>
            </div>

            <!-- Day Selection Tabs -->
            <div class="agenda-day-tabs">
                <button type="button" class="agenda-day-btn active" onclick="selectDay('day1', this)">
                    <i class="bi bi-calendar2-check mr-1"></i> Day 1 – AI, Clinical Excellence &amp; Innovation
                </button>
                <button type="button" class="agenda-day-btn" onclick="selectDay('day2', this)">
                    <i class="bi bi-calendar2-check mr-1"></i> Day 2 – Advancing Radiology &amp; AI Systems
                </button>
            </div>

            <!-- Track Filter Pills -->
            <div class="track-filter-bar">
                <button type="button" class="track-filter-pill active" onclick="filterTrack('all', this)"><i class="bi bi-grid-3x3-gap mr-1"></i> All Sessions</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-a', this)"><i class="bi bi-cpu mr-1"></i> Track A: AI &amp; RadBix</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-b', this)"><i class="bi bi-activity mr-1"></i> Track B: Clinical Radiology</button>
                <button type="button" class="track-filter-pill" onclick="filterTrack('track-c', this)"><i class="bi bi-mortarboard mr-1"></i> Track C: Education &amp; Quality</button>
            </div>

            <!-- DAY 1 CONTENT -->
            <div id="day1-panel" class="day-panel active">
                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 07:00–09:30</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-person-badge mr-2 text-info"></i> Registration &amp; Opening Ceremony</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-heart-pulse mr-2 text-primary"></i> Advanced Neuro MRI (fMRI &amp; DTI)</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-shield-check mr-2 text-success"></i> Pediatric Imaging Safety</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-people mr-2 text-info"></i> Radiology Workforce Training in the AI Era</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:30–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-stars mr-2 text-info"></i> Future of AI in Radiology</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-gear mr-2 text-info"></i> Generative AI for Imaging Workflow</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-truck mr-2 text-danger"></i> Trauma CT Optimization</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-activity mr-2 text-primary"></i> Advanced Spine &amp; Shoulder MRI</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-check-circle mr-2 text-success"></i> Quality Indicators &amp; Global Benchmarking</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-globe mr-2 text-info"></i> National AI Healthcare Framework</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-broadcast mr-2 text-primary"></i> Emergency Ultrasound Updates</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-journal-text mr-2 text-warning"></i> Publishing in High-Impact Journals</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-scale mr-2 text-warning"></i> AI Ethics &amp; Regulations</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-gender-female mr-2 text-danger"></i> Digital Mammography &amp; AI Screening</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lightbulb mr-2 text-warning"></i> Innovation in Radiology – Ideation Lab</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>
            </div>

            <!-- DAY 2 CONTENT -->
            <div id="day2-panel" class="day-panel">
                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-server mr-2 text-info"></i> RadBix Infrastructure &amp; Digital Twin</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-heart mr-2 text-danger"></i> Cardiac MRI – AI-Assisted Techniques</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-graph-up mr-2 text-info"></i> Predictive Analytics in Radiology</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 09:00–10:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-display mr-2 text-warning"></i> Simulation-Based Radiology Training</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-arrow-repeat mr-2 text-info"></i> AI Workflow Automation in Radiology</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lightning-charge mr-2 text-primary"></i> Dual-Energy CT: 2026 Advances</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 10:00–11:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-shield-check mr-2 text-success"></i> AI Quality Assurance Frameworks</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-lock mr-2 text-danger"></i> Cybersecurity in Medical Imaging</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-bandaid mr-2 text-primary"></i> IVR Trauma Innovations</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 13:00–14:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-pencil-square mr-2 text-warning"></i> Grant Writing for Imaging Research</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-a">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-sliders mr-2 text-info"></i> AI Protocols for MRI/CT</h3></div>
                    <div class="session-track-col"><span class="track-badge track-a-badge">Track A</span></div>
                </div>

                <div class="session-item track-b">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-exclamation-triangle mr-2 text-warning"></i> NM Contamination Control &amp; Safety</h3></div>
                    <div class="session-track-col"><span class="track-badge track-b-badge">Track B</span></div>
                </div>

                <div class="session-item track-c">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 14:00–15:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-radioactive mr-2 text-success"></i> Innovation &amp; Emerging Research</h3></div>
                    <div class="session-track-col"><span class="track-badge track-c-badge">Track C</span></div>
                </div>

                <div class="session-item track-main">
                    <div class="session-time-col"><i class="bi bi-clock"></i> 15:00–16:00</div>
                    <div class="session-main-col"><h3 class="session-title-text"><i class="bi bi-trophy mr-2 text-warning"></i> Closing Ceremony &amp; Strategic Partnership Signing</h3></div>
                    <div class="session-track-col"><span class="track-badge track-main-badge">Main Hall</span></div>
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
