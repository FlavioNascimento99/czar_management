# Pendências do roadmap (2026-09-21)

## Organizar
- [ ] Menções @ em comentários
- [ ] Convite por token para quem não tem conta (hoje só usuário existente)
- [ ] Roles granulares — viewer/editor/admin (hoje só dono vs membro)
- [ ] Milestones/sprints, roadmap e burndown
- [ ] Relatórios — carga por pessoa, % de progresso
- [ ] Busca global (hoje só dentro de tasks e docs, separadas)
- [ ] Recorrência mensal / dias custom (só diária e semanal)

## Docs
- [ ] Compartilhar docs com a equipe (decisão vigente: pessoal primeiro)
- [ ] Versionamento / histórico de edições
- [ ] Busca full-text (hoje LIKE; FTS5/tsvector depois)

## Plataforma
- [ ] E-mail funcionando de verdade — SMTP + worker (hoje gated `EMAIL_ENABLED=false`, badge "A implementar" no UI)
- [ ] Worker em prod para lembretes (hoje só dev)
- [ ] Webhooks e integração GitHub
- [ ] API: criar tarefas/projetos (hoje só lê e atualiza)

## UX
- [ ] PWA/mobile, dark mode, atalhos de teclado, avatares, editor rico

## Infra / processo
- [ ] Aceite manual roteirizado (só automatizado até aqui)
- [ ] Push para origin e deploy em prod com as migrations novas
- [ ] Backfill de `api_token` para usuários já existentes em prod
