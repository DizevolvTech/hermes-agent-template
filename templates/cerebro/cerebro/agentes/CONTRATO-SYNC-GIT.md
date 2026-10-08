# Contrato — sync com o GitHub

Todo repo da frota (cérebro, casa do orquestrador, casas dos agentes de área) sincroniza **do mesmo jeito**:
`scripts/sync.sh`. Ninguém usa `git push` solto.

## Quem sincroniza o quê
| Repo | Quem faz commit + push | Quando |
|---|---|---|
| `{{SLUG}}-cerebro` | qualquer agente, **só nos arquivos do seu domínio** (`CONTRATO-ACESSO-CEREBRO-AGENTES.md`) | ao registrar decisão, lição, status, pendência ou mudar estrutura |
| `{{SLUG}}-casa` | {{AGENT_NAME}} (orquestrador) | ao fim de cada tarefa que alterou a casa |
| `{{SLUG}}-casa-<agente>` | o próprio agente de área | ao fim de cada tarefa que alterou a casa dele |
| todos (rede de segurança) | {{AGENT_NAME}}, via `scripts/sync-frota.sh` | rotina `sync-frota` no `REGISTRO-RECORRENCIAS.json` |

## Como
```bash
scripts/sync.sh "tipo: o que mudou e por quê"   # tipos: registro, estrutura, rotina, identidade, correcao
scripts/sync.sh --check                          # estado sem alterar nada
```
O script: valida (hooks: MAPA, estrutura, secrets) → commita → `fetch` + `rebase` sobre `origin/main` → `push`.
Se outro agente enviou ao mesmo tempo, integra e tenta de novo (até 3 vezes).

## Regras
- Só a branch `main`; nunca `--force`; nunca reescrever histórico publicado.
- **Conflito = HOLD.** O script aborta o rebase sem perder nada e avisa; um humano (ou o orquestrador, com gate) decide.
- Commit bloqueado por hook não é contornado (`--no-verify` é proibido): corrigir a causa.
- `sync-frota.sh` nunca commita o trabalho de outro agente; só envia commits já feitos e aponta pendências.
- Credencial de push mora na máquina (`gh auth login` ou chave SSH com acesso só aos repos da frota), nunca em repo.
