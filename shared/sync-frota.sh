#!/usr/bin/env bash
# Sincroniza todos os repos da frota que estão lado a lado: <slug>-cerebro, <slug>-casa, <slug>-casa-*.
# Não commita nada por conta própria: só integra o remoto e envia commits já feitos.
# Repo com alterações não commitadas é apontado (o dono dele decide a mensagem).
# Uso: scripts/sync-frota.sh [--check]
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
PARENT="$(dirname "$HERE")"
SLUG="$(basename "$HERE" | sed -E 's/-(cerebro|casa(-.*)?)$//')"
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
