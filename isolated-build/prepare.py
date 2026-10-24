from pathlib import Path
import base64,hashlib,json,shutil,tarfile
root=Path('.')
meta=json.loads(Path('isolated-build/archive.json').read_text())
manifest=json.loads(Path('isolated-build/files.json').read_text())
for name,sha in manifest.items():
 p=Path('isolated-source')/name
 assert hashlib.sha256(p.read_bytes()).hexdigest()==sha,name
src=Path('isolated-source/app');dst=Path('generated_web')
for p in src.glob('*.dart'):shutil.copy2(p,dst/'lib'/p.name)
for name in ['pubspec.yaml','pubspec.lock']:shutil.copy2(src/name,dst/name)
shutil.rmtree(dst/'test');shutil.copytree(src/'test',dst/'test')
# Build-only neutral placeholders: no existing photographs are published to GitHub.
# The release packager preserves every original live image locally.
assets=json.loads(Path('isolated-build/public-assets.json').read_text())
pixel=base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jK1sAAAAASUVORK5CYII=')
for item in assets:
 p=dst/'assets'/item['path'];p.parent.mkdir(parents=True,exist_ok=True)
 p.write_bytes(b'{}' if p.suffix=='.json' else pixel)
# A separate preview entrypoint uses the same theme/dashboard with dummy data.
s=(dst/'lib/main.dart').read_text()
s=s.replace("import 'dart:convert';", "import 'dart:convert';\nimport 'package:http/http.dart' as preview_http;\nimport 'package:http/testing.dart';")
s=s.replace("url: supabaseUrl,", "url: 'https://example.supabase.co',")
s=s.replace("publishableKey: supabaseKey,", "publishableKey: 'test-only',\n      httpClient: MockClient((request) async => preview_http.Response('[]', request.method == 'GET' ? 200 : 403, headers: {'content-type':'application/json'})),")
s=s.replace('FlutterAuthClientOptions(autoRefreshToken: true)', 'FlutterAuthClientOptions(autoRefreshToken: false, detectSessionInUri: false)')
home="home: Shell(name: name ?? 'Christmas Lover', theme: theme, onThemeChanged: (t) => setState(() => theme = t)),"
assert home in s
s=s.replace(home,'home: const AdminPreviewEntry(),')
s+='''\nclass AdminPreviewEntry extends StatelessWidget {
 const AdminPreviewEntry({super.key});
 @override Widget build(BuildContext context) => Scaffold(body: Center(child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())), child: const Text('Preview Admin header'))));
}\n'''
(dst/'lib/admin_preview.dart').write_text(s)
print('Verified exact staged source archive:',meta['source_files'],'files; original live source baseline',meta['baseline_source'])
