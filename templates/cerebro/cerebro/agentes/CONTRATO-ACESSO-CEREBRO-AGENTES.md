# Contrato — acesso dos agentes ao cérebro

| Agente | Lê | Escreve |
|---|---|---|
| Orquestrador | tudo (seletivamente) | registros institucionais, contratos (com gate), MAPAs, topologia |
| Agente macro de área | `empresa/contexto/`, `areas/<suas áreas>/`, `agentes/` | `areas/<suas áreas>/` e registros do próprio domínio; o resto por proposta ao orquestrador |
| Humanos | tudo | tudo (o hook valida) |

- Leitura ampla não é permissão para carregar tudo (ver `CONTRATO-CARREGAMENTO-CONTEXTO.md`).
- Escrita sempre por commit com mensagem que diga o porquê; o pre-commit bloqueia MAPA desatualizado e secrets.
- Conteúdo de cliente/produto não entra no cérebro: só ficha, decisão e ponteiro.
