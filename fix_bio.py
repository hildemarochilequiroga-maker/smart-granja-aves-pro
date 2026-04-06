import os

file_path = r'lib/features/salud/presentation/pages/bioseguridad_overview_page.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('  Widget build(BuildContext context) {', '  Widget build(BuildContext context) {\n    final l = S.of(context);')
text = text.replace('l.bioLastInspection(_formatDateLocalized(ultimaFecha!, l))', "'${l.bioLastInspection} ${_formatDateLocalized(ultimaFecha!, l)}'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
