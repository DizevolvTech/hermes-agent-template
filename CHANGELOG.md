# Changelog

## 1.1.0 — 2026-10-08

- Setup interativo: missão, idioma/fuso, canal; marcadores `[[PREENCHER]]` + `checar-configuracao.sh`.
- Repos privados criados na conta GitHub do usuário (padrão quando `gh` está logado).
- Correção: o `AGENTS.md` do agente agora é projetado para o `AGENTS.md` da casa (o Hermes carrega do diretório de trabalho, não do `HERMES_HOME`).
- Correções: reconciliador resolvia `HERMES_HOME` errado sem a variável no ambiente; validador da casa falhava com arquivos locais em `var/`; exige identidade Git antes de gerar.

## 1.0.0 — 2026-10-08

- Primeira versão pública: setup.sh gera cérebro + casa; validadores, hooks, projeção com drift, gate de sanitização.
