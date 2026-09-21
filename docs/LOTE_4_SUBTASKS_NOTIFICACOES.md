# Lote 4 — Subtarefas + Notificações | Branch `feature/lote-4-subtasks-notificacoes`

> Base: `feature/lote-3-escala-api` (limpa). Commit autorizado ao final.

## Escopo (nesta ordem)
1. **Subtarefas/checklist** — `Subtask(task, title, done, position)`, CRUD aninhado, toggle done via Turbo, barra de progresso em task/show e no Kanban.
2. **Notificações in-app** — `Notification(user, actor, action, notifiable polymorphic, read_at)`, sino no layout com contagem, página `/notifications`, marcar lida/todas. Gera nos mesmos gatilhos do e-mail (atribuição, comentário, membro).
3. **Lembrete de prazo** — `DueReminderJob` diário (Solid Queue recurring: todo dia 8h, dev+prod): tasks vencendo amanhã + atrasadas abertas → e-mail `due_reminder` + notificação in-app.

## Fora de escopo
- Menções @, invite-token, roles, webhooks, arrange de subtarefas entre tasks.

## Checks
- [x] Migrations `up` dev+test; `rspec` verde (117 examples, 0 failures); `rubocop` limpo (109 files); `brakeman` 0; `diff --check` OK
- [x] Subtask: só membro, toggle persiste, progresso % correto
- [x] Sino: contagem = não lidas, marcar lida some da conta
- [x] Job: roda manual via `perform_now` em spec, gera 1 notificação+e-mail por task
