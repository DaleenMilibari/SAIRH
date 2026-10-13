/**
 * SAIRH 2026 - Interactive Speakers & Filters Engine
 * Handles real-time search, track filtering, and responsive modal display.
 */

(function () {
  'use strict';

  var currentTrack = 'all';
  var currentSearch = '';

  /**
   * Normalizes text for resilient English & Arabic comparison:
   * Strips diacritics/tashkeel, unifies Arabic alef/taa marbuta/alef maksura, and trims whitespace.
   */
  function normalizeText(str) {
    if (!str) return '';
    return str
      .toString()
      .toLowerCase()
      .replace(/[\u064B-\u065F\u0670]/g, '') // Remove Arabic tashkeel / harakat
      .replace(/[أإآٱ]/g, 'ا')               // Normalize Alef variations
      .replace(/ة/g, 'ه')                    // Normalize Taa Marbuta
      .replace(/ى/g, 'ي')                    // Normalize Alef Maksura
      .replace(/&[a-z0-9#]+;/gi, ' ')        // Remove HTML entities like &mdash;
      .replace(/[\r\n\t]+/g, ' ')
      .trim();
  }

  function initSpeakers() {
    var trackButtons = document.querySelectorAll('.track-tab-btn');
    var searchInput = document.getElementById('speakerSearch');
    var clearSearchBtn = document.getElementById('clearSearchBtn');
    var resetFiltersBtn = document.getElementById('btnResetFilters');

    // Search input (first filter)
    if (searchInput) {
      searchInput.addEventListener('input', function () {
        currentSearch = this.value;
        if (clearSearchBtn) {
          clearSearchBtn.style.display = currentSearch.trim().length > 0 ? 'inline-flex' : 'none';
        }
        applyFilters();
      });
    }

    // Clear search button
    if (clearSearchBtn) {
      clearSearchBtn.addEventListener('click', function () {
        if (searchInput) {
          searchInput.value = '';
          currentSearch = '';
          clearSearchBtn.style.display = 'none';
          searchInput.focus();
          applyFilters();
        }
      });
    }

    // Track tabs (below search bar)
    trackButtons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        trackButtons.forEach(function (b) { b.classList.remove('active'); });
        this.classList.add('active');
        currentTrack = this.getAttribute('data-track') || 'all';
        applyFilters();
      });
    });

    // Reset filters button
    if (resetFiltersBtn) {
      resetFiltersBtn.addEventListener('click', window.resetAllFilters);
    }

    // Close modal on ESC key
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        window.closeSpeakerModal();
      }
    });

    // Check URL parameters (e.g. ?track=track-a)
    try {
      var params = new URLSearchParams(window.location.search);
      var trackParam = params.get('track');
      if (trackParam) {
        var targetBtn = document.querySelector('.track-tab-btn[data-track="' + trackParam.toLowerCase() + '"]');
        if (targetBtn) {
          targetBtn.click();
        }
      }
    } catch (e) {
      // Ignore URLSearchParams error on legacy browsers
    }
    updateCounts();
    applyFilters();
  }

  function updateCounts() {
    var cards = document.querySelectorAll('.speaker-card');
    var totalCards = cards.length;
    var trackACards = document.querySelectorAll('.speaker-card[data-track="track-a"]').length;
    var trackBCards = document.querySelectorAll('.speaker-card[data-track="track-b"]').length;
    var trackCCards = document.querySelectorAll('.speaker-card[data-track="track-c"]').length;

    var totalBadge = document.querySelector('.track-tab-btn[data-track="all"] .tab-count');
    if (totalBadge) totalBadge.textContent = totalCards;
    var trackABadge = document.querySelector('.track-tab-btn[data-track="track-a"] .tab-count');
    if (trackABadge) trackABadge.textContent = trackACards;
    var trackBBadge = document.querySelector('.track-tab-btn[data-track="track-b"] .tab-count');
    if (trackBBadge) trackBBadge.textContent = trackBCards;
    var trackCBadge = document.querySelector('.track-tab-btn[data-track="track-c"] .tab-count');
    if (trackCBadge) trackCBadge.textContent = trackCCards;

    var totalCountEl = document.getElementById('speakersTotalCount');
    if (totalCountEl) totalCountEl.textContent = totalCards;
  }

  function applyFilters() {
    var cards = document.querySelectorAll('.speaker-card');
    var visibleCount = 0;
    var emptyState = document.getElementById('speakersEmptyState');
    var countEl = document.getElementById('speakersCount');
    var resetBtn = document.getElementById('btnResetFilters');

    var rawSearch = (currentSearch || '').trim();
    var normSearch = normalizeText(rawSearch);
    var searchTokens = normSearch ? normSearch.split(/\s+/).filter(Boolean) : [];

    cards.forEach(function (card) {
      var cardTrack = (card.getAttribute('data-track') || '').toLowerCase().trim();

      // Gather card fields for targeted matching (speaker name, session title, track name, role, org, room)
      var speakerName = card.getAttribute('data-name') || '';
      var lectureTitle = card.getAttribute('data-lecture') || '';
      var trackName = card.getAttribute('data-track-name') || '';
      var role = card.getAttribute('data-role') || '';
      var org = card.getAttribute('data-org') || '';
      var room = card.getAttribute('data-room') || '';
      var sessionRole = card.getAttribute('data-session-role') || '';

      var combinedText = (
        speakerName + ' ' +
        lectureTitle + ' ' +
        trackName + ' ' +
        role + ' ' +
        org + ' ' +
        room + ' ' +
        sessionRole + ' ' +
        card.textContent
      );

      var normCardText = normalizeText(combinedText);

      // Track match
      var matchTrack = (currentTrack === 'all' || cardTrack === currentTrack);

      // Search match: all tokens must be present
      var matchSearch = true;
      if (searchTokens.length > 0) {
        matchSearch = searchTokens.every(function (token) {
          return normCardText.indexOf(token) !== -1;
        });
      }

      var isFiltered = (currentTrack !== 'all' || searchTokens.length > 0);
      if (matchTrack && matchSearch) {
        card.style.display = '';
        if (isFiltered) {
          card.classList.add('is-revealed');
        }
        visibleCount++;
      } else {
        card.style.display = 'none';
      }
    });

    if (countEl) {
      countEl.textContent = visibleCount;
    }

    if (emptyState) {
      if (visibleCount === 0) {
        emptyState.classList.add('active');
      } else {
        emptyState.classList.remove('active');
      }
    }

    // Show reset button if search is filled or a specific track is chosen
    var isFiltered = (currentTrack !== 'all' || searchTokens.length > 0);
    if (resetBtn) {
      resetBtn.style.display = isFiltered ? 'inline-flex' : 'none';
    }
  }

  window.filterToTrack = function (trackId) {
    if (currentTrack === trackId) {
      currentTrack = 'all';
    } else {
      currentTrack = trackId || 'all';
    }

    var trackButtons = document.querySelectorAll('.track-tab-btn');
    trackButtons.forEach(function (b) {
      if (b.getAttribute('data-track') === currentTrack) {
        b.classList.add('active');
      } else {
        b.classList.remove('active');
      }
    });

    applyFilters();

    var filterSec = document.getElementById('speakersFilterSection');
    if (filterSec) {
      filterSec.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  window.resetAllFilters = function () {
    currentTrack = 'all';
    currentSearch = '';

    var trackButtons = document.querySelectorAll('.track-tab-btn');
    trackButtons.forEach(function (b) {
      if (b.getAttribute('data-track') === 'all') {
        b.classList.add('active');
      } else {
        b.classList.remove('active');
      }
    });

    var searchInput = document.getElementById('speakerSearch');
    if (searchInput) searchInput.value = '';

    var clearSearchBtn = document.getElementById('clearSearchBtn');
    if (clearSearchBtn) clearSearchBtn.style.display = 'none';

    applyFilters();
  };

  window.openSpeakerModal = function (card) {
    if (!card) return;
    var modal = document.getElementById('speakerModal');
    if (!modal) return;

    var name = card.getAttribute('data-name') || (card.querySelector('.speaker-name') ? card.querySelector('.speaker-name').textContent : '');
    var role = card.getAttribute('data-role') || (card.querySelector('.speaker-title') ? card.querySelector('.speaker-title').textContent : '');
    var org = card.getAttribute('data-org') || (card.querySelector('.speaker-org span') ? card.querySelector('.speaker-org span').textContent : '');
    var lecture = card.getAttribute('data-lecture') || (card.querySelector('.speaker-lecture-title') ? card.querySelector('.speaker-lecture-title').textContent : '');
    var initials = card.getAttribute('data-initials') || 'SP';
    var flag = card.getAttribute('data-flag') || '🇸🇦';
    var photo = card.getAttribute('data-photo') || '';
    var cv = card.getAttribute('data-cv') || '';

    // Normalize paths to absolute root so they work from any route
    if (photo && !photo.startsWith('/') && !photo.startsWith('http')) {
      photo = '/' + photo;
    }
    if (cv && !cv.startsWith('/') && !cv.startsWith('http')) {
      cv = '/' + cv;
    }

    // Populate modal elements: Photo, Name, Job Title, Organisation, Lecture, and CV PDF button
    var nameEl = document.getElementById('modalSpeakerName');
    if (nameEl) nameEl.textContent = name;

    var roleEl = document.getElementById('modalSpeakerRole');
    if (roleEl) {
      roleEl.textContent = role;
      roleEl.style.display = role ? 'block' : 'none';
    }

    var orgEl = document.getElementById('modalSpeakerOrg');
    if (orgEl) {
      var orgSpan = orgEl.querySelector('span');
      if (orgSpan) orgSpan.textContent = org;
      else orgEl.textContent = org;
      orgEl.style.display = org ? 'block' : 'none';
    }

    var lectureEl = document.getElementById('modalLectureTitle');
    var lectureWrap = document.getElementById('modalLectureWrapper');
    if (lectureEl) lectureEl.textContent = lecture;
    if (lectureWrap) {
      lectureWrap.style.display = lecture ? 'block' : 'none';
    }

    var initialsEl = document.getElementById('modalSpeakerInitials');
    if (initialsEl) initialsEl.textContent = initials;

    var flagEl = document.getElementById('modalSpeakerFlag');
    if (flagEl) flagEl.textContent = flag;

    // Speaker Photo
    var photoEl = document.getElementById('modalSpeakerPhoto');
    if (photoEl) {
      if (photo) {
        photoEl.src = photo;
        photoEl.style.display = 'block';
        if (initialsEl) initialsEl.style.display = 'none';
      } else {
        photoEl.src = '';
        photoEl.style.display = 'none';
        if (initialsEl) initialsEl.style.display = 'flex';
      }
    }

    // Speaker CV PDF Button (View in new tab)
    var cvBtn = document.getElementById('modalCvBtn');
    var noCvMsg = document.getElementById('modalNoCvMsg');
    if (cvBtn) {
      if (cv) {
        cvBtn.href = cv;
        cvBtn.target = '_blank';
        cvBtn.rel = 'noopener noreferrer';
        cvBtn.removeAttribute('download');
        cvBtn.style.display = 'inline-flex';
        if (noCvMsg) noCvMsg.style.display = 'none';
      } else {
        cvBtn.style.display = 'none';
        if (noCvMsg) noCvMsg.style.display = 'block';
      }
    }

    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
  };

  window.closeSpeakerModal = function () {
    var modal = document.getElementById('speakerModal');
    if (modal) {
      modal.classList.remove('active');
      document.body.style.overflow = '';
    }
  };

  // Initialize once DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSpeakers);
  } else {
    initSpeakers();
  }
})();
