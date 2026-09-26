/**
 * SAIRH Platform - Scroll Reveal Animation (Triggered Once)
 * Reveals content smoothly when scrolled into view using IntersectionObserver.
 */

(function () {
  'use strict';

  function initScrollReveal() {
    // Check for prefers-reduced-motion
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      document.querySelectorAll('.reveal-on-scroll, section, .glass-card, .vision-pillar-card, .venue-showcase-card, .qr-pass-container, .hub-track-card, .sairh-live-widget, .card, .de-team-list').forEach(function (el) {
        el.classList.add('is-revealed');
      });
      return;
    }

    // Select elements to reveal across pages
    var selector = '.reveal-on-scroll, section:not(.hero-no-reveal), .glass-card, .vision-pillar-card, .venue-showcase-card, .qr-pass-container, .hub-track-card, .sairh-live-widget, .de-team-list';
    var targets = document.querySelectorAll(selector);

    if (!targets || targets.length === 0) return;

    // Apply reveal-on-scroll base class
    targets.forEach(function (el) {
      if (!el.classList.contains('is-revealed')) {
        el.classList.add('reveal-on-scroll');
      }
    });

    // IntersectionObserver options
    var observerOptions = {
      root: null,
      rootMargin: '0px 0px -60px 0px',
      threshold: 0.1
    };

    var revealObserver = new IntersectionObserver(function (entries, observer) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-revealed');
          // Unobserve so animation triggers ONCE only
          observer.unobserve(entry.target);
        }
      });
    }, observerOptions);

    targets.forEach(function (el) {
      revealObserver.observe(el);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initScrollReveal);
  } else {
    initScrollReveal();
  }
})();
