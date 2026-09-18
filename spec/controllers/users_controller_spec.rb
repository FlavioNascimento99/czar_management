require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #show" do
    it "redireciona deslogado para o login" do
      get :show, params: { id: user.id }
      expect(response).to redirect_to(login_path)
    end

    it "mostra o próprio perfil" do
      allow(controller).to receive(:current_user).and_return(user)
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
      expect(response).to have_http_status(:ok)
    end

    it "bloqueia perfil de outro usuário" do
      allow(controller).to receive(:current_user).and_return(user)
      other = create(:user)
      get :show, params: { id: other.id }
      expect(response).to redirect_to(root_path)
    end
  end
end
