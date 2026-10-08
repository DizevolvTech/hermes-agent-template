#!/usr/bin/env bash
# Projeção quente: leva a identidade canônica do cérebro para onde o Hermes realmente lê.
#   SOUL.md   do agente → $HERMES_HOME/SOUL.md     (slot de identidade, sempre carregado)
#   AGENTS.md do agente → bloco gerado no AGENTS.md desta casa
#                         (o Hermes carrega AGENTS.md do diretório de trabalho = terminal.cwd,
#                          não do HERMES_HOME)
# Uso: scripts/projetar.sh [--check | --dry-run]
#   --check    não escreve; sai 1 se houver drift entre cérebro e destinos
#   --dry-run  mostra o que mudaria
set -euo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
source "$CASA/.casa.conf"
SRC="$CEREBRO_PATH/cerebro/agentes/$AGENT_SLUG"
MODE="${1:-apply}"
BEGIN="<!-- BEGIN projecao-cerebro: gerado por scripts/projetar.sh; edite no cérebro -->"
END="<!-- END projecao-cerebro -->"
[[ -d "$SRC" ]] || { echo "ERRO: $SRC não existe (ajuste CEREBRO_PATH em .casa.conf)"; exit 2; }
drift=0

apply() { # apply <rótulo> <destino> <conteúdo desejado>
  local label="$1" dest="$2" want="$3" have
  have="$(cat "$dest" 2>/dev/null || true)"
  if [[ "$want" == "$have" ]]; then echo "OK        $label"; return; fi
  drift=1
  case "$MODE" in
    --check)   echo "DRIFT     $label" ;;
    --dry-run) echo "MUDARIA   $label"; diff <(echo "$have") <(echo "$want") | head -20 || true ;;
    *) [[ -f "$dest" ]] && cp "$dest" "$dest.bak-$(date +%Y%m%dT%H%M%S)"
       printf '%s\n' "$want" > "$dest"; echo "PROJETADO $label" ;;
  esac
}

if [[ -d "$HERMES_HOME" ]]; then
  apply "SOUL.md → $HERMES_HOME" "$HERMES_HOME/SOUL.md" \
    "$(cat "$SRC/SOUL.md"; printf '\n<!-- Fonte canônica: %s/SOUL.md · gerado por projetar.sh -->' "$SRC")"
else
  echo "AVISO     HERMES_HOME=$HERMES_HOME não existe; SOUL.md não projetado (instale o Hermes)"; drift=1
fi

local_part="$(awk -v b="$BEGIN" '$0==b{exit} {print}' "$CASA/AGENTS.md")"
apply "AGENTS.md (bloco do cérebro) → casa" "$CASA/AGENTS.md" \
  "$(printf '%s\n%s\n\n' "$local_part" "$BEGIN"; cat "$SRC/AGENTS.md"; printf '\n%s' "$END")"

[[ "$MODE" == "--check" && $drift -eq 1 ]] && exit 1
exit 0
