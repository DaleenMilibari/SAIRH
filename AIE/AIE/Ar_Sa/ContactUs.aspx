<%@ Page Title="تواصل معنا - القمة السعودية للذكاء الاصطناعي في الأشعة" Language="C#" MasterPageFile="~/Ar_Sa/PublicAr.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="AIE.Ar_Sa.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Header -->
    <section class="py-5 simpler-main-bg" aria-label="Header">
        <div class="container text-center pt-4 pb-2">
            <h1 class="text-white font-weight-bold display-4 mb-3">
                تواصل معنا
            </h1>
            <div style="width: 80px; height: 3px; background: linear-gradient(90deg, #38bdf8, #2563eb); margin: 0 auto; border-radius: 2px;"></div>
            
            <p class="text-secondary mx-auto mt-4" style="max-width: 800px; font-size: 1.2rem; line-height: 1.8;">
                للحصول على مزيد من المعلومات حول القمة السعودية للذكاء الاصطناعي في الاشعة والابتكار لصحي بما في ذلك تفاصيل المشاركة، وفرص الرعاية، والاستفسارات العامة، يرجى الاتصال بنا على:
            </p>
        </div>
    </section>

    <!-- 2-Column Contact Section -->
    <section class="py-5" aria-label="قنوات التواصل ونموذج المراسلة">
        <div class="container">
            <div class="row g-4 justify-content-center">
                <!-- Left Column: Contact Channels -->
                <div class="col-lg-5 mb-4 mb-lg-0">
                    <div class="contact-info-card">
                        <h3 class="text-white font-weight-bold mb-4" style="font-size: 1.35rem;">
                            مكتب أمانة القمة
                        </h3>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-envelope"></i></div>
                            <div>
                                <div class="contact-channel-label">البريد الإلكتروني الرسمي</div>
                                <div class="contact-channel-val"><a href="mailto:iie@iau.edu.sa">iie@iau.edu.sa</a></div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-twitter-x"></i></div>
                            <div>
                                <div class="contact-channel-label">الحساب الرسمي على منصة X</div>
                                <div class="contact-channel-val"><a href="https://twitter.com/IAU_VPSRI" target="_blank">@IAU_VPSRI</a></div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-geo-alt"></i></div>
                            <div>
                                <div class="contact-channel-label">مقر الفعالية</div>
                                <div class="contact-channel-val">فندق ومساكن جراند حياة الخبر</div>
                            </div>
                        </div>

                        <div class="contact-channel-item">
                            <div class="contact-channel-icon"><i class="bi bi-phone"></i></div>
                            <div>
                                <div class="contact-channel-label">تطبيقات القمة الرسمية</div>
                                <div class="contact-channel-val">SRAS-IAU (آبل وجوجل)</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Form -->
                <div class="col-lg-6">
                    <div class="contact-form-glass">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div id="contact_form">
                                    <div class="form-group">
                                        <label for="<%= TxtName.ClientID %>">الاسم الكامل</label>
                                        <asp:TextBox ID="TxtName" runat="server" CssClass="form-control" placeholder="مثال: د. عبدالله الغامدي" MaxLength="100" autocomplete="name" required="required"></asp:TextBox>
                                    </div>

                                    <div class="form-group">
                                        <label for="<%= TxtEmail.ClientID %>">عنوان البريد الإلكتروني</label>
                                        <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@institution.edu.sa" MaxLength="100" autocomplete="email" required="required"></asp:TextBox>
                                    </div>

                                    <div class="form-group">
                                        <div class="auth-row-between">
                                            <label for="<%= TxtMobile.ClientID %>">رقم المحمول</label>
                                            <span class="auth-optional">اختياري</span>
                                        </div>
                                        <div class="phone-input-group">
                                            <div class="phone-country-dropdown-wrap">
                                                <select id="DdlContactCountryCode" name="DdlContactCountryCode" class="phone-country-select" aria-label="رمز الدولة" autocomplete="tel-country-code">
                                                    <option value="+966" selected="selected">🇸🇦 +966 (السعودية)</option>
                                                    <option value="+971">🇦🇪 +971 (الإمارات)</option>
                                                    <option value="+965">🇰🇼 +965 (الكويت)</option>
                                                    <option value="+973">🇧🇭 +973 (البحرين)</option>
                                                    <option value="+974">🇶🇦 +974 (قطر)</option>
                                                    <option value="+968">🇴🇲 +968 (عُمان)</option>
                                                    <option value="+20">🇪🇬 +20 (مصر)</option>
                                                    <option value="+962">🇯🇴 +962 (الأردن)</option>
                                                    <option value="+961">🇱🇧 +961 (لبنان)</option>
                                                    <option value="+964">🇮🇶 +964 (العراق)</option>
                                                    <option value="+967">🇾🇪 +967 (اليمن)</option>
                                                    <option value="+44">🇬🇧 +44 (المملكة المتحدة)</option>
                                                    <option value="+1">🇺🇸 +1 (أمريكا / كندا)</option>
                                                    <option value="+49">🇩🇪 +49 (ألمانيا)</option>
                                                    <option value="+33">🇫🇷 +33 (فرنسا)</option>
                                                    <option value="+90">🇹🇷 +90 (تركيا)</option>
                                                    <option value="+91">🇮🇳 +91 (الهند)</option>
                                                    <option value="+92">🇵🇰 +92 (باكستان)</option>
                                                    <option value="+60">🇲🇾 +60 (ماليزيا)</option>
                                                    <option value="+65">🇸🇬 +65 (سنغافورة)</option>
                                                    <option value="+61">🇦🇺 +61 (أستراليا)</option>
                                                    <option value="">🌐 أخرى / دولي مخصص</option>
                                                </select>
                                                <i class="bi bi-chevron-down phone-dropdown-arrow" aria-hidden="true"></i>
                                            </div>
                                            <div class="phone-number-wrap">
                                                <asp:TextBox ID="TxtMobile" runat="server" TextMode="Phone" CssClass="form-control phone-number-input" placeholder="50 123 4567" autocomplete="tel-national" MaxLength="15"></asp:TextBox>
                                            </div>
                                        </div>
                                        <small class="auth-hint phone-hint" id="phoneHintContact">صيغة الجوال السعودي: 50 123 4567 (9 أرقام)</small>
                                        <div class="phone-validation-feedback" id="phoneFeedbackContact" style="display: none;"></div>
                                    </div>

                                    <div class="form-group">
                                        <label for="<%= TxtMessage.ClientID %>">نص الرسالة والاستفسار</label>
                                        <asp:TextBox ID="TxtMessage" runat="server" CssClass="form-control" placeholder="كيف يمكننا مساعدتك بخصوص القمة والمشاركة؟" TextMode="MultiLine" Rows="4" MaxLength="2000" required="required"></asp:TextBox>
                                        <div class="char-counter" id="messageCharCounter"><span id="charCount">0</span> / 2000 حرف</div>
                                    </div>

                                    <div id="submit" class="mt-4">
                                        <asp:Button ID="BtnSubmit" runat="server" CssClass="cyan-glow-btn w-100 py-3 text-white font-weight-bold" Text="إرسال الرسالة" OnClick="BtnSubmit_Click" data-loading-text="جارٍ إرسال الرسالة..." />
                                    </div>

                                    <div id="divError" class="alert alert-danger text-danger mt-3" runat="server" visible="false">Test Messages</div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Concluding Note -->
    <section class="py-5" aria-label="خاتمة">
        <div class="container text-center">
            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="glass-card p-4" style="border-radius: 20px;">
                        <p class="text-light mb-0" style="font-size: 1.15rem; line-height: 1.8;">
                            ندعو جميع الأطراف المهتمة للتواصل معنا بأي أسئلة أو طلبات لمزيد من المعلومات. نتطلع إلى التعاون معكم لجعل الحدث السنوي للابتكار نجاحاً باهراً، وتمكين الجيل القادم من المبتكرين والمساهمة في مستقبل مستدام للاقتصاد السعودي.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
