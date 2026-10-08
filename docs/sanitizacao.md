# Sanitização (para quem mantém um fork público)

Antes de publicar qualquer mudança vinda da sua instância real:

1. Crie `.sanitize-denylist` (não versionado): um termo por linha — nome da empresa, pessoas, clientes, hosts, domínios internos.
2. Rode `tools/check-template.sh`. Ele falha se encontrar termos da lista, IPs, e-mails, caminhos de home pessoal, secrets ou placeholders quebrados.
3. Copie **estrutura e regra**, nunca conteúdo: o template leva o formato de uma decisão, não a decisão.
4. Exemplos usam nomes fictícios (`Acme`, `Maria`).
