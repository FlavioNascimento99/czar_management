class MyTasksController < ApplicationController
  before_action :require_login

  def index
    scope = current_user.assigned_tasks.includes(:project, :assigned_to).ordered_by_due

    scope = scope.where(status: params[:status]) if Task.statuses.key?(params[:status].to_s)

    case params[:filter]
    when "overdue"
      scope = scope.overdue
    when "today"
      scope = scope.due_today
    when "open"
      scope = scope.where.not(status: Task.statuses[:concluida])
    end

    @tasks = scope.page(params[:page]).per(20)
    @overdue_count = current_user.assigned_tasks.overdue.count
  end

  def calendar
    ics = IcalService.tasks_calendar(tasks: current_user.assigned_tasks.where.not(due_date: nil), calendar_name: "Minhas Tarefas")
    render plain: ics, content_type: "text/calendar"
  end
end
