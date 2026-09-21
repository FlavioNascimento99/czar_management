require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "é válido com nome e cor" do
    expect(build(:tag)).to be_valid
  end

  it "exige nome único por projeto (case-insensitive)" do
    tag = create(:tag, name: "Frontend")
    expect(build(:tag, project: tag.project, name: "frontend")).not_to be_valid
  end

  it "permite mesmo nome em projetos diferentes" do
    create(:tag, name: "Frontend")
    expect(build(:tag, name: "Frontend")).to be_valid
  end

  it "rejeita cor inválida" do
    expect(build(:tag, color: "red")).not_to be_valid
  end
end

RSpec.describe TaskTag, type: :model do
  it "exige mesmo projeto entre task e tag" do
    task_tag = build(:task_tag)
    task_tag.tag.project = create(:project)
    expect(task_tag).not_to be_valid
  end

  it "aceita tag do mesmo projeto" do
    project = create(:project)
    task = create(:task, project: project)
    tag = create(:tag, project: project)
    expect(build(:task_tag, task: task, tag: tag)).to be_valid
  end
end
