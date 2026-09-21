# Lote 3 — Escala + API | Branch `feature/lote-3-escala-api`

> Base: `feature/lote-2-colaboracao-kanban` (Lote 2 ainda não commitado — vai junto; checagem geral no fim).
> Foco: anexos, templates, API com tokens e calendário, sem quebrar nada.

## Escopo (nesta ordem)
1. **Anexos em tarefas** — Active Storage (`has_many_attached :files`), upload múltiplo, lista com download/exclusão, limite 10MB, bloqueia executáveis.
2. **Templates de projeto** — `ProjectTemplateService` com 3 presets (Sprint dev, Onboarding, Evento); `Projects#new/create` aceita `?template=`, cria projeto + requisitos/tasks seed.
3. **API REST v1 + tokens** — `User#api_token` (`has_secure_token`), `Api::V1::BaseController` (Bearer ou `?token=`), `GET projects`, `GET/PATCH tasks`, JSON puro, sem HTML.
4. **Export iCal** — `GET /projects/:id/calendar.ics` + `GET /my_tasks.ics`, ICS manual sem gem, VEVENT por task com `due_date`.

## Fora de escopo
- Virus scan, preview de PDF, versionamento de arquivo, roles na API (só membro), CalDAV, invite-token.

## Checks (checagem geral no fim, pelo usuário)
- [x] Anexos: migrações AS `up`, upload/download/purge só membro, spec com fixture.
- [x] Templates: cria N requisitos/tasks, membro adicionado, spec de serviço + request.
- [x] API: 401 sem token, 200/422 com token, escopo só meus projetos, request specs.
- [x] iCal: `text/calendar`, contém VEVENT/DTSTART, só membro.
- [x] Suite: 105 examples, 0 failures · rubocop 96 files limpo · brakeman 0 warnings · diff-check OK
