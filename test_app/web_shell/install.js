(() => {
  let pendingPrompt = null;
  const standalone = window.matchMedia('(display-mode: standalone)');
  const isInstalled = () => standalone.matches || navigator.standalone === true;
  function update() { document.body.classList.toggle('installed', isInstalled()); }
  window.addEventListener('beforeinstallprompt', event => {
    event.preventDefault(); pendingPrompt = event;
    document.querySelector('#install-button').textContent = 'Install app';
  });
  window.addEventListener('appinstalled', () => { pendingPrompt = null; document.body.classList.add('installed'); });
  standalone.addEventListener?.('change', update);
  document.querySelector('#install-button').addEventListener('click', async () => {
    if (pendingPrompt) {
      const prompt = pendingPrompt; pendingPrompt = null;
      try { await prompt.prompt(); await prompt.userChoice; return; } catch (_) {}
    }
    const ua = navigator.userAgent;
    let instructions;
    if (/FBAN|FBAV|Instagram|WhatsApp/i.test(ua)) {
      instructions = 'Open this link in Safari on iPhone, or Chrome on Android, using this browser’s menu. Then use Share → Add to Home Screen on iPhone, or Install app / Add to Home screen on Android.';
    } else if (/iPhone|iPad|iPod/.test(ua) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)) {
      instructions = 'In Safari, tap Share, then Add to Home Screen. If shown, leave Open as Web App switched on, then tap Add.';
    } else if (/Android/.test(ua)) {
      instructions = 'In Chrome, open the three-dot menu and choose Install app or Add to Home screen. In Samsung Internet, use its menu to add this page to your Home screen.';
    } else if (/Safari/.test(ua) && !/Chrome|Chromium|Edg/.test(ua)) {
      instructions = 'On a Mac with Safari 17 or later, choose File → Add to Dock. You can also open this link in Chrome or Edge and choose the install icon beside the address bar.';
    } else {
      instructions = 'In Chrome or Edge, look for the install icon beside the address bar, or open the browser menu and look for Install page as app / Apps → Install this site as an app. If your browser does not offer installation, open this link in Chrome or Edge.';
    }
    document.querySelector('#install-instructions').textContent = instructions;
    document.querySelector('#install-help').showModal();
  });
  document.querySelector('#close-install').addEventListener('click', () => document.querySelector('#install-help').close());
  update();
  // Retire old Flutter caches; current content and releases are loaded online.
  if ('serviceWorker' in navigator) navigator.serviceWorker.getRegistrations().then(registrations => {
    registrations.filter(r => /flutter_service_worker\.js/.test(r.active?.scriptURL || r.waiting?.scriptURL || '')).forEach(r => r.unregister());
  }).catch(() => {});
})();
