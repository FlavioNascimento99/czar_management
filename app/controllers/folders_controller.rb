class FoldersController < ApplicationController
  before_action :require_login
  before_action :set_folder, only: [ :show, :edit, :update, :destroy ]

  def index
    @folders = current_user.folders.roots.includes(:subfolders)
    @loose_docs = current_user.docs.where(folder_id: nil).recent.limit(10)
  end

  def show
    @subfolders = @folder.subfolders.ordered
    @docs = @folder.docs.recent.page(params[:page]).per(20)
  end

  def new
    @folder = current_user.folders.build(parent_id: params[:parent_id])
    @folders = current_user.folders.ordered
  end

  def create
    @folder = current_user.folders.build(folder_params)
    if @folder.save
      redirect_to @folder, notice: "Pasta criada!"
    else
      @folders = current_user.folders.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @folders = current_user.folders.where.not(id: @folder.id).ordered
  end

  def update
    if @folder.update(folder_params)
      redirect_to @folder, notice: "Pasta atualizada!"
    else
      @folders = current_user.folders.where.not(id: @folder.id).ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_path, notice: "Pasta excluída!"
  end

  private

  def set_folder
    @folder = current_user.folders.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
