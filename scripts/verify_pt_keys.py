import re
with open('lib/core/errors/error_messages.dart', 'r', encoding='utf-8') as f:
    c = f.read()

es_section = c.split("'es': {")[1].split("'en': {")[0]
en_section = c.split("'en': {")[1].split("'pt': {")[0]
pt_section = c.split("'pt': {")[1].split('  };')[0]

key_pattern = r"'([A-Z][A-Z0-9_]+)'\s*:"
es_keys = set(re.findall(key_pattern, es_section))
en_keys = set(re.findall(key_pattern, en_section))
pt_keys = set(re.findall(key_pattern, pt_section))

print(f'ES keys: {len(es_keys)}')
print(f'EN keys: {len(en_keys)}')
print(f'PT keys: {len(pt_keys)}')

missing_in_pt = es_keys - pt_keys
if missing_in_pt:
    print(f'\nMissing in PT ({len(missing_in_pt)}):')
    for k in sorted(missing_in_pt):
        print(f'  {k}')
else:
    print('\nAll keys present in PT!')
