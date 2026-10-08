# Checklist de segurança

- [ ] Secrets só no `.env` do `HERMES_HOME` (nunca em repo). `scripts/scan-secrets.sh` passa.
- [ ] Canal do agente (ex.: Telegram) com allowlist de usuários.
- [ ] Agente roda com usuário sem sudo quando possível.
- [ ] Comandos destrutivos exigem aprovação (config `approvals`).
- [ ] Repos privados; o template público não contém dado real.
- [ ] Backup do `HERMES_HOME` (exceto caches) e plano de rollback documentado.
