class TasksController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :check_project_member
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  # Enum inválido (ex.: status/prioridade adulterados no form) levanta
  # ArgumentError na atribuição; converte em 302 com alerta em vez de 500.
  rescue_from ArgumentError, with: :invalid_enumeration

  def index
    @tasks = @project.tasks.includes(:author, :assigned_to)
  end

  def show
  end

  def new
    @task = @project.tasks.build
    @project_users = @project.users.order(:name)
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.author = current_user

    if @task.save
      redirect_to [ @project, @task ], notice: "Tarefa criada com sucesso!"
    else
      @project_users = @project.users.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project_users = @project.users.order(:name)
  end

  def update
    if @task.update(task_params)
      redirect_to [ @project, @task ], notice: "Tarefa atualizada com sucesso!"
    else
      @project_users = @project.users.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: "Tarefa excluída com sucesso!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = "Você não tem permissão para acessar este projeto"
      redirect_to projects_path
    end
  end

  def invalid_enumeration
    redirect_to @project, alert: "Status ou prioridade inválidos"
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :assigned_to_id)
  end
end
