# Decisões

Registro de decisões humanas duráveis. Buscar por data/palavra-chave; não carregar inteiro.
Formato: `## AAAA-MM-DD — <escopo>: <título>` (use `scripts/registrar.py decisao`).

<!-- entradas -->

## {{DATE}} — Estrutura: adotar o par cérebro + casa de execução

- **Decisão:** conhecimento versionado em `{{SLUG}}-cerebro`; execução do agente em `{{SLUG}}-casa`.
- **Autorizado por:** {{OWNER_NAME}}
- **Motivo:** separar o que a organização sabe/decidiu de como o agente executa.
- **Continua bloqueado / fora do escopo:** secrets e estado de runtime não entram em nenhum dos dois repos.
- **Reversão:** os repos são independentes; remover o runtime não afeta o cérebro.
