class TasksController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :check_project_member
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :purge_file ]

  # Enum inválido (ex.: status/prioridade adulterados no form) levanta
  # ArgumentError na atribuição; converte em 302 com alerta em vez de 500.
  rescue_from ArgumentError, with: :invalid_enumeration

  def index
    scope = @project.tasks.includes(:author, :assigned_to, :tags).ordered_by_due
    scope = scope.where(status: params[:status]) if Task.statuses.key?(params[:status].to_s)
    scope = scope.where(priority: params[:priority]) if Task.priorities.key?(params[:priority].to_s)
    scope = scope.where(assigned_to_id: params[:assigned_to_id]) if params[:assigned_to_id].present?
    scope = scope.joins(:tags).where(tags: { id: params[:tag_id] }) if params[:tag_id].present?
    if params[:q].present?
      q = "%#{params[:q].to_s.strip}%"
      scope = scope.where("tasks.title LIKE ? OR tasks.description LIKE ?", q, q)
    end
    scope = scope.overdue if params[:filter] == "overdue"
    @tasks = scope.page(params[:page]).per(20)
    @project_users = @project.users.order(:name)
    @project_tags = @project.tags.order(:name)
  end

  def show
    @comments = @task.comments.includes(:author).order(created_at: :asc)
    @comment = @task.comments.build
  end

  def new
    @task = @project.tasks.build
    @project_users = @project.users.order(:name)
    @project_tags = @project.tags.order(:name)
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.author = current_user

    if @task.save
      ActivityLog.log!(project: @project, actor: current_user, action: "task_created", trackable: @task)
      TaskMailer.assigned_task(@task.id).deliver_later if @task.assigned_to != current_user
      redirect_to [ @project, @task ], notice: "Tarefa criada com sucesso!"
    else
      @project_users = @project.users.order(:name)
      @project_tags = @project.tags.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project_users = @project.users.order(:name)
    @project_tags = @project.tags.order(:name)
  end

  def update
    if @task.update(task_params)
      action = (@task.saved_change_to_status? && @task.concluida?) ? "task_completed" : "task_updated"
      ActivityLog.log!(project: @project, actor: current_user, action: action, trackable: @task)
      TaskMailer.task_reassigned(@task.id).deliver_later if @task.saved_change_to_assigned_to_id? && @task.assigned_to != current_user
      respond_to do |format|
        format.html { redirect_to [ @project, @task ], notice: "Tarefa atualizada com sucesso!" }
        format.json { render json: { id: @task.id, status: @task.status }, status: :ok }
      end
    else
      @project_users = @project.users.order(:name)
      @project_tags = @project.tags.order(:name)
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: "Tarefa excluída com sucesso!"
  end

  def purge_file
    attachment = @task.files.find(params[:attachment_id])
    attachment.purge
    redirect_to [ @project, @task ], notice: "Anexo removido!"
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
    params.require(:task).permit(:title, :description, :status, :priority, :assigned_to_id, :due_date, tag_ids: [], files: [])
  end
end
