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

  it "não permite email duplicado com caixa diferente" do
    create(:user, email: "teste@email.com")
    user = build(:user, email: "TESTE@EMAIL.COM")
    expect(user).not_to be_valid
  end

  it "normaliza o email antes de validar" do
    user = build(:user, email: "  Teste@Email.COM  ")
    expect(user).to be_valid
    expect(user.email).to eq("teste@email.com")
  end

  it "é inválido com senha curta" do
    user = build(:user, password: "curta")
    expect(user).not_to be_valid
  end

  it "retorna os projetos do usuário" do
    user = create(:user)
    project = create(:project)
    project.users << user
    expect(user.projects).to include(project)
  end
end
