# MAPA — Cérebro {{ORG_NAME}}

> Owner: {{OWNER_NAME}} · Última validação: {{DATE}} · Revalidar quando: a estrutura desta pasta mudar

```text
cerebro/
├── empresa/     ← contexto global: status, decisões, lições, projetos, skills
├── areas/       ← uma pasta por área de trabalho (copie _modelo-area)
├── agentes/     ← identidade dos agentes, topologia e contratos da frota
├── seguranca/   ← checklist e auditorias (sem secrets)
└── archive/     ← histórico morto versionado (archive/AAAA-MM-DD/)
```

## Por intenção

| Preciso de… | Vá para |
|---|---|
| O que está valendo agora | `empresa/contexto/current-status.md` |
| Por que algo foi decidido | `empresa/contexto/decisions.md` (buscar, não ler inteiro) |
| O que já aprendemos | `empresa/contexto/lessons.md` |
| Quem é o agente / como carrega contexto | `agentes/{{AGENT_SLUG}}/` |
| Como uma mudança se propaga | `agentes/CONTRATO-PROPAGACAO-MUDANCAS.md` |
