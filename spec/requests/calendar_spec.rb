require 'rails_helper'

RSpec.describe "Calendários iCal", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [ user ]) }
  let!(:task) { create(:task, project: project, author: user, assigned_to: user, due_date: Date.new(2026, 10, 5)) }

  before do
    post "/login", params: { email: user.email, password: "password123" }
  end

  it "exporta projeto em text/calendar com VEVENT" do
    get "/projects/#{project.id}/calendar.ics"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include("text/calendar")
    expect(response.body).to include("BEGIN:VCALENDAR").and include("BEGIN:VEVENT").and include("DTSTART;VALUE=DATE:20261005")
  end

  it "exporta minhas tarefas" do
    get "/my_tasks/calendar.ics"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Minhas Tarefas")
  end

  it "bloqueia projeto alheio" do
    other = create(:project)
    get "/projects/#{other.id}/calendar.ics"
    expect(response).to redirect_to(projects_path)
  end
end
