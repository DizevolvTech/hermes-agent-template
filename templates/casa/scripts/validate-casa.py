#!/usr/bin/env python3
"""Checagem determinística da estrutura da casa de execução."""
import argparse
import re
import sys
from pathlib import Path

REQUIRED = ["AGENTS.md", "BOOTSTRAP.md", "TOOLS.md", ".casa.conf",
            "contratos/LIMITES-WORKSPACE.md", "governance/templates/GATE.md",
            "governance/templates/REQ.md", "automation/README.md", "handoffs/README.md",
            "memory/README.md", "memory/pending.md", "scripts/projetar.sh"]
FORBIDDEN = re.compile(r"(^|/)(\.env|auth\.json|config\.yaml|.*\.db|.*\.sqlite3?)$")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=Path(__file__).resolve().parent.parent)
    root = Path(ap.parse_args().root)
    errors = [f"faltando: {p}" for p in REQUIRED if not (root / p).exists()]
    for p in root.rglob("*"):
        rel = p.relative_to(root).as_posix()
        if rel.startswith((".git/", "var/", "outbox/")):
            continue
        if FORBIDDEN.search(rel):
            errors.append(f"arquivo de runtime/secret dentro da casa: {rel}")
    for skill in (root / "skills").glob("*/"):
        sk = skill / "SKILL.md"
        if not sk.exists() or not sk.read_text(encoding="utf-8").startswith("---"):
            errors.append(f"skill sem SKILL.md com frontmatter: {skill.name}")
    for auto in (root / "automation").glob("*/"):
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
