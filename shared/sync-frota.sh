#!/usr/bin/env bash
# Sincroniza todos os repos da frota que estão lado a lado: <slug>-cerebro, <slug>-casa, <slug>-casa-*.
# Não commita nada por conta própria: só integra o remoto e envia commits já feitos.
# Repo com alterações não commitadas é apontado (o dono dele decide a mensagem).
# Uso: scripts/sync-frota.sh [--check]
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
PARENT="$(dirname "$HERE")"
CASA="$HERE"
if [[ -f "$HERE/.casa.conf" ]]; then source "$HERE/.casa.conf"; elif [[ -f "$HERE/.frota.conf" ]]; then source "$HERE/.frota.conf"; fi
[[ -n "${SLUG:-}" ]] || { echo "ERRO: SLUG não encontrado em .casa.conf/.frota.conf"; exit 2; }
rc=0
for r in "$PARENT/$SLUG-cerebro" "$PARENT/$SLUG-casa" "$PARENT/$SLUG"-casa-*; do
  [[ -x "$r/scripts/sync.sh" ]] || continue
  if [[ "${1:-}" == "--check" ]]; then "$r/scripts/sync.sh" --check; continue; fi
  if [[ -n "$(git -C "$r" status --porcelain)" ]]; then
    echo "[$(basename "$r")] PENDENTE: alterações sem commit; o agente dono deve rodar scripts/sync.sh \"mensagem\""; rc=1; continue
  fi
  "$r/scripts/sync.sh" || rc=1
done
exit $rc
