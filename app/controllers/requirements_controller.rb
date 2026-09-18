class RequirementsController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :check_project_member
  before_action :set_requirement, only: [ :show, :edit, :update, :destroy ]

  # Prioridade adulterada no form levanta ArgumentError na atribuição do enum;
  # converte em 302 com alerta em vez de 500.
  rescue_from ArgumentError, with: :invalid_enumeration

  def index
    @requirements = @project.requirements.page(params[:page]).per(20)
  end

  def show
  end

  def new
    @requirement = @project.requirements.build
  end

  def create
    @requirement = @project.requirements.build(requirement_params)

    if @requirement.save
      redirect_to [ @project, @requirement ], notice: "Requisito criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @requirement.update(requirement_params)
      redirect_to [ @project, @requirement ], notice: "Requisito atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @requirement.destroy
    redirect_to @project, notice: "Requisito excluído com sucesso!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_requirement
    @requirement = @project.requirements.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = "Você não tem permissão para acessar este projeto"
      redirect_to projects_path
    end
  end

  def invalid_enumeration
    redirect_to @project, alert: "Prioridade inválida"
  end

  def requirement_params
    params.require(:requirement).permit(:title, :description, :priority)
  end
end
