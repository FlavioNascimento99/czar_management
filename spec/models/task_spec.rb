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
    assignee = create(:user)
    task = create(:task, assigned_to: assignee)
    expect(task.assigned_to).to eq(assignee)
  end
end
