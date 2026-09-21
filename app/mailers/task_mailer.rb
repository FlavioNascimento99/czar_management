class TaskMailer < ApplicationMailer
  default from: "Czar <noreply@example.com>"

  def assigned_task(task_id)
    @task = Task.includes(:project, :assigned_to).find(task_id)
    @project = @task.project
    mail(to: @task.assigned_to.email, subject: "[Czar] Nova tarefa para você: #{@task.title}")
  end

  def task_reassigned(task_id)
    @task = Task.includes(:project, :assigned_to).find(task_id)
    @project = @task.project
    mail(to: @task.assigned_to.email, subject: "[Czar] Tarefa reatribuída: #{@task.title}")
  end

  def task_commented(comment_id)
    @comment = Comment.includes(task: [ :project, :assigned_to, :author ]).find(comment_id)
    @task = @comment.task
    @project = @task.project
    recipients = [ @task.assigned_to, @task.author ].compact.uniq - [ @comment.author ]
    return if recipients.empty?
    mail(to: recipients.map(&:email), subject: "[Czar] Novo comentário em: #{@task.title}")
  end

  def member_added(project_id, user_id)
    @project = Project.find(project_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "[Czar] Você entrou no projeto: #{@project.name}")
  end
end
