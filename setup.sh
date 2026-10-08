#!/usr/bin/env bash
# Cria o par de repositórios <slug>-cerebro e <slug>-casa a partir deste template.
#
# Uso:
#   ./setup.sh --org "Minha Empresa" --agente "Atlas" --owner "Maria" [opções]
#
# Opções:
#   --slug <slug>        prefixo dos repos (padrão: org em kebab-case)
#   --destino <dir>      onde criar os repos (padrão: diretório pai deste template)
#   --github <conta>     também cria os repos PRIVADOS no GitHub via `gh` e faz o push inicial
#   --sim                não pergunta confirmação
#
# Sem --github, nada sai da sua máquina.
set -euo pipefail
TPL="$(cd "$(dirname "$0")" && pwd)"
ORG="" AGENT="" OWNER="" SLUG="" DEST="$(dirname "$TPL")" GH="" YES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --org) ORG="$2"; shift 2;; --agente) AGENT="$2"; shift 2;; --owner) OWNER="$2"; shift 2;;
    --slug) SLUG="$2"; shift 2;; --destino) DEST="$2"; shift 2;; --github) GH="$2"; shift 2;;
    --sim) YES=1; shift;; -h|--help) sed -n '2,14p' "$0"; exit 0;;
    *) echo "opção desconhecida: $1"; exit 1;;
  esac
done
ask() { local v; read -r -p "$1: " v; echo "$v"; }
[[ -n "$ORG" ]]   || ORG="$(ask 'Nome da organização')"
[[ -n "$AGENT" ]] || AGENT="$(ask 'Nome do agente')"
[[ -n "$OWNER" ]] || OWNER="$(ask 'Owner / aprovador humano')"
kebab() { echo "$1" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g;s/^-|-$//g'; }
[[ -n "$SLUG" ]] || SLUG="$(kebab "$ORG")"
AGENT_SLUG="$(kebab "$AGENT")"
[[ "$SLUG" =~ ^[a-z0-9-]+$ && "$AGENT_SLUG" =~ ^[a-z0-9-]+$ ]] || { echo "ERRO: slug inválido"; exit 1; }
DEST="$(cd "$DEST" && pwd)"
CEREBRO="$DEST/$SLUG-cerebro"; CASA="$DEST/$SLUG-casa"
for d in "$CEREBRO" "$CASA"; do [[ ! -e "$d" ]] || { echo "ERRO: $d já existe; não sobrescrevo"; exit 1; }; done

echo "Vou criar:"; echo "  $CEREBRO"; echo "  $CASA"; echo "  agente: $AGENT ($AGENT_SLUG) · owner: $OWNER"
[[ -n "$GH" ]] && echo "  + repos PRIVADOS github.com/$GH/$SLUG-cerebro e $SLUG-casa"
if [[ $YES -eq 0 ]]; then read -r -p "Continuar? [s/N] " ok; [[ "$ok" =~ ^[sSyY]$ ]] || exit 1; fi

VERSION="$(cat "$TPL/VERSION")"; TODAY="$(date +%F)"
render() { # render <src> <dst>
  cp -a "$1" "$2"
  find "$2" -depth -name '*__AGENT_SLUG__*' -execdir bash -c 'mv "$1" "${1//__AGENT_SLUG__/$2}"' _ {} "$AGENT_SLUG" \;
  find "$2" -type f ! -path '*/.git/*' -print0 | while IFS= read -r -d '' f; do
    grep -Iq . "$f" 2>/dev/null || continue
    ORG="$ORG" AGENT="$AGENT" OWNER="$OWNER" SLUG="$SLUG" AS="$AGENT_SLUG" D="$TODAY" CB="$CEREBRO" CS="$CASA" \
    perl -pi -e 's/\{\{ORG_NAME\}\}/$ENV{ORG}/g; s/\{\{AGENT_NAME\}\}/$ENV{AGENT}/g; s/\{\{OWNER_NAME\}\}/$ENV{OWNER}/g;
                 s/\{\{SLUG\}\}/$ENV{SLUG}/g; s/\{\{AGENT_SLUG\}\}|__AGENT_SLUG__/$ENV{AS}/g; s/\{\{DATE\}\}/$ENV{D}/g;
                 s/\{\{CEREBRO_PATH\}\}/$ENV{CB}/g; s/\{\{CASA_PATH\}\}/$ENV{CS}/g' "$f"
  done
}
render "$TPL/templates/cerebro" "$CEREBRO"
render "$TPL/templates/casa" "$CASA"

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
  command -v gh >/dev/null || { echo "ERRO: gh não instalado"; exit 1; }
  for r in "$CEREBRO" "$CASA"; do
    gh repo create "$GH/$(basename "$r")" --private --source "$r" --push
  done
fi

cat <<NEXT

Pronto. Próximos passos:
  1. Instale o Hermes Agent:  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
  2. Configure modelo e canal: hermes setup      (secrets ficam em ~/.hermes/.env)
  3. Projete a identidade:     $CASA/scripts/projetar.sh
  4. Diretório de trabalho:    terminal.cwd: $CASA   (ver $CASA/hermes/config.example.yaml)
  5. Teste:                    cd $CASA && hermes --in .   → "Quem é você e quem é seu owner?"
NEXT
