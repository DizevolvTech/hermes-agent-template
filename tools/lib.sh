# Funções comuns do gerador (source, não executar).
TPL="${TPL:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

kebab() { echo "$1" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-|-$//g'; }
fill()  { [[ -n "$1" ]] && echo "$1" || echo "[[PREENCHER: $2]]"; }

require_git_identity() {
  for bin in git perl python3; do command -v "$bin" >/dev/null || { echo "ERRO: falta '$bin'"; exit 1; }; done
  if [[ -z "$(git config user.name || true)" || -z "$(git config user.email || true)" ]]; then
    echo "ERRO: configure sua identidade Git antes:"
    echo '  git config --global user.name "Seu Nome"'
    echo '  git config --global user.email "seu-usuario@users.noreply.github.com"   # e-mail que pode ficar público'
    exit 1
  fi
}

# render <tipo: cerebro|casa|casa-macro> <destino>
# Usa as variáveis exportadas: ORG AGENT OWNER SLUG AGENT_SLUG TODAY CEREBRO CASA MISSION ABOUT LOCALE CHANNEL HOST AREA ORCH ORCH_SLUG
render() {
  local kind="$1" dst="$2" f
  cp -a "$TPL/templates/$kind" "$dst"
  mkdir -p "$dst/scripts" "$dst/.githooks"
  cp "$TPL/shared/pre-commit" "$dst/.githooks/"
  cp "$TPL/shared/scan-secrets.sh" "$TPL/shared/checar-configuracao.sh" "$TPL/shared/sync.sh" "$TPL/shared/sync-frota.sh" "$dst/scripts/"
  if [[ "$kind" != cerebro ]]; then
    cp "$TPL/shared/projetar.sh" "$TPL/shared/status.sh" "$TPL/shared/sync-bundle.sh" "$TPL/shared/validate-casa.py" "$dst/scripts/"
  fi
  chmod +x "$dst"/scripts/* "$dst"/.githooks/*
  find "$dst" -depth -name '*__AGENT_SLUG__*' -execdir bash -c 'mv "$1" "${1//__AGENT_SLUG__/$2}"' _ {} "$AGENT_SLUG" \;
  find "$dst" -type f ! -path '*/.git/*' -print0 | while IFS= read -r -d '' f; do
    grep -Iq . "$f" 2>/dev/null || continue
    perl -pi -e 's/\{\{ORG_NAME\}\}/$ENV{ORG}/g; s/\{\{AGENT_NAME\}\}/$ENV{AGENT}/g; s/\{\{OWNER_NAME\}\}/$ENV{OWNER}/g;
                 s/\{\{SLUG\}\}/$ENV{SLUG}/g; s/\{\{AGENT_SLUG\}\}|__AGENT_SLUG__/$ENV{AGENT_SLUG}/g; s/\{\{DATE\}\}/$ENV{TODAY}/g;
                 s/\{\{CEREBRO_PATH\}\}/$ENV{CEREBRO}/g; s/\{\{CASA_PATH\}\}/$ENV{CASA}/g; s/\{\{MISSION\}\}/$ENV{MISSION}/g;
                 s/\{\{ABOUT\}\}/$ENV{ABOUT}/g; s/\{\{LOCALE\}\}/$ENV{LOCALE}/g; s/\{\{CHANNEL\}\}/$ENV{CHANNEL}/g;
                 s/\{\{HOST\}\}/$ENV{HOST}/g; s/\{\{AREA\}\}/$ENV{AREA}/g; s/\{\{ORCH_NAME\}\}/$ENV{ORCH}/g;
                 s/\{\{ORCH_SLUG\}\}/$ENV{ORCH_SLUG}/g' "$f"
  done
}

# git_init <repo> <mensagem>
git_init() {
  printf '%s\n' "$(cat "$TPL/VERSION")" > "$1/.template-version"
  git -C "$1" init -q -b main
  git -C "$1" config core.hooksPath .githooks
  git -C "$1" add -A
  git -C "$1" commit -q -m "$2"
  echo "OK  $1"
}

# ask_github → define GH (conta/org) ou NOGH=1
ask_github() {
  [[ $NOGH -eq 1 || -n "$GH" ]] && return
  command -v gh >/dev/null && gh auth status >/dev/null 2>&1 || return 0
  local me v; me="$(gh api user --jq .login 2>/dev/null || true)"
  [[ -n "$me" && $YES -eq 0 ]] || return 0
  read -r -p "Criar repo(s) PRIVADO(s) no GitHub em qual conta/org? [$me] (digite 'nao' para pular): " v
  case "${v:-$me}" in nao|não|n|N) NOGH=1;; *) GH="${v:-$me}";; esac
}

# gh_publish <repo_local>
gh_publish() {
  command -v gh >/dev/null || { echo "ERRO: instale e logue o gh (gh auth login) ou use --sem-github"; exit 1; }
  gh repo create "$GH/$(basename "$1")" --private --source "$1" --remote origin --push >/dev/null
  git -C "$1" branch -q --set-upstream-to=origin/main main 2>/dev/null || true
  # Para os agentes conseguirem fazer push depois com a mesma credencial do gh
  gh auth setup-git >/dev/null 2>&1 || true
  echo "GitHub OK  https://github.com/$GH/$(basename "$1") (privado)"
}
