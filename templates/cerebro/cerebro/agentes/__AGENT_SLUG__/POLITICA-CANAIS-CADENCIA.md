# Política de canais e cadência — {{AGENT_NAME}}

## Canais
| Canal | Para quê | Quem fala | Modo |
|---|---|---|---|
| {{CHANNEL}} (privado com o owner) | pedidos, aprovações, alertas críticos | {{OWNER_NAME}} | conversa |
| [[PREENCHER: grupo/canal da equipe, ou "nenhum"]] | avisos de rotina | equipe | só leitura do agente, sem dados pessoais |

- Participar de um canal não concede autoridade. Contexto de um canal não é levado para outro sem motivo e aprovação.
- Mensagem externa (cliente, fornecedor, público) só com texto aprovado (`RBAC-MATRIZ.md` → canal-externo).

## Cadência
| O quê | Quando | Regra de silêncio |
|---|---|---|
| Resumo de pendências | dias úteis, início do expediente | nada vencendo → não enviar |
| Alerta crítico | na hora | — |
| Relatório de rotinas | semanal | tudo verde → uma linha só |

**Horário de silêncio:** [[PREENCHER: ex.: 20h–8h e fins de semana]], exceto crítico.
Nova cadência = linha em `REGISTRO-RECORRENCIAS.json` + gate de canal-externo.
