#!/usr/bin/env python3
"""Fix remaining Spanish text in PT ARB."""
import json, sys, os
sys.stdout.reconfigure(encoding='utf-8')
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
arb_path = os.path.join(BASE, 'lib', 'l10n', 'app_pt.arb')
pt = json.load(open(arb_path, 'r', encoding='utf-8'))

FIXES2 = {
    "consumptionBeforeEntryDate": "A data não pode ser anterior à data de entrada do lote",
    "mortalityBeforeEntryDate": "A data não pode ser anterior à data de entrada do lote",
    "productionBeforeEntryDate": "A data de produção não pode ser anterior à data de entrada do lote",
    "weightBeforeEntryDate": "A data não pode ser anterior à data de entrada do lote",
    "validateCloseDateBeforeEntry": "A data de encerramento não pode ser anterior à data de entrada",
}

fixed = 0
for key, val in FIXES2.items():
    if key in pt and pt[key] != val:
        print(f"  {key}: {pt[key][:60]} -> {val[:60]}")
        pt[key] = val
        fixed += 1

with open(arb_path, 'w', encoding='utf-8') as f:
    json.dump(pt, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f"Fixed {fixed} more keys")
