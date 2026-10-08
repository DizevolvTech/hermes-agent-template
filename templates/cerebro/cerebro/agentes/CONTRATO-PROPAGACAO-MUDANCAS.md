# Contrato — propagação de mudanças

1. **Fonte canônica:** editar aqui no cérebro (commit).
2. **Projeção quente:** `{{SLUG}}-casa/scripts/projetar.sh` copia `SOUL.md` para `HERMES_HOME` e o `AGENTS.md` do agente para um bloco gerado no `AGENTS.md` da casa — que é o arquivo que o Hermes carrega do diretório de trabalho. A memória própria do Hermes (`memories/`) não é tocada.
3. **Drift:** `projetar.sh --check` precisa sair 0 (runtime == cérebro).
4. **Smoke cognitivo:** perguntar ao agente algo que só a mudança responde.
5. **Captura:** registrar status/decisão conforme o contrato de captura.

Comportamento novo relevante pede um caso de teste (pergunta + resposta esperada) no `RUNTIME-STATUS.md` do agente.
Provar o consumidor real: qual `HERMES_HOME` e qual diretório de trabalho o serviço usa.
