from pathlib import Path
import subprocess

path=Path('generated_web/lib/christmas_inspiration.dart')
fixed=path.read_text()
marker="key:PageStorageKey<String>('tradition-card:$title'),"
assert fixed.count(marker)==1
try:
    # Exercise the original v88 widget only in this isolated test directory.
    path.write_text(fixed.replace(marker,''))
    result=subprocess.run(['flutter','test','test/traditions_state_test.dart','--reporter','expanded'],cwd='generated_web',stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    Path('baseline-tests.log').write_text(result.stdout)
    assert result.returncode!=0,'Regression did not fail on original v88 widget'
    assert "double" in result.stdout and "bool" in result.stdout,result.stdout[-4000:]
    print('Original live widget reproduces double/bool saved-state failure. Fixed widget restored for full tests/build.')
finally:
    path.write_text(fixed)
