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

  describe "anexos" do
    it "rejeita executável" do
      task = build(:task)
      task.files.attach(io: StringIO.new("x"), filename: "run.exe", content_type: "application/octet-stream")
      expect(task).not_to be_valid
    end

    it "aceita txt pequeno" do
      task = build(:task)
      task.files.attach(io: StringIO.new("hello"), filename: "nota.txt", content_type: "text/plain")
      expect(task).to be_valid
    end
  end

  describe "prazos" do
    it "detecta atrasada" do
      task = build(:task, due_date: 1.day.ago.to_date, status: "pendente")
      expect(task.overdue?).to be_truthy
    end

    it "concluída não conta como atrasada" do
      task = build(:task, due_date: 1.day.ago.to_date, status: "concluida")
      expect(task.overdue?).to be_falsey
    end

    it ".overdue retorna só pendentes/em andamento vencidas" do
      project = create(:project)
      overdue = create(:task, project: project, due_date: 2.days.ago.to_date, status: "pendente")
      create(:task, project: project, due_date: 2.days.ago.to_date, status: "concluida")
      expect(Task.overdue).to include(overdue)
      expect(Task.overdue.count).to eq(1)
    end
  end
end
