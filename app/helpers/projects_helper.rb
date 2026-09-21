module ProjectsHelper
  def activity_description(log)
    actor = log.actor&.name || "Alguém"
    case log.action
    when "task_created" then "#{actor} criou a tarefa ##{log.trackable_id}"
    when "task_updated" then "#{actor} atualizou a tarefa ##{log.trackable_id}"
    when "task_completed" then "#{actor} concluiu a tarefa ##{log.trackable_id}"
    when "comment_created" then "#{actor} comentou na tarefa"
    when "requirement_created" then "#{actor} criou um requisito"
    when "member_added" then "#{actor} adicionou um membro ao projeto"
    when "member_removed" then "#{actor} removeu um membro do projeto"
    else "#{actor} fez #{log.action}"
    end
  end
end
