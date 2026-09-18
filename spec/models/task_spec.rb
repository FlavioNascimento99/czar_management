require 'rails_helper'

RSpec.describe Task, type: :model do
  it "é válido com título, descrição, autor e responsável" do
    task = build(:task)
    expect(task).to be_valid
  end

  it "é inválido sem título" do
    task = build(:task, title: nil)
    expect(task).not_to be_valid
  end

  it "é inválido sem status" do
    task = build(:task, status: nil)
    expect(task).not_to be_valid
  end

  it "é inválido sem prioridade" do
    task = build(:task, priority: nil)
    expect(task).not_to be_valid
  end

  it "pertence a um projeto" do
    project = create(:project)
    task = create(:task, project: project)
    expect(task.project).to eq(project)
  end

  it "tem um autor" do
    author = create(:user)
    task = create(:task, author: author)
    expect(task.author).to eq(author)
  end

  it "tem um responsável" do
    project = create(:project)
    assignee = create(:user)
    project.users << assignee
    task = create(:task, project: project, assigned_to: assignee)
    expect(task.assigned_to).to eq(assignee)
  end

  it "é inválido com responsável fora do projeto" do
    project = create(:project)
    outsider = create(:user)
    task = build(:task, project: project, assigned_to: outsider)
    # a factory adiciona o responsável como membro; remove para simular invasão
    task.project.users.delete(outsider)
    expect(task).not_to be_valid
  end
end
