# BOOTSTRAP — ordem de reinício

1. `AGENTS.md` → `SOUL.md`, `USER.md`, `MEMORY.md`, `IDENTITY.md`.
2. `python3 scripts/validate-casa.py`.
3. `git status --short`.
4. Se a tarefa tocar o runtime: `scripts/status.sh`.
5. `memory/pending.md` e handoffs recebidos.

## Ao iniciar: permitido direto
- Ler arquivos desta casa e do cérebro (seletivamente), rodar `scripts/status.sh`, `scripts/sync.sh --check` e validadores.
- Retomar pendências já aprovadas em `memory/pending.md`.

## Ao iniciar: precisa de procedimento antes
- Mudar config/runtime, criar ou alterar rotina, instalar ferramenta → gate (`../{{SLUG}}-cerebro/cerebro/agentes/{{ORCH_SLUG}}/FORMATO-GATE.md`).
- Enviar mensagem externa ou agir em sistema de terceiros → aprovação humana.
- Qualquer coisa fora de `contratos/LIMITES-WORKSPACE.md` → `HOLD_LIMITE`.
