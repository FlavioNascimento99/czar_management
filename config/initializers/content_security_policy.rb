# Be sure to restart your server when you modify this file.

# Application-wide content security policy (issue #45).
# Allows self + pinned jsDelivr Bootstrap CDN. Importmap / Turbo inline
# scripts and styles get per-request nonces via csp_meta_tag + nonce
# generator below (no 'unsafe-inline' for scripts).
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src :self, :https, :data
    policy.img_src :self, :https, :data
    policy.object_src :none
    policy.script_src :self, :https, "cdn.jsdelivr.net"
    # 'unsafe-inline' kept for styles only: Bootstrap + small view-level
    # style attributes break under nonce-only styles in older browsers.
    policy.style_src :self, :https, "cdn.jsdelivr.net", :unsafe_inline
    policy.connect_src :self, :https
    policy.base_uri :self
    policy.form_action :self, :https
    policy.frame_ancestors :self
    policy.upgrade_insecure_requests
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
