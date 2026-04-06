import os

file_path = r'lib/features/lotes/presentation/widgets/produccion_form_steps/clasificacion_huevos_step.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace(r"\': huevosBuenos\'", "'${S.of(context).batchFormTotalToClassify}: $huevosBuenos'")
text = text.replace(r"\': faltante\'", "'${S.of(context).batchFormMissingEggs}: $faltante'")
text = text.replace(r"\': -faltante\'", "'${S.of(context).batchFormExcessEggs}: ${-faltante}'")
text = text.replace(r"\': _totalClasificados\'", "'${S.of(context).batchFormAutoCalculatedWeight}: $_totalClasificados'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
