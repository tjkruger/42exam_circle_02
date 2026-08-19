#!/usr/bin/env python3
import sys
import argparse
import difflib
import re
from pathlib import Path

NAME_RE = re.compile(r'^\s*(def|class|function|public|private|static|async)\s+([A-Za-z0-9_<>$]+)')

def find_names(line):
    m = NAME_RE.match(line)
    if m:
        return m.group(2)
    return None

def summarize(diff_lines):
    added = removed = hunks = 0
    added_names = set()
    removed_names = set()
    for ln in diff_lines:
        if ln.startswith('@@'):
            hunks += 1
        if ln.startswith('+++') or ln.startswith('---') or ln.startswith('***'):
            continue
        if ln.startswith('+'):
            added += 1
            name = find_names(ln[1:])
            if name: added_names.add(name)
        elif ln.startswith('-'):
            removed += 1
            name = find_names(ln[1:])
            if name: removed_names.add(name)
    return {
        'hunks': hunks,
        'added': added,
        'removed': removed,
        'added_names': sorted(added_names),
        'removed_names': sorted(removed_names),
    }

def main():
    p = argparse.ArgumentParser(description="Zeigt diff und kurze Zusammenfassung der Änderungen.")
    p.add_argument('old', help='alte Datei')
    p.add_argument('new', help='neue Datei')
    args = p.parse_args()

    f1 = Path(args.old)
    f2 = Path(args.new)
    if not f1.exists():
        print(f"Fehler: Datei nicht gefunden: {f1}", file=sys.stderr); sys.exit(2)
    if not f2.exists():
        print(f"Fehler: Datei nicht gefunden: {f2}", file=sys.stderr); sys.exit(2)

    a = f1.read_text(encoding='utf-8', errors='replace').splitlines(keepends=True)
    b = f2.read_text(encoding='utf-8', errors='replace').splitlines(keepends=True)

    diff = list(difflib.unified_diff(a, b, fromfile=str(f1), tofile=str(f2), lineterm=''))
    if not diff:
        print("Keine Unterschiede gefunden.")
        return

    # Ausgabe des diffs
    print('\n'.join(diff))

    # Zusammenfassung
    s = summarize(diff)
    print("\n--- Zusammenfassung ---")
    print(f"Hunks: {s['hunks']}, hinzugefügt: {s['added']}, entfernt: {s['removed']}")
    if s['added_names']:
        print("Neu/angepasste Names (hinzugefügt):", ', '.join(s['added_names']))
    if s['removed_names']:
        print("Entfernte Names:", ', '.join(s['removed_names']))

if __name__ == '__main__':
    main()