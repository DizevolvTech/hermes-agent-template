# {{SLUG}}-casa-{{AGENT_SLUG}} — {{AGENT_NAME}}, agente macro de {{AREA}}

Casa de execução **e identidade** de {{AGENT_NAME}}. Responde *como este agente executa*.
O que a organização sabe e decidiu fica em `{{SLUG}}-cerebro`; quem coordena a frota é {{ORCH_NAME}}.

```text
{{SLUG}}-casa-{{AGENT_SLUG}}/
├── AGENTS.md          ← bootstrap (é o que o Hermes carrega do diretório de trabalho)
├── SOUL.md            ← persona e missão (projetada para o perfil Hermes)
├── IDENTITY.md        ← ficha técnica · USER.md ← owner/aprovador · MEMORY.md ← índice
├── BOOTSTRAP.md       ← ordem de reinício
├── HEARTBEAT.md       ← rotinas recorrentes deste agente
├── TOOLS.md           ← ferramentas/integrações e limites
├── RUNTIME_STATUS.md  ← estado vivo verificado + smoke
├── contratos/         ← limites de workspace, handoff, carregamento de contexto, backup/rollback
├── memory/            ← memória curta: pending, context/, integrations/, projects/, sessions/
├── skills/            ← skills do domínio (SKILL.md + evals/ + references/)
├── areas/             ← frentes de trabalho do agente (copie _template)
├── scripts/           ← projetar, status, validadores, sync
├── hermes/            ← config de exemplo do perfil e unit systemd
└── var/               ← logs/output/state/tmp locais (ignorado)
```

## Runtime
Perfil Hermes isolado: `hermes profile create {{AGENT_SLUG}}` → `~/.hermes/profiles/{{AGENT_SLUG}}`.
No `config.yaml` do perfil: `terminal.cwd: /caminho/para/{{SLUG}}-casa-{{AGENT_SLUG}}`. Depois `scripts/projetar.sh`.

## Depois de clonar em outra máquina
```bash
git config core.hooksPath .githooks && $EDITOR .casa.conf && scripts/projetar.sh && scripts/status.sh
```
