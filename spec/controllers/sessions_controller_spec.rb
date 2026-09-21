require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, password: "password123") }

  describe "POST #create" do
    it "loga com credenciais válidas" do
      post :create, params: { email: user.email, password: "password123" }
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it "loga com email em caixa alta e espaços" do
      post :create, params: { email: "  #{user.email.upcase}  ", password: "password123" }
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it "reseta a sessão no login (anti-fixation)" do
      post :create, params: { email: user.email, password: "password123" }, session: { pre_login: "stale" }
      expect(session[:user_id]).to eq(user.id)
      expect(session[:pre_login]).to be_nil
    end

    it "não loga com credenciais inválidas" do
      post :create, params: { email: user.email, password: "errada" }
      expect(session[:user_id]).to be_nil
      expect(response).to render_template(:new)
    end
  end

  describe "DELETE #destroy" do
    it "faz logout" do
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
