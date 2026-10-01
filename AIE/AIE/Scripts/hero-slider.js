/**
 * SAIRH - Summit Hero Carousel & Countdown System
 * Handles the 3-slide unified hero carousel with autoplay,
 * interaction-aware pausing, and live countdown to 13 December 2026 09:00 AM AST.
 */
(function ($) {
    'use strict';

    // Target Date: 13 December 2026 09:00:00 AST (UTC+3 => 06:00:00 UTC)
    var SUMMIT_TARGET_UTC = Date.UTC(2026, 11, 13, 6, 0, 0);
    var AUTOPLAY_INTERVAL = 6000; // 6 seconds per slide
    var autoplayTimer = null;
    var isInteracting = false;

    function padZero(num, length) {
        length = length || 2;
        var s = String(num);
        while (s.length < length) {
            s = '0' + s;
        }
        return s;
    }

    function initCountdown() {
        var $days = $('.hero-countdown-days');
        var $hours = $('.hero-countdown-hours');
        var $minutes = $('.hero-countdown-minutes');
        var $seconds = $('.hero-countdown-seconds');

        if (!$days.length) {
            return;
        }

        function updateTimer() {
            var now = new Date().getTime();
            var distance = SUMMIT_TARGET_UTC - now;

            if (distance <= 0) {
                $days.text('00');
                $hours.text('00');
                $minutes.text('00');
                $seconds.text('00');
                return;
            }

            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);

            $days.text(padZero(days, 2));
            $hours.text(padZero(hours, 2));
            $minutes.text(padZero(minutes, 2));
            $seconds.text(padZero(seconds, 2));
        }

        updateTimer();
        setInterval(updateTimer, 1000);
    }

    function initHeroCarousel() {
        var $carousel = $('#heroSummitCarousel');
        var $section = $('.landing-hero-section');
        if (!$carousel.length) {
            return;
        }

        // Initialize Bootstrap Carousel without native timer to give full control to our robust controller
        $carousel.carousel({
            interval: false,
            wrap: true,
            touch: true
        });

        function startAutoplay() {
            stopAutoplay();
            if (!isInteracting) {
                autoplayTimer = setInterval(function () {
                    if (!isInteracting) {
                        var isRtl = $('html').attr('dir') === 'rtl';
                        $carousel.carousel(isRtl ? 'prev' : 'next');
                    }
                }, AUTOPLAY_INTERVAL);
            }
        }

        function stopAutoplay() {
            if (autoplayTimer) {
                clearInterval(autoplayTimer);
                autoplayTimer = null;
            }
        }

        // Launch autoplay on page load
        startAutoplay();

        // Pause when interacting with hero section (mouse hover or keyboard focus)
        $section.on('mouseenter focusin', function () {
            isInteracting = true;
            stopAutoplay();
        });

        // Resume when user interaction ends
        $section.on('mouseleave focusout', function () {
            isInteracting = false;
            startAutoplay();
        });

        // Touch handling on mobile/tablet devices
        var touchTimeout = null;
        $section.on('touchstart', function () {
            isInteracting = true;
            stopAutoplay();
            if (touchTimeout) {
                clearTimeout(touchTimeout);
            }
        });

        $section.on('touchend', function () {
            // Give the user 4 seconds of reading time after touch before resuming
            touchTimeout = setTimeout(function () {
                isInteracting = false;
                startAutoplay();
            }, 4000);
        });

        // Synchronize bottom liquid-glass indicators on slide change
        $carousel.on('slide.bs.carousel', function (e) {
            var toIndex = e.to;
            $('.hero-indicator-dot').removeClass('active');
            $('.hero-indicator-dot[data-slide-to="' + toIndex + '"]').addClass('active');
        });

        // Bottom indicator click navigation
        $('.hero-indicator-dot').on('click', function (e) {
            e.preventDefault();
            var slideIndex = parseInt($(this).attr('data-slide-to'), 10);
            if (!isNaN(slideIndex)) {
                $carousel.carousel(slideIndex);
                if (!isInteracting) {
                    startAutoplay();
                }
            }
        });

        // Extreme Left & Right Arrow Navigation
        $('.hero-arrow-left').on('click', function (e) {
            e.preventDefault();
            var isRtl = $('html').attr('dir') === 'rtl';
            $carousel.carousel(isRtl ? 'next' : 'prev');
            if (!isInteracting) {
                startAutoplay();
            }
        });

        $('.hero-arrow-right').on('click', function (e) {
            e.preventDefault();
            var isRtl = $('html').attr('dir') === 'rtl';
            $carousel.carousel(isRtl ? 'prev' : 'next');
            if (!isInteracting) {
                startAutoplay();
            }
        });
    }

    $(document).ready(function () {
        initCountdown();
        initHeroCarousel();
    });

})(jQuery);
