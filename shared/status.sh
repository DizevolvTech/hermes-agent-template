#!/usr/bin/env bash
# Status sanitizado do agente (sem secrets, sem logs). Saída em linhas chave=valor.
set -uo pipefail
CASA="$(cd "$(dirname "$0")/.." && pwd)"
source "$CASA/.casa.conf"
echo "host=$(hostname)"
echo "hermes_version=$(hermes --version 2>/dev/null | head -1 || echo ausente)"
echo "hermes_home=$HERMES_HOME"
echo "config_yaml=$([[ -f $HERMES_HOME/config.yaml ]] && echo presente || echo ausente)"
echo "env_file=$([[ -f $HERMES_HOME/.env ]] && echo presente || echo ausente)"
echo "projecao=$("$CASA/scripts/projetar.sh" --check >/dev/null 2>&1 && echo sem_drift || echo DRIFT)"
echo "hooks_casa=$(git -C "$CASA" config core.hooksPath || echo DESATIVADOS)"
echo "config_pendente=$("$CASA/scripts/checar-configuracao.sh" 2>/dev/null | tail -1)"
echo "casa_git=$(git -C "$CASA" status --porcelain | wc -l) alteracoes"
echo "cerebro_git=$(git -C "$CEREBRO_PATH" status --porcelain 2>/dev/null | wc -l) alteracoes"
echo "gateway=$(hermes gateway status 2>/dev/null | head -1 || echo desconhecido)"
