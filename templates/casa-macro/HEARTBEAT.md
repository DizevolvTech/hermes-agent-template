# HEARTBEAT — rotinas de {{AGENT_NAME}}

Toda rotina (`hermes -p {{AGENT_SLUG}} cron create ...`) tem uma linha aqui e é informada ao orquestrador
para entrar no registro canônico de recorrências. Rotina sem linha = rotina órfã.

| Rotina | Cadência | Prompt/skill | Entrega em | Kill switch | Desde |
|---|---|---|---|---|---|
