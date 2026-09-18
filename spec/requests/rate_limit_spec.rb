require "rails_helper"

RSpec.describe "Rate limiting", type: :request do
  before do
    # Troca o null_store de teste por memória para exercitar o throttle.
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  after do
    Rack::Attack.cache.store = ActiveSupport::Cache::NullStore.new
  end

  it "bloqueia força bruta no login após 5 tentativas" do
    user = create(:user)

    5.times do
      post login_path, params: { email: user.email, password: "errada" }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    post login_path, params: { email: user.email, password: "errada" }
    expect(response).to have_http_status(:too_many_requests)
  end

  it "login válido passa com cache limpo" do
    user = create(:user)
    post login_path, params: { email: user.email, password: "password123" }
    expect(response).to redirect_to(root_path)
  end
end
