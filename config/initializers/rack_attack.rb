require "rack/attack"

# Throttle anônimo por IP nos endpoints de autenticação (força bruta).
# Usa Rails.cache (Solid Cache em produção). Em teste o cache é :null_store,
# então os throttles não disparam na suite — ver spec/requests/rate_limit_spec.rb.
class Rack::Attack
  throttle("logins/ip", limit: 5, period: 1.minute) do |request|
    request.ip if request.path == "/login" && request.post?
  end

  throttle("signups/ip", limit: 20, period: 1.hour) do |request|
    request.ip if request.path == "/signup" && request.post?
  end

  self.throttled_responder = lambda do |_request|
    [ 429, { "Content-Type" => "text/plain" }, [ "Muitas tentativas. Tente novamente mais tarde.\n" ] ]
  end
end
