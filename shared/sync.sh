#!/usr/bin/env bash
# Sync padrão (igual em todos os repos da frota): valida → commita → integra o remoto → envia.
#
# Uso:
#   scripts/sync.sh "tipo: o que mudou e por quê"   # commita o que mudou e faz push
#   scripts/sync.sh                                   # só traz o remoto e envia commits pendentes
#   scripts/sync.sh --check                           # não altera nada; mostra o estado do sync
#
# Regras (CONTRATO-SYNC-GIT.md): só na branch main · nunca force · conflito = PARA e avisa (HOLD) ·
# os hooks validam MAPA/estrutura/secrets antes de cada commit.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
REPO="$(basename "$PWD")"
BR="main"
say()  { echo "[$REPO] $*"; }
hold() { echo "[$REPO] HOLD_SYNC: $*"; exit 3; }

[[ "$(git branch --show-current)" == "$BR" ]] || hold "não está na branch $BR"
git config core.hooksPath >/dev/null || git config core.hooksPath .githooks
[[ -d .git/rebase-merge || -d .git/rebase-apply || -f .git/MERGE_HEAD ]] && hold "rebase/merge em andamento; resolva antes"
HAS_REMOTE=0; git remote get-url origin >/dev/null 2>&1 && HAS_REMOTE=1

if [[ "${1:-}" == "--check" ]]; then
  [[ $HAS_REMOTE -eq 1 ]] && { git fetch -q origin "$BR" 2>/dev/null || true; }
  echo "repo=$REPO alteracoes=$(git status --porcelain | wc -l) remoto=$([[ $HAS_REMOTE -eq 1 ]] && echo sim || echo NAO)" \
       "a_enviar=$(git rev-list --count "origin/$BR..HEAD" 2>/dev/null || echo ?)" \
       "a_receber=$(git rev-list --count "HEAD..origin/$BR" 2>/dev/null || echo ?)"
  exit 0
fi

MSG="${1:-}"
if [[ -n "$(git status --porcelain)" ]]; then
  [[ -n "$MSG" ]] || hold "há alterações e nenhuma mensagem de commit; rode: scripts/sync.sh \"tipo: o que mudou\""
  git add -A
  git commit -q -m "$MSG" || hold "commit bloqueado pelos hooks (veja acima); corrija e rode de novo"
  say "commit: $MSG"
fi

if [[ $HAS_REMOTE -eq 0 ]]; then
  say "sem remoto 'origin': commit local apenas. Crie o repo privado e rode: git remote add origin <url>"
  exit 0
fi

for tentativa in 1 2 3; do
  heads="$(git ls-remote --heads origin "$BR" 2>/dev/null)" || hold "não consegui acessar o remoto (rede ou credencial: gh auth login / chave SSH)"
  if [[ -n "$heads" ]]; then   # remoto já tem a branch: integra antes de enviar (repo novo/vazio: envia direto)
    git fetch -q origin "$BR" 2>/dev/null || hold "falha ao buscar origin/$BR"
    git rebase -q "origin/$BR" 2>/dev/null || { git rebase --abort 2>/dev/null; hold "conflito com o remoto; precisa de decisão humana (nada foi perdido)"; }
  fi
  if out="$(git push -q -u origin "$BR" 2>&1)"; then
    say "SYNC_OK $(git rev-parse --short HEAD)"; exit 0
  fi
  if grep -q 'PRE_PUSH_FAIL' <<<"$out"; then
    echo "$out" | grep -v '^error: failed to push' ; hold "push bloqueado pela validação (commit feito sem passar pelos hooks?); corrija e faça um commit novo"
  fi
  sleep $((tentativa * 2))   # outro agente enviou ao mesmo tempo: integra e tenta de novo
done
hold "push recusado após 3 tentativas"
