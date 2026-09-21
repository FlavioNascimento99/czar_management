require 'rails_helper'

RSpec.describe MyTasksController, type: :controller do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let!(:mine) { create(:task, assigned_to: user) }
  let!(:theirs) { create(:task, assigned_to: other) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  it "lista só minhas tarefas" do
    get :index
    expect(assigns(:tasks)).to include(mine)
    expect(assigns(:tasks)).not_to include(theirs)
  end

  it "filtra atrasadas" do
    mine.update!(due_date: 2.days.ago.to_date, status: "pendente")
    get :index, params: { filter: "overdue" }
    expect(assigns(:tasks)).to include(mine)
  end

  it "exige login" do
    allow(controller).to receive(:current_user).and_return(nil)
    get :index
    expect(response).to redirect_to(login_path)
  end
end
