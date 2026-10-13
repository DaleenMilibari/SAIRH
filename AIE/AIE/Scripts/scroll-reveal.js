/**
 * SAIRH Platform - Comprehensive Liquid Glass Scroll Reveal System
 * Reveals container and main elements smoothly across all pages using IntersectionObserver.
 * Speakers page: reveals header, filter container, and speaker cards row-by-row (no inner-card animation).
 * All pages: strictly targets container/main blocks, never inner sub-elements.
 */
(function () {
  'use strict';

  // Container & Main Elements Only (No inner/sub-elements)
  var REVEAL_SELECTORS = [
    // Generic Liquid Glass marker (if explicitly set on a card)
    '.reveal-on-scroll',

    // Page Header Containers & Section Header Blocks
    '.simpler-main-bg > .container',
    'section:not(.landing-hero-section):not(.simpler-main-bg) > .container > .text-center:first-child',

    // Speakers Page: Header, Filter Container, and Speaker Cards per row
    '.speakers-filter-container',
    '.speaker-card',

    // Landing Page Main Containers
    '.sairh-live-widget',
    '.hero-countdown-card',
    '.vision-pillar-card',
    '.qr-pass-container',
    '.venue-showcase-card',

    // Ceremony & Publication Track Cards & Agenda Containers
    '.track-deck-card',
    '.agenda-day-tabs',
    '.track-filter-bar',
    '.session-item',

    // Exhibition Containers
    '.expo-meta-banner',
    '.pavilion-card',

    // Sponsors / Partners Containers
    '.partner-block',
    '.alliances-ribbon',

    // Contact Containers
    '.contact-info-card',
    '.contact-form-glass',

    // Dashboard & Profile Containers
    '.profile-user-card',
    '.dash-nav-pills',
    '.dash-content-card',
    '.glass-card',

    // Auth Containers
    '.login-glass-card',
    '.register-glass-card'
  ];

  function initScrollReveal() {
    var selectorStr = REVEAL_SELECTORS.join(', ');

    // Fallback if IntersectionObserver is unsupported
    if (!('IntersectionObserver' in window)) {
      document.querySelectorAll(selectorStr).forEach(function (el) {
        el.classList.add('is-revealed');
      });
      return;
    }

    // Respect reduced-motion preference
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      document.querySelectorAll(selectorStr).forEach(function (el) {
        el.classList.add('is-revealed');
      });
      return;
    }

    var targets = document.querySelectorAll(selectorStr);
    if (!targets || targets.length === 0) return;

    // Apply base reveal class to all matched container targets
    targets.forEach(function (el) {
      if (!el.classList.contains('is-revealed')) {
        el.classList.add('reveal-on-scroll');
      }
    });

    var vh = window.innerHeight || document.documentElement.clientHeight;
    // Responsive rootMargin: -40px on desktop, -20px on mobile for natural on-screen triggering
    var bottomMargin = vh > 650 ? '-40px' : '-20px';

    var observerOptions = {
      root: null,
      rootMargin: '0px 0px ' + bottomMargin + ' 0px',
      threshold: 0.05
    };

    var observer = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          var target = entry.target;

          var parent = target.parentElement;
          if (parent) {
            // Speakers grid: row-based stagger (3 columns on desktop, 2 on tablet, 1 on mobile)
            if (parent.classList.contains('speakers-grid')) {
              var allCards = Array.prototype.slice.call(parent.children);
              var cardIdx = allCards.indexOf(target);
              if (cardIdx >= 0) {
                var colsPerRow = window.innerWidth > 991 ? 3 : (window.innerWidth > 640 ? 2 : 1);
                var colInRow = cardIdx % colsPerRow;
                target.style.transitionDelay = (colInRow * 0.16) + 's';
              }
            } else {
              // General sibling stagger for card decks / grids
              var siblings = parent.querySelectorAll(':scope > .reveal-on-scroll:not(.is-revealed)');
              var idx = Array.prototype.indexOf.call(siblings, target);
              if (idx > 0) {
                var colIdx = idx % 4;
                target.style.transitionDelay = (colIdx * 0.16) + 's';
              }
            }
          }

          target.classList.add('is-revealed');
          obs.unobserve(target);

          // Clean up inline delay after transition completes
          setTimeout(function () {
            target.style.transitionDelay = '';
          }, 1900);
        }
      });
    }, observerOptions);

    // Initial check: elements already visible in viewport reveal immediately with smooth entrance
    targets.forEach(function (el) {
      var rect = el.getBoundingClientRect();
      if (rect.bottom < 0) {
        // Element is already scrolled past above viewport
        el.classList.add('is-revealed');
      } else if (rect.top < vh - 40 && rect.bottom > 0) {
        // Element is currently visible in viewport on initial load
        el.classList.add('is-revealed');
      } else {
        // Element is below viewport: observe for scroll reveal
        observer.observe(el);
      }
    });

    // Dynamic Tab & Filter Handling (Agenda Day 1/2, Dashboard tabs, Speakers search & track filters)
    function revealDynamicElements() {
      setTimeout(function () {
        var currentVh = window.innerHeight || document.documentElement.clientHeight;
        document.querySelectorAll(selectorStr).forEach(function (el) {
          if (!el.classList.contains('is-revealed')) {
            var rect = el.getBoundingClientRect();
            if (rect.top < currentVh - 20 && rect.bottom > 0) {
              el.classList.add('is-revealed');
              observer.unobserve(el);
            }
          }
        });
      }, 100);
    }

    document.addEventListener('click', function (e) {
      var tabBtn = e.target.closest('button, a, [data-toggle="tab"], .track-filter-pill, .dash-pill-btn, .agenda-day-btn, .track-tab-btn');
      if (tabBtn) {
        revealDynamicElements();
      }
    });

    // Safety timeout: ensure no content remains hidden after 4s
    setTimeout(function () {
      document.querySelectorAll(selectorStr).forEach(function (el) {
        if (!el.classList.contains('is-revealed')) {
          el.classList.add('is-revealed');
        }
      });
    }, 4000);
  }

  // Initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initScrollReveal);
  } else {
    initScrollReveal();
  }
})();
