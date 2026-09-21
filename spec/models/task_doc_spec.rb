require 'rails_helper'

RSpec.describe TaskDoc, type: :model do
  it "vincula doc do próprio usuário membro" do
    user = create(:user)
    project = create(:project, users: [ user ])
    task = create(:task, project: project, author: user, assigned_to: user)
    doc = create(:doc, user: user)
    expect(build(:task_doc, task: task, doc: doc)).to be_valid
  end

  it "rejeita doc de quem não é membro do projeto" do
    task = create(:task)
    outsider_doc = create(:doc)
    expect(TaskDoc.new(task: task, doc: outsider_doc)).not_to be_valid
  end

  it "rejeita duplicado" do
    link = create(:task_doc)
    expect(build(:task_doc, task: link.task, doc: link.doc)).not_to be_valid
  end
end

RSpec.describe TaskDocsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let(:task) { create(:task, project: project, author: user, assigned_to: user) }
  let(:doc) { create(:doc, user: user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  it "vincula e desvincula" do
    expect {
      post :create, params: { project_id: project.id, task_id: task.id, doc_id: doc.id }
    }.to change(TaskDoc, :count).by(1)
    link = TaskDoc.last
    expect {
      delete :destroy, params: { project_id: project.id, task_id: task.id, id: link.id }
    }.to change(TaskDoc, :count).by(-1)
  end

  it "não vincula doc alheio (404 escopado)" do
    other_doc = create(:doc)
    expect {
      post :create, params: { project_id: project.id, task_id: task.id, doc_id: other_doc.id }
    }.to raise_error(ActiveRecord::RecordNotFound)
    expect(TaskDoc.count).to eq(0)
  end
end
