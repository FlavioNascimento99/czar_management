require 'rails_helper'

RSpec.describe Subtask, type: :model do
  it "é válido com título" do
    expect(build(:subtask)).to be_valid
  end

  it "é inválido sem título" do
    expect(build(:subtask, title: "")).not_to be_valid
  end

  it "#toggle! alterna done" do
    subtask = create(:subtask, done: false)
    subtask.toggle!
    expect(subtask.done).to be_truthy
  end
end

RSpec.describe SubtasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let(:task) { create(:task, project: project, author: user, assigned_to: user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  it "cria subtarefa" do
    expect {
      post :create, params: { project_id: project.id, task_id: task.id, subtask: { title: "Passo 1" } }
    }.to change(Subtask, :count).by(1)
  end

  it "alterna done" do
    subtask = create(:subtask, task: task, done: false)
    patch :toggle, params: { project_id: project.id, task_id: task.id, id: subtask.id }
    expect(subtask.reload.done).to be_truthy
  end

  it "bloqueia não-membro" do
    outsider = create(:user)
    allow(controller).to receive(:current_user).and_return(outsider)
    post :create, params: { project_id: project.id, task_id: task.id, subtask: { title: "spam" } }
    expect(response).to redirect_to(projects_path)
  end
end
