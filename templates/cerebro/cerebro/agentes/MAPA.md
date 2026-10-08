# MAPA — agentes

> Owner: {{OWNER_NAME}} · Última validação: {{DATE}} · Revalidar quando: entrar/sair agente ou contrato

```text
agentes/
├── README.md                              ← roteamento: o que vai para cérebro x casa x runtime
├── TOPOLOGIA-MACRO-AGENTES.md             ← quem é quem: tipo, domínio, host, runtime, casa, canais
├── PRINCIPIO-QUALIDADE-OPERACIONAL.md     ← gate para criar qualquer coisa
├── CONTRATO-ACESSO-CEREBRO-AGENTES.md     ← quem lê/escreve o quê no cérebro
├── CONTRATO-CARREGAMENTO-CONTEXTO.md      ← ordem e limites de leitura de contexto
├── CONTRATO-CAPTURA-APRENDIZADOS.md       ← fechamento de tarefa: o que vira registro
├── CONTRATO-PROPAGACAO-MUDANCAS.md        ← fonte canônica → projeção quente → validação
├── CONTRATO-INTEGRACAO-AGENTES.md         ← hierarquia, handoff e retorno entre agentes
├── CONTRATO-SYNC-GIT.md                   ← como e quando cada agente faz commit + push
├── CONTRATO-CICLO-VIDA-AGENTES.md         ← criar, pilotar, ativar, pausar, aposentar agente
├── CHANGELOG-MODELO-OPERACIONAL.md        ← histórico de mudanças no modelo da frota
├── evals/                                 ← casos de teste de comportamento
└── __AGENT_SLUG__/                        ← identidade completa do orquestrador
```

## Agentes macro de área (ponteiros; identidade completa na casa de cada um)

<!-- novo-agente.sh acrescenta linhas abaixo -->
