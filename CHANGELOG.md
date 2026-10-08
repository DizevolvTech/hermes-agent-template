# Changelog

## 1.5.1 — testado com Hermes real

- Correção: agente de área com `HERMES_HOME` no ambiente projetava o SOUL por cima do orquestrador;
  o perfil agora é sempre resolvido como `<raiz>/profiles/<agente>`.
- Comando exato para ativar a rotina `sync-frota` no `hermes cron` (script em `$HERMES_HOME/scripts/`, `--no-agent`).
- Validado com Hermes Agent instalado: perfil criado, contexto carregado por agente (SOUL + AGENTS corretos e isolados),
  job de cron rodando o sync da frota até o remoto, reconciliador lendo o cron real.

## 1.5.0 — revisão de qualidade

Segurança e robustez
- Nomes com aspas, `$`, crases ou `$(...)` não quebram nem executam nada (`.frota.conf` gravado com escape).
- `projetar.sh` não deixa mais backups versionados (vão para `var/state/` ou para o `HERMES_HOME`).
- Repos 100% portáveis: nenhum caminho da máquina gravado; `.casa.conf` resolve o cérebro como pasta irmã.
- `sync-frota.sh` lê o slug da configuração (não confunde orgs com "casa"/"cerebro" no nome).
- Hook `pre-push` revalida o que vai ser enviado (pega commit feito com `--no-verify`); o sync para na hora com mensagem clara.
- Compatível com macOS: slug via Python (NFKD) e edições via perl (sem `sed -i`).

Novos guardas e conteúdo
- `validate-artifacts.py` (PDF, planilhas, ZIP, mídia e arquivos grandes ficam fora do cérebro).
- `validate-registros.py` (títulos de decisions/lessons/current-status no formato padrão).
- `validate-mapas.py` acusa ponteiro de agente para área apagada.
- `POLITICA-CANAIS-CADENCIA.md`, BOOTSTRAP com "permitido direto / precisa de procedimento", skill `autorrevisao`.

Correções menores
- Segundo agente na mesma área é acrescentado como responsável (não substitui o primeiro).
- `--sim` aplica os padrões de idioma e canal; `registrar.py status` exige o estado; `novo-req.sh` com acentos e barras.
- `status.sh` consulta o gateway do perfil certo; docs com links e caminhos corrigidos; regra única de quem faz push.

## 1.4.0

- Sync padronizado: `scripts/sync.sh` em todos os repos (valida → commit → rebase → push, retry, conflito = HOLD)
  e `scripts/sync-frota.sh`; `CONTRATO-SYNC-GIT.md`; rotina `sync-frota` no registro; agentes sincronizam sozinhos.
- `novo-agente.sh` sincroniza o cérebro; `setup.sh` configura a credencial do gh para os pushes dos agentes.
- README: diagrama com o cérebro no topo e os agentes lado a lado com seus repos; fluxo do sync.
- Correção de segurança: `scan-secrets.sh` podia imprimir o valor do secret com um único arquivo staged
  e varria o repo errado quando chamado de fora dele.
- Correção: validador de MAPA aceitava nome citado em texto corrido; agora exige entrada da árvore ou nome entre crases.

## 1.3.0

- `AGENTS.md` na raiz: roteiro para o agente da pessoa conduzir a montagem por conversa
  (entrevista, plano, criação, adaptação, GitHub dela, ligar o Hermes, crescer). Nomes livres.
- README reescrito para não técnicos: mensagem pronta para colar no agente e fluxos visuais (Mermaid).
- Detalhes técnicos movidos para `docs/referencia.md`.

## 1.2.0

- Frota completa no modelo de produção: orquestrador + agentes macro por área (`novo-agente.sh`).
- Cérebro com as áreas de negócio, contexto da empresa (pessoas, canais, métricas, regras de repositórios, playbooks, brand),
  `TOPOLOGIA-MACRO-AGENTES.md`, ponteiros por agente, princípio de qualidade, contrato de acesso, changelog do modelo e evals.
- Casa de agente macro com identidade própria, HEARTBEAT, memória (context/integrations/projects/sessions), skills e áreas.
- Scripts compartilhados em `shared/` (fonte única); `projetar.sh` serve orquestrador e agentes macro (perfis).
- README reescrito: como funciona, por que assim, estrutura completa, crescimento por área; `docs/runtime.md`.

## 1.1.0 — 2026-10-08

- Setup interativo: missão, idioma/fuso, canal; marcadores `[[PREENCHER]]` + `checar-configuracao.sh`.
- Repos privados criados na conta GitHub do usuário (padrão quando `gh` está logado).
- Correção: o `AGENTS.md` do agente agora é projetado para o `AGENTS.md` da casa (o Hermes carrega do diretório de trabalho, não do `HERMES_HOME`).
- Correções: reconciliador resolvia `HERMES_HOME` errado sem a variável no ambiente; validador da casa falhava com arquivos locais em `var/`; exige identidade Git antes de gerar.

## 1.0.0 — 2026-10-08

- Primeira versão pública: setup.sh gera cérebro + casa; validadores, hooks, projeção com drift, gate de sanitização.
