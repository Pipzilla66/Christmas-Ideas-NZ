(() => {
  const bootstrap = document.currentScript.dataset.bootstrap;
  async function start() {
    // Only retire Flutter's old release caches. Account storage is untouched.
    try {
      if ('serviceWorker' in navigator) {
        const registrations = await navigator.serviceWorker.getRegistrations();
        await Promise.all(registrations.filter(r =>
          [r.active, r.waiting, r.installing].some(w => w && /\/flutter_service_worker\.js(?:\?|$)/.test(w.scriptURL))
        ).map(r => r.unregister()));
      }
      if ('caches' in window) {
        const names = await caches.keys();
        await Promise.all(names.filter(n => ['flutter-app-cache', 'flutter-temp-cache', 'flutter-app-manifest'].includes(n)).map(n => caches.delete(n)));
      }
    } catch (error) { console.warn('Could not retire a previous app cache', error); }
    const script = document.createElement('script');
    script.src = bootstrap;
    script.onerror = () => {
      const loading = document.querySelector('#loading');
      if (loading) loading.textContent = 'Could not load the latest app. Please refresh to try again.';
    };
    document.head.appendChild(script);
  }
  start();
})();
