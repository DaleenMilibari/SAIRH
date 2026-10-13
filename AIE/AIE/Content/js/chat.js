/**
 * SAIRH 2026 Summit - AI Assistant Interactive Chat Widget
 * Handles bilingual FAQ navigation, Gemini free-form AI chat, and FAB transitions.
 */

(function () {
    'use strict';

    const UI_TEXT = {
        en: {
            title: 'SAIRH AI Assistant',
            status: 'Online • 2026 Summit Guide',
            placeholder: 'Ask about sessions, venue, registration...',
            send: 'Send',
            toggle: 'العربية',
            fabText: 'Ask AI Assistant',
            banner: 'Official AI Summit Guide for SAIRH 2026',
            welcome: 'Welcome to SAIRH 2026! I am your AI summit assistant. Choose a topic below or type any question.',
            categoriesTitle: 'Suggested Topics',
            pickQuestion: 'Please select a question:',
            back: '← Back to categories',
            typing: 'Analyzing with Summit AI...',
            error: 'Sorry, I am having trouble connecting right now. Please try again.',
            faqsError: 'Could not load FAQ topics right now. You can still type your question below.',
            sourceFaq: 'Official Summit FAQ',
            sourceGemini: 'SAIRH AI Model'
        },
        ar: {
            title: 'مساعد SAIRH الذكي',
            status: 'متصل • دليل القمة 2026',
            placeholder: 'اسأل عن الجلسات، المقر، التسجيل...',
            send: 'إرسال',
            toggle: 'English',
            fabText: 'اسأل المساعد الذكي',
            banner: 'الدليل الذكي الرسمي لقمة SAIRH 2026',
            welcome: 'مرحباً بك في قمة SAIRH 2026! أنا مساعدك الذكي للقمة. اختر موضوعاً من الأسفل أو اكتب سؤالك مباشرة.',
            categoriesTitle: 'الموضوعات المقترحة',
            pickQuestion: 'الرجاء اختيار أحد الأسئلة:',
            back: 'العودة إلى الفئات →',
            typing: 'جارٍ التحليل بواسطة الذكاء الاصطناعي...',
            error: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
            faqsError: 'تعذر تحميل قائمة الأسئلة حالياً. يمكنك كتابة سؤالك بالأسفل.',
            sourceFaq: 'الأسئلة الشائعة للقمة',
            sourceGemini: 'نموذج SAIRH الذكي'
        }
    };

    let currentLang = 'en';
    let faqCategories = [];
    let isSending = false;
    let isOpen = false;

    const $ = (id) => document.getElementById(id);

    // Detect page language from <html> tag or URL
    function detectInitialLanguage() {
        const docLang = (document.documentElement.getAttribute('lang') || '').toLowerCase();
        const path = window.location.pathname.toLowerCase();
        if (docLang === 'ar' || path.includes('/ar_sa')) {
            return 'ar';
        }
        return 'en';
    }

    // Smooth scroll inside chat messages
    function scrollToBottom() {
        const box = $('chat-messages');
        if (box) {
            box.scrollTop = box.scrollHeight;
        }
    }

    // Create safe bot message bubble
    function addBotBubble(text, source) {
        const box = $('chat-messages');
        if (!box) return null;

        const row = document.createElement('div');
        row.className = 'sairh-msg-row-bot';

        const badge = document.createElement('div');
        badge.className = 'sairh-bot-badge';
        const sourceLabel = source === 'faq'
            ? UI_TEXT[currentLang].sourceFaq
            : (source === 'gemini' ? UI_TEXT[currentLang].sourceGemini : 'SAIRH AI');
        badge.innerHTML = '<i class="bi bi-stars"></i> <span>' + sourceLabel + '</span>';
        row.appendChild(badge);

        const bubble = document.createElement('div');
        bubble.className = 'sairh-bubble-bot';
        bubble.textContent = text;
        row.appendChild(bubble);

        box.appendChild(row);
        scrollToBottom();
        return row;
    }

    // Create safe user message bubble
    function addUserBubble(text) {
        const box = $('chat-messages');
        if (!box) return null;

        const row = document.createElement('div');
        row.className = 'sairh-msg-row-user';

        const bubble = document.createElement('div');
        bubble.className = 'sairh-bubble-user';
        bubble.textContent = text;

        row.appendChild(bubble);
        box.appendChild(row);
        scrollToBottom();
        return row;
    }

    // Create typing indicator
    function addTypingBubble() {
        const box = $('chat-messages');
        if (!box) return null;

        const row = document.createElement('div');
        row.className = 'sairh-msg-row-bot sairh-typing-row';

        const badge = document.createElement('div');
        badge.className = 'sairh-bot-badge';
        badge.innerHTML = '<i class="bi bi-stars"></i> <span>' + UI_TEXT[currentLang].typing + '</span>';
        row.appendChild(badge);

        const bubble = document.createElement('div');
        bubble.className = 'sairh-bubble-bot sairh-typing-box';
        bubble.innerHTML = '<span class="sairh-typing-dot"></span><span class="sairh-typing-dot"></span><span class="sairh-typing-dot"></span>';

        row.appendChild(bubble);
        box.appendChild(row);
        scrollToBottom();
        return row;
    }

    // Render interactive buttons box (Categories or Questions)
    function addButtonList(titleText, buttons) {
        const box = $('chat-messages');
        if (!box) return;

        const row = document.createElement('div');
        row.className = 'sairh-msg-row-bot w-100';

        const container = document.createElement('div');
        container.className = 'sairh-faq-box';

        if (titleText) {
            const title = document.createElement('div');
            title.className = 'sairh-faq-box-title';
            title.innerHTML = '<i class="bi bi-layers-fill"></i> <span>' + titleText + '</span>';
            container.appendChild(title);
        }

        const grid = document.createElement('div');
        grid.className = 'sairh-faq-grid';

        const isRtl = currentLang === 'ar';
        const chevronClass = isRtl ? 'bi-chevron-left' : 'bi-chevron-right';
        const backIconClass = isRtl ? 'bi-arrow-right' : 'bi-arrow-left';

        buttons.forEach(({ label, onClick, isBack, isOutline }) => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'sairh-faq-btn' + (isBack ? ' sairh-faq-btn-back' : (isOutline ? ' sairh-faq-btn-outline' : ''));

            const textSpan = document.createElement('span');
            textSpan.textContent = label;

            const icon = document.createElement('i');
            icon.className = 'bi ' + (isBack ? backIconClass : chevronClass) + ' sairh-faq-icon';

            if (isBack) {
                btn.appendChild(icon);
                btn.appendChild(textSpan);
            } else {
                btn.appendChild(textSpan);
                btn.appendChild(icon);
            }

            btn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                onClick();
            });

            grid.appendChild(btn);
        });

        container.appendChild(grid);
        row.appendChild(container);
        box.appendChild(row);
        scrollToBottom();
    }

    // Language management
    function applyLanguage() {
        const t = UI_TEXT[currentLang];
        const popup = $('chat-popup-window');
        const fabPillText = $('sairh-fab-pill-text');
        const langToggleText = $('lang-toggle-text');
        const chatTitle = $('chat-title');
        const chatStatus = $('chat-status');
        const chatBannerText = $('chat-banner-text');
        const userInput = $('user-input');

        if (popup) {
            popup.setAttribute('dir', currentLang === 'ar' ? 'rtl' : 'ltr');
        }
        if (fabPillText) fabPillText.textContent = t.fabText;
        if (langToggleText) langToggleText.textContent = t.toggle;
        if (chatTitle) chatTitle.textContent = t.title;
        if (chatStatus) chatStatus.textContent = t.status;
        if (chatBannerText) chatBannerText.textContent = t.banner;
        if (userInput) userInput.placeholder = t.placeholder;
    }

    function toggleLanguage() {
        currentLang = currentLang === 'en' ? 'ar' : 'en';
        applyLanguage();
        resetConversation();
    }

    // Load FAQs with automatic endpoint fallback
    async function loadFaqs() {
        const endpoints = [
            '/api/chat/faqs',
            '/Content/data/faqs.json',
            '/data/faqs.json'
        ];

        for (const url of endpoints) {
            try {
                const response = await fetch(url);
                if (response.ok) {
                    faqCategories = await response.json();
                    if (Array.isArray(faqCategories) && faqCategories.length > 0) {
                        return;
                    }
                }
            } catch (err) {
                // Continue to next fallback
            }
        }

        console.warn('SAIRH AI: Unable to load FAQ endpoints.');
        faqCategories = [];
    }

    function categoryName(c) {
        return currentLang === 'ar' ? (c.categoryNameAr || c.categoryNameEn) : (c.categoryNameEn || c.categoryNameAr);
    }

    function showCategories() {
        const t = UI_TEXT[currentLang];
        if (!faqCategories || faqCategories.length === 0) {
            addBotBubble(t.faqsError, 'bot');
            return;
        }

        const buttons = faqCategories.map(c => ({
            label: categoryName(c),
            isOutline: true,
            onClick: () => selectCategory(c.categoryId)
        }));

        addButtonList(t.categoriesTitle, buttons);
    }

    function selectCategory(categoryId) {
        const cat = faqCategories.find(c => c.categoryId === categoryId);
        if (!cat) return;
        const t = UI_TEXT[currentLang];

        addUserBubble(categoryName(cat));

        const buttons = (cat.questions || []).map(q => ({
            label: currentLang === 'ar' ? (q.questionAr || q.questionEn) : (q.questionEn || q.questionAr),
            onClick: () => showFaqAnswer(q)
        }));

        buttons.push({
            label: t.back,
            isBack: true,
            onClick: () => {
                showCategories();
            }
        });

        addButtonList(t.pickQuestion, buttons);
    }

    function showFaqAnswer(q) {
        const questionText = currentLang === 'ar' ? (q.questionAr || q.questionEn) : (q.questionEn || q.questionAr);
        const answerText = currentLang === 'ar' ? (q.answerAr || q.answerEn) : (q.answerEn || q.answerAr);

        addUserBubble(questionText);
        addBotBubble(answerText, 'faq');

        // Offer returning to categories or picking more questions
        const t = UI_TEXT[currentLang];
        addButtonList(null, [{
            label: t.back,
            isBack: true,
            onClick: showCategories
        }]);
    }

    function resetConversation() {
        const box = $('chat-messages');
        if (box) {
            box.innerHTML = '';
        }
        addBotBubble(UI_TEXT[currentLang].welcome, 'bot');
        showCategories();
    }

    // Submit user message to API or fallback match
    async function submitUserQuery() {
        if (isSending) return;
        const input = $('user-input');
        if (!input) return;

        const text = input.value.trim();
        if (text === '') return;

        input.value = '';
        addUserBubble(text);

        isSending = true;
        const sendBtn = $('send-btn');
        if (sendBtn) sendBtn.disabled = true;

        const typingRow = addTypingBubble();

        try {
            const response = await fetch('/api/chat/ask', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({ message: text, language: currentLang })
            });

            const data = await response.json().catch(() => ({}));
            if (typingRow) typingRow.remove();

            if (!response.ok) {
                // Client-side exact FAQ match fallback if server was unavailable
                const localMatch = findLocalFaq(text);
                if (localMatch) {
                    const ans = currentLang === 'ar' ? (localMatch.answerAr || localMatch.answerEn) : (localMatch.answerEn || localMatch.answerAr);
                    addBotBubble(ans, 'faq');
                } else {
                    addBotBubble(data.error || UI_TEXT[currentLang].error, 'bot');
                }
            } else {
                addBotBubble(data.answer || UI_TEXT[currentLang].error, data.source || 'gemini');
            }
        } catch (error) {
            if (typingRow) typingRow.remove();
            const localMatch = findLocalFaq(text);
            if (localMatch) {
                const ans = currentLang === 'ar' ? (localMatch.answerAr || localMatch.answerEn) : (localMatch.answerEn || localMatch.answerAr);
                addBotBubble(ans, 'faq');
            } else {
                addBotBubble(UI_TEXT[currentLang].error, 'bot');
            }
        } finally {
            isSending = false;
            if (sendBtn) sendBtn.disabled = false;
            if (input) input.focus();
        }
    }

    function normalizeText(s) {
        return (s || '').trim().replace(/[?؟!.]$/g, '').trim().toLowerCase();
    }

    function findLocalFaq(query) {
        const clean = normalizeText(query);
        if (!faqCategories) return null;
        for (const cat of faqCategories) {
            for (const q of (cat.questions || [])) {
                if (normalizeText(q.questionEn) === clean || normalizeText(q.questionAr) === clean) {
                    return q;
                }
            }
        }
        return null;
    }

    // Toggle Chat Window
    function toggleChatWindow() {
        const popup = $('chat-popup-window');
        const fab = $('chat-toggle-btn');
        const pill = $('sairh-chat-fab-pill');
        if (!popup) return;

        isOpen = !isOpen;
        if (isOpen) {
            popup.classList.add('active');
            popup.setAttribute('aria-hidden', 'false');
            if (fab) fab.classList.add('active');
            if (pill) pill.style.opacity = '0';
            const input = $('user-input');
            if (input) setTimeout(() => input.focus(), 150);
            scrollToBottom();
        } else {
            popup.classList.remove('active');
            popup.setAttribute('aria-hidden', 'true');
            if (fab) fab.classList.remove('active');
            if (pill) pill.style.opacity = '1';
        }
    }

    // Expose toggles globally for HTML onclick handlers
    window.toggleChatWindow = toggleChatWindow;
    window.toggleLanguage = toggleLanguage;
    window.submitUserQuery = submitUserQuery;

    // Initialize on DOM ready
    async function initChat() {
        currentLang = detectInitialLanguage();
        applyLanguage();

        const input = $('user-input');
        if (input) {
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    e.stopPropagation();
                    submitUserQuery();
                }
            });
        }

        // Auto-minimize pill after 10s if not interacted
        setTimeout(() => {
            const pill = $('sairh-chat-fab-pill');
            if (pill && !isOpen) {
                pill.style.opacity = '0.85';
            }
        }, 10000);

        await loadFaqs();
        resetConversation();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initChat);
    } else {
        initChat();
    }
})();
