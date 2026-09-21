# Docs MVP | Branch `feature/docs-mvp`

Decisões: docs **pessoais** (sem compartilhar), editor **markdown simples**
(textarea + preview server-side), começar pelo **Docs MVP**.

## Escopo
1. `Folder(user, parent?, name)` em árvore + `Doc(user, folder?, title, body)` — tudo escopado em `current_user`, zero permissão cruzada.
2. CRUD de pastas e docs, editor com preview (kramdown, pura-Ruby, sem dependência nativa).
3. Anexos em docs via Active Storage (mesmo padrão das tasks).
4. Busca simples (LIKE em título/corpo) — FTS fica para depois.

## Fora de escopo
Compartilhar docs, blocos Notion-like, versionamento, ligar Docs ↔ Tasks (fase 2), contextos de rotina (módulo Organizar).

## Fase 2 — vínculo Docs ↔ Tasks | Branch `feature/docs-tasks-link`

Regra: só vinculo **meu** doc em task de projeto do qual sou membro
(`TaskDoc` valida dono-do-doc-membro-do-projeto). Nos dois lados:
card na task ("Documentos vinculados") e no doc ("Tarefas vinculadas",
só as de projetos meus).

## Checks (MVP)
- [x] Migrations up dev+test; `rspec` verde (132 examples, 0 failures); `rubocop` limpo (123 files); `brakeman` 0 (1 XSS fraco corrigido com `sanitize` na show)
- [x] Doc de outro usuário nunca vaza (spec 404/redirect)
- [x] Preview renderiza markdown sem XSS (sanitize)
