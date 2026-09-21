# Gate para conexões externas de e-mail (SMTP).
# Enquanto EMAIL_ENABLED != "true", nada é enfileirado e o UI exibe
# "A implementar" nos pontos que dependeriam de e-mail.
module EmailGate
  def self.enabled?
    Rails.configuration.x.email_enabled
  end

  def self.deliver(message)
    message.deliver_later if enabled?
  end
end
