FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Tarefa #{n}" }
    description { "Descrição da tarefa" }
    status { "pendente" }
    priority { "media" }

    association :project
    association :author, factory: :user
    association :assigned_to, factory: :user

    # Regra de negócio: responsável precisa ser membro do projeto.
    after(:build) do |task|
      next unless task.project
      if task.author && !task.project.users.include?(task.author)
        task.project.users << task.author
      end
      if task.assigned_to && !task.project.users.include?(task.assigned_to)
        task.project.users << task.assigned_to
      end
    end
  end
end
