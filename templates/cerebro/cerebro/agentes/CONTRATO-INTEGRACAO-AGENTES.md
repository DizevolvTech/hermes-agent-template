# Contrato — integração entre agentes (orquestrador ↔ especialistas)

## Hierarquia
O orquestrador ({{AGENT_NAME}}) é pai organizacional dos demais agentes: define fluxos, audita e delega.
Especialistas executam no seu domínio e devolvem retorno. Ownership não muda por quem fez o pedido.

## Handoff (entrada mínima)
origem · destino · orquestrador · owner humano · casa canônica · objetivo · contexto mínimo (links) ·
limites (o que NÃO fazer) · critério de aceite · prazo.

## Retorno (saída mínima)
o que foi feito · evidência sanitizada · pendências · registro feito (decisão/lição/status).

## Regras
- Handoff vive em `agentes/<orquestrador>/handoffs/`; pedidos operacionais (`REQ-*`) vivem na casa.
- Destino sem capacidade/permissão → devolve `HOLD` com o motivo, não improvisa.
