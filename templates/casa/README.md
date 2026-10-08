# {{SLUG}}-casa — casa de execução de {{AGENT_NAME}} (orquestrador)

Responde **como o agente executa**. O que a organização sabe e decidiu fica em
`{{SLUG}}-cerebro`. Config, secrets, sessões e logs ficam no runtime (`HERMES_HOME`) e nunca aqui.

```text
{{SLUG}}-casa/
├── AGENTS.md / BOOTSTRAP.md   ← o que o agente lê ao abrir este diretório
├── TOOLS.md                   ← ferramentas/integrações e seus limites
├── automation/                ← uma pasta por rotina/automação (código + README), registrada no cérebro
├── governance/templates/      ← modelos de GATE, REQ (pedido operacional) e RETORNO
├── handoffs/                  ← pedidos operacionais REQ-<DESTINO>-<ASSUNTO>-<UTC>.md e correções
├── reports/                   ← relatórios sanitizados de auditoria/rotina
├── outbox/                    ← mensagens preparadas aguardando aprovação (conteúdo não versionado)
├── contratos/                 ← limites de workspace, backup/rollback
├── memory/                    ← memória curta operacional
├── skills/                    ← skills operacionais (SKILL.md por pasta)
├── scripts/                   ← projetar, status, reconciliar-recorrencias, novo-req, sync-bundle, validadores
├── hermes/                    ← config.example.yaml e unit systemd de exemplo
└── var/                       ← logs/state/tmp locais (ignorado)
```

## Ligação com o runtime

```bash
scripts/projetar.sh                 # SOUL.md → HERMES_HOME; bootstrap do agente → AGENTS.md da casa
scripts/projetar.sh --check         # sai 1 se houver drift
scripts/reconciliar-recorrencias.py # registro no cérebro × jobs do hermes cron
hermes --in "$PWD"                  # sessão CLI com esta casa como diretório de trabalho
```

No gateway (Telegram etc.), aponte `terminal.cwd` do `config.yaml` para esta pasta.

## Depois de clonar em outra máquina

```bash
git config core.hooksPath .githooks      # hooks não vêm ativados num clone
$EDITOR .casa.conf                       # CEREBRO_PATH e HERMES_HOME desta máquina
scripts/projetar.sh && scripts/status.sh
```
