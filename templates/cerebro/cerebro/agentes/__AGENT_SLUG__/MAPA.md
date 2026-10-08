# MAPA — agente {{AGENT_NAME}} (orquestrador)

> Owner: {{OWNER_NAME}} · Última validação: {{DATE}} · Revalidar quando: entrar/sair arquivo ou mudar autoridade

```text
__AGENT_SLUG__/
├── AGENTS.md                      ← bootstrap e regras quentes (mais novas no topo)
├── SOUL.md                        ← persona, missão e postura (projetado para o runtime)
├── IDENTITY.md                    ← ficha técnica: nome, engine, runtime, casa, autoridade
├── USER.md                        ← owner/aprovador e preferências (sem dado sensível)
├── MEMORY.md                      ← índice de ponteiros, não depósito
├── MANDATO.md                     ← função executiva, autoridade e limites
├── RBAC-MATRIZ.md                 ← classes de decisão × aprovação × evidência × gate
├── FORMATO-GATE.md                ← campos obrigatórios para aprovar qualquer ação
├── POLITICA-OPERACAO-CEREBRO.md   ← modos: leitura, auditoria, proposta, escrita controlada, sync
├── POLITICA-CANAIS-CADENCIA.md     ← qual canal para quê, frequência e horário de silêncio
├── REGISTRO-RECORRENCIAS.json     ← inventário canônico de toda rotina agendada (reconciliado com o cron)
├── CHECKLIST-PRE-RUNTIME.md       ← antes de setup/auth/modelo/canal
├── RUNTIME-STATUS.md              ← estado vivo verificado e casos de smoke
├── lessons.md                     ← lições específicas deste agente
├── prompts/                       ← prompts canônicos reutilizados em gates/rotinas
└── handoffs/                      ← handoffs macro (origem → destino) e retornos
```
