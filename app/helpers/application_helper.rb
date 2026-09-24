module ApplicationHelper
  def empty_state(icon_name:, title:, text: nil, &actions)
    tag.div(class: "saas-empty") do
      safe_join([
        tag.span(icon(icon_name, size: 24), class: "saas-empty-icon"),
        tag.h3(title),
        (tag.p(text) if text),
        (tag.div(capture(&actions), class: "saas-empty-actions") if actions)
      ].compact)
    end
  end
end
