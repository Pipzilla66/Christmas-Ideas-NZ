from pathlib import Path
import tarfile,base64,hashlib,io
items=[]
for prefix,folder in [('production',Path('production-build')),('preview',Path('generated_web/build/web'))]:
 for name in ['main.dart.js','flutter_bootstrap.js','assets/fonts/MaterialIcons-Regular.otf','assets/AssetManifest.bin','assets/FontManifest.json']:
  p=folder/name
  if p.exists():items.append((prefix+'/'+name,p))
for name in ['tests.log','baseline-tests.log','analysis.log','build.log','preview-build.log']:
 p=Path(name)
 if p.exists():items.append(('checks/'+name,p))
out=io.BytesIO()
with tarfile.open(fileobj=out,mode='w:gz') as t:
 for name,p in items:t.add(p,arcname=name,recursive=False)
b=out.getvalue();encoded=base64.b64encode(b).decode()
print('CINZ_BUILD_EXPORT_SHA256='+hashlib.sha256(b).hexdigest())
print('CINZ_BUILD_EXPORT_BEGIN')
for i in range(0,len(encoded),4096):print(encoded[i:i+4096])
print('CINZ_BUILD_EXPORT_END')
