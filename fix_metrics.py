import re

files = [
    r'lib/features/lotes/presentation/widgets/cerrar_lote/closure_summary_section.dart',
    r'lib/features/lotes/presentation/widgets/cerrar_lote/final_metrics_section.dart'
]

for file_path in files:
    with open(file_path, 'r', encoding='utf-8') as f:
        text = f.read()

    # The previous replace messed it up to '$} ' or something.
    # Let me just manually find where 'batchCloseDuration' is and fix it.
    if 'closure_summary_section' in file_path:
        text = text.replace("'$} ',", "'${diasCiclo} ${S.of(context).batchCloseDays}',")
    else:
        text = text.replace("'$} ',", "'${duracionCicloDias} ${S.of(context).batchCloseDays}',")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(text)
