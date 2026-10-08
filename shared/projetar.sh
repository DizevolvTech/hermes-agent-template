#!/usr/bin/env bash
# Projeção quente: leva a identidade canônica para onde o Hermes realmente lê.
#   SOUL.md   → $HERMES_HOME/SOUL.md  (slot de identidade; HERMES_HOME pode ser um perfil)
#   AGENTS.md → bloco gerado no AGENTS.md desta casa, quando a identidade mora no cérebro
#               (o Hermes carrega AGENTS.md do diretório de trabalho = terminal.cwd, não do HERMES_HOME)
# De onde vem a identidade (.casa.conf → IDENTITY_SRC):
#   orquestrador: $CEREBRO_PATH/cerebro/agentes/<slug>  (identidade mora no cérebro)
#   agente macro: a própria casa                          (identidade mora na casa; só o SOUL é projetado)
# Uso: scripts/projetar.sh [--check | --dry-run]
#   --check    não escreve; sai 1 se houver drift entre cérebro e destinos
#   --dry-run  mostra o que mudaria
set -euo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
source "$CASA/.casa.conf"
SRC="$IDENTITY_SRC"
MODE="${1:-apply}"
BEGIN="<!-- BEGIN projecao-cerebro: gerado por scripts/projetar.sh; edite no cérebro -->"
END="<!-- END projecao-cerebro -->"
[[ -d "$SRC" ]] || { echo "ERRO: $SRC não existe (ajuste IDENTITY_SRC/CEREBRO_PATH em .casa.conf)"; exit 2; }
drift=0
# Rótulo da fonte sem caminho da máquina (ex.: minha-org-cerebro/cerebro/agentes/orion), igual em qualquer clone
SRC_ABS="$(cd "$SRC" && pwd)"; SRC_TOP="$(git -C "$SRC_ABS" rev-parse --show-toplevel 2>/dev/null || echo "$SRC_ABS")"
SRC_LABEL="$(basename "$SRC_TOP")${SRC_ABS#"$SRC_TOP"}"

apply() { # apply <rótulo> <destino> <conteúdo desejado>
  local label="$1" dest="$2" want="$3" have
  have="$(cat "$dest" 2>/dev/null || true)"
  if [[ "$want" == "$have" ]]; then echo "OK        $label"; return; fi
  drift=1
  case "$MODE" in
    --check)   echo "DRIFT     $label" ;;
    --dry-run) echo "MUDARIA   $label"; diff <(echo "$have") <(echo "$want") | head -20 || true ;;
    *) if [[ -f "$dest" ]]; then   # backup fora do Git: casa → var/state/, runtime → próprio HERMES_HOME
         bdir="$(dirname "$dest")"; [[ "$bdir" == "$CASA" ]] && bdir="$CASA/var/state" && mkdir -p "$bdir"
         cp "$dest" "$bdir/$(basename "$dest").bak-$(date +%Y%m%dT%H%M%S)"
       fi
       printf '%s\n' "$want" > "$dest"; echo "PROJETADO $label" ;;
  esac
}

if [[ -d "$HERMES_HOME" ]]; then
  apply "SOUL.md → $HERMES_HOME" "$HERMES_HOME/SOUL.md" \
    "$(cat "$SRC/SOUL.md"; printf '\n<!-- Fonte canônica: %s/SOUL.md · gerado por projetar.sh -->' "$SRC_LABEL")"
else
  echo "AVISO     HERMES_HOME=$HERMES_HOME não existe; SOUL.md não projetado (instale o Hermes ou crie o perfil: hermes profile create $AGENT_SLUG)"; drift=1
fi

if [[ "$(cd "$SRC" && pwd)" != "$CASA" ]]; then
local_part="$(awk -v b="$BEGIN" '$0==b{exit} {print}' "$CASA/AGENTS.md")"
apply "AGENTS.md (bloco do cérebro) → casa" "$CASA/AGENTS.md" \
  "$(printf '%s\n%s\n\n' "$local_part" "$BEGIN"; cat "$SRC/AGENTS.md"; printf '\n%s' "$END")"
fi

[[ "$MODE" == "--check" && $drift -eq 1 ]] && exit 1
exit 0
