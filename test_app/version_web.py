"""Give each compiled release unique entrypoint URLs so old caches cannot win."""
import hashlib, pathlib, re, shutil, sys
root = pathlib.Path(sys.argv[1])
version = hashlib.sha256((root / 'main.dart.js').read_bytes()).hexdigest()[:16]
for pattern in ['main.*.dart.js', 'flutter_bootstrap.*.js', 'release-loader.*.js']:
    for old in root.glob(pattern):
        old.unlink()
main = f'main.{version}.dart.js'
bootstrap = f'flutter_bootstrap.{version}.js'
loader = f'release-loader.{version}.js'
shutil.copy2(root / 'main.dart.js', root / main)
text = (root / 'flutter_bootstrap.js').read_text()
text = re.sub(r'"mainJsPath":"[^"]+"', f'"mainJsPath":"{main}"', text)
(root / 'flutter_bootstrap.js').write_text(text)
(root / bootstrap).write_text(text)
shutil.copy2(pathlib.Path(__file__).parent / 'web_shell/release-loader.js', root / loader)
p = root / 'index.html'
text = p.read_text()
text = re.sub(r'<script src="(?:flutter_bootstrap\.js|release-loader\.[a-f0-9]+\.js)"[^>]*></script>',
              f'<script src="{loader}" data-bootstrap="{bootstrap}" defer></script>', text)
p.write_text(text)
(root / 'flutter_service_worker.js').write_text('''
self.addEventListener('install', event => event.waitUntil(self.skipWaiting()));
self.addEventListener('activate', event => event.waitUntil((async () => {
  const names = await caches.keys();
  await Promise.all(names.filter(n => ['flutter-app-cache', 'flutter-temp-cache', 'flutter-app-manifest'].includes(n)).map(n => caches.delete(n)));
  await self.clients.claim();
  await self.registration.unregister();
})()));
''')
print('Versioned release', version)
