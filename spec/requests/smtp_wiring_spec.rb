require "rails_helper"

RSpec.describe "SMTP wiring (feat/smtp-worker)", type: :request do
  let(:user) { create(:user) }

  before { post login_path, params: { email: user.email, password: user.password } }

  it "mailer uses configurable from and CZAR MANAGER subjects" do
    task = create(:task)
    mail = TaskMailer.assigned_task(task.id)
    expect(mail.from.join).to include("noreply@example.com")
    expect(mail.subject).to start_with("[CZAR MANAGER]")
  end

  it "profile shows 'A implementar' badge while gate is off" do
    allow(Rails.configuration.x).to receive(:email_enabled).and_return(false)
    get user_path(user)
    expect(response.body).to include("A implementar")
  end

  it "profile shows 'Ativo' badge when gate is on" do
    allow(Rails.configuration.x).to receive(:email_enabled).and_return(true)
    get user_path(user)
    expect(response.body).to include("Ativo")
    expect(response.body).not_to include("A implementar")
  end
end
