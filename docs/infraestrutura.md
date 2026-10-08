# Infraestrutura

## Uma máquina (recomendado para começar)

```text
~/minha-empresa-cerebro   (git, remoto privado)
~/minha-empresa-casa      (git, remoto privado) ← terminal.cwd do Hermes
~/.hermes                 (runtime, sem git; faça backup cifrado)
```

O agente lê o cérebro direto do disco. Para escrever registros, ele commita no cérebro;
o push pode ser seu (revisão humana) ou do agente com uma deploy key de escrita restrita ao repo.

## Duas máquinas

Ex.: cérebro editado num host de operação, agente rodando em outro.
- Opção A: clone nos dois hosts com **deploy keys por repo** (leitura no host do agente).
- Opção B: sem credencial de GitHub no host do agente — `casa/scripts/sync-bundle.sh <repo> user@host <caminho>` (git bundle + `merge --ff-only`, recusa worktree suja).

## Serviço

Prefira o gerenciador do próprio Hermes (`hermes gateway start`). Se precisar de systemd
manual, use `casa/hermes/systemd/hermes-gateway.service.example` e confirme
`HERMES_HOME` e `WorkingDirectory` — é isso que prova qual casa o agente usa de verdade.
