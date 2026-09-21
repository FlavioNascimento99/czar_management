require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  it "é válido com projeto, ator e ação" do
    expect(build(:activity_log)).to be_valid
  end

  it "rejeita ação desconhecida" do
    expect(build(:activity_log, action: "hacked")).not_to be_valid
  end

  it ".log! cria registro com trackable" do
    project = create(:project)
    actor = create(:user)
    task = create(:task, project: project)
    expect {
      described_class.log!(project: project, actor: actor, action: "task_created", trackable: task)
    }.to change(described_class, :count).by(1)
  end
end
