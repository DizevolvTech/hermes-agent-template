# Backup e rollback

- **Cérebro e casa:** o Git é o backup (remoto privado).
- **Runtime:** fazer backup de `HERMES_HOME` (config.yaml, .env, memories/, skills/, cron/) cifrado e fora da máquina; caches e logs podem ficar de fora.
- **Antes de mudar config/versão:** copiar `config.yaml` para `config.yaml.bak-AAAAMMDD` e registrar em `current-status`.
- **Rollback:** restaurar arquivo + `hermes gateway restart` + smoke de `RUNTIME-STATUS.md`.
