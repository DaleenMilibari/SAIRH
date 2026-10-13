<%@ Page Title="Saudi First AI Summit in Radiology and Health Innovation" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AIE.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section (AI-Powered Liquid Glass Hero) -->
    <section aria-label="Summit Hero" class="landing-hero-section text-light" style="background-image: linear-gradient(to right, rgba(4, 8, 22, 0.94) 0%, rgba(4, 8, 22, 0.82) 36%, rgba(4, 8, 22, 0.15) 68%, transparent 100%), linear-gradient(to bottom, transparent 75%, #040816 100%), url('<%= ResolveUrl("~/Content/images/background/hero-ai-bg.png") %>') !important; background-position: right center !important; background-size: cover !important; background-repeat: no-repeat !important;">
        <!-- Edge Slider Navigation Controls (Middle of Most Left & Right of Section) -->
        <button type="button" class="hero-arrow-btn hero-arrow-left" aria-label="Previous Slide">
            <i class="bi bi-chevron-left"></i>
        </button>
        <button type="button" class="hero-arrow-btn hero-arrow-right" aria-label="Next Slide">
            <i class="bi bi-chevron-right"></i>
        </button>

        <div class="container">
            <div id="heroSummitCarousel" class="carousel slide carousel-fade hero-carousel" data-ride="carousel" data-interval="6000" data-pause="hover">
                <div class="carousel-inner">
                    <!-- Slide 1: Main Summit Overview (Existing Hero with Typed 2026 Effect) -->
                    <div class="carousel-item active" data-slide-index="0">
                        <div class="row align-items-center">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-left">
                                <div class="hero-slide-stage">
                                    <h1 class="hero-slide-title font-weight-bold text-white mb-2">
                                        Saudi First AI Summit in Radiology and Health Innovation
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
                                            <span>Grand Hyatt Alkhobar</span>
                                        </div>
                                        <div class="hero-meta-item">
                                            <i class="bi bi-calendar3"></i>
                                            <span>13 December 2026</span>
                                        </div>
                                        <div class="hero-meta-item">
                                            <i class="bi bi-stack"></i>
                                            <span>3 Scientific Tracks</span>
                                        </div>
                                    </div>

                                    <!-- Main Action CTAs -->
                                    <div class="hero-cta-group">
                                        <a href="Ceremony" class="cyan-glow-btn">
                                            <i class="bi bi-calendar2-check mr-1"></i> Program &amp; Tracks
                                        </a>
                                        <a href="#qr-section" class="action-pill text-white">
                                            <i class="bi bi-qr-code mr-1"></i> Participation Pass
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Slide 2: Summit Inauguration Live Countdown Timer (13 December, 09:00 AM AST) -->
                    <div class="carousel-item" data-slide-index="1">
                        <div class="row align-items-center">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-left">
                                <div class="hero-slide-stage">
                                    <h2 class="hero-slide-title font-weight-bold text-white mb-2">
                                        Countdown to the Next Era in Radiology AI
                                    </h2>

                                    <!-- Live Liquid-Glass Countdown Display -->
                                    <div class="hero-countdown-grid" role="timer" aria-label="Countdown to Summit Opening">
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-days" aria-label="Days">--</div>
                                            <div class="hero-countdown-label">Days</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-hours" aria-label="Hours">--</div>
                                            <div class="hero-countdown-label">Hours</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-minutes" aria-label="Minutes">--</div>
                                            <div class="hero-countdown-label">Minutes</div>
                                        </div>
                                        <div class="hero-countdown-sep" aria-hidden="true">:</div>
                                        <div class="hero-countdown-card">
                                            <div class="hero-countdown-num hero-countdown-seconds" aria-label="Seconds">--</div>
                                            <div class="hero-countdown-label">Seconds</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Slide 3: Royal Quote & Portrait of HRH Crown Prince Mohammed bin Salman -->
                    <div class="carousel-item" data-slide-index="2">
                        <div class="row align-items-center">
                            <div class="col-lg-8 col-xl-8 hero-text-col text-left">
                                <div class="hero-slide-stage">
                                    <div class="royal-quote-wrapper">
                                        <div class="royal-portrait-frame">
                                            <img src="<%= ResolveUrl("~/Content/images/mbs-portrait.jpg") %>" alt="صاحب السمو الملكي الأمير محمد بن سلمان بن عبدالعزيز آل سعود" class="royal-portrait-img" />
                                        </div>
                                        <div class="royal-content-col">
                                            <div class="royal-quote-box">
                                                <i class="bi bi-quote royal-quote-icon"></i>
                                                <blockquote class="royal-quote-text">
                                                    “I invite you all to work together in a spirit of cooperation to chart the future of Artificial Intelligence in a manner that serves all societies, prioritizes collaboration over competition, and focuses on trusted and responsible applications of AI for the service of humanity.”
                                                </blockquote>
                                            </div>
                                            <div class="royal-attribution">
                                                <h3 class="royal-author-name">
                                                    HRH Crown Prince Mohammed bin Salman
                                                </h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Centered Liquid Glass Indicators at Bottom -->
                <div class="hero-carousel-indicators" role="tablist" aria-label="Slide Selection">
                    <button type="button" class="hero-indicator-dot active" data-slide-to="0" aria-label="Slide 1: Overview"></button>
                    <button type="button" class="hero-indicator-dot" data-slide-to="1" aria-label="Slide 2: Countdown"></button>
                    <button type="button" class="hero-indicator-dot" data-slide-to="2" aria-label="Slide 3: Royal Vision"></button>
                </div>
            </div>
        </div>
    </section>

    <!-- Dedicated Live Summit Telemetry & Session Hub (Identical to LiveDashboard Mini-Project) -->
    <section id="dashboard-section" aria-label="Live Summit Dashboard" class="py-5">
        <div class="container">
            <!-- Section Header -->
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">Live Summit Session Hub</h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto 20px; border-radius: 2px;"></div>
            </div>

            <!-- Complete Live Dashboard Widget (Exact Replica of Mini-Project) -->
            <div class="sairh-live-widget" lang="en" dir="ltr">
                <div class="sairh-background-pattern" aria-hidden="true">
                    <span class="sairh-orb sairh-orb-one"></span>
                    <span class="sairh-orb sairh-orb-two"></span>
                    <span class="sairh-grid-glow"></span>
                </div>

                <!-- Live Telemetry Status Bar (Live Beacon & Real-Time Clock, No redundant widget header) -->
                <div class="sairh-telemetry-bar">
                    <div class="sairh-telemetry-left">
                        <span class="sairh-telemetry-badge">
                            <i class="bi bi-circle-fill text-danger"></i> LIVE SUMMIT SCHEDULE
                        </span>
                        <span class="sairh-track-tag">
                            <i class="bi bi-calendar2-check"></i> Day 1 &bull; 8 Sessions
                        </span>
                    </div>
                    <div class="sairh-current-time" data-locale="en-US"></div>
                </div>

                <!-- Slider with all 8 Sessions from sessions.json -->
                <div class="sairh-slider">
                    <!-- Session 1 -->
                    <article class="sairh-session-slide active"
                             data-start="2026-10-01T07:00:00"
                             data-end="2026-10-01T07:45:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Ahmed Al-Qahtani"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Ahmed Al-Qahtani</h3>
                            <p class="sairh-speaker-role">Consultant Radiologist</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>Imam Abdulrahman Bin Faisal University</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Diagnostic AI Track
                                </span>
                                <div class="sairh-status live">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Live Now</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Artificial Intelligence in Diagnostic Radiology</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Main Hall</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">07:00 AM &ndash; 07:45 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Time Remaining</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Live Session</strong>
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

                    <!-- Session 2 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T08:00:00"
                             data-end="2026-10-01T08:45:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Sara Mohammed"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Sara Mohammed</h3>
                            <p class="sairh-speaker-role">Assistant Professor of Artificial Intelligence</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Fahd University Hospital</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Deep Learning Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Next Session</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Deep Learning Applications in Medical Imaging</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Hall B</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">08:00 AM &ndash; 08:45 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 3 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T09:00:00"
                             data-end="2026-10-01T09:50:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Reem Al-Harbi"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Reem Al-Harbi</h3>
                            <p class="sairh-speaker-role">Consultant Diagnostic Radiologist</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Fahd Specialist Hospital</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Clinical AI Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Generative AI in Radiology Reporting</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Hall C</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">09:00 AM &ndash; 09:50 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 4 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T10:15:00"
                             data-end="2026-10-01T11:00:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Fahad Al-Zahrani"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Fahad Al-Zahrani</h3>
                            <p class="sairh-speaker-role">Medical Image Processing Researcher</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Abdulaziz City for Science &amp; Technology</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Imaging Technology Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">AI-Based Enhancement of Radiology Images</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Hall D</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">10:15 AM &ndash; 11:00 AM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 5 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T11:30:00"
                             data-end="2026-10-01T12:15:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Noura Al-Dosari"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Noura Al-Dosari</h3>
                            <p class="sairh-speaker-role">AI Ethics Researcher</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Saud University</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Healthcare Ethics Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Responsible Artificial Intelligence in Healthcare</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Workshop Hall</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">11:30 AM &ndash; 12:15 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 6 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T13:00:00"
                             data-end="2026-10-01T13:50:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Layan Al-Ghamdi"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Layan Al-Ghamdi</h3>
                            <p class="sairh-speaker-role">Oncology Radiology Consultant</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Fahd Oncology Center</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Oncology &amp; AI Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Artificial Intelligence for Early Tumor Detection</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Main Hall</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">01:00 PM &ndash; 01:50 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 7 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T14:15:00"
                             data-end="2026-10-01T15:00:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Dr. Yousef Al-Salem"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Dr. Yousef Al-Salem</h3>
                            <p class="sairh-speaker-role">Professor of Health Informatics</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>King Faisal University</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Health Informatics Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">Multimodal Data for Clinical Decision Support</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Conference Hall</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">02:15 PM &ndash; 03:00 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                    <!-- Session 8 -->
                    <article class="sairh-session-slide"
                             data-start="2026-10-01T16:00:00"
                             data-end="2026-10-01T16:45:00"
                             data-language="en">
                        <aside class="sairh-speaker-card">
                            <div class="sairh-speaker-avatar-wrap">
                                <img src="<%= ResolveUrl("~/Content/images/speakers/default-speaker.png") %>"
                                     alt="Eng. Khalid Al-Otaibi"
                                     class="sairh-speaker-avatar"
                                     onerror="this.onerror=null; this.src='Content/images/logo.jpg';" />
                                <span class="sairh-speaker-badge">Speaker</span>
                            </div>
                            <h3 class="sairh-speaker-name">Eng. Khalid Al-Otaibi</h3>
                            <p class="sairh-speaker-role">Health Innovation Specialist</p>
                            <p class="sairh-speaker-org">
                                <i class="bi bi-bank sairh-organization-icon"></i>
                                <span>Health Innovation Center</span>
                            </p>
                        </aside>

                        <div class="sairh-session-main">
                            <div class="sairh-slide-header">
                                <span class="sairh-track-tag">
                                    <i class="bi bi-boxes"></i> Health Innovation Track
                                </span>
                                <div class="sairh-status upcoming">
                                    <span class="sairh-status-dot"></span>
                                    <span class="sairh-status-text">Upcoming</span>
                                </div>
                            </div>

                            <h2 class="sairh-session-title">The Future of AI-Powered Health Innovation</h2>

                            <div class="sairh-session-meta-grid">
                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-geo-alt"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Location</span>
                                        <strong class="sairh-meta-value">Innovation Hall</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card">
                                    <div class="sairh-meta-icon"><i class="bi bi-clock"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label">Schedule</span>
                                        <strong class="sairh-meta-value sairh-session-time" dir="ltr">04:00 PM &ndash; 04:45 PM</strong>
                                    </div>
                                </div>

                                <div class="sairh-meta-card sairh-meta-card-highlight">
                                    <div class="sairh-meta-icon"><i class="bi bi-hourglass-split"></i></div>
                                    <div class="sairh-meta-info">
                                        <span class="sairh-meta-label sairh-countdown-label">Starts In</span>
                                        <strong class="sairh-meta-value sairh-countdown" aria-live="polite">Upcoming</strong>
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

                <!-- Slider Controls: Unified Centered Previous/Next Arrows & 8 Dots -->
                <div class="sairh-slider-controls">
                    <button type="button"
                            class="sairh-slider-arrow previous"
                            aria-label="Previous session">
                        <i class="bi bi-chevron-left" aria-hidden="true"></i>
                    </button>

                    <div class="sairh-slider-dots" role="tablist" aria-label="Session indicators">
                        <button type="button" class="sairh-slider-dot active" data-index="0" aria-label="Show session 1"></button>
                        <button type="button" class="sairh-slider-dot" data-index="1" aria-label="Show session 2"></button>
                        <button type="button" class="sairh-slider-dot" data-index="2" aria-label="Show session 3"></button>
                        <button type="button" class="sairh-slider-dot" data-index="3" aria-label="Show session 4"></button>
                        <button type="button" class="sairh-slider-dot" data-index="4" aria-label="Show session 5"></button>
                        <button type="button" class="sairh-slider-dot" data-index="5" aria-label="Show session 6"></button>
                        <button type="button" class="sairh-slider-dot" data-index="6" aria-label="Show session 7"></button>
                        <button type="button" class="sairh-slider-dot" data-index="7" aria-label="Show session 8"></button>
                    </div>

                    <button type="button"
                            class="sairh-slider-arrow next"
                            aria-label="Next session">
                        <i class="bi bi-chevron-right" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Strategic Goals & Alignment with Saudi Vision 2030 (Vision 2030 5-Pillar Matrix) -->
    <section aria-label="Saudi Vision 2030 Aims" class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    Aims &amp; Alignment with Saudi Vision 2030
                </h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <div class="vision-pillar-grid">
                <!-- Pillar 01 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">PILLAR 01</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-heart-pulse"></i></div>
                    </div>
                    <h3 class="pillar-title">AI-Driven Diagnostic Imaging</h3>
                    <p class="pillar-text">
                        Enhance healthcare innovation through AI-driven diagnostic imaging.
                    </p>
                </div>

                <!-- Pillar 02 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">PILLAR 02</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-gear"></i></div>
                    </div>
                    <h3 class="pillar-title">Workflow Transformation</h3>
                    <p class="pillar-text">
                        Support national digital transformation in radiology workflows.
                    </p>
                </div>

                <!-- Pillar 03 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">PILLAR 03</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-globe"></i></div>
                    </div>
                    <h3 class="pillar-title">Global Collaborations</h3>
                    <p class="pillar-text">
                        Strengthen global collaborations with leading radiology &amp; AI institutions.
                    </p>
                </div>

                <!-- Pillar 04 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">PILLAR 04</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-radioactive"></i></div>
                    </div>
                    <h3 class="pillar-title">Research &amp; AI Development</h3>
                    <p class="pillar-text">
                        Advance research, innovation, and AI development across healthcare.
                    </p>
                </div>

                <!-- Pillar 05 -->
                <div class="vision-pillar-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="pillar-number">PILLAR 05</span>
                        <div class="pillar-icon-box mb-0"><i class="bi bi-people"></i></div>
                    </div>
                    <h3 class="pillar-title">Future-Ready Workforce</h3>
                    <p class="pillar-text">
                        Build a future-ready workforce of radiologists, technologists, and data scientists.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- QR Code for Participation in the SRAS -->
    <section id="qr-section" aria-label="QR Code Participation" class="py-5">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    QR code for participation in the SRAS
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
                        <h4 class="text-white font-weight-bold mb-2">Scan to Participate &amp; Download SRAS App</h4>
                        <p class="text-secondary mb-4 mx-auto" style="max-width: 540px; font-size: 1.05rem; line-height: 1.6;">
                            Download the official SRAS app for instant delegate badge verification, live program schedule notifications, and interactive participation.
                        </p>
                        <div class="d-flex justify-content-center gap-3 flex-wrap">
                            <a href="https://apps.apple.com/us/app/annual-innovation-event/id6475714056" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                                <i class="bi bi-apple mr-1"></i> Apple App Store
                            </a>
                            <a href="https://play.google.com/store/apps/details?id=sa.edu.iau.annualinnovationevent" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                                <i class="bi bi-google-play mr-1"></i> Google Play
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Venue Location Showcase -->
    <section aria-label="Venue Location" class="py-5 mb-4">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="text-white font-weight-bold display-5 mb-3">
                    Venue Location
                </h2>
                <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="venue-showcase-card">
                        <img src="<%= ResolveUrl("~/Content/images/Home-Image/Grand Hyatt Alkhobar logo.svg") %>"
                             class="d-block img-fluid mx-auto mb-4"
                             alt="Grand Hyatt Alkhobar">
                        <h3 class="text-white font-weight-bold mb-2">Grand Hyatt Alkhobar Hotel and Residences</h3>
                        <p class="text-secondary mb-4" style="font-size: 1.1rem;">
                            Al Olaya, Alkhobar, Eastern Province, Kingdom of Saudi Arabia
                        </p>
                        <a href="https://maps.google.com/?q=Grand+Hyatt+Alkhobar" target="_blank" class="btn btn-outline-info rounded-pill px-4 py-2">
                            <i class="bi bi-geo-alt mr-1"></i> View on Google Maps
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
