class ProjectTemplateService
  TEMPLATES = {
    "sprint_dev" => {
      name: "Sprint de desenvolvimento",
      requirements: [
        { title: "Ambiente configurado", description: "Setup local, CI e code review", priority: "alta" },
        { title: "Autenticação", description: "Login, sessões e permissões", priority: "alta" },
        { title: "Kanban funcional", description: "Quadro com 3 colunas e drag-drop", priority: "media" }
      ],
      tasks: [
        { title: "Planejar sprint", description: "Definir escopo e responsáveis", status: "pendente", priority: "alta" },
        { title: "Implementar base", description: "Models, rotas e telas iniciais", status: "pendente", priority: "media" },
        { title: "Revisar e entregar", description: "PR, testes e demo", status: "pendente", priority: "media" }
      ]
    },
    "onboarding" => {
      name: "Onboarding de membro",
      requirements: [
        { title: "Acesso liberado", description: "Conta, repos e ferramentas", priority: "alta" }
      ],
      tasks: [
        { title: "Boas-vindas", description: "Apresentar time e rituais", status: "pendente", priority: "media" },
        { title: "Primeira tarefa guiada", description: "Issue pequena com par", status: "pendente", priority: "media" }
      ]
    },
    "evento" => {
      name: "Organizar evento",
      requirements: [
        { title: "Local e data", description: "Reserva e logística", priority: "alta" }
      ],
      tasks: [
        { title: "Divulgar", description: "Arte, texto e canais", status: "pendente", priority: "media" },
        { title: "Checklist do dia", description: "Som, coffee e recepção", status: "pendente", priority: "baixa" }
      ]
    }
  }.freeze

  def self.keys
    TEMPLATES.keys
  end

  def self.apply!(project:, template_key:, creator:)
    template = TEMPLATES[template_key.to_s]
    raise ArgumentError, "Template desconhecido" if template.nil?

    template[:requirements].each do |attrs|
      project.requirements.create!(attrs)
    end
    template[:tasks].each do |attrs|
      project.tasks.create!(attrs.merge(author: creator, assigned_to: creator))
    end
  end
end
