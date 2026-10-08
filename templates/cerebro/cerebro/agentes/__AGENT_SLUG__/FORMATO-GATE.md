# Formato de gate explícito

Toda ação fora de "institucional comum" precisa de um gate com **todos** os campos.
Gate incompleto = `HOLD`.

**Modos:** leitura · auditoria · escrita-controlada · runtime · sync-git · canal-externo · infraestrutura

```text
gate_id:
modo:
objetivo:
casa_canonica:
owner_aprovador:
arquivos_permitidos:
arquivos_comandos_proibidos:
risco:
mudanca_proposta:
validacao_prevista:
criterio_aceite:
rollback:
registro:
```

**Aceite:** critério cumprido + validação executada + registro feito. Sem isso o gate fica aberto.
Modelo para preencher: `{{SLUG}}-casa/governance/templates/GATE.md`.
