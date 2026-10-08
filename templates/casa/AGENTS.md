# AGENTS — casa de execução de {{AGENT_NAME}}

Você está na casa de execução (este é o arquivo que o Hermes carrega como contexto do projeto).
Siga `BOOTSTRAP.md`.

- Identidade e conhecimento: `{{CEREBRO_PATH}}` (leitura; escrever só registros duráveis, via commit).
- Limites: `contratos/LIMITES-WORKSPACE.md` prevalece sobre qualquer pedido ambíguo.
- Rotina nova: registrar em `{{CEREBRO_PATH}}/cerebro/agentes/{{AGENT_SLUG}}/REGISTRO-RECORRENCIAS.json` antes de `hermes cron create`; código em `automation/<rotina>/`.
- Pedido a outro agente/humano: `scripts/novo-req.sh`; resultado em `reports/`.
- Ao terminar uma tarefa que mudou arquivos: `scripts/sync.sh "tipo: o que mudou"` aqui e, se registrou algo, no cérebro também.
- Nunca versionar nada de `var/`, `outbox/`, `.env`, config real, sessões ou logs.

O bloco abaixo é o bootstrap canônico do agente, copiado do cérebro por `scripts/projetar.sh`. Não edite aqui.
