/**
 * SAIRH Platform - Liquid Glass Scroll Reveal (Once)
 * Reveals content elements smoothly on scroll using IntersectionObserver.
 * Each element animates only once when it enters the viewport.
 */
(function () {
  'use strict';

  // All selectors that should animate on scroll
  var REVEAL_SELECTORS = [
    '.reveal-on-scroll',
    'section:not(.simpler-main-bg):not(.hero-no-reveal)',
    '.glass-card',
    '.liquid-glass',
    '.vision-pillar-card',
    '.venue-showcase-card',
    '.qr-pass-container',
    '.hub-track-card',
    '.sairh-live-widget',
    '.de-team-list',
    '.track-deck-card',
    '.pavilion-card',
    '.partner-block',
    '.session-item',
    '.contact-info-card',
    '.contact-form-glass',
    '.speakers-intro-card',
    '.roster-card',
    '.expo-meta-banner',
    '.alliances-ribbon',
    '.login-glass-card',
    '.register-glass-card',
    '.profile-user-card',
    '.dash-content-card',
    '.dash-nav-pills'
  ];

  function initScrollReveal() {
    // Respect reduced-motion preference
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      var all = document.querySelectorAll(REVEAL_SELECTORS.join(', '));
      all.forEach(function (el) { el.classList.add('is-revealed'); });
      return;
    }

    var targets = document.querySelectorAll(REVEAL_SELECTORS.join(', '));
    if (!targets || targets.length === 0) return;

    // Ensure base class is applied
    targets.forEach(function (el) {
      if (!el.classList.contains('is-revealed')) {
        el.classList.add('reveal-on-scroll');
      }
    });

    var observerOptions = {
      root: null,
      rootMargin: '0px 0px -50px 0px',
      threshold: 0.08
    };

    var observer = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          // Add stagger delay for sibling elements
          var parent = entry.target.parentElement;
          if (parent) {
            var siblings = parent.querySelectorAll(':scope > .reveal-on-scroll:not(.is-revealed)');
            var idx = Array.prototype.indexOf.call(siblings, entry.target);
            if (idx > 0) {
              entry.target.style.transitionDelay = (idx * 0.07) + 's';
            }
          }
          entry.target.classList.add('is-revealed');
          obs.unobserve(entry.target);

          // Clean up transition delay after animation
          setTimeout(function () {
            entry.target.style.transitionDelay = '';
          }, 1200);
        }
      });
    }, observerOptions);

    targets.forEach(function (el) {
      observer.observe(el);
    });
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initScrollReveal);
  } else {
    initScrollReveal();
  }
})();
