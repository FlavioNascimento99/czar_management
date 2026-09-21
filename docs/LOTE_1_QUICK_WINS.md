# Lote 1 — Quick Wins | Branch `feature/lote-1-quick-wins`

> Criado em 2026-09-21. Branch isolada de `main` para evitar conflito com trabalhos paralelos.
> Foco: valor rápido sem quebrar o que já funciona (Projects / Tasks / Requirements + auth).

## 1. Objetivo
Enriquecer o core atual (Trello/Asana simplificado) com colaboração viva e gestão por prazo,
sem mudar autenticação, permissões de membro (`Project#member?`) ou deploy Cloudflare.

## 2. Escopo fechado (5 itens)
1. **Comentários em tarefas** — `Comment belongs_to :task, :author(User)`, só membro do projeto pode criar/ver.
2. **Activity log / timeline do projeto** — `ActivityLog(project, actor, action, trackable)`, gera via callback em Task/Comment/Requirement.
3. **Due date em Task** — `tasks.due_date:date`, badge atrasada/hoje, ordenação.
4. **Minhas Tarefas (`/my_tasks`)** — agrega `assigned_tasks` do `current_user` com filtro pendente/atrasada.
5. **Filtros + busca em Tasks** — por `status, priority, assigned_to_id, q(title/description)`, mantendo Kaminari (20/pág).

## 3. Fora de escopo (não mexer neste lote)
- Roles granulares (admin/viewer), convites por e-mail, anexos Active Storage, API REST, Kanban drag-drop, iCal, GitHub.
- Troca de auth, troca de DB (SQLite dev / PG prod), mudança em `wrangler.jsonc` / Dockerfile.

## 4. Design técnico previsto
- Migrations: `create_comments`, `create_activity_logs`, `add_due_date_to_tasks + index`.
- Models com validações PT-BR, `dependent: :destroy`, scopes (`overdue`, `due_today`, `by_status`).
- Controllers: nested `projects/:project_id/tasks/:task_id/comments`, `ActivityLogs` read-only, `MyTasksController#index`, `Tasks#index` com `filter_params` whitelist.
- Views: partial `_comment`, timeline no `projects/show`, badge de prazo, `my_tasks/index`, manter Bootstrap 5 + Turbo.
- i18n: usar `config/locales/pt-BR.yml` existente.

## 5. Checks de implementação (rodar antes de cada PR)
- [x] `bundle install --local` OK (Ruby 3.4.10, Rails ~8.1.0)
- [x] `bin/rails db:migrate:status` sem `down` pendente em dev e test
- [x] `bundle exec rspec` verde — 76 examples, 0 failures (2026-09-21)
- [x] `bundle exec rubocop --no-color` sem ofensas — 75 files, no offenses
- [x] `bundle exec brakeman --no-pager -q` sem warning — 0 warnings
- [x] `git diff --check` sem whitespace error

## 6. Critérios de aceite por item
- [x] Comentário: cria, lista em ordem, valida presença, só membro acessa (request spec 302 se não-membro).
- [x] Activity: criar/editar/concluir task gera linha na timeline do projeto.
- [x] Due date: badge vermelha se `overdue`, ordenável, `Task.overdue` testado.
- [x] Minhas Tarefas: mostra só minhas tasks, paginada, link volta ao projeto.
- [x] Filtros: combinação status+prioridade+responsável+q funciona e preserva paginação.

## 7. Proteção contra trabalhos paralelos
- Branch atual: `feature/lote-1-quick-wins` (base: `main` em 2026-09-21).
- Não commitar `vendor/bundle/`, `tmp/`, `log/`, `.wrangler/`, `node_modules/`.
- Rebase com `main` só via `git fetch origin && git rebase origin/main`, resolver `db/schema.rb` com `db:migrate`.
- Commits pequenos por item: `feat(comments): ...`, `feat(activity): ...`, `feat(tasks): due_date + filters`, `feat(mytasks): ...`.

## 8. Próximo passo
Implementar na ordem: Comment → ActivityLog → due_date → MyTasks → Filtros, com spec primeiro (RSpec + FactoryBot já configurados).
