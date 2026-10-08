# Changelog

## 1.2.0

- Frota completa no modelo de produção: orquestrador + agentes macro por área (`novo-agente.sh`).
- Cérebro com as áreas de negócio, contexto da empresa (pessoas, canais, métricas, regras de repositórios, playbooks, brand),
  `TOPOLOGIA-MACRO-AGENTES.md`, ponteiros por agente, princípio de qualidade, contrato de acesso, changelog do modelo e evals.
- Casa de agente macro com identidade própria, HEARTBEAT, memória (context/integrations/projects/sessions), skills e áreas.
- Scripts compartilhados em `shared/` (fonte única); `projetar.sh` serve orquestrador e agentes macro (perfis).
- README reescrito: como funciona, por que assim, estrutura completa, crescimento por área; `docs/runtime.md`.

## 1.1.0 — 2026-10-08

- Setup interativo: missão, idioma/fuso, canal; marcadores `[[PREENCHER]]` + `checar-configuracao.sh`.
- Repos privados criados na conta GitHub do usuário (padrão quando `gh` está logado).
- Correção: o `AGENTS.md` do agente agora é projetado para o `AGENTS.md` da casa (o Hermes carrega do diretório de trabalho, não do `HERMES_HOME`).
- Correções: reconciliador resolvia `HERMES_HOME` errado sem a variável no ambiente; validador da casa falhava com arquivos locais em `var/`; exige identidade Git antes de gerar.

## 1.0.0 — 2026-10-08

- Primeira versão pública: setup.sh gera cérebro + casa; validadores, hooks, projeção com drift, gate de sanitização.
