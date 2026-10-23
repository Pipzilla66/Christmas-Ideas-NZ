"""Reject accidental Flutter test branding in packaged releases."""
import json
import math
from PIL import Image
import pathlib
import subprocess
import sys
import tempfile
import unittest

APP = pathlib.Path(__file__).resolve().parents[1]

class WebBrandingTest(unittest.TestCase):
    def test_install_metadata_uses_new_centred_artwork(self):
        manifest = json.loads((APP / 'web_shell/manifest.json').read_text())
        self.assertEqual(manifest['display'], 'standalone')
        self.assertEqual(manifest['name'], 'Christmas Ideas NZ')
        for item in manifest['icons']:
            self.assertIn(item['purpose'], {'any', 'maskable'})
            self.assertIn('logo-v8', item['src'])
            with Image.open(APP / 'web_shell' / item['src']) as icon:
                self.assertEqual(item['sizes'], f'{icon.width}x{icon.height}')
        html = (APP / 'web_shell/index.html').read_text()
        self.assertIn('apple-touch-logo-v8.png', html)
        self.assertNotIn('apple-touch-protected-v3.png', html)

    def test_logo_and_icons_match_wallpaper_background(self):
        background = (247, 242, 232)
        files = [APP / 'assets/christmas_brand_logo_v3.webp',
                 APP / 'branding/christmas-ideas-nz-logo-square-v3.png']
        manifest = json.loads((APP / 'web_shell/manifest.json').read_text())
        files += [APP / 'web_shell' / item['src'] for item in manifest['icons']]
        files += [APP / 'web_shell/icons/apple-touch-logo-v8.png']
        for path in files:
            with Image.open(path) as image:
                pixels = image.convert('RGB')
                for x in range(image.width):
                    self.assertEqual(pixels.getpixel((x, 0)), background)
                    self.assertEqual(pixels.getpixel((x, image.height - 1)), background)
                for y in range(image.height):
                    self.assertEqual(pixels.getpixel((0, y)), background)
                    self.assertEqual(pixels.getpixel((image.width - 1, y)), background)
        self.assertIn('0xFFF7F2E8', (APP / 'brand_logo.dart').read_text())

    def test_release_replaces_generated_test_name_and_icons(self):
        with tempfile.TemporaryDirectory() as folder:
            root = pathlib.Path(folder)
            (root / 'main.dart.js').write_text('compiled app')
            (root / 'flutter_bootstrap.js').write_text('{"mainJsPath":"main.dart.js"}')
            (root / 'manifest.json').write_text('{"name":"christmas_ideas_nz_test"}')
            (root / 'icons').mkdir()
            (root / 'icons/Icon-192.png').write_bytes(b'wrong icon')
            (root / 'index.html').write_text('<title>christmas_ideas_nz_test</title><meta name="apple-mobile-web-app-title" content="christmas_ideas_nz_test"><link rel="manifest" href="manifest.json"><script src="flutter_bootstrap.js"></script>')
            subprocess.run([sys.executable, str(APP / 'version_web.py'), str(root)], check=True, capture_output=True)
            manifest = json.loads((root / 'manifest.json').read_text())
            self.assertEqual(manifest['name'], 'Christmas Ideas NZ')
            self.assertEqual(manifest['short_name'], 'Christmas Ideas NZ')
            self.assertEqual(manifest['start_url'], '.')
            html = (root / 'index.html').read_text()
            self.assertNotIn('christmas_ideas_nz_test', html)
            self.assertIn('href="manifest.json"', html)
            for icon in manifest['icons']:
                self.assertEqual((root / icon['src']).read_bytes(), (APP / 'web_shell' / icon['src']).read_bytes())
            self.assertEqual((root / 'favicon.png').read_bytes(), (APP / 'web_shell/favicon.png').read_bytes())
            self.assertIn('release-loader.', html)

if __name__ == '__main__':
    unittest.main()
