#!/usr/bin/env python3
import os, subprocess, re, sys
from pathlib import Path

def run_cmd(cmd):
    try:
        p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, check=True)
        return p.stdout
    except Exception:
        return ''

def extract_text(path):
    path = str(path)
    if path.lower().endswith('.pdf'):
        out = run_cmd(['pdftotext','-q','-layout', path, '-'])
        if out:
            return out
    out = run_cmd(['strings', path])
    if out:
        return out
    return ''

def find_institution(text, filename):
    if text:
        patterns = [
            r'([A-Z][\w\-\&\.\' " ]{2,60} (University|College|Institute|School|Academy|Academy of|Community College|High School))',
            r'(University of [A-Z][A-Za-z \-]{2,60})'
        ]
        for pat in patterns:
            try:
                m = re.search(pat, text)
            except re.error:
                m = None
            if m:
                inst = m.group(0).strip()
                return ' '.join(inst.split())
    base = re.sub(r'\.(pdf|jpeg|jpg|png|docx)$','', filename, flags=re.I)
    base = base.replace('_',' ').replace('-', ' ')
    base = re.sub(r'\b(transcript|transcripts|unofficial|unoffical|full)\b','', base, flags=re.I)
    base = re.sub(r'\b(casonk|casonkonzer|cason|konzer)\b','', base, flags=re.I)
    base = re.sub(r'\s+',' ', base).strip()
    if base:
        return base.title()
    return filename

def find_degree(text):
    if not text:
        return ''
    lines = text.splitlines()
    for i,line in enumerate(lines):
        if re.search(r'\b(bachelor|master|doctor|associate|b\.s\.|bachelor of|master of|bachelor\'s|master\'s|phd|ph\.d\.|mba|ms|ba|bs|associate)\b', line, flags=re.I):
            deg = line.strip()
            if i+1 < len(lines) and re.search(r'\b(major|field|conferred|date|award|degree|program)\b', lines[i+1], flags=re.I):
                deg = deg + ' ' + lines[i+1].strip()
            return ' '.join(deg.split())
    m = re.search(r'Degree[:\s]+([^\n\r]+)', text, flags=re.I)
    if m:
        return m.group(1).strip()
    return ''

def find_major(text):
    if not text:
        return ''
    m = re.search(r'(Major|Field of Study|Program)[:\s]+([^\n\r]+)', text, flags=re.I)
    if m:
        return m.group(2).strip()
    return ''

def find_year(text):
    if not text:
        return ''
    m = re.search(r'\b(19|20)\d{2}\b', text)
    if m:
        return m.group(0)
    return ''

def yaml_safe(s):
    if isinstance(s, int):
        return str(s)
    s = str(s)
    s = s.replace("'", "''")
    return "'{}'".format(s)

def main():
    root = Path('private_data/trans')
    if not root.exists() or not root.is_dir():
        root = Path('private_data')
        if not root.exists():
            print("# No private_data/trans found", file=sys.stderr)
            sys.exit(1)
    entries = []
    for p in sorted(root.iterdir()):
        if p.name.startswith('.'):
            continue
        text = extract_text(str(p))
        inst = find_institution(text, p.name)
        deg = find_degree(text)
        major = find_major(text)
        year = find_year(text)
        entry = {'institution': inst}
        if deg:
            entry['degree'] = deg
        if major:
            entry['field'] = major
        if year:
            try:
                entry['year'] = int(year)
            except:
                entry['year'] = year
        entries.append(entry)
    lines = []
    lines.append("# Generated education data (sanitized) - derived from private_data/transcripts")
    lines.append("# Sources are private and not published. Verify entries before publishing.")
    for e in entries:
        lines.append("- institution: {}".format(yaml_safe(e.get('institution',''))))
        if 'degree' in e:
            lines.append("  degree: {}".format(yaml_safe(e['degree'])))
        if 'field' in e:
            lines.append("  field: {}".format(yaml_safe(e['field'])))
        if 'year' in e:
            lines.append("  year: {}".format(yaml_safe(e['year'])))
        lines.append("")
    print("\n".join(lines))

if __name__ == '__main__':
    main()
