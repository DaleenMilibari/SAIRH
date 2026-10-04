/**
 * SAIRH 2026 - Interactive Speakers & Filters Engine
 * Handles real-time search, track filtering, and responsive modal display.
 */

(function () {
  'use strict';

  var currentTrack = 'all';
  var currentSearch = '';

  function initSpeakers() {
    var trackButtons = document.querySelectorAll('.track-tab-btn');
    var searchInput = document.getElementById('speakerSearch');
    var clearSearchBtn = document.getElementById('clearSearchBtn');
    var resetFiltersBtn = document.getElementById('btnResetFilters');

    // Search input (first filter)
    if (searchInput) {
      searchInput.addEventListener('input', function () {
        currentSearch = this.value.trim().toLowerCase();
        if (clearSearchBtn) {
          clearSearchBtn.style.display = currentSearch.length > 0 ? 'block' : 'none';
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
    } catch (err) {}

    applyFilters();
  }

  function applyFilters() {
    var cards = document.querySelectorAll('.speaker-card');
    var visibleCount = 0;
    var emptyState = document.getElementById('speakersEmptyState');
    var countEl = document.getElementById('speakersCount');
    var resetBtn = document.getElementById('btnResetFilters');

    cards.forEach(function (card) {
      var cardTrack = card.getAttribute('data-track') || '';

      var cardText = (
        (card.getAttribute('data-name') || '') + ' ' +
        (card.getAttribute('data-role') || '') + ' ' +
        (card.getAttribute('data-org') || '') + ' ' +
        (card.getAttribute('data-lecture') || '') + ' ' +
        card.textContent
      ).toLowerCase();

      var matchTrack = (currentTrack === 'all' || cardTrack === currentTrack);
      var matchSearch = (!currentSearch || cardText.indexOf(currentSearch) !== -1);

      if (matchTrack && matchSearch) {
        card.style.display = '';
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
    var isFiltered = (currentTrack !== 'all' || currentSearch.length > 0);
    if (resetBtn) {
      resetBtn.style.display = isFiltered ? 'inline-flex' : 'none';
    }
  }

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

    var name = card.getAttribute('data-name') || card.querySelector('.speaker-name').textContent;
    var role = card.getAttribute('data-role') || card.querySelector('.speaker-title').textContent;
    var org = card.getAttribute('data-org') || card.querySelector('.speaker-org span').textContent;
    var lecture = card.getAttribute('data-lecture') || card.querySelector('.speaker-lecture-title').textContent;
    var track = card.getAttribute('data-track-name') || 'Summit Track';
    var trackId = card.getAttribute('data-track') || 'track-a';
    var initials = card.getAttribute('data-initials') || 'SP';
    var flag = card.getAttribute('data-flag') || '🇸🇦';
    var regionName = card.getAttribute('data-region-name') || 'Saudi Arabia';
    var photo = card.getAttribute('data-photo') || '';
    var cv = card.getAttribute('data-cv') || '';

    // Normalize paths to absolute root so they work from any route
    if (photo && !photo.startsWith('/') && !photo.startsWith('http')) {
      photo = '/' + photo;
    }
    if (cv && !cv.startsWith('/') && !cv.startsWith('http')) {
      cv = '/' + cv;
    }

    // Populate modal elements
    document.getElementById('modalSpeakerName').textContent = name;
    document.getElementById('modalSpeakerRole').textContent = role;
    document.getElementById('modalSpeakerOrg').textContent = org;
    document.getElementById('modalLectureTitle').textContent = lecture;
    document.getElementById('modalSpeakerInitials').textContent = initials;
    document.getElementById('modalSpeakerFlag').textContent = flag;

    var metaRegion = document.getElementById('modalMetaRegion');
    if (metaRegion) metaRegion.textContent = regionName;

    // Speaker Photo
    var photoEl = document.getElementById('modalSpeakerPhoto');
    var initialsEl = document.getElementById('modalSpeakerInitials');
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
    if (cvBtn) {
      if (cv) {
        cvBtn.href = cv;
        cvBtn.target = '_blank';
        cvBtn.rel = 'noopener noreferrer';
        cvBtn.removeAttribute('download');
        cvBtn.style.display = 'inline-flex';
      } else {
        cvBtn.style.display = 'none';
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
