# AGENTS.md — Cérebro {{ORG_NAME}}

Este repo é a fonte canônica de contexto. Não é runtime, cache nem rascunho.

## Ordem de carregamento (não carregar tudo por reflexo)

1. `cerebro/agentes/{{AGENT_SLUG}}/AGENTS.md` — bootstrap do agente.
2. `cerebro/MAPA.md` — navegação por intenção.
3. Contexto seletivo da tarefa: `cerebro/empresa/contexto/current-status.md`
   (estado atual prevalece), depois `decisions.md` / `lessons.md` por busca
   (palavra-chave ou data), nunca leitura integral.
4. Contratos em `cerebro/agentes/` só quando a tarefa tocar o tema.

## Regras

- Separar fato verificado, decisão humana, hipótese e desconhecido.
- Conflito entre fontes: declarar a divergência e propor reconciliação; não escolher em silêncio.
- Mudança estrutural exige atualizar o `MAPA.md` da pasta no mesmo commit.
- Fechamento de tarefa: aplicar `cerebro/agentes/CONTRATO-CAPTURA-APRENDIZADOS.md`.
- Nunca versionar secrets, `.env`, tokens, sessões ou logs brutos.
