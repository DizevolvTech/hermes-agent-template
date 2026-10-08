#!/usr/bin/env python3
"""Valida que cada MAPA.md indexa seus filhos diretos e tem metadados.

Regras:
- Toda pasta sob cerebro/ que contém conteúdo deve ter MAPA.md OU estar listada
  no MAPA.md do pai (pastas folha podem ter só README.md).
- Todo arquivo/pasta filho direto de uma pasta com MAPA.md precisa aparecer
  (pelo nome) no texto daquele MAPA.md.
- Todo MAPA.md precisa dos campos: "Owner:" e "Última validação:".
"""
import argparse
import sys
from pathlib import Path

IGNORE = {"MAPA.md", ".gitkeep", "__pycache__", ".DS_Store"}
REQUIRED_FIELDS = ("Owner:", "Última validação:")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=Path(__file__).resolve().parent.parent)
    args = ap.parse_args()
    base = Path(args.root) / "cerebro"
    if not base.is_dir():
        print("SKIP_MAPAS: sem pasta cerebro/")
        return 0
    errors = []
    for mapa in sorted(base.rglob("MAPA.md")):
        text = mapa.read_text(encoding="utf-8")
        for field in REQUIRED_FIELDS:
            if field not in text:
                errors.append(f"{mapa.relative_to(base.parent)}: falta metadado '{field}'")
        for child in sorted(mapa.parent.iterdir()):
            if child.name in IGNORE or child.name.startswith("."):
                continue
            if child.is_dir() and not any(child.rglob("*")):
                continue
            if child.name not in text:
                errors.append(f"{mapa.relative_to(base.parent)}: não indexa '{child.name}'")
    if not (base / "MAPA.md").exists():
        errors.append("cerebro/MAPA.md ausente")
    for e in errors:
        print("MAPA_FAIL:", e)
    if errors:
        return 1
    print("PASS_MAPAS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
