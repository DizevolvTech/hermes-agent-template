#!/usr/bin/env python3
"""Reconcilia o registro canônico de recorrências (cérebro) com os jobs vivos do Hermes.

Somente leitura. Aponta:
- REGISTRADA_SEM_JOB: está no registro (scheduler=hermes-cron, status ativo) mas não existe job;
- JOB_ORFAO: job no Hermes sem linha no registro;
- PAUSADO_DIVERGENTE: job pausado/desabilitado mas registrado como ativo.
Sai 1 se houver divergência.
"""
import json
import os
import shlex
import sys
from pathlib import Path

CASA = Path(__file__).resolve().parent.parent


def conf() -> dict:
    vals = {}
    for line in (CASA / ".casa.conf").read_text(encoding="utf-8").splitlines():
        if "=" in line and not line.lstrip().startswith("#"):
            k, v = line.split("=", 1)
            vals[k.strip()] = os.path.expandvars(shlex.split(v)[0]) if v.strip() else ""
    return vals


def main() -> int:
    c = conf()
    home = Path(os.environ.get("HERMES_HOME") or c.get("HERMES_HOME") or Path.home() / ".hermes").expanduser()
    reg_path = Path(c["CEREBRO_PATH"]) / "cerebro/agentes" / c["AGENT_SLUG"] / "REGISTRO-RECORRENCIAS.json"
    reg = json.loads(reg_path.read_text(encoding="utf-8"))
    registered = {r.get("job_name") or r["key"]: r for r in reg.get("recurrences", [])
                  if r.get("scheduler") == "hermes-cron"}
    jobs_file = home / "cron" / "jobs.json"
    jobs = {}
    if jobs_file.exists():
        raw = json.loads(jobs_file.read_text(encoding="utf-8"))
        items = raw.get("jobs", raw) if isinstance(raw, dict) else raw
        items = items.values() if isinstance(items, dict) else items
        jobs = {j.get("name") or j.get("id"): j for j in items}
    else:
        print(f"AVISO: {jobs_file} não existe (sem jobs ou versão do Hermes guarda jobs em outro lugar)")
    issues = []
    for name, r in registered.items():
        if r.get("status") == "ativo" and name not in jobs:
            issues.append(f"REGISTRADA_SEM_JOB {name}")
        j = jobs.get(name)
        if j and r.get("status") == "ativo" and (j.get("enabled") is False or j.get("paused_at")):
            issues.append(f"PAUSADO_DIVERGENTE {name}")
    for name in jobs:
        if name not in registered:
            issues.append(f"JOB_ORFAO {name}")
    for i in issues:
        print(i)
    print(f"registradas={len(registered)} jobs={len(jobs)} divergencias={len(issues)}")
    return 1 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
