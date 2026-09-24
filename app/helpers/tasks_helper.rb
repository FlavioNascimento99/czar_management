module TasksHelper
  def due_date_badge(task)
    return tag.span("Sem prazo", class: "saas-badge gray") if task.due_date.nil?

    date = l(task.due_date, format: :short)
    label, tone =
      if task.overdue?
        [ "Atrasada #{date}", "red" ]
      elsif task.due_today?
        [ "Vence #{date}", "amber" ]
      else
        [ "Vence #{date}", "gray" ]
      end
    tag.span(safe_join([ icon("calendar", size: 14), label ]), class: "saas-badge #{tone}")
  end
end
