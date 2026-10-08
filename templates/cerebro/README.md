# {{ORG_NAME}} — Cérebro

Repositório **versionado de memória e conhecimento** de {{ORG_NAME}}.
Aqui fica tudo o que precisa sobreviver: contexto, decisões, lições, status,
projetos, identidade dos agentes e contratos de operação.

Não é runtime. O agente roda na **casa de execução** (`{{SLUG}}-casa`) e no
`HERMES_HOME`; este repo é a fonte canônica que eles leem.

## Estrutura

```text
{{SLUG}}-cerebro/
├── AGENTS.md          ← bootstrap curto para qualquer agente que abrir este repo
├── cerebro/           ← conhecimento canônico (comece por cerebro/MAPA.md)
├── scripts/           ← validadores (MAPA, secrets) e helper de registro
└── .githooks/         ← pre-commit versionado (ativar: git config core.hooksPath .githooks)
```

## Regras de ouro

1. Toda pasta estrutural é indexada no `MAPA.md` mais próximo (validado no commit).
2. Fato atual → `current-status.md`; decisão → `decisions.md`; aprendizado → `lessons.md`.
   Use `scripts/registrar.py` para criar a entrada no formato certo.
3. Sem secrets, sem dados pessoais brutos, sem logs. Binários ficam fora (ponteiro apenas).
4. Remover ou consolidar antes de criar arquivo novo.
