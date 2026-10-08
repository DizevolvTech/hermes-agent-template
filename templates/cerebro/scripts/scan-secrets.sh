#!/usr/bin/env bash
# Scan fail-closed por secrets em arquivos versionados. Nunca imprime o valor.
# Uso: scripts/scan-secrets.sh [--staged]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
PATTERNS=(
  'ghp_[A-Za-z0-9]{36}' 'github_pat_[A-Za-z0-9_]{22,}' 'sk-[A-Za-z0-9_-]{20,}'
  'sk-ant-[A-Za-z0-9_-]{20,}' 'xox[baprs]-[A-Za-z0-9-]{10,}' 'AKIA[0-9A-Z]{16}'
  '-----BEGIN [A-Z ]*PRIVATE KEY-----' '[0-9]{8,10}:AA[A-Za-z0-9_-]{33}'
  'eyJ[A-Za-z0-9_-]{20,}\.eyJ[A-Za-z0-9_-]{20,}' 'tskey-[a-z]+-[A-Za-z0-9-]{10,}'
  'AIza[0-9A-Za-z_-]{35}'
)
if [[ "${1:-}" == "--staged" ]]; then FILES="$(git diff --cached --name-only --diff-filter=ACM)"; else FILES="$(git ls-files)"; fi
hits=0
for pat in "${PATTERNS[@]}"; do
  while IFS= read -r hit; do
    [[ -z "$hit" ]] && continue
    echo "HOLD_SECRET: padrão suspeito em $hit"; hits=$((hits+1))
  done < <(echo "$FILES" | xargs -r grep -InE --binary-files=without-match -e "$pat" 2>/dev/null | cut -d: -f1,2 || true)
done
# Arquivos que nunca devem ser versionados
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  case "$(basename "$f")" in
    .env|.env.*|auth.json|*.pem|*.key|id_rsa*|id_ed25519*|credentials*.json) [[ "$f" == *.example ]] || { echo "HOLD_SECRET: arquivo proibido versionado: $f"; hits=$((hits+1)); } ;;
  esac
done <<< "$FILES"
if [[ $hits -gt 0 ]]; then echo "FAIL: $hits ocorrência(s). Remova do Git e rotacione a credencial."; exit 2; fi
echo "PASS_SECRETS"
