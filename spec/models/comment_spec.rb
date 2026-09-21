require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "é válido com body, task e autor membro" do
    expect(build(:comment)).to be_valid
  end

  it "é inválido sem body" do
    expect(build(:comment, body: nil)).not_to be_valid
  end

  it "é inválido com autor fora do projeto" do
    project = create(:project)
    outsider = create(:user)
    task = create(:task, project: project)
    comment = build(:comment, task: task, author: outsider)
    task.project.users.delete(outsider)
    expect(comment).not_to be_valid
  end

  it "é destruído junto com a task" do
    comment = create(:comment)
    expect { comment.task.destroy }.to change(described_class, :count).by(-1)
  end
end
