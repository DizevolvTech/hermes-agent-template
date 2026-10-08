# Infraestrutura

## Uma máquina (recomendado para começar)

```text
~/minha-empresa-cerebro   (git, remoto privado)
~/minha-empresa-casa      (git, remoto privado) ← terminal.cwd do Hermes
~/.hermes                 (runtime, sem git; faça backup cifrado)
```

O agente lê o cérebro direto do disco e **ele mesmo** faz commit e push com `scripts/sync.sh`
(`cerebro/agentes/CONTRATO-SYNC-GIT.md`). A credencial de push fica na máquina: `gh auth login` + `gh auth setup-git`,
ou uma chave SSH/deploy key com escrita só nos repos da frota. Você revisa pelo histórico do GitHub.

## Duas máquinas

Ex.: cérebro editado num host de operação, agente rodando em outro.
- Opção A: clone nos dois hosts com **deploy keys por repo** (leitura no host do agente).
- Opção B: sem credencial de GitHub no host do agente — `casa/scripts/sync-bundle.sh <repo> user@host <caminho>` (git bundle + `merge --ff-only`, recusa worktree suja).

## Serviço

Prefira o gerenciador do próprio Hermes (`hermes gateway start`). Se precisar de systemd
manual, use `casa/hermes/systemd/hermes-gateway.service.example` e confirme
`HERMES_HOME` e `WorkingDirectory` — é isso que prova qual casa o agente usa de verdade.
