require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  it "cria etiqueta no projeto" do
    expect {
      post :create, params: { project_id: project.id, tag: { name: "backend", color: "#ff0000" } }
    }.to change(Tag, :count).by(1)
  end

  it "bloqueia não-membro" do
    outsider = create(:user)
    allow(controller).to receive(:current_user).and_return(outsider)
    post :create, params: { project_id: project.id, tag: { name: "x", color: "#ff0000" } }
    expect(response).to redirect_to(projects_path)
  end
end
