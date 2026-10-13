<%@ Page Title="Personalized Summit Survey - SAIRH 2026" Language="C#" MasterPageFile="~/Public.Master" AutoEventWireup="true" CodeBehind="Survey.aspx.cs" Inherits="AIE.Survey" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .survey-container {
            max-width: 1080px;
            margin: 0 auto;
            padding: 40px 20px 80px;
        }
        .survey-welcome-banner {
            background: linear-gradient(135deg, rgba(2, 132, 199, 0.25), rgba(15, 23, 42, 0.6));
            border: 1px solid rgba(56, 189, 248, 0.4);
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            backdrop-filter: blur(12px);
        }
        .survey-glass-card {
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 24px;
            backdrop-filter: blur(16px);
            box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.4);
            display: grid;
            grid-template-columns: 52px 1fr;
            gap: 24px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .survey-glass-card:hover {
            border-color: rgba(56, 189, 248, 0.3);
            box-shadow: 0 15px 35px -10px rgba(2, 132, 199, 0.15);
        }
        .survey-num {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: rgba(56, 189, 248, 0.15);
            border: 1px solid rgba(56, 189, 248, 0.4);
            color: #38bdf8;
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            letter-spacing: 0.5px;
        }
        .survey-q-title {
            color: #ffffff;
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 4px;
            line-height: 1.4;
        }
        .survey-q-subtitle {
            color: #94a3b8;
            font-size: 0.88rem;
            margin-bottom: 20px;
        }
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 12px;
        }
        .custom-option-label {
            position: relative;
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            user-select: none;
            color: #e2e8f0;
            font-size: 0.95rem;
            font-weight: 500;
            margin: 0;
        }
        .custom-option-label:hover {
            background: rgba(56, 189, 248, 0.08);
            border-color: rgba(56, 189, 248, 0.35);
            color: #ffffff;
        }
        .custom-option-label input[type="checkbox"],
        .custom-option-label input[type="radio"] {
            appearance: none;
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            border: 2px solid #64748b;
            border-radius: 6px;
            background: rgba(15, 23, 42, 0.8);
            cursor: pointer;
            display: grid;
            place-content: center;
            transition: all 0.2s ease;
            flex-shrink: 0;
            margin: 0;
        }
        .custom-option-label input[type="radio"] {
            border-radius: 50%;
        }
        .custom-option-label input[type="checkbox"]:checked,
        .custom-option-label input[type="radio"]:checked {
            background: #0284c7;
            border-color: #38bdf8;
            box-shadow: 0 0 10px rgba(56, 189, 248, 0.5);
        }
        .custom-option-label input[type="checkbox"]:checked::before {
            content: "✓";
            color: #ffffff;
            font-size: 13px;
            font-weight: 900;
        }
        .custom-option-label input[type="radio"]:checked::before {
            content: "";
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #ffffff;
        }
        .custom-option-label.active-choice {
            background: rgba(2, 132, 199, 0.15);
            border-color: #38bdf8;
            color: #ffffff;
        }
        /* Stop count selector cards */
        .stop-count-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        @media (max-width: 768px) {
            .stop-count-grid { grid-template-columns: 1fr; }
            .survey-glass-card { grid-template-columns: 1fr; gap: 16px; }
            .survey-num { margin-bottom: 8px; }
        }
        .stop-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            padding: 20px;
            cursor: pointer;
            text-align: center;
            transition: all 0.2s ease;
            position: relative;
        }
        .stop-card:hover {
            border-color: rgba(56, 189, 248, 0.35);
            background: rgba(56, 189, 248, 0.06);
        }
        .stop-card.active-stop {
            background: rgba(2, 132, 199, 0.18);
            border-color: #38bdf8;
            box-shadow: 0 0 20px rgba(56, 189, 248, 0.2);
        }
        .stop-count-num {
            font-size: 2.2rem;
            font-weight: 800;
            color: #38bdf8;
            line-height: 1;
            margin-bottom: 6px;
        }
        .stop-card-title {
            font-weight: 700;
            color: #ffffff;
            font-size: 1rem;
            margin-bottom: 4px;
        }
        .stop-card-desc {
            color: #94a3b8;
            font-size: 0.82rem;
            margin: 0;
        }
        .stop-badge-rec {
            position: absolute;
            top: -10px;
            right: 14px;
            background: #0284c7;
            color: #ffffff;
            font-size: 0.68rem;
            font-weight: 800;
            padding: 3px 8px;
            border-radius: 20px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Survey Header">
        <div class="container text-center pt-4 pb-2">
            <span class="badge badge-info rounded-pill px-3 py-2 text-uppercase mb-3 font-weight-bold" style="letter-spacing: 1px;">
                Personalized Experience
            </span>
            <h1 class="text-white font-weight-bold display-4 mb-3">
                Build Your Summit Roadmap
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            <p class="text-secondary mx-auto mt-4" style="max-width: 760px; font-size: 1.15rem; line-height: 1.7;">
                Tell us what interests you and we will recommend the sponsor booths and research displays that best match your SAIRH 2026 experience.
            </p>
        </div>
    </section>

    <!-- Main Survey Container -->
    <div class="survey-container">
        <!-- First-time Welcome Banner -->
        <div id="pnlFirstTimeBanner" runat="server" visible="false" class="survey-welcome-banner">
            <div class="display-5 text-info">
                <i class="bi bi-compass"></i>
            </div>
            <div>
                <h4 class="text-white font-weight-bold mb-1">
                    Welcome to SAIRH 2026, <asp:Literal ID="LitUserName" runat="server">Attendee</asp:Literal>!
                </h4>
                <p class="text-light mb-0 small" style="opacity: 0.9;">
                    Your account has been registered! Please take this 1-minute survey to discover booths matching your interests and generate your personalized, color-coded Exhibition Floor map.
                </p>
            </div>
        </div>

        <div id="divError" class="auth-alert alert alert-danger mb-4" runat="server" visible="false" role="alert"></div>

        <!-- Question 01 -->
        <div class="survey-glass-card">
            <div class="survey-num">01</div>
            <div>
                <h2 class="survey-q-title">What are you most interested in exploring at SAIRH 2026?</h2>
                <p class="survey-q-subtitle">Select all that apply.</p>
                
                <div class="options-grid">
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="AI & Digital Technology" checked="checked" />
                        <span>AI &amp; Digital Technology</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="Medical Imaging & Radiology" checked="checked" />
                        <span>Medical Imaging &amp; Radiology</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="Health Innovation" />
                        <span>Health Innovation</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="Research & Education" />
                        <span>Research &amp; Education</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="Startups & Innovation" />
                        <span>Startups &amp; Innovation</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="interests" value="Healthcare Technology" />
                        <span>Healthcare Technology</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Question 02 -->
        <div class="survey-glass-card">
            <div class="survey-num">02</div>
            <div>
                <h2 class="survey-q-title">What type of exhibition areas would you like to explore?</h2>
                <p class="survey-q-subtitle">Select all that apply.</p>
                
                <div class="options-grid">
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="Medical Imaging Companies" checked="checked" />
                        <span>Medical Imaging Companies</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="AI Companies" checked="checked" />
                        <span>AI Companies</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="Universities & Colleges" />
                        <span>Universities &amp; Colleges</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="Healthcare Organizations" />
                        <span>Healthcare Organizations</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="Startups" />
                        <span>Startups &amp; Incubators</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="boothTypes" value="Research Displays" checked="checked" />
                        <span>Research Project Displays</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Question 03 -->
        <div class="survey-glass-card">
            <div class="survey-num">03</div>
            <div>
                <h2 class="survey-q-title">What would you like to get out of your visit?</h2>
                <p class="survey-q-subtitle">Select all that apply.</p>
                
                <div class="options-grid">
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="New Technology" checked="checked" />
                        <span>Discover new technologies</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="Research" checked="checked" />
                        <span>Explore research projects</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="Products" />
                        <span>Explore products and services</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="Healthcare Solutions" />
                        <span>Find healthcare solutions</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="Innovation" />
                        <span>Discover startups and innovations</span>
                    </label>
                    <label class="custom-option-label">
                        <input type="checkbox" name="goals" value="Networking" checked="checked" />
                        <span>Network with organizations &amp; peers</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Question 04 -->
        <div class="survey-glass-card">
            <div class="survey-num">04</div>
            <div>
                <h2 class="survey-q-title">How many recommended stops would you like?</h2>
                <p class="survey-q-subtitle">Choose the experience that best fits your available schedule.</p>
                
                <div class="stop-count-grid">
                    <label class="stop-card" onclick="selectStopCount(this)">
                        <input type="radio" name="boothCount" value="3" style="display:none;" />
                        <div class="stop-count-num">3</div>
                        <div class="stop-card-title">Quick Visit</div>
                        <p class="stop-card-desc">3 recommended stops for busy schedules</p>
                    </label>

                    <label class="stop-card active-stop" onclick="selectStopCount(this)">
                        <span class="stop-badge-rec">Recommended</span>
                        <input type="radio" name="boothCount" value="5" checked="checked" style="display:none;" />
                        <div class="stop-count-num">5</div>
                        <div class="stop-card-title">Standard Experience</div>
                        <p class="stop-card-desc">5 recommended stops balancing sponsors &amp; research</p>
                    </label>

                    <label class="stop-card" onclick="selectStopCount(this)">
                        <input type="radio" name="boothCount" value="8" style="display:none;" />
                        <div class="stop-count-num">8</div>
                        <div class="stop-card-title">Explore More</div>
                        <p class="stop-card-desc">8 comprehensive stops across both halls</p>
                    </label>
                </div>
            </div>
        </div>

        <!-- Submit Action -->
        <div class="text-center mt-5 pt-3">
            <p class="text-secondary small mb-3">
                <i class="bi bi-info-circle mr-1"></i> You can update your survey preferences at any time from your profile or the exhibition map.
            </p>
            <asp:Button ID="BtnSubmitSurvey" runat="server" CssClass="cyan-glow-btn px-5 py-3 text-white font-weight-bold" style="font-size: 1.15rem; min-width: 280px;" Text="Generate My Roadmap →" OnClick="BtnSubmitSurvey_Click" data-loading-text="Analyzing &amp; Matching..." />
        </div>
    </div>

    <script>
        function selectStopCount(card) {
            document.querySelectorAll('.stop-card').forEach(function(c) {
                c.classList.remove('active-stop');
            });
            card.classList.add('active-stop');
            var radio = card.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
        }

        // Add interactive highlighting to checkboxes
        document.addEventListener('DOMContentLoaded', function () {
            var labels = document.querySelectorAll('.custom-option-label');
            labels.forEach(function (label) {
                var box = label.querySelector('input[type="checkbox"]');
                if (box) {
                    if (box.checked) label.classList.add('active-choice');
                    box.addEventListener('change', function () {
                        if (box.checked) label.classList.add('active-choice');
                        else label.classList.remove('active-choice');
                    });
                }
            });
        });
    </script>
</asp:Content>
