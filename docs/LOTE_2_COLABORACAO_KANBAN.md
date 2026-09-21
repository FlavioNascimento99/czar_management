# Lote 2 — Colaboração + Kanban | Branch `feature/lote-2-colaboracao-kanban`

> Base: `feature/lote-1-quick-wins` commitado (base SaaS + feat lote-1). Branch isolada.
> Foco: destravar colaboração sem quebrar permissões nem SMTP.

## Escopo fechado (4 itens, nesta ordem)
1. **Convites/membros** — afrouxar `add_member` de owner-only para member, logar `member_added/member_removed` no ActivityLog, manter owner-only para remover terceiros.
2. **Tags/labels** — `Tag(project, name, color)` + `TaskTag(task, tag)`, CRUD escopado ao projeto, filtro por tag em `Tasks#index`, badges.
3. **Kanban drag-drop** — `Projects#board` (3 colunas por status), Stimulus + PATCH `status` via Turbo, fallback sem JS (select + botão).
4. **Notificações e-mail** — `TaskMailer` (atribuído, comentário, prazo) via `deliver_later` (Solid Queue), sem exigir SMTP em dev/test (`raise_delivery_errors=false`).

## Fora de escopo
- Invite-token para não-usuários, roles admin/viewer, PWA, API, iCal, anexos.
- Troca de auth, DB, Cloudflare/worker.

## Ordem (motivo)
Convites → Tags → Kanban → E-mails. Permissão primeiro (afeta tudo), modelo de tags antes do board (filtro), board antes dos e-mails (e-mails hookam em tudo).

## Checks por item
- [x] Migration `up` dev+test, `schema.rb` commitado
- [x] Request/controller spec: membro convida, não-membro 302, owner remove
- [x] Tag: unicidade por projeto (case-insensitive), só membro gerencia
- [x] Board: PATCH status só membro, Turbo Stream + HTML fallback, sem gem nova
- [x] Mailer: `deliver_later`, previews, sem crash sem SMTP, specs com `perform_enqueued_jobs`
- [x] `rspec` verde (92 examples, 0 failures), `rubocop` limpo (86 files), `brakeman` 0 warnings, `git diff --check` OK

## Critérios de aceite
- [x] Qualquer membro adiciona usuário existente; activity registra; owner remove terceiros; membro sai sozinho.
- [x] Tag criada/edita/exclui no projeto; task aceita 0..N tags; filtro por tag preserva paginação.
- [x] Arrastar card muda status e persiste; recarrega e mantém; sem JS ainda funciona.
- [x] Atribuir/comentar/vencer gera e-mail enfileirado, não bloqueia request.
