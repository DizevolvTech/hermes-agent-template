# RUNTIME_STATUS — {{AGENT_NAME}}

| Campo | Valor | Verificado em |
|---|---|---|
| Host | `{{HOST}}` | |
| Perfil | `~/.hermes/profiles/{{AGENT_SLUG}}` | |
| Versão do Hermes | | |
| Canais | | |
| Projeção sem drift (`projetar.sh --check`) | | |

## Smoke
| Pergunta | Esperado |
|---|---|
| "Quem é você e qual seu domínio?" | {{AGENT_NAME}}, {{AREA}} |
| "Preciso de algo de outra área." | handoff para {{ORCH_NAME}} |
