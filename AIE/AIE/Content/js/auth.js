/*
 * SAIRH 2026 - Sign in / Register / Profile form enhancements.
 * Progressive enhancement only: every form still works without JavaScript,
 * and all validation is repeated on the server.
 */
(function () {
  'use strict';

  // Show / hide password toggles: <button type="button" data-toggle-password="InputId">
  document.addEventListener('click', function (event) {
    var button = event.target.closest('[data-toggle-password]');
    if (!button) return;

    var input = document.getElementById(button.getAttribute('data-toggle-password'));
    if (!input) return;

    var show = input.type === 'password';
    input.type = show ? 'text' : 'password';
    button.setAttribute('aria-pressed', show ? 'true' : 'false');
    button.setAttribute('aria-label', show ? button.getAttribute('data-label-hide') : button.getAttribute('data-label-show'));

    var icon = button.querySelector('i');
    if (icon) icon.className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
    input.focus();
  });

  // Prevent double submissions (e.g. creating the same account twice).
  // The clicked button is NOT disabled: ASP.NET needs its name in the POST to raise the click event.
  document.addEventListener('submit', function (event) {
    var form = event.target;
    var button = event.submitter;
    if (!button || !button.hasAttribute('data-loading-text')) return;

    if (form.getAttribute('data-submitting') === 'true') {
      event.preventDefault();
      return;
    }
    form.setAttribute('data-submitting', 'true');
    button.classList.add('is-submitting');
    button.setAttribute('aria-disabled', 'true');
    var loadingText = button.getAttribute('data-loading-text');
    if (button.tagName === 'INPUT') {
      button.setAttribute('data-default-text', button.value);
      button.value = loadingText;
    } else {
      button.setAttribute('data-default-text', button.textContent);
      button.textContent = loadingText;
    }
  });

  // Reset the submitting state when the page is restored from the back/forward cache.
  window.addEventListener('pageshow', function (event) {
    if (!event.persisted) return;
    document.querySelectorAll('form[data-submitting]').forEach(function (form) {
      form.removeAttribute('data-submitting');
    });
    document.querySelectorAll('.is-submitting').forEach(function (button) {
      button.classList.remove('is-submitting');
      button.removeAttribute('aria-disabled');
      if (button.hasAttribute('data-default-text')) {
        var defaultText = button.getAttribute('data-default-text');
        if (button.tagName === 'INPUT') {
          button.value = defaultText;
        } else {
          button.textContent = defaultText;
        }
      }
    });
  });

  // Regex definitions tailored for strict injection prevention
  var LETTERS_ONLY_REGEX = /^[a-zA-Z\u0600-\u06FF\s]+$/;
  var SAFE_EMAIL_REGEX = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/;
  var LINKEDIN_REGEX = /^https?:\/\/([a-zA-Z0-9-]+\.)?linkedin\.com\/(in|company|pub|school)\/[a-zA-Z0-9_/%-]+(?:\?[a-zA-Z0-9_=&%-]+)?$/i;

  function attachLettersOnlyFilter(input) {
    if (!input) return;
    input.addEventListener('input', function () {
      var val = this.value;
      // Filter out numbers, punctuation, quotes, angle brackets, and symbols
      var cleaned = val.replace(/[^a-zA-Z\u0600-\u06FF\s]/g, '');
      if (cleaned !== val) {
        this.value = cleaned;
      }
      if (this.classList.contains('is-invalid') && cleaned.trim().length >= 2) {
        this.classList.remove('is-invalid');
      }
    });
    input.addEventListener('blur', function () {
      this.value = this.value.replace(/\s+/g, ' ').trim();
    });
  }

  function attachEmailFilter(input) {
    if (!input) return;
    input.addEventListener('input', function () {
      var val = this.value;
      // Strip control chars, newlines, angle brackets, quotes, spaces, and injection tokens
      var cleaned = val.replace(/[<>"'\\\s\r\n\0;]/g, '');
      if (cleaned !== val) {
        this.value = cleaned;
      }
      if (this.classList.contains('is-invalid')) {
        this.classList.remove('is-invalid');
      }
    });
    input.addEventListener('blur', function () {
      this.value = this.value.trim().toLowerCase();
    });
  }

  function attachLinkedInFilter(input) {
    if (!input) return;
    input.addEventListener('input', function () {
      var val = this.value;
      // Strip angle brackets, quotes, semicolons, brackets, backslashes
      var cleaned = val.replace(/[<>"';(){}[\]\\]/g, '');
      if (cleaned !== val) {
        this.value = cleaned;
      }
      if (this.classList.contains('is-invalid')) {
        this.classList.remove('is-invalid');
      }
    });
    input.addEventListener('blur', function () {
      var v = this.value.trim();
      if (v && !/^https?:\/\//i.test(v)) {
        if (/^(?:www\.)?linkedin\.com/i.test(v) || /^in\//i.test(v)) {
          v = 'https://' + (v.startsWith('in/') ? 'linkedin.com/' + v : v);
        } else if (v.indexOf('/') === -1 && !v.includes('.')) {
          v = 'https://linkedin.com/in/' + v;
        } else {
          v = 'https://' + v;
        }
        this.value = v;
      }
    });
  }

  // Move keyboard / screen reader focus to the first server-side error so it is noticed.
  document.addEventListener('DOMContentLoaded', function () {
    var alert = document.querySelector('.auth-alert');
    if (alert && alert.style.display !== 'none' && alert.textContent.trim()) {
      alert.setAttribute('tabindex', '-1');
      alert.focus({ preventScroll: false });
    }

    initPasswordStrengthMeter();
    initProfileTabs();
    initProfileForm();
    initPasswordChangeForm();
    initRegisterForm();
    initLoginForm();
    initUserDropdown();
    initPhoneInputs();
    initContactForm();
  });

  function initUserDropdown() {
    document.addEventListener('click', function (event) {
      var toggle = event.target.closest('.user-dropdown-toggle');
      var dropdown = event.target.closest('.header-user-dropdown');

      if (toggle && dropdown) {
        event.preventDefault();
        event.stopPropagation();
        dropdown.classList.toggle('open');
        return;
      }

      if (!dropdown) {
        document.querySelectorAll('.header-user-dropdown.open').forEach(function (el) {
          el.classList.remove('open');
        });
      }
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        document.querySelectorAll('.header-user-dropdown.open').forEach(function (el) {
          el.classList.remove('open');
        });
      }
    });
  }

  function initPasswordStrengthMeter() {
    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';

    // Password input and confirm password inputs (supporting Register and Profile pages)
    var pwdInput = document.querySelector('input[id*="TxtPassword"], input[id*="TxtPass"]');
    // Ensure we don't pick TxtPassCurrent as the new password input
    if (pwdInput && pwdInput.id.indexOf('TxtPassCurrent') !== -1) {
      pwdInput = document.querySelector('input[id="TxtPass"], input[id$="_TxtPass"]');
    }
    var confirmInput = document.querySelector('input[id*="TxtPasswordAgain"], input[id*="TxtPassRe"]');

    var strengthBox = document.getElementById('pwdStrengthBox');
    var strengthBar = document.getElementById('pwdStrengthBar');
    var strengthText = document.getElementById('pwdStrengthText');
    var matchMsg = document.getElementById('pwdMatchMsg');

    var reqLen = document.getElementById('reqLen');
    var reqUpper = document.getElementById('reqUpper');
    var reqLower = document.getElementById('reqLower');
    var reqNum = document.getElementById('reqNum');
    var reqSpecial = document.getElementById('reqSpecial');

    if (!pwdInput || !strengthBox) return;

    function updateReq(el, isValid) {
      if (!el) return;
      el.classList.toggle('is-valid', isValid);
      var icon = el.querySelector('i');
      if (icon) {
        icon.className = isValid ? 'bi bi-check-circle-fill' : 'bi bi-circle';
      }
    }

    function evaluateStrength() {
      var pwd = pwdInput.value || '';
      if (pwd.length === 0) {
        strengthBox.style.display = 'none';
        if (matchMsg) matchMsg.style.display = 'none';
        return;
      }

      strengthBox.style.display = 'block';

      var hasLen = pwd.length >= 8;
      var hasUpper = /[A-Z]/.test(pwd);
      var hasLower = /[a-z]/.test(pwd);
      var hasNum = /[0-9]/.test(pwd);
      var hasSpecial = /[^A-Za-z0-9]/.test(pwd);

      updateReq(reqLen, hasLen);
      updateReq(reqUpper, hasUpper);
      updateReq(reqLower, hasLower);
      updateReq(reqNum, hasNum);
      updateReq(reqSpecial, hasSpecial);

      var score = (hasLen ? 1 : 0) + (hasUpper ? 1 : 0) + (hasLower ? 1 : 0) + (hasNum ? 1 : 0) + (hasSpecial ? 1 : 0);

      var level = 'weak';
      var label = isArabic ? 'ضعيفة' : 'Weak';

      if (score >= 5) {
        level = 'strong';
        label = isArabic ? 'قوية جداً' : 'Strong';
      } else if (score >= 4) {
        level = 'good';
        label = isArabic ? 'جيدة' : 'Good';
      } else if (score >= 2) {
        level = 'fair';
        label = isArabic ? 'مقبولة' : 'Fair';
      }

      if (strengthBar) {
        strengthBar.className = 'password-strength-bar strength-' + level;
      }
      if (strengthText) {
        strengthText.className = 'password-strength-text text-' + level;
        strengthText.textContent = label;
      }

      evaluateMatch();
    }

    function evaluateMatch() {
      if (!confirmInput || !matchMsg) return;
      var p1 = pwdInput.value || '';
      var p2 = confirmInput.value || '';

      if (p2.length === 0) {
        matchMsg.style.display = 'none';
        return;
      }

      matchMsg.style.display = 'flex';
      var isMatch = p1 === p2;
      if (isMatch) {
        matchMsg.className = 'password-match-status match-yes';
        matchMsg.innerHTML = '<i class="bi bi-check-circle-fill"></i> ' + (isArabic ? 'كلمتا المرور متطابقتان' : 'Passwords match');
      } else {
        matchMsg.className = 'password-match-status match-no';
        matchMsg.innerHTML = '<i class="bi bi-x-circle-fill"></i> ' + (isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match');
      }
    }

    pwdInput.addEventListener('input', evaluateStrength);
    if (confirmInput) {
      confirmInput.addEventListener('input', evaluateMatch);
    }
  }

  function initProfileTabs() {
    var btnProfile = document.getElementById('BtnShowProfile');
    var btnChangePass = document.getElementById('BtnShowChangePass');
    var divEditProfile = document.getElementById('div_editprofile');
    var divChangePass = document.getElementById('div_changepasss');

    if (!btnProfile || !btnChangePass || !divEditProfile || !divChangePass) return;

    function activateTab(tab) {
      if (tab === 'password') {
        divChangePass.style.display = 'block';
        divEditProfile.style.display = 'none';
        btnChangePass.classList.add('active');
        btnProfile.classList.remove('active');
      } else {
        divEditProfile.style.display = 'block';
        divChangePass.style.display = 'none';
        btnProfile.classList.add('active');
        btnChangePass.classList.remove('active');
      }
    }

    btnProfile.addEventListener('click', function (e) {
      e.preventDefault();
      activateTab('profile');
      if (window.history && window.history.replaceState) {
        try {
          var u = new URL(window.location.href);
          u.searchParams.delete('tab');
          window.history.replaceState({}, '', u.toString());
        } catch (_) {}
      }
    });

    btnChangePass.addEventListener('click', function (e) {
      e.preventDefault();
      activateTab('password');
      if (window.history && window.history.replaceState) {
        try {
          var u = new URL(window.location.href);
          u.searchParams.set('tab', 'password');
          window.history.replaceState({}, '', u.toString());
        } catch (_) {}
      }
      var curPass = document.getElementById('TxtPassCurrent');
      if (curPass) curPass.focus();
    });

    if (window.location.search.indexOf('tab=password') !== -1) {
      activateTab('password');
    } else {
      var passErr = divChangePass.querySelector('.auth-alert');
      if (passErr && passErr.style.display !== 'none' && passErr.textContent.trim()) {
        activateTab('password');
      }
    }
  }

  function initProfileForm() {
    var editProfileContainer = document.getElementById('div_editprofile');
    if (!editProfileContainer) return;

    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';

    var txtFullName = document.getElementById('TxtEditFullName') || document.querySelector('input[id$="TxtEditFullName"]');
    var txtMobile = document.getElementById('TxtEditMobile') || document.querySelector('input[id$="TxtEditMobile"]');
    var txtOrg = document.getElementById('TxtEditOrg') || document.querySelector('input[id$="TxtEditOrg"]');
    var txtJobTitle = document.getElementById('TxtEditJobTitle') || document.querySelector('input[id$="TxtEditJobTitle"]');
    var txtSpecialty = document.getElementById('TxtEditSpecialty') || document.querySelector('input[id$="TxtEditSpecialty"]');
    var txtLinkedIn = document.getElementById('TxtEditLinkedIn') || document.querySelector('input[id$="TxtEditLinkedIn"]');
    var btnSave = document.getElementById('BtnPudateProfile') || document.querySelector('button[id$="BtnPudateProfile"]');
    var alertBox = document.getElementById('divErrorProfile') || document.querySelector('div[id$="divErrorProfile"]');

    if (!btnSave) return;

    function showProfileMessage(msg, isSuccess) {
      if (!alertBox) return;
      alertBox.className = 'auth-alert alert ' + (isSuccess ? 'alert-success' : 'alert-danger');
      alertBox.style.display = 'block';
      alertBox.innerHTML = (isSuccess ? '<i class="bi bi-check-circle mr-1"></i> ' : '<i class="bi bi-exclamation-triangle mr-1"></i> ') + escapeHtml(msg);
      alertBox.setAttribute('tabindex', '-1');
      alertBox.focus({ preventScroll: false });
    }

    function clearProfileMessage() {
      if (alertBox) {
        alertBox.style.display = 'none';
        alertBox.innerHTML = '';
      }
    }

    function escapeHtml(str) {
      return (str || '').replace(/[&<>"']/g, function (m) {
        return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m];
      });
    }

    // 1. Mobile number input handling:
    // Auto-convert Arabic/Persian digits (٠-٩) to Western (0-9)
    // Filter allowed characters: +, digits, space, -, (, )
    if (txtMobile) {
      txtMobile.addEventListener('input', function () {
        var val = this.value;
        var converted = val.replace(/[\u0660-\u0669]/g, function (c) {
          return c.charCodeAt(0) - 0x0660;
        }).replace(/[\u06F0-\u06F9]/g, function (c) {
          return c.charCodeAt(0) - 0x06F0;
        });
        converted = converted.replace(/[^\d+() -]/g, '');
        if (converted !== val) {
          this.value = converted;
        }
        if (this.classList.contains('is-invalid')) {
          this.classList.remove('is-invalid');
        }
      });
    }

    // 2. Full Name, Organization, Job Title, Specialty inputs handling (Letters Only):
    [txtFullName, txtOrg, txtJobTitle, txtSpecialty].forEach(function (input) {
      if (input) {
        attachLettersOnlyFilter(input);
      }
    });

    // 4. LinkedIn URL input handling:
    if (txtLinkedIn) {
      attachLinkedInFilter(txtLinkedIn);
    }

    // 5. Submit Handling for Profile Form
    btnSave.addEventListener('click', function (e) {
      e.preventDefault();

      clearProfileMessage();

      var fullName = txtFullName ? txtFullName.value.trim() : '';
      var mobile = txtMobile ? txtMobile.value.trim() : '';
      var org = txtOrg ? txtOrg.value.trim() : '';
      var jobTitle = txtJobTitle ? txtJobTitle.value.trim() : '';
      var specialty = txtSpecialty ? txtSpecialty.value.trim() : '';
      var linkedIn = txtLinkedIn ? txtLinkedIn.value.trim() : '';

      // Validate Full Name: letters only
      if (fullName.length < 2) {
        if (txtFullName) {
          txtFullName.classList.add('is-invalid');
          txtFullName.focus();
        }
        showProfileMessage(
          isArabic ? 'يرجى إدخال اسمك الكامل (حرفين على الأقل).' : 'Please enter your full name (at least 2 characters).',
          false
        );
        return;
      }

      if (!LETTERS_ONLY_REGEX.test(fullName)) {
        if (txtFullName) {
          txtFullName.classList.add('is-invalid');
          txtFullName.focus();
        }
        showProfileMessage(
          isArabic ? 'يجب أن يحتوي الاسم الكامل على أحرف فقط (كبيرة وصغيرة).' : 'Full name must contain letters only (uppercase and lowercase).',
          false
        );
        return;
      }

      // Validate Organization: letters only if provided
      if (org && !LETTERS_ONLY_REGEX.test(org)) {
        if (txtOrg) {
          txtOrg.classList.add('is-invalid');
          txtOrg.focus();
        }
        showProfileMessage(
          isArabic ? 'يجب أن يحتوي اسم جهة العمل / المنظمة على أحرف فقط (كبيرة وصغيرة).' : 'Organization must contain letters only (uppercase and lowercase).',
          false
        );
        return;
      }

      // Validate Position (Job Title): letters only if provided
      if (jobTitle && !LETTERS_ONLY_REGEX.test(jobTitle)) {
        if (txtJobTitle) {
          txtJobTitle.classList.add('is-invalid');
          txtJobTitle.focus();
        }
        showProfileMessage(
          isArabic ? 'يجب أن يحتوي المسمى الوظيفي على أحرف فقط (كبيرة وصغيرة).' : 'Position must contain letters only (uppercase and lowercase).',
          false
        );
        return;
      }

      // Validate Field (Specialty): letters only if provided
      if (specialty && !LETTERS_ONLY_REGEX.test(specialty)) {
        if (txtSpecialty) {
          txtSpecialty.classList.add('is-invalid');
          txtSpecialty.focus();
        }
        showProfileMessage(
          isArabic ? 'يجب أن يحتوي مجال التخصص على أحرف فقط (كبيرة وصغيرة).' : 'Field must contain letters only (uppercase and lowercase).',
          false
        );
        return;
      }

      // Validate Mobile if provided
      var ddlCountry = document.getElementById('DdlEditCountryCode') || document.querySelector('select[name="DdlEditCountryCode"]');
      var countryCode = ddlCountry ? ddlCountry.value : '+966';
      var fullMobile = '';
      if (mobile) {
        var cleanDigits = mobile.replace(/[\s\-()]/g, '');
        if (cleanDigits.startsWith('0') && countryCode) {
          cleanDigits = cleanDigits.substring(1);
        }
        if (countryCode && !cleanDigits.startsWith('+')) {
          fullMobile = countryCode + cleanDigits;
        } else {
          fullMobile = cleanDigits;
        }

        if (countryCode === '+966') {
          if (!/^\+9665\d{8}$/.test(fullMobile)) {
            if (txtMobile) {
              txtMobile.classList.add('is-invalid');
              txtMobile.focus();
            }
            showProfileMessage(
              isArabic ? 'يرجى إدخال رقم جوال سعودي صحيح يبدأ بـ 5 ويتكون من 9 أرقام (مثال: 501234567).' : 'Please enter a valid 9-digit Saudi mobile starting with 5 (e.g. 50 123 4567).',
              false
            );
            return;
          }
        } else if (!/^\+[1-9]\d{6,14}$/.test(fullMobile)) {
          if (txtMobile) {
            txtMobile.classList.add('is-invalid');
            txtMobile.focus();
          }
          showProfileMessage(
            isArabic ? 'يرجى إدخال رقم جوال دولي صحيح.' : 'Please enter a valid international mobile number.',
            false
          );
          return;
        }
      }

      // Validate LinkedIn URL if provided
      if (linkedIn) {
        if (/^(?:javascript|data|vbscript|file|about|blob):/i.test(linkedIn) || /[<>"';(){}[\]\\]/.test(linkedIn) || !LINKEDIN_REGEX.test(linkedIn)) {
          if (txtLinkedIn) {
            txtLinkedIn.classList.add('is-invalid');
            txtLinkedIn.focus();
          }
          showProfileMessage(
            isArabic ? 'يرجى إدخال رابط لينكد إن صالح (مثال: https://linkedin.com/in/username).' : 'Please enter a valid LinkedIn URL (e.g. https://linkedin.com/in/username).',
            false
          );
          return;
        }
      }

      // Set Loading State
      var originalBtnText = btnSave.innerHTML;
      btnSave.disabled = true;
      btnSave.classList.add('is-submitting');
      var loadingText = btnSave.getAttribute('data-loading-text') || (isArabic ? 'جارٍ الحفظ...' : 'Saving...');
      btnSave.innerHTML = '<span class="spinner-border spinner-border-sm mr-1" role="status" aria-hidden="true"></span> ' + loadingText;

      // Prepare payload
      var params = new URLSearchParams();
      params.append('BtnPudateProfile', 'Save Changes');
      params.append('TxtEditFullName', fullName);
      params.append('TxtEditMobile', fullMobile || mobile);
      params.append('DdlEditCountryCode', countryCode);
      params.append('TxtEditOrg', org);
      params.append('TxtEditJobTitle', jobTitle);
      params.append('TxtEditSpecialty', specialty);
      params.append('TxtEditLinkedIn', linkedIn);

      fetch(window.location.href, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json, text/html'
        },
        body: params.toString()
      })
      .then(function (res) {
        var contentType = res.headers.get('content-type') || '';
        if (contentType.indexOf('application/json') !== -1) {
          return res.json().then(function (data) {
            return { isJson: true, data: data, status: res.status };
          });
        }
        return res.text().then(function (text) {
          return { isJson: false, text: text, status: res.status };
        });
      })
      .then(function (result) {
        btnSave.disabled = false;
        btnSave.classList.remove('is-submitting');
        btnSave.innerHTML = originalBtnText;

        if (result.isJson) {
          if (result.data.success || result.status === 200) {
            var succMsg = result.data.message || (isArabic ? 'تم حفظ التعديلات بنجاح!' : 'Your profile changes have been saved successfully!');
            showProfileMessage(succMsg, true);
            updateSidebarProfile(fullName, mobile, org, jobTitle);
          } else {
            showProfileMessage(result.data.error || (isArabic ? 'حدث خطأ أثناء حفظ التعديلات.' : 'An error occurred while saving profile.'), false);
          }
        } else {
          // HTML response
          var parser = new DOMParser();
          var doc = parser.parseFromString(result.text, 'text/html');

          var remoteAlert = doc.getElementById('divErrorProfile');
          var isSuccess = remoteAlert && remoteAlert.classList.contains('alert-success');
          var msg = remoteAlert ? remoteAlert.textContent.trim() : (isArabic ? 'تم حفظ التعديلات بنجاح!' : 'Your profile changes have been saved successfully!');

          showProfileMessage(msg, isSuccess !== false);
          updateSidebarProfile(fullName, mobile, org, jobTitle);
        }
      })
      .catch(function (err) {
        console.error('Profile save error:', err);
        btnSave.disabled = false;
        btnSave.classList.remove('is-submitting');
        btnSave.innerHTML = originalBtnText;
        var form = btnSave.closest('form');
        if (form) {
          form.submit();
        }
      });
    });

    function updateSidebarProfile(name, mobile, org, jobTitle) {
      var lblName = document.getElementById('LblName');
      if (lblName && name) lblName.textContent = name;

      var txtMob = document.getElementById('TxtMobile');
      if (txtMob) txtMob.textContent = mobile || '-';

      var pOrgTitle = document.getElementById('pOrgTitle');
      var lblOrgTitle = document.getElementById('LblOrgTitle');
      var parts = [jobTitle, org].filter(Boolean);
      if (parts.length > 0) {
        if (lblOrgTitle) lblOrgTitle.textContent = parts.join(' • ');
        if (pOrgTitle) pOrgTitle.style.display = 'block';
      } else {
        if (pOrgTitle) pOrgTitle.style.display = 'none';
      }
    }
  }

  function initPasswordChangeForm() {
    var btnUpdate = document.getElementById('BtnUpdate') || document.querySelector('button[id$="BtnUpdate"]');
    var divChangePass = document.getElementById('div_changepasss');
    if (!btnUpdate || !divChangePass) return;

    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';
    var curPassInput = document.getElementById('TxtPassCurrent');
    var newPassInput = document.getElementById('TxtPass');
    var confirmPassInput = document.getElementById('TxtPassRe');
    var alertBox = document.getElementById('divError') || divChangePass.querySelector('.auth-alert');

    function showPassMessage(msg, isSuccess) {
      if (!alertBox) return;
      alertBox.className = 'auth-alert alert ' + (isSuccess ? 'alert-success' : 'alert-danger');
      alertBox.style.display = 'block';
      alertBox.innerHTML = (isSuccess ? '<i class="bi bi-check-circle mr-1"></i> ' : '<i class="bi bi-exclamation-triangle mr-1"></i> ') + msg;
      alertBox.setAttribute('tabindex', '-1');
      alertBox.focus({ preventScroll: false });
    }

    btnUpdate.addEventListener('click', function (e) {
      var curVal = curPassInput ? curPassInput.value : '';
      var newVal = newPassInput ? newPassInput.value : '';
      var confVal = confirmPassInput ? confirmPassInput.value : '';

      if (!curVal) {
        e.preventDefault();
        if (curPassInput) curPassInput.focus();
        showPassMessage(isArabic ? 'يرجى إدخال كلمة المرور الحالية.' : 'Please enter your current password.', false);
        return;
      }

      if (!newVal || newVal.length < 8) {
        e.preventDefault();
        if (newPassInput) newPassInput.focus();
        showPassMessage(isArabic ? 'يجب أن تتكون كلمة المرور الجديدة من 8 أحرف على الأقل.' : 'New password must be at least 8 characters long.', false);
        return;
      }

      if (newVal !== confVal) {
        e.preventDefault();
        if (confirmPassInput) confirmPassInput.focus();
        showPassMessage(isArabic ? 'كلمتا المرور غير متطابقتين.' : 'Passwords do not match.', false);
        return;
      }
    });
  }

  function initRegisterForm() {
    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';
    var btnRegister = document.getElementById('BtnRegister') || document.querySelector('input[id*="BtnRegister"], button[id*="BtnRegister"]');
    var txtFullName = document.getElementById('TxtFullName') || document.querySelector('input[id*="TxtFullName"]');
    var txtEmail = document.getElementById('TxtEmail') || document.querySelector('input[id*="TxtEmail"]');
    var txtOrg = document.getElementById('TxtOrganization') || document.querySelector('input[id*="TxtOrganization"]');
    var txtJobTitle = document.getElementById('TxtJobTitle') || document.querySelector('input[id*="TxtJobTitle"]');
    var txtPassword = document.getElementById('TxtPassword') || document.querySelector('input[id*="TxtPassword"]');
    var txtPasswordAgain = document.getElementById('TxtPasswordAgain') || document.querySelector('input[id*="TxtPasswordAgain"]');
    var alertBox = document.getElementById('divError') || document.querySelector('.auth-alert');

    if (!btnRegister) return;

    attachLettersOnlyFilter(txtFullName);
    attachLettersOnlyFilter(txtOrg);
    attachLettersOnlyFilter(txtJobTitle);
    attachEmailFilter(txtEmail);

    function showRegError(msg) {
      if (!alertBox) return;
      alertBox.className = 'auth-alert alert alert-danger';
      alertBox.style.display = 'block';
      alertBox.innerHTML = '<i class="bi bi-exclamation-triangle mr-1"></i> ' + escapeHtml(msg);
      alertBox.setAttribute('tabindex', '-1');
      alertBox.focus({ preventScroll: false });
    }

    btnRegister.addEventListener('click', function (e) {
      var fullName = txtFullName ? txtFullName.value.trim() : '';
      var email = txtEmail ? txtEmail.value.trim() : '';
      var org = txtOrg ? txtOrg.value.trim() : '';
      var jobTitle = txtJobTitle ? txtJobTitle.value.trim() : '';
      var pass = txtPassword ? txtPassword.value : '';
      var passAgain = txtPasswordAgain ? txtPasswordAgain.value : '';

      // Validate Full Name: letters only
      if (!fullName || fullName.length < 2) {
        e.preventDefault();
        if (txtFullName) { txtFullName.classList.add('is-invalid'); txtFullName.focus(); }
        showRegError(isArabic ? 'يرجى إدخال اسمك الكامل (حرفين على الأقل).' : 'Please enter your full name (at least 2 characters).');
        return;
      }

      if (!LETTERS_ONLY_REGEX.test(fullName)) {
        e.preventDefault();
        if (txtFullName) { txtFullName.classList.add('is-invalid'); txtFullName.focus(); }
        showRegError(isArabic ? 'يجب أن يحتوي الاسم الكامل على أحرف فقط (كبيرة وصغيرة).' : 'Full name must contain letters only (uppercase and lowercase).');
        return;
      }

      // Validate Email: safe RFC email without injection tokens
      if (!email || !SAFE_EMAIL_REGEX.test(email) || /[<>"'\\\r\n;]/.test(email)) {
        e.preventDefault();
        if (txtEmail) { txtEmail.classList.add('is-invalid'); txtEmail.focus(); }
        showRegError(isArabic ? 'يرجى إدخال بريد إلكتروني صالح.' : 'Please enter a valid email address.');
        return;
      }

      // Validate Organization: letters only if provided
      if (org && !LETTERS_ONLY_REGEX.test(org)) {
        e.preventDefault();
        if (txtOrg) { txtOrg.classList.add('is-invalid'); txtOrg.focus(); }
        showRegError(isArabic ? 'يجب أن تحتوي جهة العمل / المنظمة على أحرف فقط (كبيرة وصغيرة).' : 'Organization must contain letters only (uppercase and lowercase).');
        return;
      }

      // Validate Position / Job Title: letters only if provided
      if (jobTitle && !LETTERS_ONLY_REGEX.test(jobTitle)) {
        e.preventDefault();
        if (txtJobTitle) { txtJobTitle.classList.add('is-invalid'); txtJobTitle.focus(); }
        showRegError(isArabic ? 'يجب أن يحتوي المسمى الوظيفي / التخصص على أحرف فقط (كبيرة وصغيرة).' : 'Position / Field must contain letters only (uppercase and lowercase).');
        return;
      }

      // Validate Password
      if (!pass || pass.length < 8) {
        e.preventDefault();
        if (txtPassword) { txtPassword.classList.add('is-invalid'); txtPassword.focus(); }
        showRegError(isArabic ? 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.' : 'Password must be at least 8 characters long.');
        return;
      }

      if (pass !== passAgain) {
        e.preventDefault();
        if (txtPasswordAgain) { txtPasswordAgain.classList.add('is-invalid'); txtPasswordAgain.focus(); }
        showRegError(isArabic ? 'كلمتا المرور غير متطابقتين.' : 'Passwords do not match.');
        return;
      }
    });
  }

  function initLoginForm() {
    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';
    var btnLogin = document.getElementById('BtnLogin') || document.querySelector('input[id*="BtnLogin"], button[id*="BtnLogin"]');
    var txtEmail = document.getElementById('TxtEmail') || document.querySelector('input[id*="TxtEmail"]');
    var txtPassword = document.getElementById('TxtPassword') || document.querySelector('input[id*="TxtPassword"]');
    var alertBox = document.getElementById('divError') || document.querySelector('.auth-alert');

    if (!btnLogin) return;

    attachEmailFilter(txtEmail);

    function showLoginError(msg) {
      if (!alertBox) return;
      alertBox.className = 'auth-alert alert alert-danger';
      alertBox.style.display = 'block';
      alertBox.innerHTML = '<i class="bi bi-exclamation-triangle mr-1"></i> ' + escapeHtml(msg);
      alertBox.setAttribute('tabindex', '-1');
      alertBox.focus({ preventScroll: false });
    }

    btnLogin.addEventListener('click', function (e) {
      var email = txtEmail ? txtEmail.value.trim() : '';
      var pass = txtPassword ? txtPassword.value : '';

      if (!email || !pass) {
        e.preventDefault();
        showLoginError(isArabic ? 'يرجى إدخال البريد الإلكتروني وكلمة المرور.' : 'Please enter both your email address and password.');
        if (!email && txtEmail) txtEmail.focus();
        else if (txtPassword) txtPassword.focus();
        return;
      }

      if (!SAFE_EMAIL_REGEX.test(email) || /[<>"'\\\r\n;]/.test(email)) {
        e.preventDefault();
        if (txtEmail) { txtEmail.classList.add('is-invalid'); txtEmail.focus(); }
        showLoginError(isArabic ? 'يرجى إدخال بريد إلكتروني صالح.' : 'Please enter a valid email address.');
        return;
      }
    });
  }

  function initPhoneInputs() {
    var isArabic = document.documentElement.lang === 'ar' || document.documentElement.dir === 'rtl';
    var groups = document.querySelectorAll('.phone-input-group');
    if (!groups || groups.length === 0) return;

    groups.forEach(function (group) {
      var select = group.querySelector('.phone-country-select');
      var input = group.querySelector('.phone-number-input') || group.querySelector('input[type="tel"], input[type="text"]');
      var container = group.closest('.auth-field') || group.closest('.form-group');
      var hint = container ? container.querySelector('.phone-hint') : null;
      var feedback = container ? container.querySelector('.phone-validation-feedback') : null;

      if (!input) return;

      function updateCountryHints() {
        if (!select) return;
        var code = select.value;
        if (code === '+966') {
          input.placeholder = '50 123 4567';
          if (hint) hint.textContent = isArabic ? 'صيغة الجوال السعودي: 50 123 4567 (9 أرقام)' : 'Saudi mobile format: 50 123 4567 (9 digits)';
        } else if (code === '+971') {
          input.placeholder = '50 123 4567';
          if (hint) hint.textContent = isArabic ? 'صيغة الجوال الإماراتي: 50 123 4567 (9 أرقام)' : 'UAE mobile format: 50 123 4567 (9 digits)';
        } else if (code === '+1') {
          input.placeholder = '202 555 0123';
          if (hint) hint.textContent = isArabic ? 'صيغة الهاتف الأمريكي/الكندي: 10 أرقام' : 'US/CA format: 10 digits (e.g. 202 555 0123)';
        } else if (code === '+44') {
          input.placeholder = '7911 123456';
          if (hint) hint.textContent = isArabic ? 'صيغة الجوال البريطاني: 10 أرقام' : 'UK mobile format: 10 digits';
        } else if (code === '+20') {
          input.placeholder = '10 1234 5678';
          if (hint) hint.textContent = isArabic ? 'صيغة الجوال المصري: 10-11 رقماً' : 'Egypt mobile format: 10-11 digits';
        } else if (code === '') {
          input.placeholder = '+1234567890';
          if (hint) hint.textContent = isArabic ? 'أدخل الرمز الدولي ورقم الهاتف كاملاً' : 'Enter full number with international country code';
        } else {
          input.placeholder = '1234 5678';
          if (hint) hint.textContent = isArabic ? 'أدخل رقم الهاتف بدون مفتاح الدولة' : 'Enter national phone number without country code';
        }
        validatePhone();
      }

      function cleanAndNormalizeNumber() {
        var val = input.value;
        // Convert Arabic/Persian digits
        var converted = val.replace(/[\u0660-\u0669]/g, function (c) {
          return c.charCodeAt(0) - 0x0660;
        }).replace(/[\u06F0-\u06F9]/g, function (c) {
          return c.charCodeAt(0) - 0x06F0;
        });

        var countryCode = select ? select.value : '';

        // If custom/other country selected, allow leading +, otherwise digits and hyphens/spaces
        var allowedRegex = countryCode === '' ? /[^\d+ -]/g : /[^\d -]/g;
        converted = converted.replace(allowedRegex, '');

        // If user typed duplicate country code in national field:
        if (countryCode && countryCode.startsWith('+')) {
          var cleanCode = countryCode.substring(1);
          var digitsOnly = converted.replace(/[\s\-]/g, '');
          if (digitsOnly.startsWith(countryCode)) {
            converted = digitsOnly.substring(countryCode.length);
          } else if (digitsOnly.startsWith(cleanCode)) {
            converted = digitsOnly.substring(cleanCode.length);
          }
        }

        // Auto-remove leading 0 if country code selected
        if (countryCode) {
          var trimmedDigits = converted.replace(/[\s\-]/g, '');
          if (trimmedDigits.startsWith('0')) {
            converted = trimmedDigits.substring(1);
          }
        }

        if (converted !== val) {
          input.value = converted;
        }
      }

      function validatePhone() {
        var raw = input.value.trim();
        var digits = raw.replace(/[\s\-()]/g, '');
        var countryCode = select ? select.value : '';

        if (!digits) {
          if (feedback) feedback.style.display = 'none';
          input.classList.remove('is-invalid', 'is-valid');
          return true;
        }

        var isValid = false;
        var errorMsg = '';

        if (countryCode === '+966') {
          // Saudi Arabia: 9 digits starting with 5
          if (/^5\d{8}$/.test(digits)) {
            isValid = true;
          } else {
            isValid = false;
            errorMsg = isArabic ? 'يجب أن يبدأ رقم الجوال بـ 5 ويتكون من 9 أرقام (مثال: 501234567)' : 'Must start with 5 and be 9 digits (e.g. 50 123 4567)';
          }
        } else if (countryCode === '+971') {
          isValid = /^5\d{8}$/.test(digits);
          if (!isValid) errorMsg = isArabic ? 'يجب أن يتكون من 9 أرقام (مثال: 501234567)' : 'Must be 9 digits (e.g. 50 123 4567)';
        } else if (countryCode === '+1') {
          isValid = /^\d{10}$/.test(digits);
          if (!isValid) errorMsg = isArabic ? 'يجب أن يتكون من 10 أرقام' : 'Must be 10 digits';
        } else if (countryCode === '+44') {
          isValid = /^\d{10,11}$/.test(digits);
          if (!isValid) errorMsg = isArabic ? 'يجب أن يتكون من 10-11 رقماً' : 'Must be 10-11 digits';
        } else if (countryCode === '') {
          isValid = /^\+?[1-9]\d{6,14}$/.test(digits);
          if (!isValid) errorMsg = isArabic ? 'يرجى إدخال رقم هاتف دولي صحيح يتضمن رمز الدولة (+...)' : 'Please enter a valid international phone number (+...)';
        } else {
          // General E.164: national number 6-12 digits
          isValid = /^\d{6,12}$/.test(digits);
          if (!isValid) errorMsg = isArabic ? 'يرجى إدخال رقم هاتف صحيح' : 'Please enter a valid phone number';
        }

        if (feedback) {
          if (isValid) {
            feedback.style.display = 'flex';
            feedback.className = 'phone-validation-feedback valid';
            feedback.innerHTML = '<i class="bi bi-check-circle-fill"></i> ' + (isArabic ? 'رقم صالح' : 'Valid number format');
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
          } else {
            feedback.style.display = 'flex';
            feedback.className = 'phone-validation-feedback invalid';
            feedback.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + errorMsg;
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
          }
        }
        return isValid;
      }

      input.addEventListener('input', function () {
        cleanAndNormalizeNumber();
        validatePhone();
      });

      input.addEventListener('blur', function () {
        cleanAndNormalizeNumber();
        validatePhone();
      });

      if (select) {
        select.addEventListener('change', function () {
          cleanAndNormalizeNumber();
          updateCountryHints();
        });
      }

      // Initial run
      updateCountryHints();
      if (input.value.trim()) {
        validatePhone();
      }
    });
  }

  function initContactForm() {
    var txtMessage = document.getElementById('TxtMessage') || document.querySelector('textarea[id*="TxtMessage"]');
    var charCount = document.getElementById('charCount');
    if (txtMessage && charCount) {
      function updateCount() {
        charCount.textContent = txtMessage.value.length;
      }
      txtMessage.addEventListener('input', updateCount);
      updateCount();
    }
  }
})();
