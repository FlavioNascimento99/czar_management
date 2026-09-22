# E-mail real (SMTP) + worker | `feat/smtp-worker`

Delivery path was fully built but never connected (`EMAIL_ENABLED=false`,
badge "A implementar", placeholder `noreply@example.com`). This doc is the
runbook to turn it on for real.

## How it works

- `EmailGate.deliver(msg)` → `deliver_later` only when `EMAIL_ENABLED=true`.
- Callers: task assigned/reassigned/commented, member added
  (`TasksController`, `CommentsController`, `ProjectsController`) +
  `DueReminderJob` (daily 8am via `config/recurring.yml`, prod and dev).
- Queue: Solid Queue, workers on `*` (`config/queue.yml`); in prod the
  supervisor runs inside Puma (`SOLID_QUEUE_IN_PUMA=true` in
  `config/deploy.yml`). No separate worker machine needed for one server.
- `raise_delivery_errors = true` in production so failures retry instead of
  vanishing.

## Turn on (prod)

```bash
export APP_HOST="app.example.com"
export EMAIL_ENABLED=true
export MAILER_FROM="CZAR MANAGER <noreply@app.example.com>"
export SMTP_ADDRESS="smtp.example.com"   # e.g. smtp.gmail.com, smtp.resend.com
export SMTP_PORT="587"
export SMTP_USERNAME="..."
export SMTP_PASSWORD="..."               # app password / API-key-as-password
kamal deploy
```

`SMTP_USERNAME/PASSWORD` travel as Kamal secrets (see `.kamal/secrets`);
the rest as clear env (see `config/deploy.yml`). Never commit credentials.

## Verify

```bash
# inside the deployed app (or locally with the same ENV):
bin/rails email:test[voce@example.com]
```

Checks: message arrives, links use `APP_HOST`, `/up` healthcheck still 200,
`DueReminderJob` enqueued daily (Solid Queue dashboard/recurring runs).

## Roll back

```bash
export EMAIL_ENABLED=false && kamal deploy
```

In-app notifications (🔔) keep working with the gate off; queued mails
simply stop being enqueued.
