require "rails_helper"

RSpec.describe "Security headers (issue #45)", type: :request do
  it "sends a Content-Security-Policy header allowing self + pinned CDN" do
    get login_path

    csp = response.headers["Content-Security-Policy"]
    expect(csp).to be_present
    expect(csp).to include("default-src 'self' https:")
    expect(csp).to include("cdn.jsdelivr.net")
    expect(csp).to include("object-src 'none'")
    expect(csp).to include("frame-ancestors 'self'")
  end
end
