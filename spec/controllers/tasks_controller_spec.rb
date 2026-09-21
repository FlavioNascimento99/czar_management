require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let(:task) { create(:task, project: project, author: user, assigned_to: user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "POST #create" do
    it "cria uma nova tarefa" do
      expect {
        post :create, params: { project_id: project.id, task: { title: "Tarefa X", description: "desc", status: "pendente", priority: "baixa", assigned_to_id: user.id } }
      }.to change(Task, :count).by(1)
      expect(response).to redirect_to(project_task_path(project, Task.last))
    end

    it "não enfileira e-mail por padrão (conexão externa desligada)" do
      other = create(:user)
      project.users << other
      expect {
        post :create, params: { project_id: project.id, task: { title: "Tarefa Z", description: "desc", status: "pendente", priority: "baixa", assigned_to_id: other.id } }
      }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it "enfileira e-mail quando EMAIL_ENABLED=true" do
      allow(Rails.configuration.x).to receive(:email_enabled).and_return(true)
      other = create(:user)
      project.users << other
      expect {
        post :create, params: { project_id: project.id, task: { title: "Tarefa Z", description: "desc", status: "pendente", priority: "baixa", assigned_to_id: other.id } }
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it "rejeita responsável que não é membro" do
      outsider = create(:user)
      expect {
        post :create, params: { project_id: project.id, task: { title: "Tarefa Y", description: "desc", status: "pendente", priority: "baixa", assigned_to_id: outsider.id } }
      }.not_to change(Task, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH #update" do
    it "atualiza uma tarefa" do
      patch :update, params: { project_id: project.id, id: task.id, task: { title: "Editada" } }
      expect(task.reload.title).to eq("Editada")
      expect(response).to redirect_to(project_task_path(project, task))
    end
  end

  describe "GET #index com filtros" do
    it "filtra por status e busca textual" do
      create(:task, project: project, author: user, assigned_to: user, title: "Login mágico", status: "pendente")
      create(:task, project: project, author: user, assigned_to: user, title: "Checkout", status: "concluida")
      get :index, params: { project_id: project.id, status: "pendente", q: "mágico" }
      expect(assigns(:tasks).map(&:title)).to include("Login mágico")
      expect(assigns(:tasks).map(&:title)).not_to include("Checkout")
    end
  end

  describe "PATCH #update via JSON (kanban)" do
    it "move status e retorna json" do
      patch :update, params: { project_id: project.id, id: task.id, task: { status: "em_andamento" }, format: :json }
      expect(task.reload.status).to eq("em_andamento")
      expect(response).to have_http_status(:ok)
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
