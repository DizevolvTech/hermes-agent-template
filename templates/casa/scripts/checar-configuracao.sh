#!/usr/bin/env bash
# Lista o que ainda precisa ser adaptado à sua realidade (marcadores [[PREENCHER: ...]]).
# Não bloqueia commit: é um checklist. Sai 1 enquanto houver pendência.
set -uo pipefail
cd "$(dirname "$0")/.."
hits="$(grep -rIn --exclude-dir=.git --exclude=checar-configuracao.sh '\[\[PREENCHER' . 2>/dev/null | sed 's|^\./||')"
if [[ -n "$hits" ]]; then
  echo "$hits"
  echo "FALTA_CONFIGURAR: $(echo "$hits" | wc -l) item(ns) acima"; exit 1
fi
echo "CONFIGURADO: nenhum [[PREENCHER]] pendente"
