#!/usr/bin/env python3
"""Fix the remaining unfixed mojibake values with known correct text."""

import json
import os

REMAINING_FIXES_ES = {
    "farmArea": "Área",
    "batchFeedConversion": "Índice Conversión",
    "farmTotalArea": "Área Total",
    "farmInvitationMessage": "¡Te invito a colaborar en mi granja \"{farmName}\"! Usa el código: {invCode}",
    "shedTotalArea": "Área Total",
    "shedAreaLabel": "Área",
    "chartsWeightTooltipEvolution": "📈 Evolución",
    "chartsWeightTooltipADG": "📈 Ganancia diaria",
    "chartsWeightTooltipUniformity": "📈 Uniformidad",
    "batchHighConversionAlert": "Índice de conversión alto",
}

REMAINING_FIXES_EN = {
    "farmInvitationMessage": "I invite you to collaborate on my farm \"{farmName}\"! Use the code: {invCode}",
    "chartsWeightTooltipEvolution": "📈 Evolution",
    "chartsWeightTooltipADG": "📈 Daily gain",
    "chartsWeightTooltipUniformity": "📈 Uniformity",
}

def fix_remaining(filepath, fixes):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    count = 0
    for key, correct_value in fixes.items():
        if key in data:
            old = data[key]
            data[key] = correct_value
            count += 1
            print(f"  {key}: {repr(old[:50])} -> {correct_value[:50]}")
    
    with open(filepath, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write('\n')
    
    print(f"  Fixed {count} remaining values")

def has_mojibake(text):
    mojibake_chars = ['\u00c3', '\u00c2', '\u0192', '\u2019', '\u201c', '\u201d', 
                      '\u2020', '\u2021', '\u00e2', '\u0160', '\u0152']
    return any(c in text for c in mojibake_chars)

if __name__ == '__main__':
    base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n'
    
    print("Fixing remaining ES...")
    fix_remaining(os.path.join(base, 'app_es.arb'), REMAINING_FIXES_ES)
    
    print("\nFixing remaining EN...")
    fix_remaining(os.path.join(base, 'app_en.arb'), REMAINING_FIXES_EN)
    
    # Verify
    print("\n--- Verification ---")
    for fname in ['app_es.arb', 'app_en.arb']:
        fpath = os.path.join(base, fname)
        with open(fpath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        remaining = []
        for key, value in data.items():
            if isinstance(value, str) and has_mojibake(value):
                remaining.append(key)
        
        print(f"  {fname}: {len(remaining)} keys still with mojibake")
        for k in remaining:
            print(f"    {k}: {repr(data[k][:80])}")
