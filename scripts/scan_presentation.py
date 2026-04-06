import os
import re

base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\features'
results = []
pattern = re.compile(r"'[A-ZÁÉÍÓÚÑ¿¡][a-záéíóúñ ]{3,}'")

for feature in os.listdir(base):
    pres_dir = os.path.join(base, feature, 'presentation')
    if not os.path.isdir(pres_dir):
        continue
    for root, dirs, files in os.walk(pres_dir):
        for f in files:
            if not f.endswith('.dart'):
                continue
            full = os.path.join(root, f)
            with open(full, 'r', encoding='utf-8', errors='replace') as fh:
                content = fh.read()
            has_s_of = 'S.of(' in content
            spanish = pattern.findall(content)
            if spanish and not has_s_of:
                rel = os.path.relpath(full, base)
                results.append((rel, feature, len(spanish)))

results.sort(key=lambda x: -x[2])
print(f'Found {len(results)} files with potential hardcoded Spanish (no S.of):')
for r in results[:50]:
    print(f'  {r[2]:4d}  {r[0]}')

# Also check files that DO have S.of but also have remaining hardcoded strings
print('\n--- Files WITH S.of but still hardcoded strings ---')
results2 = []
for feature in os.listdir(base):
    pres_dir = os.path.join(base, feature, 'presentation')
    if not os.path.isdir(pres_dir):
        continue
    for root, dirs, files in os.walk(pres_dir):
        for f in files:
            if not f.endswith('.dart'):
                continue
            full = os.path.join(root, f)
            with open(full, 'r', encoding='utf-8', errors='replace') as fh:
                content = fh.read()
            has_s_of = 'S.of(' in content
            spanish = pattern.findall(content)
            # Exclude common false positives
            false_pos = [s for s in spanish if s.strip("'") not in (
                'AppColors', 'Icons', 'TextStyle', 'EdgeInsets', 'BorderRadius',
                'SizedBox', 'Container', 'Scaffold', 'Column', 'Row', 'Text',
                'Padding', 'Center', 'Stack', 'Wrap', 'ListView', 'GridView',
            )]
            if has_s_of and len(false_pos) > 2:
                rel = os.path.relpath(full, base)
                results2.append((rel, feature, len(false_pos)))

results2.sort(key=lambda x: -x[2])
for r in results2[:30]:
    print(f'  {r[2]:4d}  {r[0]}')
