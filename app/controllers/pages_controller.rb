class PagesController < ApplicationController
  def home
    return unless logged_in?

    @projects = current_user.projects.order(:name).limit(6)
    @projects_count = current_user.projects.count
    assigned = Task.joins(:project)
                   .where(projects: { id: current_user.project_ids })
                   .where(assigned_to: current_user)
    @assigned_count = assigned.count
    @done_count = assigned.concluida.count
    @doing_count = assigned.em_andamento.count
    @my_tasks = assigned.includes(:project).order(created_at: :desc).limit(8)
  end
end
