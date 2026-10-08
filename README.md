# hermes-agent-template

Estrutura versionada para rodar um agente **orquestrador** [Hermes Agent](https://github.com/NousResearch/hermes-agent)
com **memória organizada no GitHub** — o agente que mantém o cérebro, governa as rotinas e delega para outros agentes.
Um comando gera dois repositórios:

| Repo | Papel | Responde |
|---|---|---|
| `<slug>-cerebro` | **Cérebro** — tudo que precisa sobreviver: contexto, decisões, lições, status, identidade do agente, contratos | *o que a organização sabe e decidiu* |
| `<slug>-casa` | **Casa de execução** — onde o agente trabalha: bootstrap, rotinas, skills, memória curta, scripts | *como o agente executa* |

O **runtime** (`~/.hermes`: config, `.env`, sessões, logs) nunca é versionado.

```text
                         projetar.sh (+ --check de drift)
 humano ──edita──▶  <slug>-cerebro ─── SOUL.md ─────────────────────▶ ~/.hermes/SOUL.md  (identidade)
                         ▲     └────── AGENTS.md do agente ──┐
   registros duráveis    │                                   ▼
   (decisão/lição/status)└──────────────────────────  <slug>-casa/AGENTS.md  ◀── terminal.cwd do Hermes
                                                     (diretório de trabalho do agente)
```

## Começar

1. Clique em **Use this template** (ou clone este repo) — este repo é só o gerador.
2. Rode o setup e responda as perguntas sobre a sua organização:
   ```bash
   gh auth login        # opcional, mas recomendado: o setup cria os repos na SUA conta
   ./setup.sh
   ```
   Ele gera `<slug>-cerebro` e `<slug>-casa` lado a lado, já com Git, hooks e o primeiro commit, e
   (se o `gh` estiver logado) cria os dois como **repos privados na sua conta ou org do GitHub** e faz o push.
   Sem `gh`, ele mostra os comandos para fazer isso depois.
3. **Adapte à sua realidade.** Tudo que depende de você está marcado com `[[PREENCHER: ...]]`:
   ```bash
   <slug>-cerebro/scripts/checar-configuracao.sh   # lista o que falta, com arquivo e linha
   ```
   Comece por `agentes/<agente>/SOUL.md`, `USER.md`, `MANDATO.md` e `RBAC-MATRIZ.md`. Commite e faça push:
   a partir daí, seu GitHub é a memória versionada do agente.
4. Instale e ligue o Hermes:
   ```bash
   curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
   hermes setup                                # modelo e canal; secrets ficam em ~/.hermes/.env
   # em ~/.hermes/config.yaml →  terminal.cwd: <caminho>/<slug>-casa
   <slug>-casa/scripts/projetar.sh             # SOUL.md → ~/.hermes; bootstrap do agente → AGENTS.md da casa
   cd <slug>-casa && hermes                    # pergunte: "Quem é você e quem é seu owner?"
   ```

**Uma VPS basta.** Os dois repos podem ficar lado a lado na mesma máquina. Se um dia
separar em hosts diferentes, `scripts/sync-bundle.sh` leva o repo sem pôr credencial de GitHub no host.
Detalhes em [`docs/infraestrutura.md`](docs/infraestrutura.md).

## O que vem pronto

**Cérebro**
- `cerebro/MAPA.md` + um `MAPA.md` por pasta — navegação por intenção; **validado no commit** (pasta não indexada bloqueia).
- `current-status.md` (estado atual, prevalece) · `decisions.md` · `lessons.md` com formato fixo, e `scripts/registrar.py` para criar entradas.
- `agentes/<agente>/` — identidade (`SOUL`, `IDENTITY`, `USER`, `AGENTS`, `MEMORY` índice) e governança do orquestrador:
  `MANDATO`, `RBAC-MATRIZ` (classe de decisão × aprovação × evidência), `FORMATO-GATE` (gate incompleto = HOLD),
  `POLITICA-OPERACAO-CEREBRO` (leitura → auditoria → proposta → escrita controlada → sync),
  `REGISTRO-RECORRENCIAS.json` (toda rotina agendada, com kill switch e regra de silêncio), `CHECKLIST-PRE-RUNTIME`,
  `RUNTIME-STATUS` (com smoke), `prompts/`, `handoffs/`.
- Contratos da frota: carregamento de contexto, captura de aprendizados, propagação de mudanças, integração entre agentes, ciclo de vida.
- `areas/_modelo-area/`, `seguranca/checklist.md`, `archive/`.

**Casa (do orquestrador)**
- `AGENTS.md` / `BOOTSTRAP.md` (ordem de reinício) · `TOOLS.md` · `contratos/` (limites, backup/rollback).
- `automation/<rotina>/` (uma pasta por rotina registrada) · `governance/templates/` (GATE, REQ, RETORNO) ·
  `handoffs/` (pedidos `REQ-*`, correções nunca reescrevem o original) · `reports/` · `outbox/` (aguardando aprovação).
- `scripts/projetar.sh` (drift), `checar-configuracao.sh`, `reconciliar-recorrencias.py` (registro × `hermes cron`), `novo-req.sh`, `status.sh`, `sync-bundle.sh`, `validate-casa.py`.
- `memory/` curta, `skills/<nome>/SKILL.md`, `hermes/config.example.yaml` e unit systemd de exemplo.

**Nos dois:** hook `pre-commit` versionado que roda os validadores e o scanner de secrets contra o snapshot staged.

## Como usar no dia a dia

- **Ao fim de cada tarefa** o agente classifica: decisão, lição, mudança de status, pendência ou nada — e registra no cérebro (`CONTRATO-CAPTURA-APRENDIZADOS.md`).
- **Mudou a identidade/regras?** Edite no cérebro → `projetar.sh` → `projetar.sh --check` → smoke.
- **Nova rotina?** Linha em `REGISTRO-RECORRENCIAS.json` → código em `casa/automation/<key>/` → `hermes cron create` → `reconciliar-recorrencias.py` verde.
- **Delegar?** `casa/scripts/novo-req.sh <DESTINO> <ASSUNTO>`; retorno com `governance/templates/RETORNO.md`.
- **Novo agente?** `CONTRATO-CICLO-VIDA-AGENTES.md`, copie `agentes/<agente>/`, `hermes profile create <nome>`, registre em `TOPOLOGIA.md`.

Mais: [`docs/arquitetura.md`](docs/arquitetura.md) · [`docs/infraestrutura.md`](docs/infraestrutura.md) · [`docs/sanitizacao.md`](docs/sanitizacao.md)

## Contribuindo

`tools/check-template.sh` precisa passar (roda no CI): gera um par de repos de teste, valida, e procura secrets/dados privados.

Licença MIT.
