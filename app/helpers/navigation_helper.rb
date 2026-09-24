module NavigationHelper
  def primary_nav_groups
    [
      [ { label: "Dashboard", path: root_path, icon: "layout-dashboard" } ],
      [ { label: "Documents", path: docs_path, icon: "file-text" },
        { label: "Folders", path: folders_path, icon: "folder" } ],
      [ { label: "Projects", path: projects_path, icon: "folder-kanban" },
        { label: "My Tasks", path: my_tasks_path, icon: "list-checks" } ]
    ]
  end

  def nav_link(item, css: "saas-nav-link")
    link_to item[:path], class: css, aria: { current: ("page" if nav_active?(item[:path])) } do
      safe_join([ icon(item[:icon]), tag.span(item[:label]) ])
    end
  end

  def nav_active?(path)
    return request.path == path if path == root_path

    request.path == path || request.path.start_with?("#{path}/")
  end
end
