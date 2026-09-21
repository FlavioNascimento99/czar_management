module TasksHelper
  def due_date_badge(task)
    return content_tag(:span, "Sem prazo", class: "badge bg-light text-dark border") if task.due_date.nil?
    label = "Vence #{l(task.due_date, format: :short)}"
    css =
      if task.overdue?
        "badge bg-danger"
      elsif task.due_today?
        "badge bg-warning text-dark"
      else
        "badge bg-info text-dark"
      end
    content_tag(:span, task.overdue? ? "Atrasada #{l(task.due_date, format: :short)}" : label, class: css)
  end
end
