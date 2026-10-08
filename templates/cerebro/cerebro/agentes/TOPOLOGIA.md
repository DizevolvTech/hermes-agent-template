# Topologia

| Agente | Engine | Host | Runtime (HERMES_HOME/perfil) | Casa | Papel | Canais |
|---|---|---|---|---|---|---|
| {{AGENT_NAME}} | Hermes Agent | `<host>` | `~/.hermes` | `{{SLUG}}-casa` | Orquestrador | `<ex.: Telegram>` |

Para adicionar agente: aplicar `CONTRATO-CICLO-VIDA-AGENTES.md`, copiar
`__AGENT_SLUG__/` (via `setup.sh --agente` ou manualmente), usar perfil Hermes isolado
(`hermes profile create <nome>`) e registrar nesta tabela.
