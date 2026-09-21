require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  it "assigned_task envia ao responsável" do
    task = create(:task)
    mail = described_class.assigned_task(task.id)
    expect(mail.to).to include(task.assigned_to.email)
    expect(mail.subject).to include(task.title)
  end

  it "task_commented não envia se só o autor está envolvido" do
    user = create(:user)
    project = create(:project, users: [ user ])
    task = create(:task, project: project, author: user, assigned_to: user)
    comment = create(:comment, task: task, author: user)
    expect {
      described_class.task_commented(comment.id).deliver_now
    }.not_to change(ActionMailer::Base.deliveries, :count)
  end
end
