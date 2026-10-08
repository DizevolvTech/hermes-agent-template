#!/usr/bin/env python3
"""Cria uma entrada no formato canônico em decisions / lessons / current-status.

Exemplos:
  scripts/registrar.py decisao "Agente: usar modelo X como padrão" --autorizado-por "Owner"
  scripts/registrar.py licao   "Deploy: validar antes de reiniciar"
  scripts/registrar.py status  "Agente" "ativo"
A entrada nasce com campos a preencher; edite e commite.
"""
import argparse
import datetime as dt
from pathlib import Path

CTX = Path(__file__).resolve().parent.parent / "cerebro/empresa/contexto"
TODAY = dt.date.today().isoformat()

TEMPLATES = {
    "decisao": ("decisions.md", "## {d} — {t}\n\n"
                "- **Decisão:** \n- **Autorizado por:** {a}\n- **Motivo:** \n"
                "- **Continua bloqueado / fora do escopo:** \n- **Reversão:** \n"),
    "licao": ("lessons.md", "## {d} — {t}\n\n"
              "- **Fatos observados:** \n- **Lição (regra reutilizável):** \n"
              "- **Evidência e limites:** prova X, não prova Y.\n"
              "- **Carga:** regra quente (AGENTS.md) | sob demanda\n"),
    "status": ("current-status.md", "### {t} — {s}, {d}\n\n"
               "- **Autorizado por:** {a}\n- **O que mudou:** \n- **Validação:** \n"
               "- **Recibos / evidência:** \n- **Estado vivo:** \n"),
}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("tipo", choices=TEMPLATES)
    ap.add_argument("titulo")
    ap.add_argument("estado", nargs="?", default="")
    ap.add_argument("--autorizado-por", default="")
    args = ap.parse_args()
    if args.tipo == "status" and not args.estado:
        ap.error('status precisa do estado: registrar.py status "<Agente>" "<estado>"')
    fname, tpl = TEMPLATES[args.tipo]
    entry = tpl.format(d=TODAY, t=args.titulo, s=args.estado, a=args.autorizado_por)
    path = CTX / fname
    lines = path.read_text(encoding="utf-8").split("<!-- entradas -->", 1)
    if len(lines) != 2:
        raise SystemExit(f"{path}: marcador '<!-- entradas -->' ausente")
    # Mais recente primeiro, logo abaixo do marcador.
    path.write_text(lines[0] + "<!-- entradas -->\n\n" + entry + "\n" + lines[1].lstrip("\n"),
                    encoding="utf-8")
    print(f"OK: entrada criada em {path.relative_to(CTX.parent.parent.parent)}")


if __name__ == "__main__":
    main()
