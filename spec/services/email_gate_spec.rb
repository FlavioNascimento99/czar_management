require 'rails_helper'

RSpec.describe EmailGate do
  it "desligado por padrão" do
    expect(described_class.enabled?).to be_falsey
  end

  it "não enfileira quando desligado" do
    task = create(:task)
    expect {
      described_class.deliver(TaskMailer.assigned_task(task.id))
    }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
  end

  it "enfileira quando ligado" do
    allow(Rails.configuration.x).to receive(:email_enabled).and_return(true)
    task = create(:task)
    expect {
      described_class.deliver(TaskMailer.assigned_task(task.id))
    }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
  end
end
