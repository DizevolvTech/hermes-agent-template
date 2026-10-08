# Agentes — regra de roteamento

| Tipo de informação | Onde mora |
|---|---|
| Decisão, lição, status, identidade, contratos | **Cérebro** (este repo) |
| Como o agente executa: bootstrap, scripts, skills operacionais, memória curta | **Casa** (`{{SLUG}}-casa`) |
| Config, `.env`, sessões, logs, banco local, cron jobs | **Runtime** (`HERMES_HOME`, nunca versionado) |

`SOUL.md` e `AGENTS.md` do runtime são **projeções quentes** geradas a partir
daqui por `{{SLUG}}-casa/scripts/projetar.sh`. Edite sempre aqui, nunca no runtime.
