require 'rails_helper'

RSpec.describe DocsController, type: :controller do
  let(:user) { create(:user) }
  before { allow(controller).to receive(:current_user).and_return(user) }

  it "cria doc pessoal" do
    expect {
      post :create, params: { doc: { title: "D", body: "# oi" } }
    }.to change(Doc, :count).by(1)
  end

  it "nunca mostra doc alheio" do
    other = create(:doc)
    expect {
      get :show, params: { id: other.id }
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "preview renderiza sem salvar" do
    post :preview, params: { body: "**negrito**" }
    expect(response.body).to include("<strong>")
  end
end

RSpec.describe FoldersController, type: :controller do
  let(:user) { create(:user) }
  before { allow(controller).to receive(:current_user).and_return(user) }

  it "cria pasta aninhada" do
    parent = create(:folder, user: user)
    expect {
      post :create, params: { folder: { name: "Filha", parent_id: parent.id } }
    }.to change(Folder, :count).by(1)
  end

  it "nunca mostra pasta alheia" do
    other = create(:folder)
    expect {
      get :show, params: { id: other.id }
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
