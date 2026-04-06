#!/usr/bin/env python3
"""Auditoría completa del archivo app_pt.arb"""
import json, re, sys, os

sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
L10N_DIR = os.path.join(BASE_DIR, 'lib', 'l10n')

es = json.load(open(os.path.join(L10N_DIR, 'app_es.arb'), 'r', encoding='utf-8'))
en = json.load(open(os.path.join(L10N_DIR, 'app_en.arb'), 'r', encoding='utf-8'))
pt = json.load(open(os.path.join(L10N_DIR, 'app_pt.arb'), 'r', encoding='utf-8'))

es_keys = set(k for k in es if not k.startswith('@') and k != '@@locale')
en_keys = set(k for k in en if not k.startswith('@') and k != '@@locale')
pt_keys = set(k for k in pt if not k.startswith('@') and k != '@@locale')

issues = 0

# 1. Key count
print('=== 1. KEY COUNT ===')
print(f'  ES keys: {len(es_keys)}')
print(f'  EN keys: {len(en_keys)}')
print(f'  PT keys: {len(pt_keys)}')
missing_in_pt = es_keys - pt_keys
extra_in_pt = pt_keys - es_keys
if missing_in_pt:
    issues += len(missing_in_pt)
    print(f'  [FAIL] Missing in PT: {len(missing_in_pt)}')
    for k in sorted(missing_in_pt)[:20]:
        print(f'    - {k}')
else:
    print('  [OK] All ES keys present in PT')
if extra_in_pt:
    print(f'  [WARN] Extra in PT: {len(extra_in_pt)}')
    for k in sorted(extra_in_pt)[:10]:
        print(f'    - {k}')

# 2. Metadata (@key) check
print()
print('=== 2. METADATA (@key) CHECK ===')
es_meta = set(k for k in es if k.startswith('@') and k != '@@locale')
pt_meta = set(k for k in pt if k.startswith('@') and k != '@@locale')
missing_meta = es_meta - pt_meta
extra_meta = pt_meta - es_meta
if missing_meta:
    issues += len(missing_meta)
    print(f'  [FAIL] Missing @keys in PT: {len(missing_meta)}')
    for k in sorted(missing_meta)[:10]:
        print(f'    - {k}')
else:
    print(f'  [OK] All {len(es_meta)} @keys present in PT')
if extra_meta:
    print(f'  [WARN] Extra @keys in PT: {len(extra_meta)}')

# 3. Placeholder consistency
print()
print('=== 3. PLACEHOLDER CONSISTENCY ===')
ph_errors = []
for key in sorted(es_keys):
    es_val = str(es.get(key, ''))
    pt_val = str(pt.get(key, ''))
    es_ph = sorted(re.findall(r'\{(\w+)\}', es_val))
    pt_ph = sorted(re.findall(r'\{(\w+)\}', pt_val))
    if es_ph != pt_ph:
        ph_errors.append((key, es_ph, pt_ph, es_val[:80], pt_val[:80]))
if ph_errors:
    issues += len(ph_errors)
    print(f'  [FAIL] Placeholder mismatches: {len(ph_errors)}')
    for k, e, p, ev, pv in ph_errors:
        print(f'    {k}:')
        print(f'      ES placeholders: {e}')
        print(f'      PT placeholders: {p}')
        print(f'      ES value: {ev}')
        print(f'      PT value: {pv}')
else:
    print('  [OK] All placeholders match')

# 4. ICU messages (select/plural)
print()
print('=== 4. ICU MESSAGE CHECK ===')
icu_errors = []
for key in sorted(pt_keys):
    val = str(pt[key])
    es_val = str(es.get(key, ''))
    # Check for translated ICU keywords
    if re.search(r'\{\w+,\s*(selecionar|seleccionar|otro|outros)\b', val):
        icu_errors.append((key, 'Translated ICU keyword', val[:120]))
    # Check select/plural messages preserved
    if ', select,' in es_val and ', select,' not in val:
        icu_errors.append((key, 'Missing select keyword', val[:120]))
    if ', plural,' in es_val and ', plural,' not in val:
        icu_errors.append((key, 'Missing plural keyword', val[:120]))
    # Check 'other' clause preserved in ICU
    if 'other{' in es_val and 'other{' not in val and ('outro{' in val or 'outros{' in val):
        icu_errors.append((key, 'Translated other clause', val[:120]))
if icu_errors:
    issues += len(icu_errors)
    print(f'  [FAIL] ICU issues: {len(icu_errors)}')
    for k, reason, v in icu_errors:
        print(f'    {k}: [{reason}] {v}')
else:
    print('  [OK] All ICU messages intact')

# 5. Empty values
print()
print('=== 5. EMPTY VALUES ===')
empty = [k for k in sorted(pt_keys) if not str(pt[k]).strip()]
if empty:
    issues += len(empty)
    print(f'  [FAIL] Empty values: {len(empty)}')
    for k in empty[:20]:
        print(f'    - {k}')
else:
    print('  [OK] No empty values')

# 6. @@locale
print()
print('=== 6. LOCALE TAG ===')
locale = pt.get('@@locale', 'MISSING')
if locale == 'pt':
    print('  [OK] @@locale = pt')
else:
    issues += 1
    print(f'  [FAIL] @@locale = {locale}')

# 7. Spanish text remaining in PT
print()
print('=== 7. SPANISH TEXT REMAINING ===')
spanish_patterns = [
    (r'\blos\s', 'los'),
    (r'\blas\s', 'las'),
    (r'\bpara\s', 'para'),  # skip - same in PT
    (r'ción\b', 'cion ending'),
    (r'\bpuede\b', 'puede'),
    (r'\btiene\b', 'tiene'),
    (r'\bestá\b', 'esta (ES)'),
    (r'\bhay\b', 'hay'),
    (r'\bdebe\b', 'debe'),  # skip - could be PT too
    (r'\bhasta\b', 'hasta'),
    (r'\bmientras\b', 'mientras'),
    (r'\btambién\b', 'tambien'),
    (r'\bningún\b', 'ningun'),
    (r'\bninguna\b', 'ninguna'),
    (r'\btodavía\b', 'todavia'),
    (r'\bmuy\b', 'muy'),
    (r'\bsiempre\b', 'siempre'),
    (r'\bnunca\b', 'nunca'),  # skip - same
    (r'\bdesde\b', 'desde'),  # skip - same in PT
    (r'\bahora\b', 'ahora'),
    (r'\baquí\b', 'aqui (ES)'),
    (r'\bdónde\b', 'donde'),
    (r'\bcuándo\b', 'cuando'),
    (r'\bcómo\b', 'como (ES)'),
    (r'¿', 'inverted question mark'),
    (r'¡', 'inverted exclamation'),
    (r'\bdel\b', 'del'),
    (r'\bal\b', 'al'),
]

# Strong Spanish indicators (not shared with Portuguese)
strong_spanish = [
    (r'¿', 'inverted question mark'),
    (r'¡', 'inverted exclamation'),
    (r'\bmientras\b', 'mientras'),
    (r'\btambién\b', 'tambien'),
    (r'\btodavía\b', 'todavia'),
    (r'\bahora\b', 'ahora'),
    (r'\bsiempre\b', 'siempre'),
    (r'\bhasta\b', 'hasta'),
    (r'\bmuy\b', 'muy'),
    (r'\bningún\b', 'ningun'),
    (r'\bninguna\b', 'ninguna'),
    (r'\bdónde\b', 'donde'),
    (r'\bcómo\b', 'como'),
    (r'\bcuándo\b', 'cuando'),
    (r'\bdeshacer\b', 'deshacer'),
    (r'\bcerrar\b', 'cerrar'),
    (r'\babrir\b', 'abrir'),  # same in PT
    (r'\bguardar\b', 'guardar'),
    (r'\bbuscar\b', 'buscar'),  # same in PT
    (r'\bañadir\b', 'anadir'),
    (r'\bcambiar\b', 'cambiar'),
    (r'\bborrar\b', 'borrar'),
    (r'\benviar\b', 'enviar'),  # same in PT
    (r'\brecibir\b', 'recibir'),
    (r'\bvolver\b', 'volver'),
    (r'\bsiguiente\b', 'siguiente'),
    (r'\banterior\b', 'anterior'),  # same in PT
    (r'\bnecesita\b', 'necesita'),
    (r'\bpermitir\b', 'permitir'),  # same in PT
    (r'\bmostrar\b', 'mostrar'),  # same in PT
    (r'\bocultar\b', 'ocultar'),
    (r'\bcomenzar\b', 'comenzar'),
    (r'\bterminar\b', 'terminar'),  # same in PT
    (r'\bseleccionar\b', 'seleccionar'),
    (r'\bescribir\b', 'escribir'),
    (r'\bleer\b', 'leer'),
    (r'\bninguno\b', 'ninguno'),
    (r'\bpuedes\b', 'puedes'),
    (r'\btienes\b', 'tienes'),
    (r'\bhaciendo\b', 'haciendo'),
    (r'\bcerrando\b', 'cerrando'),
    (r'\bcargando\b', 'cargando'),
    (r'miento\b', '-miento ending'),
]

spanish_found = {}
for key in sorted(pt_keys):
    pt_val = str(pt[key])
    es_val = str(es.get(key, ''))
    # Skip if identical to ES (already counted)
    if pt_val == es_val:
        continue
    for pattern, label in strong_spanish:
        if re.search(pattern, pt_val, re.IGNORECASE):
            # Verify it's not in the ES original context that's supposed to stay
            if key not in spanish_found:
                spanish_found[key] = []
            spanish_found[key].append((label, pt_val[:80]))
            break

if spanish_found:
    print(f'  [WARN] {len(spanish_found)} keys may still contain Spanish text:')
    for k in list(spanish_found.keys())[:40]:
        items = spanish_found[k]
        label, val = items[0]
        print(f'    {k} [{label}]: {val}')
else:
    print('  [OK] No strong Spanish indicators found in translated text')

# 8. Statistics summary
print()
print('=== 8. TRANSLATION STATS ===')
identical = sum(1 for k in pt_keys if pt.get(k) == es.get(k))
translated = len(pt_keys) - identical
print(f'  Total keys: {len(pt_keys)}')
print(f'  Translated (different from ES): {translated}')
print(f'  Identical to ES: {identical}')
print(f'  Translation coverage: {translated/len(pt_keys)*100:.1f}%')

# 9. JSON validity
print()
print('=== 9. JSON VALIDITY ===')
try:
    json.loads(open(os.path.join(L10N_DIR, 'app_pt.arb'), 'r', encoding='utf-8').read())
    print('  [OK] Valid JSON')
except json.JSONDecodeError as e:
    issues += 1
    print(f'  [FAIL] Invalid JSON: {e}')

print()
print('=' * 50)
print(f'TOTAL ISSUES: {issues}')
if issues == 0:
    print('ALL CHECKS PASSED!')
else:
    print(f'{issues} issue(s) need attention')
