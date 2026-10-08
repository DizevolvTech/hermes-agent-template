#!/usr/bin/env python3
"""Impede artefatos binários e exports de entrarem no cérebro.

O cérebro guarda texto versionável (Markdown, JSON, YAML). PDFs, planilhas, apresentações,
ZIPs, mídias e arquivos grandes ficam em Drive/storage, com um ponteiro em Markdown aqui.
Imagens pequenas de diagrama (svg/png < 500 KB) são permitidas.
"""
import argparse
import sys
from pathlib import Path

BLOQUEADOS = {".pdf", ".docx", ".doc", ".xlsx", ".xls", ".pptx", ".ppt", ".zip", ".rar", ".7z",
              ".tar", ".gz", ".mp4", ".mov", ".mp3", ".wav", ".db", ".sqlite", ".sqlite3", ".exe"}
IMAGENS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"}
LIMITE_IMG = 500 * 1024
LIMITE_TEXTO = 1024 * 1024


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=Path(__file__).resolve().parent.parent)
    root = Path(ap.parse_args().root)
    errors = []
    for p in root.rglob("*"):
        rel = p.relative_to(root).as_posix()
        if not p.is_file() or rel.startswith((".git/", ".external-artifacts/")):
            continue
        ext, size = p.suffix.lower(), p.stat().st_size
        if ext in BLOQUEADOS:
            errors.append(f"{rel}: tipo {ext} não entra no cérebro (guarde fora e deixe um ponteiro .md)")
        elif ext in IMAGENS and size > LIMITE_IMG:
            errors.append(f"{rel}: imagem com {size // 1024} KB (máx. {LIMITE_IMG // 1024} KB)")
        elif ext not in IMAGENS and size > LIMITE_TEXTO:
            errors.append(f"{rel}: {size // 1024} KB; arquivo grande demais para o cérebro")
    for e in errors:
        print("ARTIFACT_FAIL:", e)
    if errors:
        return 1
    print("PASS_ARTIFACTS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
