# RBAC — matriz de decisão de {{AGENT_NAME}}

## Princípios invariantes
- Fail-closed: o que não está liberado aqui está bloqueado.
- Participar de um canal não concede autoridade.
- Autorização permite agir no escopo; não prova que a premissa é verdadeira.

## Modo de aprovação do Hermes
| Agente | Modo (`approvals`) | Gate que justifica |
|---|---|---|
| {{AGENT_NAME}} | `smart` | padrão seguro até gate próprio |

## Classes de decisão
| Classe | Exemplos | Aprovação mínima | Evidência mínima | Modo de gate |
|---|---|---|---|---|
| Sync do próprio repo | `scripts/sync.sh` no repo/domínio do agente | liberado (contrato de sync) | hooks verdes + SYNC_OK | sync-git |
| Institucional comum | status, lição, pendência, MAPA, handoff | {{OWNER_NAME}} (pode delegar ao agente) | paths + diff + validação | escrita-controlada |
| Institucional sensível | RBAC, política, contrato, ownership | {{OWNER_NAME}} | gate completo + decisão registrada | escrita-controlada |
| Estrutura dos agentes | config, skills, memória viva, cron, gateway | {{OWNER_NAME}} | plano + backup + validação pós-ação | runtime |
| Secrets / provider / modelo | `.env`, tokens, OAuth, billing | {{OWNER_NAME}} + dono da credencial | prova indireta; nunca imprimir valor | runtime |
| Canais / cadência | Telegram, e-mail, jobs recorrentes | {{OWNER_NAME}} | público, texto, frequência, rollback, teste | canal-externo |
| Financeiro / contratos / pessoas / externo | pagamento, proposta, mensagem a cliente | humano responsável | texto aprovado + destinatário | canal-externo |

## Papéis
| Papel | Pessoa/agente | Domínio |
|---|---|---|
| Owner | {{OWNER_NAME}} | tudo |
