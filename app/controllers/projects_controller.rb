class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_project_member, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def show
    @tasks = @project.tasks.includes(:author, :assigned_to)
    @requirements = @project.requirements
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    
    if @project.save
      @project.users << current_user
      redirect_to @project, notice: 'Projeto criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Projeto atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Projeto excluído com sucesso!'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def check_project_member
    unless @project.users.include?(current_user)
      flash[:alert] = 'Você não tem permissão para acessar este projeto'
      redirect_to projects_path
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
