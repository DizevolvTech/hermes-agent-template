# AGENTS — casa de execução de {{AGENT_NAME}}

Você está na casa de execução. Siga `BOOTSTRAP.md`.

- Identidade e conhecimento: `{{CEREBRO_PATH}}` (somente leitura por padrão; escrever só registros duráveis, via commit).
- Limites: `contratos/LIMITES-WORKSPACE.md` prevalece sobre qualquer pedido ambíguo.
- Rotina nova: registrar em `{{CEREBRO_PATH}}/cerebro/agentes/{{AGENT_SLUG}}/REGISTRO-RECORRENCIAS.json` antes de `hermes cron create`; código em `automation/<rotina>/`.
- Pedido a outro agente/humano: `scripts/novo-req.sh`; resultado em `reports/`.
- Nunca versionar nada de `var/`, `.env`, config real, sessões ou logs.
