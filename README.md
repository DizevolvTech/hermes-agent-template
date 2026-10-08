# hermes-agent-template

Monte uma **frota de agentes [Hermes Agent](https://github.com/NousResearch/hermes-agent) com memória versionada no GitHub**:
um **cérebro** compartilhado, um **agente orquestrador** que cuida dele e, quando você precisar, **agentes macro por área**
(comercial, operação, desenvolvimento…), cada um com a sua casa e o seu runtime.

É a mesma organização que usamos em produção, sem nenhum dado nosso: só a estrutura, os contratos e os scripts.

---

## Sumário

1. [Como funciona](#como-funciona)
2. [Por que assim](#por-que-assim)
3. [Começar](#começar)
4. [Crescer: agentes macro por área](#crescer-agentes-macro-por-área)
5. [Estrutura completa](#estrutura-completa)
6. [Dia a dia](#dia-a-dia)
7. [Infraestrutura e segurança](#infraestrutura-e-segurança)

---

## Como funciona

Tudo se divide em **três camadas**, cada uma respondendo a uma pergunta:

| Camada | Onde | Pergunta que responde | Versionada? |
|---|---|---|---|
| **Cérebro** | repo `<slug>-cerebro` | *O que a organização sabe e decidiu?* | Sim, GitHub privado |
| **Casa de execução** | repo `<slug>-casa` (e uma `<slug>-casa-<agente>` por agente macro) | *Como cada agente executa?* | Sim, GitHub privado |
| **Runtime** | `~/.hermes` (e `~/.hermes/profiles/<agente>`) | *Com o que ele roda agora?* config, secrets, sessões | **Nunca** |

```text
                               ┌──────────────────────────────────────┐
     você / o time  ──edita──▶ │  <slug>-cerebro   (memória da org)   │ ◀── registros duráveis
                               │  contexto · decisões · lições ·      │     (decisão, lição, status)
                               │  status · áreas · agentes · contratos│     escritos pelos agentes
                               └───────┬───────────────────┬──────────┘
                     identidade do     │                   │  contexto da área
                     orquestrador      ▼                   ▼
                  ┌─────────────────────────┐   ┌─────────────────────────┐
                  │ <slug>-casa             │   │ <slug>-casa-<agente>    │   ← um por agente macro
                  │ orquestrador: rotinas,  │   │ identidade + execução   │
                  │ gates, handoffs, relat. │   │ do agente da área       │
                  └───────────┬─────────────┘   └───────────┬─────────────┘
                 terminal.cwd │  projetar.sh (SOUL)         │ terminal.cwd │ projetar.sh
                              ▼                             ▼
                  ┌─────────────────────────┐   ┌─────────────────────────┐
                  │ ~/.hermes               │   │ ~/.hermes/profiles/<ag> │   ← runtime: config, .env,
                  │ (runtime orquestrador)  │   │ (runtime isolado)       │     sessões, cron — sem Git
                  └─────────────────────────┘   └─────────────────────────┘
```

**O ciclo:**

1. **O Hermes lê a identidade**: o `SOUL.md` vem do `HERMES_HOME` e o `AGENTS.md` vem do diretório de trabalho (a casa).
   O `scripts/projetar.sh` copia os dois a partir da fonte canônica. Com `--check`, avisa se alguém editou o runtime à mão (drift).
2. **O agente trabalha a partir da casa**: segue o bootstrap, consulta o cérebro de forma **seletiva** (MAPA → busca),
   roda rotinas registradas e abre pedidos para outros agentes.
3. **Ao fechar uma tarefa, o agente registra**: classifica o resultado como decisão, lição, status, pendência ou nada,
   e grava na menor casa possível do cérebro, por commit. O hook valida o commit e o GitHub guarda a história.

---

## Por que assim

| Escolha | Benefício |
|---|---|
| **Memória em Git, não só na cabeça do agente** | Toda decisão e lição tem data, autor e diff. Dá para auditar, reverter e entender *por que* algo é assim. Trocar de modelo, de máquina ou de agente não apaga o que a organização aprendeu. |
| **Cérebro separado da execução** | O conhecimento não fica preso a um agente. Vários agentes leem o mesmo cérebro, e a casa pode ser refeita sem perder memória. |
| **Runtime fora do Git** | Secrets, sessões e logs nunca vazam para um repositório. Reinstalar o runtime vira: clonar os repos, restaurar o `.env` e rodar `projetar.sh`. |
| **Fonte canônica única + projeção com detecção de drift** | A identidade é editada em um lugar só. O runtime nunca diverge em silêncio. |
| **`MAPA.md` validado em todo commit** | O cérebro continua navegável com centenas de arquivos. O agente encontra o que precisa sem carregar tudo, o que economiza contexto e dá respostas melhores. |
| **Livros-razão com formato fixo** (`current-status`, `decisions`, `lessons`) | "O que vale agora" tem uma resposta só (`current-status` prevalece). Histórico é buscado por data e palavra-chave, não lido inteiro. |
| **Orquestrador + agentes macro por área** | Cada domínio tem um dono especializado, com ferramentas, canal e permissões próprios. O orquestrador mantém a coerência: topologia, gates, rotinas e auditoria. Você escala por área sem criar um agente monolítico. |
| **Gates, RBAC e registro de recorrências** | Autonomia com limite: o que é sensível pede aprovação explícita, e nenhuma rotina roda sem estar registrada com kill switch. |
| **Uma máquina basta** | O padrão é organizacional, não de infraestrutura. Começa numa VPS e, se crescer, separa os hosts sem mudar a estrutura. |

---

## Começar

**Pré-requisitos:** `git`, `python3`, `perl`, de preferência o [`gh`](https://cli.github.com) logado (`gh auth login`), e uma identidade Git
(`git config --global user.email "<seu-usuario>@users.noreply.github.com"` se não quiser expor seu e-mail).

1. **Gere seus repositórios.** Clique em **Use this template** (ou clone este repo; ele é só o gerador) e rode:
   ```bash
   ./setup.sh
   ```
   O setup pergunta nome da organização, do agente orquestrador, owner, missão, o que a organização faz, idioma/fuso e canal.
   Ele cria `<slug>-cerebro` e `<slug>-casa` lado a lado, com Git, hooks e o primeiro commit. Com o `gh` logado, oferece criar
   os dois como **repos privados na sua conta ou org** e faz o push.

2. **Adapte à sua realidade.** O que depende de você está marcado com `[[PREENCHER: ...]]`:
   ```bash
   <slug>-cerebro/scripts/checar-configuracao.sh     # lista arquivo:linha de cada pendência
   ```
   Ordem sugerida: `agentes/<orquestrador>/SOUL.md` → `USER.md` → `MANDATO.md` → `RBAC-MATRIZ.md` →
   `empresa/contexto/` → apague as áreas que não existem na sua organização. Commite e faça push.

3. **Ligue o Hermes.**
   ```bash
   curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
   hermes setup                                   # modelo e canal; secrets ficam em ~/.hermes/.env
   # em ~/.hermes/config.yaml:   terminal.cwd: <caminho>/<slug>-casa
   <slug>-casa/scripts/projetar.sh                # identidade → runtime
   cd <slug>-casa && hermes                       # "Quem é você e quem é seu owner?"
   ```

4. **Valide.** `scripts/status.sh` na casa e os casos de `cerebro/agentes/evals/`.

---

## Crescer: agentes macro por área

Comece **só com o orquestrador**. Quando uma área tiver demanda recorrente que ele não cobre bem, crie um agente macro para ela.
Antes, aplique o gate de `cerebro/agentes/CONTRATO-CICLO-VIDA-AGENTES.md`.

```bash
./novo-agente.sh --cerebro ../<slug>-cerebro --agente "Mercurio" --area vendas
```

O script faz o seguinte:

- Cria `<slug>-casa-mercurio` com identidade completa (SOUL, IDENTITY, USER, AGENTS, MEMORY), HEARTBEAT, TOOLS, contratos,
  memória (`context/`, `integrations/`, `projects/`), skills e áreas de trabalho.
- No cérebro: cria o ponteiro `agentes/mercurio.md`, adiciona uma linha na `TOPOLOGIA-MACRO-AGENTES.md`, indexa no MAPA, registra no changelog
  do modelo operacional e cria a área, se ela ainda não existir. Tudo num commit validado.
- Opcionalmente, cria o repo privado no seu GitHub.
- Mostra os passos do runtime: `hermes profile create mercurio`, `terminal.cwd` do perfil, `projetar.sh` e smoke.

```text
                         owner humano
                              │
                     Orquestrador (ex.: "Orion")
        cérebro · topologia · gates · rotinas · auditoria
         ┌────────────────┬───────────────┬────────────────┐
     Mercúrio (vendas)   Ceres (operações)  Vulcano (dev)   ...     ← agentes macro de área
     casa + perfil    casa + perfil      casa + perfil
         └────────────────┴───────┬───────┴────────────────┘
                          <slug>-cerebro                          ← memória compartilhada
```

Regras que mantêm a frota saudável, já escritas nos contratos:

- **Ownership por domínio.** Quem é dono é a área, não quem pediu nem o canal por onde o pedido chegou.
- **Entre agentes, só handoff e retorno** (`CONTRATO-INTEGRACAO-AGENTES.md`). Um agente nunca mexe na casa ou no runtime de outro.
- **Agentes macro não criam agentes.** Pedem ao orquestrador.
- **Escrita no cérebro por domínio** (`CONTRATO-ACESSO-CEREBRO-AGENTES.md`). Cada agente escreve na sua área; o institucional passa pelo orquestrador.
- **Ciclo de vida:** PROPOSTO → SANDBOX → PILOTO → ATIVO → PAUSADO → CONSOLIDANDO → APOSENTADO.

---

## Estrutura completa

### Cérebro (`<slug>-cerebro`)

```text
<slug>-cerebro/
├── AGENTS.md                         ← bootstrap para qualquer agente que abrir o repo
├── cerebro/
│   ├── MAPA.md                       ← navegação por intenção ("preciso de X → vá para Y")
│   ├── empresa/
│   │   ├── contexto/                 ← geral, pessoas, canais, métricas, regras-repositorios, playbooks/
│   │   │   ├── current-status.md     ← O QUE VALE AGORA (prevalece sobre o resto)
│   │   │   ├── decisions.md          ← decisões humanas duráveis
│   │   │   └── lessons.md            ← aprendizados que mudam comportamento
│   │   ├── brand/  projetos/  skills/
│   ├── areas/                        ← vendas, marketing, atendimento, operacoes, pessoas, governanca,
│   │   └── <area>/                      desenvolvimento (+ _modelo-area): contexto/ rotinas/ projetos/ skills/
│   ├── agentes/
│   │   ├── TOPOLOGIA-MACRO-AGENTES.md← quem é quem: tipo, domínio, host, runtime, casa, canais, estado
│   │   ├── CONTRATO-*.md             ← carregamento de contexto, captura de aprendizados, propagação,
│   │   │                                integração entre agentes, ciclo de vida, acesso ao cérebro
│   │   ├── PRINCIPIO-QUALIDADE-OPERACIONAL.md · CHANGELOG-MODELO-OPERACIONAL.md · evals/
│   │   ├── <agente-macro>.md         ← ponteiro de cada agente macro
│   │   └── <orquestrador>/           ← identidade completa do orquestrador:
│   │       ├── SOUL · IDENTITY · USER · AGENTS · MEMORY (índice)
│   │       ├── MANDATO · RBAC-MATRIZ · FORMATO-GATE · POLITICA-OPERACAO-CEREBRO · CHECKLIST-PRE-RUNTIME
│   │       ├── REGISTRO-RECORRENCIAS.json   ← toda rotina agendada da frota, com kill switch
│   │       ├── RUNTIME-STATUS · lessons · prompts/ · handoffs/
│   ├── seguranca/                    ← checklist e auditorias
│   └── archive/                      ← histórico morto (mover, não apagar)
├── scripts/                          ← validate-mapas.py · registrar.py · scan-secrets.sh · checar-configuracao.sh
└── .githooks/pre-commit              ← valida MAPA + secrets no snapshot staged
```

### Casa do orquestrador (`<slug>-casa`)

```text
<slug>-casa/
├── AGENTS.md            ← carregado pelo Hermes; inclui o bloco projetado do cérebro
├── BOOTSTRAP.md · TOOLS.md · .casa.conf
├── automation/<rotina>/ ← código de cada rotina registrada no cérebro
├── governance/templates/← GATE · REQ (pedido) · RETORNO
├── handoffs/            ← REQ-<DESTINO>-<ASSUNTO>-<UTC>.md (correção = arquivo novo)
├── reports/ · outbox/   ← relatórios sanitizados · mensagens aguardando aprovação
├── contratos/ · memory/ · skills/ · hermes/ (config e systemd de exemplo) · var/
└── scripts/             ← projetar.sh · status.sh · reconciliar-recorrencias.py · novo-req.sh · sync-bundle.sh · validate-casa.py
```

### Casa de agente macro (`<slug>-casa-<agente>`)

```text
<slug>-casa-<agente>/
├── AGENTS.md · SOUL.md · IDENTITY.md · USER.md · MEMORY.md   ← identidade (fonte canônica deste agente)
├── BOOTSTRAP.md · HEARTBEAT.md · TOOLS.md · RUNTIME_STATUS.md
├── contratos/   ← limites, handoff, carregamento de contexto, backup/rollback
├── memory/      ← pending · context/{decisions,lessons,people} · integrations/ · projects/ · sessions/
├── skills/      ← <skill>/SKILL.md + evals/ + references/
├── areas/       ← frentes de trabalho do agente
└── scripts/ · hermes/ · var/
```

### Runtime

Layout de `~/.hermes` e `~/.hermes/profiles/<agente>`, e o que mora em cada camada: [`docs/runtime.md`](docs/runtime.md).

---

## Dia a dia

| Situação | O que fazer |
|---|---|
| Terminou uma tarefa | O agente classifica e registra (`CONTRATO-CAPTURA-APRENDIZADOS.md`). Manual: `cerebro/scripts/registrar.py decisao\|licao\|status "..."` |
| Mudou identidade ou regras | Edite no cérebro (ou na casa, se for agente macro) → `projetar.sh` → `projetar.sh --check` → smoke |
| Nova rotina | Linha em `REGISTRO-RECORRENCIAS.json` → código em `automation/<key>/` → `hermes cron create` → `reconciliar-recorrencias.py` verde |
| Delegar | `casa/scripts/novo-req.sh <DESTINO> <ASSUNTO>`; retorno com `governance/templates/RETORNO.md` |
| Ação sensível | Gate completo (`FORMATO-GATE.md`); gate incompleto = HOLD |
| Pasta nova no cérebro | Indexe no `MAPA.md` da pasta, senão o commit é bloqueado |
| Novo agente de área | `./novo-agente.sh` (ver acima) |

---

## Infraestrutura e segurança

- **Uma VPS basta.** Cérebro, casas e runtime convivem na mesma máquina. Para separar hosts, use deploy keys por repo ou
  `scripts/sync-bundle.sh`, que leva o repo sem colocar credencial do GitHub no host. Ver [`docs/infraestrutura.md`](docs/infraestrutura.md).
- **Secrets só no `.env` do runtime.** Os hooks bloqueiam tokens conhecidos e arquivos como `.env` e `auth.json` nos repos.
- **Repos gerados são privados.** Este template é público e não contém dado real; quem mantém um fork deve seguir [`docs/sanitizacao.md`](docs/sanitizacao.md).
- Após clonar um repo gerado em outra máquina: `git config core.hooksPath .githooks` e ajuste `.casa.conf`.

Mais: [`docs/arquitetura.md`](docs/arquitetura.md) · [`docs/runtime.md`](docs/runtime.md) · [`CHANGELOG.md`](CHANGELOG.md)

## Contribuindo

`tools/check-template.sh` precisa passar (roda no CI). Ele gera uma frota de teste (cérebro, casa e um agente macro), roda os validadores
e procura secrets e dados privados.

Licença MIT.
