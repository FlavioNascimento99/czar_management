require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [user]) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "GET #index" do
    it "retorna os projetos do usuário" do
      get :index
      expect(assigns(:projects)).to include(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "mostra o projeto e suas tarefas/requisitos" do
      get :show, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "cria um novo projeto" do
      expect {
        post :create, params: { project: { name: "Novo Projeto", description: "Desc" } }
      }.to change(Project, :count).by(1)
      expect(response).to redirect_to(Project.last)
    end
  end

  describe "PATCH #update" do
    it "atualiza o projeto" do
      patch :update, params: { id: project.id, project: { name: "Atualizado" } }
      expect(project.reload.name).to eq("Atualizado")
      expect(response).to redirect_to(project)
    end
  end

  describe "DELETE #destroy" do
    it "remove o projeto" do
      delete :destroy, params: { id: project.id }
      expect(Project.exists?(project.id)).to be_falsey
      expect(response).to redirect_to(projects_path)
    end
  end
end
