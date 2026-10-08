# Referência técnica

Para quem quer os detalhes: o que cada pasta faz, scripts e comandos.

## Estrutura completa

### Cérebro (`<slug>-cerebro`)

```text
<slug>-cerebro/
├── AGENTS.md                         ← bootstrap para qualquer agente que abrir o repo
├── cerebro/
│   ├── MAPA.md                       ← navegação por intenção ("preciso de X → vá para Y")
│   ├── empresa/
│   │   ├── contexto/                 ← geral, pessoas, canais, métricas, regras-repositorios, playbooks/
│   │   │   ├── current-status.md     ← O QUE VALE AGORA (prevalece sobre o resto)
│   │   │   ├── decisions.md          ← decisões humanas duráveis
│   │   │   └── lessons.md            ← aprendizados que mudam comportamento
│   │   ├── brand/  projetos/  skills/
│   ├── areas/                        ← vendas, marketing, atendimento, operacoes, pessoas, governanca,
│   │   └── <area>/                      desenvolvimento (+ _modelo-area): contexto/ rotinas/ projetos/ skills/
│   ├── agentes/
│   │   ├── TOPOLOGIA-MACRO-AGENTES.md← quem é quem: tipo, domínio, host, runtime, casa, canais, estado
│   │   ├── CONTRATO-*.md             ← carregamento de contexto, captura de aprendizados, propagação,
│   │   │                                integração entre agentes, ciclo de vida, acesso ao cérebro
│   │   ├── PRINCIPIO-QUALIDADE-OPERACIONAL.md · CHANGELOG-MODELO-OPERACIONAL.md · evals/
│   │   ├── <agente-macro>.md         ← ponteiro de cada agente macro
│   │   └── <orquestrador>/           ← identidade completa do orquestrador:
│   │       ├── SOUL · IDENTITY · USER · AGENTS · MEMORY (índice)
│   │       ├── MANDATO · RBAC-MATRIZ · FORMATO-GATE · POLITICA-OPERACAO-CEREBRO · CHECKLIST-PRE-RUNTIME
│   │       ├── REGISTRO-RECORRENCIAS.json   ← toda rotina agendada da frota, com kill switch
│   │       ├── RUNTIME-STATUS · lessons · prompts/ · handoffs/
│   ├── seguranca/                    ← checklist e auditorias
│   └── archive/                      ← histórico morto (mover, não apagar)
├── scripts/                          ← validate-mapas.py · registrar.py · scan-secrets.sh · checar-configuracao.sh
└── .githooks/pre-commit              ← valida MAPA + secrets no snapshot staged
```

### Casa do orquestrador (`<slug>-casa`)

```text
<slug>-casa/
├── AGENTS.md            ← carregado pelo Hermes; inclui o bloco projetado do cérebro
├── BOOTSTRAP.md · TOOLS.md · .casa.conf
├── automation/<rotina>/ ← código de cada rotina registrada no cérebro
├── governance/templates/← GATE · REQ (pedido) · RETORNO
├── handoffs/            ← REQ-<DESTINO>-<ASSUNTO>-<UTC>.md (correção = arquivo novo)
├── reports/ · outbox/   ← relatórios sanitizados · mensagens aguardando aprovação
├── contratos/ · memory/ · skills/ · hermes/ (config e systemd de exemplo) · var/
└── scripts/             ← projetar.sh · status.sh · reconciliar-recorrencias.py · novo-req.sh · sync-bundle.sh · validate-casa.py
```

### Casa de agente macro (`<slug>-casa-<agente>`)

```text
<slug>-casa-<agente>/
├── AGENTS.md · SOUL.md · IDENTITY.md · USER.md · MEMORY.md   ← identidade (fonte canônica deste agente)
├── BOOTSTRAP.md · HEARTBEAT.md · TOOLS.md · RUNTIME_STATUS.md
├── contratos/   ← limites, handoff, carregamento de contexto, backup/rollback
├── memory/      ← pending · context/{decisions,lessons,people} · integrations/ · projects/ · sessions/
├── skills/      ← <skill>/SKILL.md + evals/ + references/
├── areas/       ← frentes de trabalho do agente
└── scripts/ · hermes/ · var/
```

### Runtime

Layout de `~/.hermes` e `~/.hermes/profiles/<agente>`, e o que mora em cada camada: [`docs/runtime.md`](docs/runtime.md).

---

## Dia a dia

| Situação | O que fazer |
|---|---|
| Terminou uma tarefa | O agente classifica e registra (`CONTRATO-CAPTURA-APRENDIZADOS.md`). Manual: `cerebro/scripts/registrar.py decisao\|licao\|status "..."` |
| Mudou identidade ou regras | Edite no cérebro (ou na casa, se for agente macro) → `projetar.sh` → `projetar.sh --check` → smoke |
| Nova rotina | Linha em `REGISTRO-RECORRENCIAS.json` → código em `automation/<key>/` → `hermes cron create` → `reconciliar-recorrencias.py` verde |
| Delegar | `casa/scripts/novo-req.sh <DESTINO> <ASSUNTO>`; retorno com `governance/templates/RETORNO.md` |
| Ação sensível | Gate completo (`FORMATO-GATE.md`); gate incompleto = HOLD |
| Pasta nova no cérebro | Indexe no `MAPA.md` da pasta, senão o commit é bloqueado |
| Novo agente de área | `./novo-agente.sh` (ver acima) |

---

## Scripts do gerador

| Script | O que faz |
|---|---|
| `./setup.sh` | Cria `<slug>-cerebro` e `<slug>-casa`, interativo ou com flags (`--help`) |
| `./novo-agente.sh` | Cria um agente macro de área: casa própria e registro no cérebro (`--help`) |
| `tools/check-template.sh` | Gate do próprio template: sanitização e teste ponta a ponta (roda no CI) |
