require 'rails_helper'

RSpec.describe RequirementsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [user]) }
  let(:requirement) { create(:requirement, project: project) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "POST #create" do
    it "cria um novo requisito" do
      expect {
        post :create, params: { project_id: project.id, requirement: { title: "Req X", description: "desc", priority: "alta" } }
      }.to change(Requirement, :count).by(1)
      expect(response).to redirect_to(project_requirement_path(project, Requirement.last))
    end
  end

  describe "PATCH #update" do
    it "atualiza um requisito" do
      patch :update, params: { project_id: project.id, id: requirement.id, requirement: { title: "Editado" } }
      expect(requirement.reload.title).to eq("Editado")
      expect(response).to redirect_to(project_requirement_path(project, requirement))
    end
  end

  describe "DELETE #destroy" do
    it "remove um requisito" do
      delete :destroy, params: { project_id: project.id, id: requirement.id }
      expect(Requirement.exists?(requirement.id)).to be_falsey
      expect(response).to redirect_to(project)
    end
  end
end
