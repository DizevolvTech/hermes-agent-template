#!/usr/bin/env bash
# Cria SEU par de repositórios — <slug>-cerebro e <slug>-casa — adaptado à sua realidade
# e (opcionalmente) versionado como repos PRIVADOS na SUA conta do GitHub.
#
# Uso interativo (recomendado):   ./setup.sh
# Uso não interativo:
#   ./setup.sh --org "Minha Empresa" --agente "Atlas" --owner "Maria" \
#              [--missao "..."] [--sobre "..."] [--idioma "pt-BR, UTC-3"] [--canal "Telegram"] \
#              [--slug minha-empresa] [--destino ~/agentes] [--github <conta-ou-org> | --sem-github] [--sim]
#
# O que não for respondido vira [[PREENCHER: ...]]; rode scripts/checar-configuracao.sh para ver o que falta.
set -euo pipefail
TPL="$(cd "$(dirname "$0")" && pwd)"
ORG="" AGENT="" OWNER="" MISSION="" ABOUT="" LOCALE="" CHANNEL="" SLUG="" DEST="$(dirname "$TPL")" GH="" NOGH=0 YES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --org) ORG="$2"; shift 2;; --agente) AGENT="$2"; shift 2;; --owner) OWNER="$2"; shift 2;;
    --missao) MISSION="$2"; shift 2;; --sobre) ABOUT="$2"; shift 2;; --idioma) LOCALE="$2"; shift 2;;
    --canal) CHANNEL="$2"; shift 2;; --slug) SLUG="$2"; shift 2;; --destino) DEST="$2"; shift 2;;
    --github) GH="$2"; shift 2;; --sem-github) NOGH=1; shift;; --sim) YES=1; shift;;
    -h|--help) sed -n '2,12p' "$0"; exit 0;;
    *) echo "opção desconhecida: $1"; exit 1;;
  esac
done

for bin in git perl python3; do command -v "$bin" >/dev/null || { echo "ERRO: falta '$bin'"; exit 1; }; done
if [[ -z "$(git config user.name || true)" || -z "$(git config user.email || true)" ]]; then
  echo "ERRO: configure sua identidade Git antes:"
  echo '  git config --global user.name "Seu Nome"'
  echo '  git config --global user.email "seu-usuario@users.noreply.github.com"   # e-mail que pode ficar público'
  exit 1
fi

ask() { # ask <pergunta> <variável> [padrão]
  local cur="${!2}" v
  [[ -n "$cur" || $YES -eq 1 ]] && return
  read -r -p "$1${3:+ [$3]}: " v; printf -v "$2" '%s' "${v:-${3:-}}"
}
echo "== Sua organização e seu agente (Enter deixa em branco para preencher depois) =="
ask "Nome da organização" ORG
ask "Nome do agente orquestrador" AGENT
ask "Owner / aprovador humano (nome ou papel)" OWNER
ask "Missão do agente, em uma frase" MISSION
ask "O que a organização faz, em uma frase" ABOUT
ask "Idioma e fuso" LOCALE "pt-BR, UTC-3"
ask "Canal principal do agente (Telegram, Discord, CLI...)" CHANNEL "Telegram"
[[ -n "$ORG" && -n "$AGENT" && -n "$OWNER" ]] || { echo "ERRO: organização, agente e owner são obrigatórios"; exit 1; }
fill() { [[ -n "$1" ]] && echo "$1" || echo "[[PREENCHER: $2]]"; }
MISSION="$(fill "$MISSION" "missão do agente em uma frase")"
ABOUT="$(fill "$ABOUT" "o que a organização faz")"
LOCALE="$(fill "$LOCALE" "idioma e fuso")"
CHANNEL="$(fill "$CHANNEL" "canal principal")"
HOST="$(hostname 2>/dev/null || echo host)"

kebab() { echo "$1" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-|-$//g'; }
[[ -n "$SLUG" ]] || SLUG="$(kebab "$ORG")"
AGENT_SLUG="$(kebab "$AGENT")"
[[ "$SLUG" =~ ^[a-z0-9-]+$ && "$AGENT_SLUG" =~ ^[a-z0-9-]+$ ]] || { echo "ERRO: slug inválido"; exit 1; }
mkdir -p "$DEST"; DEST="$(cd "$DEST" && pwd)"
CEREBRO="$DEST/$SLUG-cerebro"; CASA="$DEST/$SLUG-casa"
for d in "$CEREBRO" "$CASA"; do [[ ! -e "$d" ]] || { echo "ERRO: $d já existe; não sobrescrevo"; exit 1; }; done

# GitHub: padrão é versionar na conta logada no gh (repos PRIVADOS)
if [[ $NOGH -eq 0 && -z "$GH" ]] && command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
  ME="$(gh api user --jq .login 2>/dev/null || true)"
  if [[ -n "$ME" && $YES -eq 0 ]]; then
    read -r -p "Criar os dois repos PRIVADOS no GitHub em qual conta/org? [$ME] (digite 'nao' para pular): " v
    case "${v:-$ME}" in nao|não|n|N) NOGH=1;; *) GH="${v:-$ME}";; esac
  fi
fi

echo; echo "Vou criar:"; echo "  $CEREBRO"; echo "  $CASA"
echo "  agente: $AGENT ($AGENT_SLUG) · owner: $OWNER"
[[ -n "$GH" ]] && echo "  GitHub (privado): $GH/$SLUG-cerebro e $GH/$SLUG-casa" || echo "  GitHub: não (só local)"
if [[ $YES -eq 0 ]]; then read -r -p "Continuar? [s/N] " ok; [[ "$ok" =~ ^[sSyY]$ ]] || exit 1; fi

VERSION="$(cat "$TPL/VERSION")"; TODAY="$(date +%F)"
export ORG AGENT OWNER SLUG AGENT_SLUG TODAY CEREBRO CASA MISSION ABOUT LOCALE CHANNEL HOST
render() { # render <src> <dst>
  cp -a "$1" "$2"
  find "$2" -depth -name '*__AGENT_SLUG__*' -execdir bash -c 'mv "$1" "${1//__AGENT_SLUG__/$2}"' _ {} "$AGENT_SLUG" \;
  find "$2" -type f -print0 | while IFS= read -r -d '' f; do
    grep -Iq . "$f" 2>/dev/null || continue
    perl -pi -e 's/\{\{ORG_NAME\}\}/$ENV{ORG}/g; s/\{\{AGENT_NAME\}\}/$ENV{AGENT}/g; s/\{\{OWNER_NAME\}\}/$ENV{OWNER}/g;
                 s/\{\{SLUG\}\}/$ENV{SLUG}/g; s/\{\{AGENT_SLUG\}\}|__AGENT_SLUG__/$ENV{AGENT_SLUG}/g; s/\{\{DATE\}\}/$ENV{TODAY}/g;
                 s/\{\{CEREBRO_PATH\}\}/$ENV{CEREBRO}/g; s/\{\{CASA_PATH\}\}/$ENV{CASA}/g; s/\{\{MISSION\}\}/$ENV{MISSION}/g;
                 s/\{\{ABOUT\}\}/$ENV{ABOUT}/g; s/\{\{LOCALE\}\}/$ENV{LOCALE}/g; s/\{\{CHANNEL\}\}/$ENV{CHANNEL}/g;
                 s/\{\{HOST\}\}/$ENV{HOST}/g' "$f"
  done
}
render "$TPL/templates/cerebro" "$CEREBRO"
render "$TPL/templates/casa" "$CASA"
# Bloco do agente no AGENTS.md da casa já nasce projetado (não depende do Hermes instalado)
HERMES_HOME=/nonexistent "$CASA/scripts/projetar.sh" >/dev/null 2>&1 || true

for r in "$CEREBRO" "$CASA"; do
  printf '%s\n' "$VERSION" > "$r/.template-version"
  git -C "$r" init -q -b main
  git -C "$r" config core.hooksPath .githooks
  git -C "$r" add -A
  git -C "$r" commit -q -m "chore: estrutura inicial a partir do hermes-agent-template v$VERSION"
  echo "OK  $r"
done
python3 "$CEREBRO/scripts/validate-mapas.py"
python3 "$CASA/scripts/validate-casa.py"

if [[ -n "$GH" ]]; then
  command -v gh >/dev/null || { echo "ERRO: instale e logue o gh (gh auth login) ou rode com --sem-github"; exit 1; }
  for r in "$CEREBRO" "$CASA"; do
    gh repo create "$GH/$(basename "$r")" --private --source "$r" --remote origin --push >/dev/null
    echo "GitHub OK  https://github.com/$GH/$(basename "$r") (privado)"
  done
fi

echo
echo "== Falta adaptar à sua realidade =="
"$CEREBRO/scripts/checar-configuracao.sh" 2>&1 | sed "s|^|  cerebro: |" || true
"$CASA/scripts/checar-configuracao.sh" 2>&1 | sed "s|^|  casa:    |" || true
cat <<NEXT

Próximos passos:
  1. Preencha os [[PREENCHER]] acima e commite (os hooks validam). Comece por:
     $SLUG-cerebro/cerebro/agentes/$AGENT_SLUG/{SOUL,USER,MANDATO,RBAC-MATRIZ}.md
NEXT
[[ -z "$GH" ]] && cat <<NEXT
  2. Versionar no seu GitHub depois: crie dois repos PRIVADOS vazios e em cada pasta rode
       git remote add origin git@github.com:<sua-conta>/<nome>.git && git push -u origin main
NEXT
cat <<NEXT
  3. Instale o Hermes:        curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
     e configure:              hermes setup        (modelo e canal; secrets ficam em ~/.hermes/.env)
  4. Diretório de trabalho:    terminal.cwd: $CASA   (em ~/.hermes/config.yaml)
  5. Projete a identidade:     $CASA/scripts/projetar.sh
  6. Teste:                    cd $CASA && hermes   → "Quem é você e quem é seu owner?"
NEXT
