require 'rails_helper'

RSpec.describe Notification, type: :model do
  it "é válido com usuário e ação" do
    expect(build(:notification)).to be_valid
  end

  it ".notify! ignora quando user == actor" do
    user = create(:user)
    expect {
      described_class.notify!(user: user, action: "task_assigned", actor: user)
    }.not_to change(described_class, :count)
  end

  it ".notify! cria para outro usuário" do
    expect {
      described_class.notify!(user: create(:user), action: "member_added", actor: create(:user))
    }.to change(described_class, :count).by(1)
  end
end

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  before { allow(controller).to receive(:current_user).and_return(user) }

  it "lista e marca como lida" do
    notification = create(:notification, user: user)
    get :index
    expect(assigns(:notifications)).to include(notification)
    patch :mark_read, params: { id: notification.id }
    expect(notification.reload.read?).to be_truthy
  end

  it "marca todas como lidas" do
    create_list(:notification, 2, user: user)
    patch :mark_all_read
    expect(user.notifications.unread.count).to eq(0)
  end
end
