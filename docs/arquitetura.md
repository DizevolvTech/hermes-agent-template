# Arquitetura

## Três camadas, três perguntas

| Camada | Versionada? | Pergunta | Exemplos |
|---|---|---|---|
| Cérebro | sim (repo privado) | O que sabemos e decidimos? | decisões, lições, status, SOUL, contratos |
| Casa | sim (repo privado) | Como o agente executa? | bootstrap, rotinas, skills, scripts, memória curta |
| Runtime | **não** | Com o que ele roda agora? | `config.yaml`, `.env`, sessões, logs, banco, cron jobs |

## Princípios

1. **Fonte canônica única.** Identidade e regras são editadas no cérebro e *projetadas* para o runtime. O runtime nunca é editado à mão; `projetar.sh --check` detecta drift.
2. **Índice, não depósito.** `MEMORY.md` aponta para fontes; não acumula texto. `MAPA.md` em toda pasta mantém o cérebro navegável — e o hook impede que fique desatualizado.
3. **Estado atual vence histórico.** `current-status.md` prevalece; decisões e lições são buscadas por data/palavra-chave, não carregadas inteiras.
4. **Capturar ao fechar.** Cada tarefa termina classificando o resultado (decisão, lição, status, pendência, nada) e escrevendo na menor casa possível.
5. **Remover antes de criar.** Nova pasta, agente ou rotina passa por um gate: necessidade, owner, validação e rollback.
6. **Nada sensível versionado.** Scanner de secrets no commit; runtime fora dos repos.

## Formato das entradas

```markdown
### <Agente> — <estado>, AAAA-MM-DD          ← current-status.md (mais recente primeiro)
## AAAA-MM-DD — <escopo>: <título>           ← decisions.md / lessons.md
```

Seções que deixaram de valer recebem `[SUPERADO]` no título em vez de serem apagadas.

## Vários agentes

Um diretório por agente em `cerebro/agentes/`, um perfil Hermes por agente
(`hermes profile create <nome>` → `~/.hermes/profiles/<nome>`) e, quando o agente
crescer, uma casa própria (`<slug>-casa-<agente>`). A `TOPOLOGIA.md` é a tabela de verdade.
