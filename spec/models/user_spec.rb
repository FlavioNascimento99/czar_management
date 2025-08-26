require 'rails_helper'

RSpec.describe User, type: :model do
  it "é válido com nome, email e senha" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "é inválido sem nome" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it "é inválido sem email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "não permite email duplicado" do
    create(:user, email: "teste@email.com")
    user = build(:user, email: "teste@email.com")
    expect(user).not_to be_valid
  end

  it "retorna os projetos do usuário" do
    user = create(:user)
    project = create(:project)
    project.users << user
    expect(user.projects).to include(project)
  end
end
