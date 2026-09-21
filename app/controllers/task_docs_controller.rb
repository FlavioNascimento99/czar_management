class TaskDocsController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :set_task
  before_action :check_project_member

  def create
    doc = current_user.docs.find(params[:doc_id])
    @task_doc = @task.task_docs.build(doc: doc)
    if @task_doc.save
      redirect_to [ @project, @task ], notice: "Documento vinculado!"
    else
      redirect_to [ @project, @task ], alert: @task_doc.errors.full_messages.to_sentence
    end
  end

  def destroy
    @task.task_docs.find(params[:id]).destroy
    redirect_to [ @project, @task ], notice: "Vínculo removido!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = I18n.t("projects.forbidden")
      redirect_to projects_path
    end
  end
end
