class DocsController < ApplicationController
  before_action :require_login
  before_action :set_doc, only: [ :show, :edit, :update, :destroy, :purge_file ]

  def index
    scope = current_user.docs.includes(:folder).recent
    scope = scope.search(params[:q]) if params[:q].present?
    scope = scope.where(folder_id: params[:folder_id]) if params[:folder_id].present?
    @docs = scope.page(params[:page]).per(20)
    @folders = current_user.folders.ordered
  end

  def show
  end

  def new
    @doc = current_user.docs.build(folder_id: params[:folder_id])
    @folders = current_user.folders.ordered
  end

  def create
    @doc = current_user.docs.build(doc_params)
    if @doc.save
      redirect_to @doc, notice: "Documento criado!"
    else
      @folders = current_user.folders.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @folders = current_user.folders.ordered
  end

  def update
    if @doc.update(doc_params)
      redirect_to @doc, notice: "Documento atualizado!"
    else
      @folders = current_user.folders.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @doc.destroy
    redirect_to docs_path, notice: "Documento excluído!"
  end

  def preview
    html = Doc.new(body: params[:body].to_s).rendered_body
    render html: html.html_safe
  end

  def purge_file
    @doc.files.find(params[:attachment_id]).purge
    redirect_to @doc, notice: "Anexo removido!"
  end

  private

  def set_doc
    @doc = current_user.docs.find(params[:id])
  end

  def doc_params
    params.require(:doc).permit(:title, :body, :folder_id, files: [])
  end
end
