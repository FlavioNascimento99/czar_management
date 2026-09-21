class ProjectsController < ApplicationController
  before_action :require_login
  before_action :set_project, only: [ :show, :board, :calendar, :edit, :update, :destroy, :add_member, :remove_member ]
  before_action :check_project_member, only: [ :show, :board, :calendar, :edit, :update, :destroy, :add_member, :remove_member ]
  before_action :require_owner, only: [ :destroy ]

  def index
    @projects = current_user.projects.includes(:users).order(:name).to_a
    project_ids = @projects.map(&:id)
    @task_counts = Task.where(project_id: project_ids).group(:project_id).count
    @requirement_counts = Requirement.where(project_id: project_ids).group(:project_id).count
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
    @activities = @project.activity_logs.includes(:actor).recent.limit(20)
    @tasks_count = @project.tasks.count
    @tasks_done_count = @project.tasks.concluida.count
    @tasks_doing_count = @project.tasks.em_andamento.count
    @requirements_count = @project.requirements.count
  end

  def board
    tasks = @project.tasks.includes(:assigned_to, :tags).ordered_by_due
    @columns = {
      "pendente" => tasks.select(&:pendente?),
      "em_andamento" => tasks.select(&:em_andamento?),
      "concluida" => tasks.select(&:concluida?)
    }
  end

  def calendar
    ics = IcalService.tasks_calendar(tasks: @project.tasks.where.not(due_date: nil), calendar_name: @project.name)
    render plain: ics, content_type: "text/calendar"
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    @template_key = params[:project][:template].to_s if params[:project]
    @template_key = nil unless ProjectTemplateService.keys.include?(@template_key)

    begin
      ActiveRecord::Base.transaction do
        @project.save!
        @project.users << current_user
        ProjectTemplateService.apply!(project: @project, template_key: @template_key, creator: current_user) if @template_key
      end
      redirect_to @project, notice: I18n.t("projects.created")
    rescue ActiveRecord::RecordInvalid, ArgumentError
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: I18n.t("projects.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: I18n.t("projects.destroyed")
  end

  def add_member
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user.nil?
      redirect_to @project, alert: I18n.t("projects.user_not_found")
    elsif @project.member?(user)
      redirect_to @project, alert: I18n.t("projects.already_member")
    else
      @project.users << user
      ActivityLog.log!(project: @project, actor: current_user, action: "member_added", trackable: user)
      TaskMailer.member_added(@project.id, user.id).deliver_later
      redirect_to @project, notice: I18n.t("projects.member_added")
    end
  end

  def remove_member
    user = User.find_by(id: params[:user_id])

    if user.nil? || !@project.member?(user)
      redirect_to @project, alert: I18n.t("projects.member_not_found")
    elsif @project.owned_by?(user)
      redirect_to @project, alert: I18n.t("projects.owner_cannot_leave")
    elsif @project.owned_by?(current_user) || user == current_user
      @project.users.delete(user)
      ActivityLog.log!(project: @project, actor: current_user, action: "member_removed", trackable: user)
      redirect_to @project, notice: I18n.t("projects.member_removed")
    else
      redirect_to @project, alert: I18n.t("projects.owner_only")
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def check_project_member
    unless @project.member?(current_user)
      flash[:alert] = I18n.t("projects.forbidden")
      redirect_to projects_path
    end
  end

  def require_owner
    unless @project.owned_by?(current_user)
      redirect_to @project, alert: I18n.t("projects.owner_only")
    end
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
