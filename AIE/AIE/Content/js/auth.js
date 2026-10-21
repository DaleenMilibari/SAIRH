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
    initUserDropdown();
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

    // 2. Full Name input handling:
    if (txtFullName) {
      txtFullName.addEventListener('input', function () {
        if (this.classList.contains('is-invalid') && this.value.trim().length >= 3) {
          this.classList.remove('is-invalid');
        }
      });
      txtFullName.addEventListener('blur', function () {
        this.value = this.value.trim();
      });
    }

    // 3. Organization, Job Title, Specialty trimming on blur
    [txtOrg, txtJobTitle, txtSpecialty].forEach(function (input) {
      if (input) {
        input.addEventListener('blur', function () {
          this.value = this.value.trim();
        });
      }
    });

    // 4. LinkedIn URL input handling:
    if (txtLinkedIn) {
      txtLinkedIn.addEventListener('blur', function () {
        var v = this.value.trim();
        if (v && !/^https?:\/\//i.test(v)) {
          if (/^(?:www\.)?linkedin\.com/i.test(v) || /^in\//i.test(v)) {
            v = 'https://' + (v.startsWith('in/') ? 'linkedin.com/' + v : v);
          } else if (v.indexOf('/') === -1 && !v.includes('.')) {
            v = 'https://linkedin.com/in/' + v;
          }
          this.value = v;
        }
        if (this.classList.contains('is-invalid')) {
          this.classList.remove('is-invalid');
        }
      });
      txtLinkedIn.addEventListener('input', function () {
        if (this.classList.contains('is-invalid')) {
          this.classList.remove('is-invalid');
        }
      });
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

      // Validate Full Name
      if (fullName.length < 3) {
        if (txtFullName) {
          txtFullName.classList.add('is-invalid');
          txtFullName.focus();
        }
        showProfileMessage(
          isArabic ? 'يرجى إدخال اسمك الكامل (3 أحرف على الأقل).' : 'Please enter your full name (at least 3 characters).',
          false
        );
        return;
      }

      // Validate Mobile if provided
      if (mobile) {
        var cleanMobile = mobile.replace(/[\s\-()]/g, '');
        if (!/^\+?[0-9]{7,15}$/.test(cleanMobile)) {
          if (txtMobile) {
            txtMobile.classList.add('is-invalid');
            txtMobile.focus();
          }
          showProfileMessage(
            isArabic ? 'يرجى إدخال رقم جوال صحيح (مثال: +966501234567 أو 0501234567).' : 'Please enter a valid mobile number (e.g. +966 50 123 4567).',
            false
          );
          return;
        }
      }

      // Validate LinkedIn URL if provided
      if (linkedIn) {
        if (!/^https?:\/\/[^\s$.?#].[^\s]*$/i.test(linkedIn)) {
          if (txtLinkedIn) {
            txtLinkedIn.classList.add('is-invalid');
            txtLinkedIn.focus();
          }
          showProfileMessage(
            isArabic ? 'يرجى إدخال رابط لينكد إن صحيح (مثال: https://linkedin.com/in/username).' : 'Please enter a valid LinkedIn URL (e.g. https://linkedin.com/in/username).',
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
      params.append('TxtEditMobile', mobile);
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
})();
