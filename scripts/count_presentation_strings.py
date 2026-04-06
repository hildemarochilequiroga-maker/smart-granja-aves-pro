"""
Scan presentation files for hardcoded Spanish strings and generate ARB keys + code modifications.
Phase 1: Extract all strings that need translation.
"""
import os
import re
import json

base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\features'

# Pattern to match Spanish strings in common Dart UI patterns
# Matches 'Text with Spanish chars' in contexts like Text('...'), label: '...', hintText: '...', etc.
string_pattern = re.compile(
    r"""(?:Text|label|hintText|labelText|helperText|title|subtitle|mensaje|tooltip|')\s*\(\s*'([^']{4,})'"""
)

features_to_scan = ['ventas', 'costos', 'salud', 'inventario', 'reportes', 'notificaciones', 'granjas', 'galpones', 'perfil']

for feature in features_to_scan:
    pres_dir = os.path.join(base, feature, 'presentation')
    if not os.path.isdir(pres_dir):
        continue
    
    count = 0
    for root, dirs, files in os.walk(pres_dir):
        for f in files:
            if not f.endswith('.dart'):
                continue
            full = os.path.join(root, f)
            with open(full, 'r', encoding='utf-8', errors='replace') as fh:
                content = fh.read()
            if 'S.of(' in content:
                continue  # Already migrated
            # Count Spanish strings
            # Simple heuristic: look for quoted strings containing Spanish characters
            spanish_strings = re.findall(r"'([^']*[áéíóúñÁÉÍÓÚÑ¿¡][^']*)'", content)
            # Also match common Spanish words
            common_es = re.findall(r"'((?:Seleccione|Ingrese|Guardar|Cancelar|Eliminar|Editar|Crear|Actualizar|Registrar|No hay|Sin |Total|Monto|Fecha|Cantidad|Detalle|Observ|Descripci|Nombre|Estado|Tipo|Buscar|Filtrar|Cargando|Error al|Confirm|Lista de|Nuevo|Nueva|Mi |Mis |Ver |Nota|Agregar|Seleccionar|Debe |El campo|No se|Se ha|Exitosamente|Guardado|Actualizado|Eliminado|Registrado)[^']*)'", content)
            total = len(set(spanish_strings + common_es))
            if total > 0:
                count += total
    
    print(f'{feature}: ~{count} strings in presentation')
