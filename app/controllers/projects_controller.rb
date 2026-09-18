class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :add_member, :remove_member ]
  before_action :check_project_member, only: [ :show, :edit, :update, :destroy, :add_member, :remove_member ]
  before_action :require_owner, only: [ :destroy, :add_member ]

  def index
    @projects = current_user.projects
  end

  def show
    @tasks = @project.tasks
                     .includes(:author, :assigned_to)
                     .order(created_at: :desc)
                     .page(params[:tasks_page]).per(6)

    @requirements = @project.requirements
                            .order(created_at: :desc)
                            .page(params[:requirements_page]).per(6)
    @members = @project.users.order(:name)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    begin
      ActiveRecord::Base.transaction do
        @project.save!
        @project.users << current_user
      end
      redirect_to @project, notice: "Projeto criado com sucesso!"
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Projeto atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Projeto excluído com sucesso!"
  end

  def add_member
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user.nil?
      redirect_to @project, alert: "Usuário não encontrado com esse email"
    elsif @project.member?(user)
      redirect_to @project, alert: "Usuário já é membro do projeto"
    else
      @project.users << user
      redirect_to @project, notice: "Membro adicionado com sucesso!"
    end
  end

  def remove_member
    user = User.find_by(id: params[:user_id])

    if user.nil? || !@project.member?(user)
      redirect_to @project, alert: "Membro não encontrado"
    elsif @project.owned_by?(user)
      redirect_to @project, alert: "O dono do projeto não pode ser removido"
    elsif @project.owned_by?(current_user) || user == current_user
      @project.users.delete(user)
      redirect_to @project, notice: "Membro removido com sucesso!"
    else
      redirect_to @project, alert: "Apenas o dono pode remover membros"
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = "Você não tem permissão para acessar este projeto"
      redirect_to projects_path
    end
  end

  def require_owner
    unless @project.owned_by?(current_user)
      redirect_to @project, alert: "Apenas o dono do projeto pode fazer isso"
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
