# Política de operação do cérebro

## Regra principal
Leveza, auditabilidade e removibilidade. Consolidar ou remover antes de criar.

## Hierarquia de fontes
1. Decisão humana registrada (`decisions.md`) · 2. `current-status.md` · 3. contratos e políticas · 4. demais documentos · 5. chat (só orienta busca).

## Modos de operação
1. **Leitura institucional** — livre, seletiva (MAPA → busca).
2. **Auditoria** — lê e aponta divergências; não corrige por inferência.
3. **Proposta de escrita** — mostra diff/texto antes de gravar.
4. **Escrita controlada** — grava dentro de gate; hook valida; commit descreve o porquê.
5. **Sync/Git** — sempre por `scripts/sync.sh` (`CONTRATO-SYNC-GIT.md`): valida, commita, integra o remoto, envia. Sem `--force`, sem `--no-verify`; conflito = HOLD.
6. **Cadência recorrente** — só rotinas presentes em `REGISTRO-RECORRENCIAS.json`.

## Contribuição de outros agentes
Agentes subordinados propõem; o orquestrador revisa e grava (ou o agente grava dentro de gate próprio).

## Escrita no runtime
Identidade chega ao runtime só por `projetar.sh`. Nunca editar `~/.hermes/SOUL.md` nem o bloco gerado no `AGENTS.md` da casa à mão.
