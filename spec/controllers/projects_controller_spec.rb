require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user, users: [ user ]) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "GET #index" do
    it "retorna os projetos do usuário" do
      project # força criação antes da requisição (index avalia eager)
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

    it "bloqueia quem não é membro" do
      other = create(:project)
      get :show, params: { id: other.id }
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "POST #create" do
    it "cria um novo projeto com o criador como dono e membro" do
      expect {
        post :create, params: { project: { name: "Novo Projeto", description: "Desc" } }
      }.to change(Project, :count).by(1)
      created = Project.last
      expect(created.owner).to eq(user)
      expect(created.member?(user)).to be_truthy
      expect(response).to redirect_to(created)
    end

    it "aplica template quando informado" do
      expect {
        post :create, params: { project: { name: "Sprint", description: "Desc", template: "onboarding" } }
      }.to change(Task, :count).by(2)
      expect(Project.last.tasks.count).to eq(2)
    end

    it "cria espaço pessoal com rotina de estudos" do
      post :create, params: { project: { name: "Estudos", description: "Minha rotina", kind: "pessoal", template: "rotina_estudos" } }
      created = Project.last
      expect(created.pessoal?).to be_truthy
      expect(created.tasks.count).to eq(3)
      expect(response).to redirect_to(created)
    end
  end

  describe "espaços pessoais" do
    it "index separa equipe e pessoal" do
      personal = create(:project, owner: user, users: [ user ], kind: "pessoal")
      get :index
      expect(assigns(:personal_projects)).to include(personal)
      expect(assigns(:team_projects)).not_to include(personal)
    end

    it "bloqueia add_member em pessoal" do
      personal = create(:project, owner: user, users: [ user ], kind: "pessoal")
      newcomer = create(:user)
      post :add_member, params: { id: personal.id, email: newcomer.email }
      expect(personal.reload.member?(newcomer)).to be_falsey
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
    it "remove o projeto quando é o dono" do
      delete :destroy, params: { id: project.id }
      expect(Project.exists?(project.id)).to be_falsey
      expect(response).to redirect_to(projects_path)
    end

    it "bloqueia membro que não é dono" do
      other_owner = create(:user)
      owned = create(:project, owner: other_owner, users: [ other_owner, user ])
      delete :destroy, params: { id: owned.id }
      expect(Project.exists?(owned.id)).to be_truthy
      expect(response).to redirect_to(owned)
    end
  end

  describe "POST #add_member" do
    it "adiciona membro por email" do
      newcomer = create(:user)
      post :add_member, params: { id: project.id, email: newcomer.email }
      expect(project.reload.member?(newcomer)).to be_truthy
      expect(response).to redirect_to(project)
    end

    it "rejeita email desconhecido" do
      post :add_member, params: { id: project.id, email: "fantasma@example.com" }
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to be_present
    end

    it "permite membro (nao-dono) adicionar" do
      other_owner = create(:user)
      owned = create(:project, owner: other_owner, users: [ other_owner, user ])
      newcomer = create(:user)
      post :add_member, params: { id: owned.id, email: newcomer.email }
      expect(owned.reload.member?(newcomer)).to be_truthy
      expect(response).to redirect_to(owned)
    end

    it "bloqueia nao-membro" do
      outsider_project = create(:project)
      newcomer = create(:user)
      post :add_member, params: { id: outsider_project.id, email: newcomer.email }
      expect(response).to redirect_to(projects_path)
      expect(outsider_project.reload.member?(newcomer)).to be_falsey
    end

    it "registra activity ao adicionar" do
      newcomer = create(:user)
      expect {
        post :add_member, params: { id: project.id, email: newcomer.email }
      }.to change(ActivityLog, :count).by(1)
    end
  end

  describe "GET #board" do
    it "mostra colunas do kanban" do
      get :board, params: { id: project.id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:columns).keys).to match_array(%w[pendente em_andamento concluida])
    end

    it "bloqueia não-membro" do
      other = create(:project)
      get :board, params: { id: other.id }
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "DELETE #remove_member" do
    it "dono remove membro" do
      member = create(:user)
      project.users << member
      delete :remove_member, params: { id: project.id, user_id: member.id }
      expect(project.reload.member?(member)).to be_falsey
      expect(response).to redirect_to(project)
    end

    it "não permite remover o dono" do
      delete :remove_member, params: { id: project.id, user_id: user.id }
      expect(project.reload.member?(user)).to be_truthy
      expect(response).to redirect_to(project)
    end

    it "membro pode sair sozinho" do
      other_owner = create(:user)
      owned = create(:project, owner: other_owner, users: [ other_owner, user ])
      delete :remove_member, params: { id: owned.id, user_id: user.id }
      expect(owned.reload.member?(user)).to be_falsey
      expect(response).to redirect_to(owned)
    end
  end
end
