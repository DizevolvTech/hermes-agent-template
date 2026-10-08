# Runtime (HERMES_HOME)

O runtime é onde o Hermes guarda **estado vivo e segredos**. Nunca é versionado; recebe a identidade
por projeção (`casa/scripts/projetar.sh`) e é apontado para a casa via `terminal.cwd`.

## Layout numa máquina com orquestrador + agentes macro

```text
~/.hermes/                        ← runtime do ORQUESTRADOR
├── config.yaml                   ← modelo, provider, canais, approvals, terminal.cwd → <slug>-casa
├── .env                          ← secrets (tokens de bot, API keys) — só aqui, nunca em repo
├── SOUL.md                       ← PROJETADO do cérebro (não editar à mão)
├── memories/                     ← memória própria do Hermes (USER.md / MEMORY.md curtos, geridos pelo agente)
├── skills/                       ← skills instaladas no runtime
├── cron/                         ← jobs agendados (reconciliados com REGISTRO-RECORRENCIAS.json)
├── sessions/  logs/  state.db    ← histórico e estado — sensível, fora do Git
└── profiles/
    ├── mercurio/                 ← runtime do agente macro "mercurio" (mesma estrutura acima, isolada)
    │   ├── config.yaml           ← terminal.cwd → <slug>-casa-mercurio · canal próprio
    │   ├── .env                  ← secrets só deste agente
    │   └── SOUL.md               ← PROJETADO da casa do mercurio
    └── <outro-agente>/
```

## Mapa completo: quem mora onde

| | Cérebro (`<slug>-cerebro`) | Casa (`<slug>-casa[-agente]`) | Runtime (`~/.hermes[/profiles/x]`) |
|---|---|---|---|
| Identidade do orquestrador | **fonte** (`agentes/<orq>/`) | bloco projetado no `AGENTS.md` | `SOUL.md` projetado |
| Identidade de agente macro | ponteiro `agentes/<x>.md` | **fonte** (SOUL, IDENTITY, AGENTS…) | `SOUL.md` projetado |
| Decisões, lições, status | **fonte** | — | — |
| Rotinas | registro canônico (`REGISTRO-RECORRENCIAS.json`) | código (`automation/`) / `HEARTBEAT.md` | jobs (`cron/`) |
| Memória curta / rascunho | — | `memory/` | `memories/` |
| Secrets, sessões, logs | **nunca** | **nunca** | só aqui |

## Comandos úteis

```bash
hermes profile create mercurio          # cria ~/.hermes/profiles/mercurio
hermes -p mercurio setup                # modelo e canal do agente mercurio
hermes -p mercurio                      # conversar com o mercurio no terminal
hermes gateway start                 # gateway do orquestrador (canais)
hermes -p mercurio gateway start        # gateway do mercurio
casa/scripts/status.sh               # status sanitizado: versão, drift, hooks, config pendente
```

## Backup
Faça backup cifrado de cada `HERMES_HOME` (config.yaml, .env, memories/, skills/, cron/). Cérebro e casas
já estão no GitHub. Restaurar = clonar repos + restaurar runtime + `projetar.sh` + smoke.

> Os nomes de chaves e comandos seguem o Hermes Agent atual; confira com `hermes --help` na sua versão.
