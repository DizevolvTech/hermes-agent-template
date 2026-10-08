#!/usr/bin/env bash
# Projeção quente: copia a identidade canônica do cérebro para o runtime Hermes.
# Uso: scripts/projetar.sh [--check] [--dry-run]
#   --check    não escreve; sai 1 se houver drift entre cérebro e runtime
#   --dry-run  mostra o que mudaria
set -euo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
source "$CASA/.casa.conf"
SRC="$CEREBRO_PATH/cerebro/agentes/$AGENT_SLUG"
MODE="${1:-apply}"
[[ -d "$SRC" ]] || { echo "ERRO: $SRC não existe (CEREBRO_PATH em .casa.conf)"; exit 2; }
[[ -d "$HERMES_HOME" ]] || { echo "ERRO: HERMES_HOME=$HERMES_HOME não existe (instale o Hermes primeiro)"; exit 2; }
drift=0
for f in SOUL.md AGENTS.md; do
  want="$(cat "$SRC/$f"; printf '\n<!-- Fonte canônica: %s/%s · gerado por projetar.sh. Não edite aqui. -->\n' "$SRC" "$f")"
  have="$(cat "$HERMES_HOME/$f" 2>/dev/null || true)"
  if [[ "$want" == "$have" ]]; then echo "OK      $f"; continue; fi
  drift=1
  case "$MODE" in
    --check)   echo "DRIFT   $f" ;;
    --dry-run) echo "MUDARIA $f"; diff <(echo "$have") <(echo "$want") | head -20 || true ;;
    *)
      [[ -f "$HERMES_HOME/$f" ]] && cp "$HERMES_HOME/$f" "$HERMES_HOME/$f.bak-$(date +%Y%m%dT%H%M%S)"
      printf '%s\n' "$want" > "$HERMES_HOME/$f"; echo "PROJETADO $f" ;;
  esac
done
[[ "$MODE" == "--check" && $drift -eq 1 ]] && exit 1
exit 0
