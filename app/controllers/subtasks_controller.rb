class SubtasksController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :set_task
  before_action :check_project_member
  before_action :set_subtask, only: [ :toggle, :destroy ]

  def create
    @subtask = @task.subtasks.build(subtask_params)
    if @subtask.save
      redirect_to [ @project, @task ], notice: "Subtarefa adicionada!"
    else
      redirect_to [ @project, @task ], alert: @subtask.errors.full_messages.to_sentence
    end
  end

  def toggle
    @subtask.toggle!
    redirect_to [ @project, @task ]
  end

  def destroy
    @subtask.destroy
    redirect_to [ @project, @task ], notice: "Subtarefa removida!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def set_subtask
    @subtask = @task.subtasks.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = I18n.t("projects.forbidden")
      redirect_to projects_path
    end
  end

  def subtask_params
    params.require(:subtask).permit(:title)
  end
end
