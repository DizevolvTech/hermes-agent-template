#!/usr/bin/env python3
"""Valida o formato dos livros-razão (current-status, decisions, lessons).

- Cada arquivo mantém o marcador <!-- entradas -->.
- decisions/lessons: títulos "## AAAA-MM-DD — <escopo>: <título>".
- current-status: títulos "### <agente/escopo> — <estado>, AAAA-MM-DD" (ou marcados [SUPERADO]).
Use scripts/registrar.py para criar entradas no formato certo.
"""
import argparse
import re
import sys
from pathlib import Path

REGRAS = {
    "decisions.md": (r"^## ", re.compile(r"^## \d{4}-\d{2}-\d{2} — .+")),
    "lessons.md": (r"^## ", re.compile(r"^## \d{4}-\d{2}-\d{2} — .+")),
    "current-status.md": (r"^### ", re.compile(r"^### (\[SUPERADO\] )?.+ — .+, \d{4}-\d{2}-\d{2}$")),
}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=Path(__file__).resolve().parent.parent)
    ctx = Path(ap.parse_args().root) / "cerebro/empresa/contexto"
    errors = []
    for nome, (prefixo, formato) in REGRAS.items():
        p = ctx / nome
        if not p.exists():
            errors.append(f"{nome}: ausente")
            continue
        texto = p.read_text(encoding="utf-8")
        if "<!-- entradas -->" not in texto:
            errors.append(f"{nome}: marcador '<!-- entradas -->' removido")
        corpo = texto.split("<!-- entradas -->", 1)[-1]
        for n, linha in enumerate(corpo.splitlines(), 1):
            if re.match(prefixo, linha) and not formato.match(linha):
                errors.append(f"{nome}: título fora do formato: {linha[:70]!r}")
    for e in errors:
        print("REGISTRO_FAIL:", e)
    if errors:
        return 1
    print("PASS_REGISTROS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
