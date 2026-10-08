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
          edita / commita                     projetar.sh (+ --check de drift)
 humano ───────────────▶  <slug>-cerebro  ─────────────────────────────▶  ~/.hermes  (SOUL.md, AGENTS.md)
                              ▲     │ lê                                       │
       registros duráveis     │     ▼                                          │ terminal.cwd
       (decisão/lição/status) └── <slug>-casa  ◀──────────────────────────────┘
                                  (diretório de trabalho do agente)
```

## Começar (5 minutos)

1. Clique em **Use this template** (ou clone este repo).
2. Gere seus repos:
   ```bash
   ./setup.sh --org "Minha Empresa" --agente "Atlas" --owner "Maria"
   # opcional: --github <sua-conta>  → cria os dois repos PRIVADOS e faz o push
   ```
3. Instale e configure o Hermes:
   ```bash
   curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
   hermes setup                          # modelo, canal (ex.: Telegram); secrets no ~/.hermes/.env
   ```
4. Ligue o agente à estrutura:
   ```bash
   ../minha-empresa-casa/scripts/projetar.sh     # identidade do cérebro → runtime
   # no ~/.hermes/config.yaml: terminal.cwd: <caminho>/minha-empresa-casa
   cd ../minha-empresa-casa && hermes --in .     # pergunte: "Quem é você e quem é seu owner?"
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
- `scripts/projetar.sh` (drift), `reconciliar-recorrencias.py` (registro × `hermes cron`), `novo-req.sh`, `status.sh`, `sync-bundle.sh`, `validate-casa.py`.
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
