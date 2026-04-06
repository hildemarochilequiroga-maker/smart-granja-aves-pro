import os, re

base = r'c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib'
count = 0

for root, dirs, files in os.walk(base):
    for f in files:
        if not f.endswith('.dart'):
            continue
        fp = os.path.join(root, f)
        with open(fp, 'r', encoding='utf-8') as fh:
            content = fh.read()
        
        new_content = content
        # Fix package import
        new_content = new_content.replace(
            "import 'package:smartgranjaavespro/core/presentation/formatters.dart';",
            "import 'package:smartgranjaavespro/core/utils/formatters.dart';"
        )
        # Fix relative imports (various depths)
        new_content = re.sub(
            r"import '(\.\./)+core/presentation/formatters\.dart';",
            lambda m: m.group(0).replace('core/presentation/formatters.dart', 'core/utils/formatters.dart'),
            new_content
        )
        
        if new_content != content:
            with open(fp, 'w', encoding='utf-8') as fh:
                fh.write(new_content)
            rel = os.path.relpath(fp, base)
            print(f'Fixed: {rel}')
            count += 1

print(f'\nTotal fixed: {count}')
