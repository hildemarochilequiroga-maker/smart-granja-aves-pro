#!/usr/bin/env python3
"""Fix UTF-8 encoding issues in ARB files caused by PowerShell double-encoding."""

import re
import os

def fix_mojibake(text):
    """Try to fix double/triple encoded UTF-8 mojibake."""
    # Try progressive decode attempts
    result = text
    max_attempts = 5
    for _ in range(max_attempts):
        try:
            # Encode as latin-1 (to get raw bytes back) then decode as UTF-8
            fixed = result.encode('latin-1').decode('utf-8')
            if fixed != result:
                result = fixed
            else:
                break
        except (UnicodeDecodeError, UnicodeEncodeError):
            break
    return result

def fix_arb_file(filepath):
    """Fix encoding issues in an ARB file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if there are mojibake patterns
    if '\u00c3' not in content and '\u00c2' not in content:
        print(f"  {filepath}: No encoding issues found")
        return False
    
    # Fix each line's string values (between quotes after colon)
    lines = content.split('\n')
    fixed_lines = []
    fixes = 0
    
    for line in lines:
        # Match JSON string values: "key": "value"
        match = re.match(r'^(\s*"[^"]+"\s*:\s*)"(.*)"(,?\s*)$', line)
        if match:
            prefix = match.group(1)
            value = match.group(2)
            suffix = match.group(3)
            
            fixed_value = fix_mojibake(value)
            if fixed_value != value:
                fixes += 1
                line = f'{prefix}"{fixed_value}"{suffix}'
        
        fixed_lines.append(line)
    
    fixed_content = '\n'.join(fixed_lines)
    
    # Write back with proper UTF-8 encoding (no BOM)
    with open(filepath, 'w', encoding='utf-8', newline='\n') as f:
        f.write(fixed_content)
    
    print(f"  {filepath}: Fixed {fixes} values")
    return True

if __name__ == '__main__':
    base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n'
    
    for fname in ['app_es.arb', 'app_en.arb']:
        fpath = os.path.join(base, fname)
        if os.path.exists(fpath):
            print(f"Processing {fname}...")
            fix_arb_file(fpath)
        else:
            print(f"  {fname} not found!")
    
    # Verify
    print("\nVerification:")
    for fname in ['app_es.arb', 'app_en.arb']:
        fpath = os.path.join(base, fname)
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()
        has_issues = '\u00c3' in content
        lines = content.count('\n')
        print(f"  {fname}: {lines} lines, mojibake: {has_issues}")
        # Show first few lines with accented chars
        for i, line in enumerate(content.split('\n')[:30]):
            if any(c in line for c in 'áéíóúñüÁÉÍÓÚÑÜ'):
                print(f"    L{i+1}: {line.strip()[:80]}")
