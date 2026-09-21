class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_project
  before_action :set_task
  before_action :check_project_member
  before_action :set_comment, only: [ :destroy ]
  before_action :check_can_destroy, only: [ :destroy ]

  def create
    @comment = @task.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      ActivityLog.log!(project: @project, actor: current_user, action: "comment_created", trackable: @comment)
      redirect_to [ @project, @task ], notice: "Comentário adicionado!"
    else
      redirect_to [ @project, @task ], alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment.destroy
    redirect_to [ @project, @task ], notice: "Comentário excluído!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = I18n.t("projects.forbidden")
      redirect_to projects_path
    end
  end

  def check_can_destroy
    unless @comment.author == current_user || @project.owned_by?(current_user)
      flash[:alert] = I18n.t("projects.owner_only")
      redirect_to [ @project, @task ]
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
