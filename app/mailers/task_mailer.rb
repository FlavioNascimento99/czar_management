class TaskMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "CZAR MANAGER <noreply@example.com>")

  def assigned_task(task_id)
    @task = Task.includes(:project, :assigned_to).find(task_id)
    @project = @task.project
    mail(to: @task.assigned_to.email, subject: "[CZAR MANAGER] Nova tarefa para você: #{@task.title}")
  end

  def task_reassigned(task_id)
    @task = Task.includes(:project, :assigned_to).find(task_id)
    @project = @task.project
    mail(to: @task.assigned_to.email, subject: "[CZAR MANAGER] Tarefa reatribuída: #{@task.title}")
  end

  def task_commented(comment_id)
    @comment = Comment.includes(task: [ :project, :assigned_to, :author ]).find(comment_id)
    @task = @comment.task
    @project = @task.project
    recipients = [ @task.assigned_to, @task.author ].compact.uniq - [ @comment.author ]
    return if recipients.empty?
    mail(to: recipients.map(&:email), subject: "[CZAR MANAGER] Novo comentário em: #{@task.title}")
  end

  def member_added(project_id, user_id)
    @project = Project.find(project_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "[CZAR MANAGER] Você entrou no projeto: #{@project.name}")
  end

  def due_reminder(task_id, kind)
    @task = Task.includes(:project, :assigned_to).find(task_id)
    @project = @task.project
    @kind = kind
    subject = kind == "overdue" ? "[CZAR MANAGER] Tarefa atrasada: #{@task.title}" : "[CZAR MANAGER] Vence amanhã: #{@task.title}"
    mail(to: @task.assigned_to.email, subject: subject)
  end
end
