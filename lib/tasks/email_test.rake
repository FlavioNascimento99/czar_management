# Verification for real SMTP delivery (see docs/EMAIL_SMTP.md).
# Sends immediately (deliver_now) so a misconfigured SMTP fails loudly here
# instead of hiding inside a queued job.
# Usage: bin/rails email:test[voce@example.com]
namespace :email do
  desc "Send a test e-mail via the configured SMTP"
  task :test, [ :to ] => :environment do |_, args|
    to = args[:to] or abort "Usage: bin/rails email:test[voce@example.com]"
    from = ENV.fetch("MAILER_FROM", "CZAR MANAGER <noreply@example.com>")
    ActionMailer::Base.mail(
      from: from,
      to: to,
      subject: "[CZAR MANAGER] SMTP OK",
      body: "If you got this, SMTP delivery works. Gate enabled: #{EmailGate.enabled?}"
    ).deliver_now
    puts "Test e-mail sent to #{to} (gate enabled: #{EmailGate.enabled?})"
  end
end
