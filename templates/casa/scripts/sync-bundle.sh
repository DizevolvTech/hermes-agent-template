#!/usr/bin/env bash
# Leva um repo (cérebro ou casa) para outro host SEM dar ao host credencial de GitHub.
# Usa git bundle + scp + merge --ff-only. Útil quando cérebro e casa rodam em VPS diferentes.
# Uso: scripts/sync-bundle.sh <repo_local> <ssh_destino> <caminho_remoto> [branch]
set -euo pipefail
REPO="${1:?repo local}"; DEST="${2:?ssh destino, ex.: user@host}"; RPATH="${3:?caminho remoto}"; BR="${4:-main}"
cd "$REPO"
[[ "$(git branch --show-current)" == "$BR" ]] || { echo "ERRO: não está em $BR"; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "ERRO: worktree suja"; exit 1; }
B="$(mktemp -u /tmp/sync-XXXX).bundle"; git bundle create "$B" "$BR" >/dev/null
scp -q "$B" "$DEST:$B"; rm -f "$B"
ssh "$DEST" bash -s -- "$RPATH" "$BR" "$B" <<'REMOTE'
set -euo pipefail; cd "$1"
[[ "$(git branch --show-current)" == "$2" && -z "$(git status --porcelain)" ]] || { echo "ERRO remoto: branch/worktree"; exit 1; }
git fetch -q "$3" "$2:refs/remotes/bundle/$2" && git merge -q --ff-only "bundle/$2"; rm -f "$3"
echo "SYNC_OK $(git rev-parse --short HEAD)"
REMOTE
