require 'rails_helper'

RSpec.describe "Api::V1", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let!(:task) { create(:task, project: project, author: user, assigned_to: user) }
  let(:headers) { { "Authorization" => "Bearer #{user.api_token}" } }

  it "401 sem token" do
    get "/api/v1/projects"
    expect(response).to have_http_status(:unauthorized)
  end

  it "lista meus projetos" do
    get "/api/v1/projects", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.map { |p| p["id"] }).to include(project.id)
  end

  it "não vaza projeto alheio" do
    other = create(:project)
    get "/api/v1/projects/#{other.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "atualiza status da tarefa" do
    patch "/api/v1/projects/#{project.id}/tasks/#{task.id}", params: { task: { status: "em_andamento" } }, headers: headers
    expect(response).to have_http_status(:ok)
    expect(task.reload.status).to eq("em_andamento")
  end

  it "422 com status inválido" do
    patch "/api/v1/projects/#{project.id}/tasks/#{task.id}", params: { task: { status: "x" } }, headers: headers
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
