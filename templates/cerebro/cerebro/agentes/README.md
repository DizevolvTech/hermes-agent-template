# Agentes — regra de roteamento

| Tipo de informação | Onde mora |
|---|---|
| Decisão, lição, status, topologia, contratos da frota | **Cérebro** (este repo) |
| Identidade do **orquestrador** | Cérebro: `agentes/{{AGENT_SLUG}}/` |
| Identidade de um **agente macro de área** | Casa dele (`{{SLUG}}-casa-<agente>`) + ponteiro `agentes/<agente>.md` aqui |
| Como cada agente executa: bootstrap, rotinas, skills, memória curta | **Casa** do agente |
| Config, `.env`, sessões, logs, banco, cron jobs | **Runtime** (`HERMES_HOME` / perfil), nunca versionado |

`SOUL.md` do runtime e o bloco do agente no `AGENTS.md` da casa são **projeções quentes** geradas por
`scripts/projetar.sh` da casa. Edite sempre na fonte canônica, nunca no runtime.
