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

// Project card click — navigate to data-href unless clicking a link inside
document.querySelectorAll('.project-card[data-href]').forEach(card => {
  card.addEventListener('click', e => {
    if (e.target.closest('a')) return;
    window.open(card.dataset.href, '_blank', 'noopener,noreferrer');
  });
});
