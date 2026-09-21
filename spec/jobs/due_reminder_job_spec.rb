require 'rails_helper'

RSpec.describe DueReminderJob, type: :job do
  it "notifica vencendo amanhã e atrasadas, ignora sem prazo e concluídas" do
    soon = create(:task, due_date: Date.tomorrow, status: "pendente")
    late = create(:task, project: soon.project, author: soon.author, assigned_to: soon.assigned_to, due_date: 2.days.ago.to_date, status: "em_andamento")
    create(:task, project: soon.project, author: soon.author, assigned_to: soon.assigned_to, due_date: 2.days.ago.to_date, status: "concluida")
    create(:task, project: soon.project, author: soon.author, assigned_to: soon.assigned_to, due_date: nil)

    expect { described_class.perform_now }.to change(Notification, :count).by(2)
    expect(Notification.where(action: "due_soon").count).to eq(1)
    expect(Notification.where(action: "overdue").count).to eq(1)
  end
end
