require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [user]) }
  let(:task) { create(:task, project: project, author: user, assigned_to: user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "POST #create" do
    it "cria uma nova tarefa" do
      expect {
        post :create, params: { project_id: project.id, task: { title: "Tarefa X", description: "desc", status: "pendente", priority: "baixa", assigned_to_id: user.id } }
      }.to change(Task, :count).by(1)
      expect(response).to redirect_to(project_task_path(project, Task.last))
    end
  end

  describe "PATCH #update" do
    it "atualiza uma tarefa" do
      patch :update, params: { project_id: project.id, id: task.id, task: { title: "Editada" } }
      expect(task.reload.title).to eq("Editada")
      expect(response).to redirect_to(project_task_path(project, task))
    end
  end

  describe "DELETE #destroy" do
    it "remove a tarefa" do
      delete :destroy, params: { project_id: project.id, id: task.id }
      expect(Task.exists?(task.id)).to be_falsey
      expect(response).to redirect_to(project)
    end
  end
end
