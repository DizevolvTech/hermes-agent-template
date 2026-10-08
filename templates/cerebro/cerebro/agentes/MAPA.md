# MAPA — agentes

> Owner: {{OWNER_NAME}} · Última validação: {{DATE}} · Revalidar quando: entrar/sair agente ou contrato

```text
agentes/
├── README.md                              ← regra de roteamento: o que vai para cérebro x casa x runtime
├── TOPOLOGIA.md                           ← quem é quem: agente, engine, host, runtime, casa
├── CONTRATO-CARREGAMENTO-CONTEXTO.md      ← ordem e limites de leitura de contexto
├── CONTRATO-CAPTURA-APRENDIZADOS.md       ← fechamento de tarefa: o que vira registro
├── CONTRATO-PROPAGACAO-MUDANCAS.md        ← fonte canônica → projeção quente → validação
├── CONTRATO-CICLO-VIDA-AGENTES.md         ← criar, pilotar, ativar, pausar, aposentar agente
├── CONTRATO-INTEGRACAO-AGENTES.md         ← hierarquia, handoff e retorno entre agentes
└── __AGENT_SLUG__/                        ← identidade do orquestrador (um diretório por agente)
```
