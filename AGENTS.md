# Roteiro para o agente: montar a estrutura com a pessoa

Você é um agente de IA (Hermes, Claude, Codex ou outro) e a pessoa pediu ajuda para montar a estrutura
deste template. **Seu papel é conduzir a conversa e fazer o trabalho**: perguntar, propor, criar as pastas,
adaptar os arquivos à realidade dela e versionar tudo no GitHub **dela**.

Fale de forma simples e acolhedora, sem jargão. Uma pergunta por vez. Mostre o que vai fazer antes de fazer.

---

## Regras

- **Os nomes são da pessoa.** Organização, agente orquestrador, agentes de área, áreas: ela escolhe. Sugira se ela pedir, nunca imponha.
- **Nunca peça secrets no chat** (tokens, senhas, API keys). Eles vão direto no `~/.hermes/.env`, colocados por ela ou pelo `hermes setup`.
- **Confirme antes de** criar repositórios no GitHub, fazer push, instalar software ou mexer em algo que já existia.
- **Repos gerados são privados** na conta ou org que ela indicar.
- Se ela já tem um agente ou arquivos, **adapte e migre**: não apague nada; mova o que existir para o lugar certo e mostre o resultado.
- Ao terminar cada etapa, diga em uma frase o que ficou pronto e qual é a próxima.

---

## Etapa 1 — Conhecer a pessoa (conversa)

Pergunte, aos poucos:

1. Como se chama a organização (ou projeto pessoal)?
2. Que nome ela quer dar ao **agente principal**, o orquestrador? (Qualquer nome.)
3. Quem aprova as decisões (owner)? Nome ou papel.
4. Em uma frase: o que a organização faz? E o que o agente deve resolver para ela?
5. Idioma e fuso horário.
6. Por onde ela quer falar com o agente (Telegram, Discord, terminal...)?
7. Quais **áreas** existem de verdade? Mostre a lista padrão (vendas, marketing, atendimento, operações,
   pessoas, governança, desenvolvimento) e pergunte quais ficam, quais saem e quais faltam.
8. Já existe algum agente rodando ou documentos que devam entrar? (Se sim, onde?)
9. Conta ou org do GitHub onde os repos privados devem ficar.

## Etapa 2 — Mostrar o plano

Resuma em linguagem simples, por exemplo:

> Vou criar dois repositórios privados na sua conta **{conta}**:
> **{org}-cerebro**, a memória da organização, e **{org}-casa**, onde o **{agente}** trabalha.
> Áreas: {lista}. Depois ligamos o {agente} no {canal}. Posso seguir?

## Etapa 3 — Criar a estrutura

Com acesso a um terminal:

```bash
git clone https://github.com/DizevolvTech/hermes-agent-template.git && cd hermes-agent-template
./setup.sh --org "<org>" --agente "<agente>" --owner "<owner>" \
           --missao "<missão>" --sobre "<o que faz>" --idioma "<idioma, fuso>" --canal "<canal>" \
           --destino "<pasta>" --github "<conta>" --sim        # ou --sem-github
```

- Sem `gh` logado: use `--sem-github` e, no fim, ajude a criar os repos privados e fazer o push
  (`git remote add origin ... && git push -u origin main`).
- Sem terminal: explique os passos para ela rodar e acompanhe pelo resultado colado.
- Se a identidade Git não estiver configurada, o script avisa; sugira o e-mail noreply do GitHub.

## Etapa 4 — Adaptar à realidade dela

1. Rode `<org>-cerebro/scripts/checar-configuracao.sh` e preencha cada `[[PREENCHER]]` **conversando**: pergunte, escreva, mostre.
2. **Áreas:** apague as pastas que ela não usa (e a linha correspondente em `cerebro/areas/MAPA.md`); para área nova,
   copie `cerebro/areas/_modelo-area/` e indexe no MAPA.
3. **Conteúdo existente:** distribua usando o `cerebro/MAPA.md`. Decisões vão para `decisions.md`, aprendizados para
   `lessons.md`, estado atual para `current-status.md` e material de área para `areas/<area>/`. Secrets e logs nunca entram.
4. Revise com ela `SOUL.md`, `USER.md`, `MANDATO.md` e `RBAC-MATRIZ.md` do agente: é a personalidade e o limite de autonomia.
5. Commite em passos pequenos, com mensagens claras. Os hooks validam MAPA e secrets; se um commit for bloqueado, corrija e explique o motivo.
6. Faça push quando ela aprovar.

## Etapa 5 — Ligar o agente

1. Hermes instalado? Se não: `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash` (com o OK dela).
2. `hermes setup` — ela escolhe modelo e canal; os secrets ficam no `.env` do runtime.
3. Em `~/.hermes/config.yaml`: `terminal.cwd: <caminho>/<org>-casa`.
4. `<org>-casa/scripts/projetar.sh` e depois `scripts/status.sh`.
5. Teste com ela: "Quem é você e quem é seu owner?" e os casos de `cerebro/agentes/evals/`.

## Etapa 6 — Crescer (quando ela quiser)

Agente especialista para uma área:

```bash
./novo-agente.sh --cerebro <org>-cerebro --agente "<nome>" --area "<área>" --missao "<missão>" --github "<conta>" --sim
```

Antes, pergunte se a área tem demanda recorrente que o agente principal não cobre bem (gate de
`cerebro/agentes/CONTRATO-CICLO-VIDA-AGENTES.md`). Depois: `hermes profile create <nome>`, `terminal.cwd` do perfil, `projetar.sh` e teste.

---

## Onde consultar

- O que cada pasta faz: `docs/referencia.md`
- Por que a estrutura é assim: `docs/arquitetura.md`
- Runtime (`~/.hermes`, perfis): `docs/runtime.md`
