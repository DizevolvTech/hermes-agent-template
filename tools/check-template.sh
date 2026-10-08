#!/usr/bin/env bash
# Gate antes de publicar o template: sanitização + teste ponta a ponta.
#   1. Nenhum termo da lista privada .sanitize-denylist (não versionada) aparece.
#   2. Nenhum IP, e-mail real ou caminho de home pessoal.
#   3. Nenhum secret (scan-secrets).
#   4. setup.sh gera os dois repos e os validadores passam.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
FILES=$(git ls-files 2>/dev/null || find . -type f ! -path './.git/*')
if [[ -f .sanitize-denylist ]]; then
  while IFS= read -r term; do
    [[ -z "$term" || "$term" == \#* ]] && continue
    if echo "$FILES" | xargs grep -Iilw -- "$term" 2>/dev/null | grep -v '^.sanitize-denylist$'; then
      echo "SANITIZE_FAIL: termo privado encontrado (veja arquivos acima)"; fail=1
    fi
  done < .sanitize-denylist
else
  echo "AVISO: sem .sanitize-denylist local (crie com nomes da empresa, pessoas, clientes, hosts)."
fi
if echo "$FILES" | xargs grep -InE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[a-z]{2,}|/home/[a-z]+/' 2>/dev/null | grep -v 'tools/check-template.sh' | grep -v '@t\b'; then
  echo "SANITIZE_FAIL: IP, e-mail ou home pessoal"; fail=1
fi
bash shared/scan-secrets.sh || fail=1
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
GIT_AUTHOR_NAME=ci GIT_AUTHOR_EMAIL=ci@example.invalid GIT_COMMITTER_NAME=ci GIT_COMMITTER_EMAIL=ci@example.invalid \
  ./setup.sh --org "Exemplo SA" --agente "Teste" --owner "Owner" --destino "$T" --sim >/dev/null || fail=1
if grep -rn '{{[A-Z_]*}}\|__AGENT_SLUG__' --exclude-dir=.git "$T"; then echo "FAIL: placeholder não substituído"; fail=1; fi
[[ $fail -eq 0 ]] && echo "PASS_TEMPLATE" || { echo "FAIL_TEMPLATE"; exit 1; }
