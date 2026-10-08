#!/usr/bin/env python3
"""Checagem determinística da estrutura da casa de execução."""
import argparse
import re
import sys
from pathlib import Path

COMMON = ["AGENTS.md", "BOOTSTRAP.md", "TOOLS.md", ".casa.conf", "contratos/LIMITES-WORKSPACE.md",
          "memory/README.md", "memory/pending.md", "scripts/projetar.sh"]
# Casa do orquestrador x casa de agente macro (identidade própria na raiz).
ORQUESTRADOR = ["governance/templates/GATE.md", "governance/templates/REQ.md",
                "automation/README.md", "handoffs/README.md"]
MACRO = ["SOUL.md", "IDENTITY.md", "USER.md", "MEMORY.md", "HEARTBEAT.md", "RUNTIME_STATUS.md",
         "contratos/HANDOFF.md"]
FORBIDDEN = re.compile(r"(^|/)(\.env|auth\.json|config\.yaml|.*\.db|.*\.sqlite3?)$")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=Path(__file__).resolve().parent.parent)
    root = Path(ap.parse_args().root)
    required = COMMON + (MACRO if (root / "SOUL.md").exists() else ORQUESTRADOR)
    errors = [f"faltando: {p}" for p in required if not (root / p).exists()]
    for p in root.rglob("*"):
        rel = p.relative_to(root).as_posix()
        if rel.startswith((".git/", "var/", "outbox/")):
            continue
        if FORBIDDEN.search(rel):
            errors.append(f"arquivo de runtime/secret dentro da casa: {rel}")
    for skill in (root / "skills").glob("*/") if (root / "skills").is_dir() else []:
        sk = skill / "SKILL.md"
        if not sk.exists() or not sk.read_text(encoding="utf-8").startswith("---"):
            errors.append(f"skill sem SKILL.md com frontmatter: {skill.name}")
    for auto in (root / "automation").glob("*/") if (root / "automation").is_dir() else []:
        if not (auto / "README.md").exists():
            errors.append(f"automação sem README.md: {auto.name}")
    for e in errors:
        print("CASA_FAIL:", e)
    if errors:
        return 1
    print("PASS_CASA")
    return 0


if __name__ == "__main__":
    sys.exit(main())
