# Regras de repositórios

| Repo | Papel | Quem escreve | Branch |
|---|---|---|---|
| `{{SLUG}}-cerebro` | memória institucional | humanos + agentes (registros duráveis, via hook) | `main` curta; mudança grande em branch |
| `{{SLUG}}-casa` | casa do orquestrador {{AGENT_NAME}} | {{AGENT_NAME}} + humanos | `main` |
| `{{SLUG}}-casa-<agente>` | casa de cada agente macro de área | o próprio agente + humanos | `main` |

- Sync sempre por `scripts/sync.sh` (ver `cerebro/agentes/CONTRATO-SYNC-GIT.md`).
- Nunca: `push --force` em `main`, secrets, `.env`, sessões, logs brutos, binários grandes (guarde fora e deixe ponteiro).
- Repo de produto/cliente não é casa de agente: fica em repo próprio, apontado daqui.
