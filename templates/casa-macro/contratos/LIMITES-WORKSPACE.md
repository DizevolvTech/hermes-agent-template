# Limites de workspace — {{AGENT_NAME}}

**Pode ler/escrever:** esta casa; seu perfil Hermes (`~/.hermes/profiles/{{AGENT_SLUG}}`); `cerebro/areas/{{AREA}}/`.
**Pode ler:** `cerebro/empresa/contexto/`, `cerebro/agentes/`.
**Nunca:** perfis/casas de outros agentes, `.env` de terceiros, sistema (`/etc`, systemd) sem aprovação.
Fora disso → `HOLD_LIMITE` + handoff para {{ORCH_NAME}}.
