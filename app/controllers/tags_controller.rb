class TagsController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :check_project_member
  before_action :set_tag, only: [ :edit, :update, :destroy ]

  def index
    @tags = @project.tags.order(:name).page(params[:page]).per(20)
  end

  def new
    @tag = @project.tags.build
  end

  def create
    @tag = @project.tags.build(tag_params)
    if @tag.save
      redirect_to project_tags_path(@project), notice: "Etiqueta criada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to project_tags_path(@project), notice: "Etiqueta atualizada!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to project_tags_path(@project), notice: "Etiqueta excluída!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_tag
    @tag = @project.tags.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = I18n.t("projects.forbidden")
      redirect_to projects_path
    end
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
