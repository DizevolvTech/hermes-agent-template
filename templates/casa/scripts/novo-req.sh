#!/usr/bin/env bash
# Cria um pedido operacional a partir do modelo. Uso: scripts/novo-req.sh <DESTINO> <ASSUNTO>
set -euo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
D="$(echo "${1:?DESTINO}" | tr '[:lower:] ' '[:upper:]-')"; A="$(echo "${2:?ASSUNTO}" | tr '[:lower:] ' '[:upper:]-')"
ID="REQ-$D-$A-$(date -u +%Y%m%dT%H%M%SZ)"
sed "s/^# REQ-.*/# $ID/" "$CASA/governance/templates/REQ.md" > "$CASA/handoffs/$ID.md"
echo "$CASA/handoffs/$ID.md"
