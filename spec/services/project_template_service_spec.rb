require 'rails_helper'

RSpec.describe ProjectTemplateService do
  it "aplica sprint_dev com requisitos e tarefas" do
    project = create(:project)
    creator = project.owner
    expect {
      described_class.apply!(project: project, template_key: "sprint_dev", creator: creator)
    }.to change(project.requirements, :count).by(3).and change(project.tasks, :count).by(3)
  end

  it "rejeita template desconhecido" do
    project = create(:project)
    expect {
      described_class.apply!(project: project, template_key: "nope", creator: project.owner)
    }.to raise_error(ArgumentError)
  end
end
