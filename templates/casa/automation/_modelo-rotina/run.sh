#!/usr/bin/env bash
# Modelo de rotina: idempotente, sem secrets no código, saída sanitizada em reports/.
set -euo pipefail
CASA="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="$CASA/reports/$(basename "$(dirname "$0")")-$(date -u +%Y%m%dT%H%M%SZ).md"
echo "# Relatório $(date -u +%FT%TZ)" > "$OUT"
echo "OK $OUT"
