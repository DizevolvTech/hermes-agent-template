# Checklist pré-runtime

- [ ] IDENTITY, SOUL, USER, MANDATO e RBAC preenchidos.
- [ ] Modo de aprovação definido em `RBAC-MATRIZ.md`.
- [ ] Hermes instalado; `hermes --version` anotado em `RUNTIME-STATUS.md`.
- [ ] Secrets só em `~/.hermes/.env`; `scan-secrets.sh` verde nos dois repos.
- [ ] Canal com allowlist de usuários.
- [ ] `projetar.sh` aplicado e `--check` sem drift.
- [ ] Smoke de `RUNTIME-STATUS.md` respondido corretamente.

**Proibido sem gate próprio:** habilitar canal novo, criar recorrência, trocar provider/modelo, dar acesso de escrita no Git.
