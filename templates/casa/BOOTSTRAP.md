# BOOTSTRAP — ordem de reinício

1. `AGENTS.md` (este repo).
2. `{{CEREBRO_PATH}}/cerebro/agentes/{{AGENT_SLUG}}/` → SOUL, USER, MEMORY, MANDATO, RBAC-MATRIZ.
3. `python3 scripts/validate-casa.py` (estrutura íntegra).
4. `git status --short` (trabalho pendente?).
5. Se a tarefa tocar o runtime: `scripts/status.sh`.
6. `memory/pending.md` e `handoffs/` abertos — retomar o que ficou pendente.
7. `scripts/reconciliar-recorrencias.py` se a tarefa tocar rotinas.
