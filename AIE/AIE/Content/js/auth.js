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
    if (alert) {
      alert.setAttribute('tabindex', '-1');
      alert.focus({ preventScroll: false });
    }

    initPasswordStrengthMeter();
  });

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
})();
