module NotificationsHelper
  def notification_text(notification)
    actor = notification.actor&.name || "Sistema"
    case notification.action
    when "task_assigned" then "#{actor} atribuiu uma tarefa a você"
    when "task_reassigned" then "#{actor} reatribuiu uma tarefa a você"
    when "task_commented" then "#{actor} comentou numa tarefa sua"
    when "member_added" then "#{actor} adicionou você a um projeto"
    when "due_soon" then "Uma tarefa vence amanhã"
    when "overdue" then "Você tem tarefa atrasada"
    else notification.action
    end
  end

  def notification_link(notification)
    target = notification.notifiable
    case target
    when Task then [ target.project, target ]
    when Comment then [ target.task.project, target.task ]
    when Project then target
    else notifications_path
    end
  rescue StandardError
    notifications_path
  end
end
