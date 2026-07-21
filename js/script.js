// Smooth scroll for nav anchor links + close mobile menu
const navLinks = document.querySelector('.nav-links');
const toggle = document.querySelector('.nav-toggle');

navLinks.addEventListener('click', e => {
  const link = e.target.closest('a[href^="#"]');
  if (link) {
    e.preventDefault();
    const target = document.querySelector(link.getAttribute('href'));
    if (target) target.scrollIntoView({ behavior: 'smooth' });
  }
  navLinks.classList.remove('open');
  toggle.setAttribute('aria-expanded', 'false');
});

// Mobile nav toggle
toggle.addEventListener('click', () => {
  const open = navLinks.classList.toggle('open');
  toggle.setAttribute('aria-expanded', String(open));
});

// Project card click: navigate to data-href unless clicking a link inside.
// External links open a new tab; internal pages navigate in place.
document.querySelectorAll('.project-card[data-href]').forEach(card => {
  card.addEventListener('click', e => {
    if (e.target.closest('a')) return;
    const href = card.dataset.href;
    if (href.startsWith('http')) {
      window.open(href, '_blank', 'noopener,noreferrer');
    } else {
      window.location.href = href;
    }
  });
});

// Crate version badges (crates/index.html): fetch the current version from
// crates.io's public API for each [data-crate] span. crates.io requires a
// descriptive User-Agent on API requests, but that's a server-side curl/bot
// policy. Browsers refuse to let JS override the UA header, so a real
// browser's own UA sails through fine (verified: 200 + access-control-allow-origin: *).
// On any failure (offline, crates.io down, crate renamed) just leave the
// badge out rather than show a stale or broken "v...".
document.querySelectorAll('[data-crate]').forEach(async el => {
  const name = el.dataset.crate;
  try {
    const res = await fetch(`https://crates.io/api/v1/crates/${encodeURIComponent(name)}`);
    if (!res.ok) throw new Error(`${res.status}`);
    const data = await res.json();
    const version = data?.crate?.max_stable_version || data?.crate?.newest_version;
    if (version) el.textContent = `v${version}`;
    else el.remove();
  } catch {
    el.remove();
  }
});
