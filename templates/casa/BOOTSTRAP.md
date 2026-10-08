# BOOTSTRAP — ordem de reinício

1. `AGENTS.md` (este repo).
2. `../{{SLUG}}-cerebro/cerebro/agentes/{{AGENT_SLUG}}/` → SOUL, USER, MEMORY, MANDATO, RBAC-MATRIZ.
3. `python3 scripts/validate-casa.py` (estrutura íntegra).
4. `git status --short` (trabalho pendente?).
5. Se a tarefa tocar o runtime: `scripts/status.sh`.
6. `memory/pending.md` e `handoffs/` abertos — retomar o que ficou pendente.
7. `scripts/reconciliar-recorrencias.py` se a tarefa tocar rotinas.

## Ao iniciar: permitido direto
- Ler arquivos desta casa e do cérebro (seletivamente), rodar `scripts/status.sh`, `scripts/sync.sh --check` e validadores.
- Retomar pendências já aprovadas em `memory/pending.md`.

## Ao iniciar: precisa de procedimento antes
- Mudar config/runtime, criar ou alterar rotina, instalar ferramenta → gate (`../{{SLUG}}-cerebro/cerebro/agentes/{{AGENT_SLUG}}/FORMATO-GATE.md`).
- Enviar mensagem externa ou agir em sistema de terceiros → aprovação humana.
- Qualquer coisa fora de `contratos/LIMITES-WORKSPACE.md` → `HOLD_LIMITE`.
