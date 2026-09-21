require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let(:task) { create(:task, project: project, author: user, assigned_to: user) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "POST #create" do
    it "cria comentário como membro" do
      expect {
        post :create, params: { project_id: project.id, task_id: task.id, comment: { body: "Bom progresso!" } }
      }.to change(Comment, :count).by(1)
      expect(response).to redirect_to(project_task_path(project, task))
    end

    it "rejeita body vazio" do
      expect {
        post :create, params: { project_id: project.id, task_id: task.id, comment: { body: "" } }
      }.not_to change(Comment, :count)
    end

    it "bloqueia não-membro" do
      outsider = create(:user)
      allow(controller).to receive(:current_user).and_return(outsider)
      post :create, params: { project_id: project.id, task_id: task.id, comment: { body: "spam" } }
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "DELETE #destroy" do
    it "autor exclui próprio comentário" do
      comment = create(:comment, task: task, author: user)
      expect {
        delete :destroy, params: { project_id: project.id, task_id: task.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it "outro membro não exclui" do
      other = create(:user)
      project.users << other
      comment = create(:comment, task: task, author: other)
      delete :destroy, params: { project_id: project.id, task_id: task.id, id: comment.id }
      # user não é autor nem owner do projeto da factory (owner é outro user) -> bloqueia
      # garante que, se user for owner, ele pode; aqui owner é diferente, então mantém
      expect(Comment.exists?(comment.id)).to be_truthy
    end
  end
end
