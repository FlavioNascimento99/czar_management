module BadgesHelper
  STATUS_TONES = { "pendente" => "gray", "em_andamento" => "blue", "concluida" => "green" }.freeze
  PRIORITY_TONES = { "baixa" => "gray", "media" => "amber", "alta" => "red" }.freeze

  def status_badge(status)
    tag.span(status.humanize, class: "saas-badge #{STATUS_TONES.fetch(status, 'gray')}")
  end

  def priority_badge(priority)
    tag.span(priority.capitalize, class: "saas-badge #{PRIORITY_TONES.fetch(priority, 'gray')}")
  end

  # Tag colors come from the DB; an SVG fill attribute renders them without inline styles (blocked by the CSP).
  def tag_badge(project_tag)
    tag.span(safe_join([ color_dot(project_tag.color), project_tag.name ]), class: "saas-badge gray")
  end

  def color_dot(color, size: 8)
    tag.svg(
      tag.circle(cx: 4, cy: 4, r: 4, fill: color),
      viewBox: "0 0 8 8", width: size, height: size, class: "saas-color-dot", "aria-hidden": "true"
    )
  end
end
