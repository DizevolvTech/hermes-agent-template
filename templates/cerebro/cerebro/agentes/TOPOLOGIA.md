# Topologia

| Agente | Engine | Host | Runtime (HERMES_HOME/perfil) | Casa | Papel | Canais |
|---|---|---|---|---|---|---|
| {{AGENT_NAME}} | Hermes Agent | `{{HOST}}` | `~/.hermes` | `{{SLUG}}-casa` | Orquestrador | {{CHANNEL}} |

Para adicionar agente: aplicar `CONTRATO-CICLO-VIDA-AGENTES.md`, copiar
`__AGENT_SLUG__/` do orquestrador como ponto de partida (manual), usar perfil Hermes isolado
(`hermes profile create <nome>`) e registrar nesta tabela.
