import re

files = [
    r'lib/features/lotes/presentation/widgets/cerrar_lote/closure_summary_section.dart',
    r'lib/features/lotes/presentation/widgets/cerrar_lote/final_metrics_section.dart'
]

for file_path in files:
    with open(file_path, 'r', encoding='utf-8') as f:
        text = f.read()

    # Just find batchCloseDuration line and the one after it
    if 'closure_summary_section' in file_path:
        lines = text.split('\n')
        for i, doc in enumerate(lines):
            if 'S.of(context).batchCloseDuration,' in doc:
                lines[i+1] = "                '${diasCiclo} ${S.of(context).batchCloseDays}',"
        text = '\n'.join(lines)
    else:
        lines = text.split('\n')
        for i, doc in enumerate(lines):
            if 'S.of(context).batchCloseCycleDuration,' in doc:
                lines[i+1] = "            '${duracionCicloDias} ${S.of(context).batchCloseDays}',"
        text = '\n'.join(lines)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(text)
