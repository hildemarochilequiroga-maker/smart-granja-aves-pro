import os

with open("analyzer_errors_new.txt", "r", encoding="utf-16") as f:
    lines = f.readlines()

errors_by_file = {}
for line in lines:
    parts = line.strip().split("|")
    if len(parts) > 7:
        file_path = parts[3]
        msg = parts[7]
        line_num = parts[4]
        if file_path not in errors_by_file:
            errors_by_file[file_path] = {}
        if msg not in errors_by_file[file_path]:
            errors_by_file[file_path][msg] = []
        errors_by_file[file_path][msg].append(line_num)

for file_path, msgs in sorted(errors_by_file.items(), key=lambda x: -sum(len(l) for l in x[1].values())):
    try:
        short_path = file_path.split("lib\\")[-1] if "lib\\" in file_path else file_path.split("lib/")[-1]
    except:
        short_path = file_path
    print(short_path)
    for m, lines in msgs.items():
        print(f"  - {m}: {len(lines)} times (lines: {','.join(lines[:3])})")