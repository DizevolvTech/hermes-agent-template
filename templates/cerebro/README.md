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
├── scripts/           ← sync.sh, registrar.py e validadores (MAPA, registros, artefatos, secrets)
└── .githooks/         ← pre-commit e pre-push versionados
```

## Regras de ouro

1. Toda pasta estrutural é indexada no `MAPA.md` mais próximo (validado no commit).
2. Fato atual → `current-status.md`; decisão → `decisions.md`; aprendizado → `lessons.md`.
   Use `scripts/registrar.py` para criar a entrada no formato certo.
3. Sem secrets, sem dados pessoais brutos, sem logs. Binários (PDF, planilhas, ZIP...) ficam fora, com ponteiro (o hook bloqueia).
5. Salvar e enviar: `scripts/sync.sh "tipo: o que mudou"`.
4. Remover ou consolidar antes de criar arquivo novo.

## Depois de clonar

```bash
git config core.hooksPath .githooks   # hooks não vêm ativados num clone
```
