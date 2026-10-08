#!/usr/bin/env bash
# Cria um pedido operacional a partir do modelo. Uso: scripts/novo-req.sh <DESTINO> <ASSUNTO>
set -euo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
up() { python3 -c 'import re,sys,unicodedata as u; s=u.normalize("NFKD",sys.argv[1]).encode("ascii","ignore").decode().upper(); print(re.sub(r"[^A-Z0-9]+","-",s).strip("-"))' "$1"; }
D="$(up "${1:?DESTINO}")"; A="$(up "${2:?ASSUNTO}")"
[[ -n "$D" && -n "$A" ]] || { echo "ERRO: destino e assunto precisam ter letras ou números"; exit 1; }
ID="REQ-$D-$A-$(date -u +%Y%m%dT%H%M%SZ)"
sed "s/^# REQ-.*/# $ID/" "$CASA/governance/templates/REQ.md" > "$CASA/handoffs/$ID.md"
echo "$CASA/handoffs/$ID.md"
