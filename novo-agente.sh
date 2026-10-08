#!/usr/bin/env bash
# Cria um AGENTE MACRO DE ÁREA na sua frota (ex.: comercial, operação, desenvolvimento):
#   - nova casa  <slug>-casa-<agente>  (identidade + execução do agente, formato completo)
#   - ponteiro   cerebro/agentes/<agente>.md  + linha na TOPOLOGIA-MACRO-AGENTES.md + MAPA
#   - commit no cérebro (os hooks validam) e, opcional, repo PRIVADO no seu GitHub
#
# Uso:
#   ./novo-agente.sh --cerebro ../minha-empresa-cerebro --agente "Mercurio" --area vendas \
#                    [--missao "..."] [--destino DIR] [--github <conta-ou-org> | --sem-github] [--sim]
#
# Antes de criar, aplique o gate de cerebro/agentes/CONTRATO-CICLO-VIDA-AGENTES.md:
# a área tem demanda recorrente que o orquestrador sozinho não cobre bem?
set -euo pipefail
TPL="$(cd "$(dirname "$0")" && pwd)"
source "$TPL/tools/lib.sh"
CEREBRO="" AGENT="" AREA="" MISSION="" DEST="" GH="" NOGH=0 YES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cerebro) CEREBRO="$2"; shift 2;; --agente) AGENT="$2"; shift 2;; --area) AREA="$2"; shift 2;;
    --missao) MISSION="$2"; shift 2;; --destino) DEST="$2"; shift 2;;
    --github) GH="$2"; shift 2;; --sem-github) NOGH=1; shift;; --sim) YES=1; shift;;
    -h|--help) sed -n '2,13p' "$0"; exit 0;;
    *) echo "opção desconhecida: $1"; exit 1;;
  esac
done
require_git_identity
[[ -n "$CEREBRO" && -f "$CEREBRO/.frota.conf" ]] || { echo "ERRO: --cerebro deve apontar para o repo cérebro gerado pelo setup.sh"; exit 1; }
CEREBRO="$(cd "$CEREBRO" && pwd)"
source "$CEREBRO/.frota.conf"
[[ -z "$(git -C "$CEREBRO" status --porcelain)" ]] || { echo "ERRO: cérebro com alterações não commitadas; commite antes"; exit 1; }
if [[ $YES -eq 0 ]]; then
  [[ -n "$AGENT" ]] || read -r -p "Nome do agente: " AGENT
  [[ -n "$AREA" ]] || { echo "Áreas no cérebro: $(ls "$CEREBRO/cerebro/areas" | grep -v '^_\|MAPA' | tr '\n' ' ')"; read -r -p "Área (domínio) do agente: " AREA; }
  [[ -n "$MISSION" ]] || read -r -p "Missão do agente em uma frase: " MISSION
fi
[[ -n "$AGENT" && -n "$AREA" ]] || { echo "ERRO: --agente e --area são obrigatórios"; exit 1; }
AGENT_SLUG="$(kebab "$AGENT")"; AREA="$(kebab "$AREA")"
[[ "$AGENT_SLUG" != "$ORCH_SLUG" ]] || { echo "ERRO: nome igual ao do orquestrador"; exit 1; }
[[ -e "$CEREBRO/cerebro/agentes/$AGENT_SLUG.md" ]] && { echo "ERRO: agente $AGENT_SLUG já existe"; exit 1; }
if [[ ! -d "$CEREBRO/cerebro/areas/$AREA" ]]; then
  echo "AVISO: área '$AREA' não existe no cérebro; vou criá-la a partir de _modelo-area"; NEW_AREA=1
fi
DEST="${DEST:-$(dirname "$CEREBRO")}"; DEST="$(cd "$DEST" && pwd)"
CASA="$DEST/$SLUG-casa-$AGENT_SLUG"
[[ ! -e "$CASA" ]] || { echo "ERRO: $CASA já existe"; exit 1; }
MISSION="$(fill "$MISSION" "missão do agente em uma frase")"
TODAY="$(date +%F)"; HOST="$(hostname 2>/dev/null || echo host)"; ABOUT=""; LOCALE=""; CHANNEL=""
ask_github
echo "Vou criar: $CASA  (agente $AGENT · área $AREA · coordenado por $ORCH)"
echo "E alterar: $CEREBRO (ponteiro, topologia, MAPA${NEW_AREA:+, área nova})"
[[ -n "$GH" ]] && echo "GitHub (privado): $GH/$(basename "$CASA")"
if [[ $YES -eq 0 ]]; then read -r -p "Continuar? [s/N] " ok; [[ "$ok" =~ ^[sSyY]$ ]] || exit 1; fi

export ORG AGENT OWNER SLUG AGENT_SLUG TODAY CEREBRO CASA MISSION ABOUT LOCALE CHANNEL HOST AREA ORCH ORCH_SLUG
render casa-macro "$CASA"
git_init "$CASA" "chore: casa do agente macro $AGENT ($AREA) a partir do hermes-agent-template v$(cat "$TPL/VERSION")"

# --- cérebro: área (se nova), ponteiro, topologia, MAPA ---
C="$CEREBRO/cerebro"
if [[ -n "${NEW_AREA:-}" ]]; then
  cp -a "$C/areas/_modelo-area" "$C/areas/$AREA"
  rm "$C/areas/$AREA/README.md"
  cat > "$C/areas/$AREA/MAPA.md" <<MAPA
# MAPA — $AREA

> Owner: $OWNER · Última validação: $TODAY · Revalidar quando: a estrutura desta pasta mudar

**Escopo:** [[PREENCHER: escopo da área]].
**Agente macro responsável:**

\`\`\`text
$AREA/
├── contexto/   ← como a área funciona: regras, glossário, sistemas usados
├── rotinas/    ← processos recorrentes, passo a passo verificável
├── projetos/   ← projetos ativos da área (um arquivo cada)
└── skills/     ← skills da área (formato empresa/skills/_templates)
\`\`\`
MAPA
  NEWLINE="$(printf '├── %-17s← [[PREENCHER: escopo da área]]' "$AREA/")" \
    perl -pi -e 's/^└── _modelo-area\//$ENV{NEWLINE}\n└── _modelo-area\//' "$C/areas/MAPA.md"
fi
# Responsável da área: acrescenta (uma área pode ter mais de um agente)
RESP_LINE="$C/areas/$AREA/MAPA.md"
if grep -q '^\*\*Agente macro responsável:\*\* .*orquestrador' "$RESP_LINE" || grep -q '^\*\*Agente macro responsável:\*\* *$' "$RESP_LINE"; then
  NEWRESP="**Agente macro responsável:** $AGENT — ver \`cerebro/agentes/$AGENT_SLUG.md\`." \
    perl -pi -e 's/^\*\*Agente macro responsável:\*\*.*$/$ENV{NEWRESP}/' "$RESP_LINE"
else
  echo "AVISO: a área $AREA já tem agente responsável; $AGENT entra como responsável adicional"
  ADD=", $AGENT (\`cerebro/agentes/$AGENT_SLUG.md\`)" perl -pi -e 's/^(\*\*Agente macro responsável:\*\*.*?)\.?$/$1$ENV{ADD}./' "$RESP_LINE"
fi
cat > "$C/agentes/$AGENT_SLUG.md" <<PTR
# $AGENT

Ponteiro. A identidade completa e a operação de $AGENT moram na casa dele.

- **Tipo:** agente macro de área · **Domínio:** \`areas/$AREA/\`
- **Coordenado por:** $ORCH · **Owner humano:** $OWNER
- **Casa:** \`$(basename "$CASA")\` (SOUL, IDENTITY, USER, AGENTS, MEMORY, HEARTBEAT, contratos, skills)
- **Runtime:** perfil Hermes \`~/.hermes/profiles/$AGENT_SLUG\` em \`$HOST\`
- **Estado:** PROPOSTO (ver CONTRATO-CICLO-VIDA-AGENTES.md)

## Responsabilidades
- $MISSION

## Não faz
- Não cria outros agentes nem sistemas independentes; pede a $ORCH.
- Não atua fora de \`$AREA\` sem handoff.
PTR
ROW="| $AGENT | macro de área | $AREA | Hermes Agent | \`$HOST\` | \`~/.hermes/profiles/$AGENT_SLUG\` | \`$(basename "$CASA")\` | [[PREENCHER: canal]] | PROPOSTO |" \
  perl -pi -e 's/^(<!-- novo-agente.sh acrescenta linhas acima desta marca -->)/$ENV{ROW}\n$1/' "$C/agentes/TOPOLOGIA-MACRO-AGENTES.md"
python3 - "$C/agentes/TOPOLOGIA-MACRO-AGENTES.md" <<'PY'
import sys,re
p=sys.argv[1]; s=open(p).read()
# a linha nova precisa ficar colada à tabela (sem linha em branco no meio)
s=re.sub(r"(\| SANDBOX \|\n|\| PROPOSTO \|\n)\n(\| )", r"\1\2", s)
open(p,"w").write(s)
PY
echo "- \`$AGENT_SLUG.md\` ← $AGENT, agente macro de $AREA (casa \`$(basename "$CASA")\`)" >> "$C/agentes/MAPA.md"
printf '\n## %s — agente macro %s (%s)\n- Criado em estado PROPOSTO com casa `%s` e perfil Hermes próprio.\n' "$TODAY" "$AGENT" "$AREA" "$(basename "$CASA")" >> "$C/agentes/CHANGELOG-MODELO-OPERACIONAL.md"
[[ -n "$GH" ]] && gh_publish "$CASA"
# Commit + push do cérebro pelo caminho padrão (valida, integra o remoto, envia)
"$CEREBRO/scripts/sync.sh" "estrutura: agente macro $AGENT para a área $AREA (PROPOSTO)" || exit $?
echo "OK  cérebro atualizado"

cat <<NEXT

Próximos passos para $AGENT:
  1. Preencha o que falta:       $CASA/scripts/checar-configuracao.sh
  2. Perfil Hermes isolado:      hermes profile create $AGENT_SLUG
  3. Diretório de trabalho:      em ~/.hermes/profiles/$AGENT_SLUG/config.yaml →  terminal.cwd: $CASA
  4. Projete a identidade:       $CASA/scripts/projetar.sh
  5. Teste:                      cd $CASA && hermes -p $AGENT_SLUG   → smoke de RUNTIME_STATUS.md
  6. Canal próprio (opcional):   hermes -p $AGENT_SLUG setup  (outro bot; secrets no .env do perfil)
  7. Ao passar no smoke: estado PILOTO na TOPOLOGIA e registro em current-status (scripts/registrar.py status).
  8. Sync: ao fim de cada tarefa o agente roda scripts/sync.sh "tipo: o que mudou" (CONTRATO-SYNC-GIT.md).
NEXT
