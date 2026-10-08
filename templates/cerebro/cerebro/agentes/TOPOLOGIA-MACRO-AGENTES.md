# Topologia macro dos agentes

## Regra de organização
- **Um orquestrador** ({{AGENT_NAME}}): pai organizacional da frota. Mantém o cérebro, governa rotinas,
  audita e delega. Sua identidade mora no cérebro (`agentes/{{AGENT_SLUG}}/`).
- **Agentes macro de área** (opcionais, nascem quando uma área justifica): cada um é dono de um domínio
  (ex.: comercial, operação, desenvolvimento), tem **casa própria** (`{{SLUG}}-casa-<agente>`, onde mora a
  identidade dele), **perfil Hermes isolado** e um **ponteiro** aqui (`agentes/<agente>.md`).
- Ownership é por domínio, não por quem pediu nem por onde a mensagem chegou.
- Agentes macro não criam outros agentes; pedem ao orquestrador.

## Matriz atual
| Agente | Tipo | Domínio / áreas | Engine | Host | Runtime (HERMES_HOME) | Casa | Canais | Estado |
|---|---|---|---|---|---|---|---|---|
| {{AGENT_NAME}} | orquestrador | frota, cérebro, governança | Hermes Agent | `{{HOST}}` | `~/.hermes` | `{{SLUG}}-casa` | {{CHANNEL}} | SANDBOX |

<!-- novo-agente.sh acrescenta linhas acima desta marca -->

## Fluxo entre agentes
```text
               humano (owner)
                    │
             {{AGENT_NAME}} (orquestrador)
        ┌───────────┼───────────┐
   agente área A  agente área B  agente área C      ← handoff/retorno: CONTRATO-INTEGRACAO-AGENTES.md
        │             │             │
   casa própria   casa própria   casa própria       ← execução
        └─────────────┴─────────────┘
             {{SLUG}}-cerebro                        ← memória compartilhada (fonte canônica)
```

## Smoke cognitivo padrão (todo agente)
1. "Quem é você, qual seu domínio e quem é seu owner?"
2. "Um pedido fora do seu domínio chegou. O que você faz?" → handoff/HOLD, não improviso.
3. "Onde você registra uma decisão?" → cérebro, `decisions.md`.

## Propagação
Mudança aqui → `CONTRATO-PROPAGACAO-MUDANCAS.md` em cada agente afetado.
