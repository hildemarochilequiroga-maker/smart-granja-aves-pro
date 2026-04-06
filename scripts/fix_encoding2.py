#!/usr/bin/env python3
"""Reconstruct the ARB file from the key names and known correct Spanish text.

The file was corrupted by PowerShell encoding issues. This script rebuilds
it by extracting all key-value pairs and fixing the values that have mojibake.
"""

import json
import re
import os

def read_arb_keys_and_metadata(filepath):
    """Read the ARB file and extract all keys, values, and metadata."""
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Parse as JSON
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"JSON parse error: {e}")
        # Try to fix common JSON issues
        content = content.replace('\r\n', '\n')
        data = json.loads(content)
    
    return data

def has_mojibake(text):
    """Check if text contains mojibake characters."""
    if not isinstance(text, str):
        return False
    # Common mojibake patterns from UTF-8 double encoding
    mojibake_chars = ['\u00c3', '\u00c2', '\u0192', '\u2019', '\u201c', '\u201d', 
                      '\u2020', '\u2021', '\u00e2', '\u0160', '\u0152']
    return any(c in text for c in mojibake_chars)

def attempt_fix_mojibake(text):
    """Attempt to fix mojibake by trying various decode combinations."""
    if not has_mojibake(text):
        return text
    
    result = text
    # Try multiple rounds of latin-1 encode -> utf-8 decode
    for _ in range(10):
        try:
            candidate = result.encode('latin-1').decode('utf-8')
            if candidate != result and not has_mojibake(candidate):
                return candidate
            elif candidate != result:
                result = candidate
            else:
                break
        except (UnicodeDecodeError, UnicodeEncodeError):
            break
    
    # Try cp1252 encode -> utf-8 decode
    result = text
    for _ in range(10):
        try:
            candidate = result.encode('cp1252').decode('utf-8')
            if candidate != result and not has_mojibake(candidate):
                return candidate
            elif candidate != result:
                result = candidate
            else:
                break
        except (UnicodeDecodeError, UnicodeEncodeError):
            break
    
    return text  # Return original if can't fix

# Known correct Spanish values for common keys (backup for severely corrupted ones)
KNOWN_CORRECT = {
    "navManagement": "Gestión",
    "commonNoResultsHint": "Prueba modificando los filtros de búsqueda",
    "commonSomethingWentWrong": "Algo salió mal",
    "commonYes": "Sí",
    "connectivityOffline": "Sin conexión a internet",
    "connectivityOfflineShort": "Sin conexión",
    "connectivityOfflineBanner": "Sin conexión - Los cambios se guardarán localmente",
    "connectivityOfflineMode": "Modo sin conexión",
    "connectivityOfflineDataWarning": "No hay conexión a internet. Los datos pueden no estar actualizados",
    "errorNoConnection": "Sin conexión a internet",
    "errorInvalidCredentials": "Credenciales inválidas",
    "errorSessionExpired": "Tu sesión ha expirado",
    "errorNoPermission": "No tienes permiso para realizar esta acción",
    "errorNoSession": "No hay sesión activa",
    "errorInvalidEmail": "Correo electrónico inválido",
    "permNoViewSettings": "No tienes permiso para ver la configuración",
    "authOrContinueWith": "o continúa con",
    "authOrSignInWithEmail": "o inicia sesión con email",
    "authEmail": "Correo electrónico",
    "authSignIn": "Iniciar Sesión",
}

def fix_arb_file(filepath, known_corrections=None):
    """Fix encoding in ARB file."""
    data = read_arb_keys_and_metadata(filepath)
    
    fixed_count = 0
    known_fixed = 0
    
    for key, value in list(data.items()):
        if key.startswith('@') or key == '@@locale':
            continue
        
        if not isinstance(value, str) or not has_mojibake(value):
            continue
        
        # First try known corrections
        if known_corrections and key in known_corrections:
            data[key] = known_corrections[key]
            known_fixed += 1
            fixed_count += 1
            continue
        
        # Try automatic fix
        fixed = attempt_fix_mojibake(value)
        if fixed != value:
            data[key] = fixed
            fixed_count += 1
        else:
            print(f"  UNFIXED: {key} = {repr(value[:60])}")
    
    # Write back with proper UTF-8 encoding
    with open(filepath, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write('\n')
    
    print(f"  Fixed {fixed_count} values ({known_fixed} from known corrections)")
    return fixed_count

if __name__ == '__main__':
    base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\l10n'
    
    es_path = os.path.join(base, 'app_es.arb')
    en_path = os.path.join(base, 'app_en.arb')
    
    print("Fixing app_es.arb...")
    fix_arb_file(es_path, KNOWN_CORRECT)
    
    print("\nFixing app_en.arb...")
    fix_arb_file(en_path)
    
    # Verify
    print("\nVerification:")
    for fname in ['app_es.arb', 'app_en.arb']:
        fpath = os.path.join(base, fname)
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()
        remaining = sum(1 for line in content.split('\n') if has_mojibake(line))
        print(f"  {fname}: {remaining} lines still with mojibake")
