require 'rails_helper'

RSpec.describe Project, type: :model do
  it "é válido com nome e descrição" do
    project = build(:project)
    expect(project).to be_valid
  end

  it "é inválido sem nome" do
    project = build(:project, name: nil)
    expect(project).not_to be_valid
  end

  it "pode ter múltiplos usuários" do
    project = create(:project)
    users = create_list(:user, 2)
    project.users << users
    expect(project.users.count).to eq(3)
  end

  it "retorna as tarefas associadas" do
    project = create(:project)
    task = create(:task, project: project)
    expect(project.tasks).to include(task)
  end

  it "retorna os requisitos associados" do
    project = create(:project)
    requirement = create(:requirement, project: project)
    expect(project.requirements).to include(requirement)
  end
end
