require 'rails_helper'

RSpec.describe Requirement, type: :model do
  it "é válido com título, descrição e prioridade" do
    requirement = build(:requirement)
    expect(requirement).to be_valid
  end

  it "é inválido sem título" do
    requirement = build(:requirement, title: nil)
    expect(requirement).not_to be_valid
  end

  it "é inválido sem descrição" do
    requirement = build(:requirement, description: nil)
    expect(requirement).not_to be_valid
  end

  it "é inválido sem prioridade" do
    requirement = build(:requirement, priority: nil)
    expect(requirement).not_to be_valid
  end

  it "pertence a um projeto" do
    project = create(:project)
    requirement = create(:requirement, project: project)
    expect(requirement.project).to eq(project)
  end
end
