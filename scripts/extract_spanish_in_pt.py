#!/usr/bin/env python3
"""Extract keys with Spanish remnants in PT ARB for fixing."""
import json, re, sys
sys.stdout.reconfigure(encoding='utf-8')

BASE = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro'
pt = json.load(open(f'{BASE}/lib/l10n/app_pt.arb', 'r', encoding='utf-8'))
es = json.load(open(f'{BASE}/lib/l10n/app_es.arb', 'r', encoding='utf-8'))
en = json.load(open(f'{BASE}/lib/l10n/app_en.arb', 'r', encoding='utf-8'))

strong_spanish = [
    r'(?<!\w)[¿¡]',
    r'\bmientras\b', r'\btambién\b', r'\btodavía\b', r'\bahora\b',
    r'\bsiempre\b', r'\bhasta\b', r'\bmuy\b', r'\bningún\b', r'\bninguna\b',
    r'\bdónde\b', r'\bcómo\b', r'\bcuándo\b', r'\bdeshacer\b',
    r'\bcerrar\b', r'\bguardar\b', r'\bañadir\b', r'\bcambiar\b',
    r'\bborrar\b', r'\brecibir\b', r'\bvolver\b', r'\bsiguiente\b',
    r'\bnecesita\b', r'\bmostrar\b', r'\bocultar\b', r'\bcomenzar\b',
    r'\bseleccionar\b', r'\bescribir\b', r'\bninguno\b',
    r'\bpuedes\b', r'\btienes\b', r'\bhaciendo\b', r'\bcerrando\b',
    r'\bcargando\b', r'miento\b', r'\benviar\b', r'\bbuscar\b',
]

keys = []
for key in sorted(pt):
    if key.startswith('@') or key == '@@locale':
        continue
    pt_val = str(pt[key])
    es_val = str(es.get(key, ''))
    if pt_val == es_val:
        continue
    for pattern in strong_spanish:
        if re.search(pattern, pt_val, re.IGNORECASE):
            keys.append(key)
            break

for k in keys:
    ev = es[k]
    enval = en.get(k, '')
    print(f'KEY: {k}')
    print(f'  ES: {ev}')
    print(f'  EN: {enval}')
    print(f'  PT_CURRENT: {pt[k]}')
    print()
print(f'TOTAL: {len(keys)}')
