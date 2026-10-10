(() => {
  const measurementId = 'G-SCRK4947CY';
  const key = 'christmas-analytics-consent';
  let consent = null;
  try { consent = localStorage.getItem(key); } catch (_) {}
  window.christmasUsageAllowed = () => consent === 'yes' && document.visibilityState === 'visible';
  let started = false;
  let currentScreen = 'Home';
  let previousLocation = '';
  const allowed = new Set(['page_view', 'section_view', 'view_item', 'gift_click']);
  const fields = new Set(['screen_name', 'section_name', 'item_id', 'item_name', 'retailer_host']);
  const cleanLocation = () => location.origin + location.pathname;
  const cleanReferrer = () => {
    try { const url = new URL(document.referrer); return url.origin + url.pathname; } catch (_) { return ''; }
  };
  window.dataLayer = window.dataLayer || [];
  window.gtag = function () { window.dataLayer.push(arguments); };
  function send(event, parameters) {
    if (consent !== 'yes' || !started) return;
    const safe = {};
    for (const [field, value] of Object.entries(parameters)) {
      if (fields.has(field) && typeof value === 'string') safe[field] = value.slice(0, 100);
    }
    // Authentication tokens, searches, email addresses and affiliate URLs are excluded.
    safe.page_location = cleanLocation();
    safe.page_referrer = cleanReferrer();
    if (event === 'page_view') {
      safe.page_location += '#/' + encodeURIComponent(currentScreen);
      safe.page_title = currentScreen + ' | Christmas Ideas NZ';
      safe.page_referrer = previousLocation || cleanReferrer();
      previousLocation = safe.page_location;
    }
    window.gtag('event', event, safe);
  }
  window.christmasAnalytics = (event, raw) => {
    if (!allowed.has(event)) return;
    let parameters;
    try { parameters = JSON.parse(raw); } catch (_) { return; }
    if (!parameters || typeof parameters !== 'object') return;
    if (event === 'page_view') currentScreen = parameters.screen_name || 'Home';
    send(event, parameters);
  };
  function start() {
    if (started || consent !== 'yes') return;
    started = true;
    window.gtag('js', new Date());
    window.gtag('config', measurementId, {
      send_page_view: false, allow_google_signals: false,
      allow_ad_personalization_signals: false,
      page_location: cleanLocation(), page_referrer: cleanReferrer()
    });
    const script = document.createElement('script');
    script.async = true;
    script.src = 'https://www.googletagmanager.com/gtag/js?id=' + measurementId;
    document.head.appendChild(script);
    send('page_view', {screen_name: currentScreen});
  }
  function choose(value) {
    consent = value;
    try { localStorage.setItem(key, value); } catch (_) {}
    document.getElementById('analytics-choice').hidden = true;
    if (value === 'yes') start();
    else if (started) {
      window['ga-disable-' + measurementId] = true;
      document.cookie.split(';').forEach(cookie => {
        const name = cookie.trim().split('=')[0];
        if (!name.startsWith('_ga')) return;
        const domains = [location.hostname, '.' + location.hostname];
        for (let i = 1; i < location.hostname.split('.').length - 1; i++) domains.push('.' + location.hostname.split('.').slice(i).join('.'));
        document.cookie = name + '=; Max-Age=0; Path=/';
        for (const domain of domains) document.cookie = name + '=; Max-Age=0; Path=/; Domain=' + domain;
      });
    }
    if (value === 'yes') window['ga-disable-' + measurementId] = false;
  }
  document.addEventListener('DOMContentLoaded', () => {
    const panel = document.getElementById('analytics-choice');
    panel.hidden = consent === 'yes' || consent === 'no';
    document.getElementById('allow-analytics').addEventListener('click', () => choose('yes'));
    document.getElementById('decline-analytics').addEventListener('click', () => choose('no'));
    document.getElementById('analytics-settings').addEventListener('click', () => { panel.hidden = false; });
    start();
  });
})();
