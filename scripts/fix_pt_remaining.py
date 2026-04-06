#!/usr/bin/env python3
"""Fix remaining PT issues: wrong fallback translations and unmatched patterns."""

import os
import re

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ============================================================
# Fix 1: Wrong PT translations (ES text used as fallback in first run)
# Pattern: 'pt' => 'SPANISH_TEXT' → 'pt' => 'CORRECT_PT_TEXT'
# ============================================================
WRONG_PT_FIXES = {
    # galpon_notifiers.dart
    "'pt' => 'Estado cambiado a ${nuevoEstado.displayName}'":
        "'pt' => 'Estado alterado para ${nuevoEstado.displayName}'",
    "'pt' => 'Mantenimiento programado'":
        "'pt' => 'Manutenção programada'",
    "'pt' => 'Registrando desinfección...'":
        "'pt' => 'Registrando desinfecção...'",
    "'pt' => 'Desinfección registrada'":
        "'pt' => 'Desinfecção registrada'",

    # lote_notifiers.dart
    "'pt' => 'Cerrando lote...'":
        "'pt' => 'Fechando lote...'",
    "'pt' => 'Lote cerrado exitosamente'":
        "'pt' => 'Lote fechado com sucesso'",
    "'pt' => 'Registrando venta completa...'":
        "'pt' => 'Registrando venda completa...'",
    "'pt' => 'Lote marcado como vendido'":
        "'pt' => 'Lote marcado como vendido'",
    "'pt' => 'Transfiriendo lote...'":
        "'pt' => 'Transferindo lote...'",
    "'pt' => 'Lote transferido exitosamente'":
        "'pt' => 'Lote transferido com sucesso'",

    # lote_validators.dart
    "'pt' => 'Seleccione el tipo de ave'":
        "'pt' => 'Selecione o tipo de ave'",
    "'pt' => 'Seleccione la fecha de ingreso'":
        "'pt' => 'Selecione a data de entrada'",
    "'pt' => 'El código es obligatorio'":
        "'pt' => 'O código é obrigatório'",
    "'pt' => 'Ingrese una cantidad válida'":
        "'pt' => 'Insira uma quantidade válida'",
    "'pt' => 'Ya existe otro lote con el código \"$codigo\"'":
        "'pt' => 'Já existe outro lote com o código \"$codigo\"'",
}

FILES_WITH_WRONG_PT = [
    'lib/features/galpones/application/providers/galpon_notifiers.dart',
    'lib/features/granjas/application/providers/granja_notifiers.dart',
    'lib/features/lotes/application/providers/lote_notifiers.dart',
    'lib/features/lotes/application/validators/lote_validators.dart',
]


def fix_wrong_pt():
    """Fix wrong PT translations that used ES as fallback."""
    count = 0
    for rel_path in FILES_WITH_WRONG_PT:
        full = os.path.join(BASE, rel_path)
        if not os.path.exists(full):
            continue
        with open(full, 'r', encoding='utf-8') as f:
            content = f.read()
        original = content
        for old, new in WRONG_PT_FIXES.items():
            if old in content:
                content = content.replace(old, new)
                count += 1
        if content != original:
            with open(full, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"  Fixed wrong PT in: {rel_path}")
    print(f"  Total wrong PT fixes: {count}")


# ============================================================
# Fix 2: Concatenated multi-line strings in lote_validators.dart
# ============================================================
def fix_lote_validators_concat():
    """Fix the 2 concatenated string patterns the regex couldn't match."""
    full = os.path.join(BASE, 'lib/features/lotes/application/validators/lote_validators.dart')
    with open(full, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content

    # Fix 1: mortalidad count multiline
    old1 = """        message: Formatters.currentLocale == 'es'
            ? 'La cantidad de mortalidad ($cantidadMortalidad) no puede exceder '
                  'la cantidad actual ($cantidadActual)'
            : 'Mortality count ($cantidadMortalidad) cannot exceed '
                  'current count ($cantidadActual)',"""
    new1 = """        message: switch (Formatters.currentLocale) {
              'es' => 'La cantidad de mortalidad ($cantidadMortalidad) no puede exceder '
                  'la cantidad actual ($cantidadActual)',
              'pt' => 'A quantidade de mortalidade ($cantidadMortalidad) não pode exceder '
                  'a quantidade atual ($cantidadActual)',
              _ => 'Mortality count ($cantidadMortalidad) cannot exceed '
                  'current count ($cantidadActual)',
            },"""
    content = content.replace(old1, new1)

    # Fix 2: laying rate multiline
    old2 = """        message: Formatters.currentLocale == 'es'
            ? 'La tasa de postura del ${tasaPostura.toStringAsFixed(1)}% parece muy alta. '
                  'Verifique los datos.'
            : 'The laying rate of ${tasaPostura.toStringAsFixed(1)}% seems very high. '
                  'Please verify the data.',"""
    new2 = """        message: switch (Formatters.currentLocale) {
              'es' => 'La tasa de postura del ${tasaPostura.toStringAsFixed(1)}% parece muy alta. '
                  'Verifique los datos.',
              'pt' => 'A taxa de postura de ${tasaPostura.toStringAsFixed(1)}% parece muito alta. '
                  'Verifique os dados.',
              _ => 'The laying rate of ${tasaPostura.toStringAsFixed(1)}% seems very high. '
                  'Please verify the data.',
            },"""
    content = content.replace(old2, new2)

    if content != original:
        with open(full, 'w', encoding='utf-8') as f:
            f.write(content)
        print("  Fixed concatenated strings in lote_validators.dart")
    else:
        print("  No concat changes needed in lote_validators.dart")


# ============================================================
# Fix 3: salud/tipo_ave.dart - field reference pattern
# ============================================================
def fix_salud_tipo_ave():
    """Fix the field-reference pattern in salud tipo_ave.dart."""
    full = os.path.join(BASE, 'lib/features/salud/domain/enums/tipo_ave.dart')
    with open(full, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content

    old = """  /// Nombre localizado del tipo de ave.
  String get displayName =>
      Formatters.currentLocale == 'es' ? nombre : nombreIngles;"""

    new = """  /// Nombre localizado del tipo de ave.
  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    if (locale == 'pt') {
      return switch (this) {
        TipoAveProduccion.polloCarne => 'Frango de Corte',
        TipoAveProduccion.gallinaPonedoraComercial => 'Galinha Poedeira Comercial',
        TipoAveProduccion.gallinaPonedoraLibre => 'Galinha Poedeira Pastoreio',
        TipoAveProduccion.reproductoraPesada => 'Reprodutora Pesada',
        TipoAveProduccion.reproductoraLigera => 'Reprodutora Leve',
        TipoAveProduccion.pavoEngorde => 'Peru de Corte',
        TipoAveProduccion.codorniz => 'Codorna',
        TipoAveProduccion.pato => 'Pato',
      };
    }
    return nombreIngles;
  }"""

    content = content.replace(old, new)

    if content != original:
        with open(full, 'w', encoding='utf-8') as f:
            f.write(content)
        print("  Fixed salud/tipo_ave.dart field-reference pattern")
    else:
        print("  No changes needed in salud/tipo_ave.dart")


def main():
    print("=" * 60)
    print("Fixing remaining PT issues")
    print("=" * 60)

    print("\n1. Fixing wrong PT fallback translations...")
    fix_wrong_pt()

    print("\n2. Fixing concatenated strings in lote_validators...")
    fix_lote_validators_concat()

    print("\n3. Fixing salud/tipo_ave.dart field reference...")
    fix_salud_tipo_ave()

    print("\n✓ Done!")
    print("=" * 60)


if __name__ == '__main__':
    main()
