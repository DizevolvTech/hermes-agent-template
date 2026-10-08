# 🧠 hermes-agent-template

**Dê ao seu agente de IA uma memória organizada, que cresce com você e fica guardada no seu GitHub.**

Este template monta, em uma conversa, a mesma estrutura que usamos para operar uma frota de agentes [Hermes](https://github.com/NousResearch/hermes-agent):
um **cérebro** com tudo que sua organização sabe e decide, um **agente principal** que cuida dele e,
quando fizer sentido, **agentes especialistas** para cada área.

Você escolhe todos os nomes. Nenhum dado nosso vem junto: só a organização.

---

## ✨ Comece em 1 minuto

Copie a mensagem abaixo e **cole no seu agente** (Hermes, Claude, ChatGPT com terminal, Codex...):

```text
Quero montar a estrutura do https://github.com/DizevolvTech/hermes-agent-template
para a minha organização. Leia o AGENTS.md do repositório e me conduza passo a passo:
faça as perguntas, crie as pastas, adapte tudo à minha realidade e versione no meu GitHub.
```

O agente vai conversar com você e fazer o resto:

```mermaid
flowchart LR
    A["📋 Você cola<br/>a mensagem"] --> B["💬 O agente pergunta<br/>nomes, áreas, canal"]
    B --> C["🗂️ Cria e adapta<br/>as pastas"]
    C --> D["🔒 Salva no seu<br/>GitHub privado"]
    D --> E["🚀 Liga o agente<br/>e testa com você"]
```

> Prefere fazer sozinho? `git clone` deste repositório e rode `./setup.sh`; ele faz as mesmas perguntas.

---

## 🏠 Como funciona

No topo fica o **cérebro**, a memória que todos compartilham. Embaixo, lado a lado, ficam os **agentes**, cada um com o
**seu repositório operacional** no GitHub (a "casa", onde ele trabalha). Todos leem o cérebro, registram nele o que
aprenderam e **fazem o próprio sync**: commit e push.

```mermaid
flowchart TB
    C[("🧠 CÉREBRO<br/><b>sua-org-cerebro</b><br/>decisões · aprendizados · status<br/>áreas · regras · identidade dos agentes")]

    subgraph D["💻 Área: Desenvolvimento"]
        D1["<b>Vulcano</b><br/>especialista em sistemas"] -->|"sync · push"| D2["📁 GitHub<br/>sua-org-casa-vulcano"]
    end
    subgraph P["⚙️ Área: Operações"]
        P1["<b>Ceres</b><br/>especialista em operação"] -->|"sync · push"| P2["📁 GitHub<br/>sua-org-casa-ceres"]
    end
    subgraph V["💼 Área: Vendas"]
        V1["<b>Mercúrio</b><br/>especialista comercial"] -->|"sync · push"| V2["📁 GitHub<br/>sua-org-casa-mercurio"]
    end
    subgraph O["🧭 Agente principal"]
        O1["<b>Orion</b><br/>coordena e organiza"] -->|"sync · push"| O2["📁 GitHub<br/>sua-org-casa"]
    end

    C <-->|"lê · registra · sync"| D1
    C <-->|"lê · registra · sync"| P1
    C <-->|"lê · registra · sync"| V1
    C <-->|"lê · registra · sync"| O1
```

<sub>Os especialistas são opcionais: comece só com o agente principal e crie os outros quando uma área pedir. Orion, Mercúrio, Ceres e Vulcano são só exemplos: os nomes são todos seus.</sub>

| | O que guarda | Onde fica |
|---|---|---|
| 🧠 **Cérebro** | Memória da organização: "decidimos X", "aprendemos Y", "o status hoje é Z" | GitHub privado: `sua-org-cerebro` |
| 📁 **Casa de cada agente** | Como aquele agente trabalha: rotinas, tarefas, ferramentas, memória curta | GitHub privado: `sua-org-casa` (agente principal) e `sua-org-casa-<especialista>` |
| ⚙️ **Runtime** | Senhas, tokens, configuração e histórico de conversas | Só na sua máquina (`~/.hermes`); nunca vai para o GitHub |

### O ciclo de cada tarefa

```mermaid
flowchart LR
    P["🙋 Pedido"] --> L["🔎 Consulta<br/>o cérebro"]
    L --> F["🛠️ Trabalha<br/>na sua casa"]
    F --> Q{"Aprendeu ou<br/>decidiu algo?"}
    Q -- "sim" --> M["📝 Registra<br/>no cérebro"]
    Q -- "não" --> S
    M --> S["🔄 Sync<br/>commit + push"]
    S --> X["✅ Pronto e<br/>salvo no GitHub"]
```

### 🔄 Como o sync funciona

Todo repositório da frota tem o **mesmo comando**, e os agentes o usam sozinhos ao terminar cada tarefa:

```bash
scripts/sync.sh "registro: decidimos atender só por WhatsApp"
```

```mermaid
flowchart LR
    A["📝 Mudanças"] --> B{"🛡️ Validação<br/>mapa em dia?<br/>sem senhas?"}
    B -- "não" --> H1["⛔ Bloqueia e explica<br/>o que corrigir"]
    B -- "sim" --> C["💾 Commit"]
    C --> D["⬇️ Traz o que outros<br/>agentes enviaram"]
    D --> E{"Conflito?"}
    E -- "sim" --> H2["✋ Para e avisa você<br/>(nada se perde)"]
    E -- "não" --> F["⬆️ Push<br/>para o GitHub"]
```

- Vários agentes podem escrever no cérebro ao mesmo tempo: o sync integra o trabalho de todos antes de enviar.
- O agente principal roda um **sync da frota** periódico como rede de segurança (`scripts/sync-frota.sh`).
- Nunca há push forçado, e ninguém pula a validação. Regras completas: `cerebro/agentes/CONTRATO-SYNC-GIT.md`.

---

## 💡 Por que assim

- **🧠 A memória é da organização, não do agente.** Troque de modelo, de máquina ou de agente: o que foi aprendido continua lá.
- **🔍 Tudo auditável.** Cada decisão tem histórico no GitHub. Dá para ver o que mudou, quando e reverter.
- **🧭 Nunca vira bagunça.** Cada pasta tem um mapa (`MAPA.md`), e o próprio Git bloqueia pasta nova fora do mapa.
  O agente acha o que precisa sem ler tudo, o que deixa as respostas melhores e mais baratas.
- **🔒 Segredos protegidos.** Senhas e tokens ficam só na sua máquina, e o Git bloqueia se alguém tentar salvar um.
- **🎛️ Autonomia com limites.** Você define o que o agente pode fazer sozinho e o que precisa da sua aprovação.
- **🔄 Tudo sincronizado.** Cada agente salva o próprio trabalho no GitHub com o mesmo comando, sem atropelar os outros.
- **🌱 Cresce por área.** Começa com um agente só; quando uma área pedir, ganha um especialista sem bagunçar o resto.
- **💻 Uma máquina basta.** Tudo pode rodar numa única VPS ou computador.

---

## 🌱 Crescendo: agentes especialistas por área

Comece **só com o agente principal**. Quando uma área tiver muita demanda, peça ao seu agente:
*"crie um agente especialista para vendas chamado ___"*. Ele usa o `novo-agente.sh` e organiza tudo.

O especialista já nasce com casa própria (um repositório no seu GitHub), runtime isolado e lugar no cérebro, como no diagrama de [Como funciona](#-como-funciona).

- Cada especialista tem **sua casa, sua configuração e seu canal**, e todos compartilham o mesmo cérebro.
- O agente principal é o **coordenador**: distribui pedidos, mantém tudo organizado e audita.
- Um especialista cuida da **sua área** e devolve para o principal o que for de outra.
- Os nomes são seus: "Mercúrio", "Ana do Comercial", "Bot de Vendas"...

---

## 📦 O que vem pronto

| | |
|---|---|
| 🧠 **Cérebro** | Mapa de navegação, áreas da empresa, registro de decisões, aprendizados e status, identidade do agente, regras de convivência entre agentes |
| 🧭 **Agente principal** | Personalidade, mandato, quem aprova o quê, formato de pedido de aprovação, registro de rotinas automáticas |
| 🏠 **Casa** | Rotinas, pedidos entre agentes, relatórios, mensagens aguardando aprovação |
| 🔄 **Sync** | O mesmo `scripts/sync.sh` em todos os repos (valida, integra, envia) e o sync da frota pelo agente principal |
| 🛡️ **Proteções** | Bloqueio de senha no Git, mapa sempre atualizado, aviso se alguém editar a identidade fora do lugar |
| 🧰 **Ajudantes** | Criar estrutura, criar especialista, checar o que falta preencher, status do agente |

Detalhes técnicos de cada pasta e script: [`docs/referencia.md`](docs/referencia.md).

---

## 📚 Para ir mais fundo

| Documento | Para quê |
|---|---|
| [`AGENTS.md`](AGENTS.md) | O roteiro que o seu agente segue para montar tudo com você |
| [`docs/arquitetura.md`](docs/arquitetura.md) | Os princípios por trás da estrutura |
| [`docs/runtime.md`](docs/runtime.md) | Como o Hermes fica organizado na máquina (`~/.hermes`, perfis) |
| [`docs/infraestrutura.md`](docs/infraestrutura.md) | Uma ou várias máquinas, serviço, sincronização |
| [`docs/referencia.md`](docs/referencia.md) | Todas as pastas, scripts e comandos |
| [`docs/sanitizacao.md`](docs/sanitizacao.md) | Para quem mantém um fork público |

---

<sub>Licença MIT · Contribuições: `tools/check-template.sh` precisa passar (roda no CI).</sub>
