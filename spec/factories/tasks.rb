FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Tarefa #{n}" }
    description { "Descrição da tarefa" }
    status { "pendente" }
    priority { "media" }

    association :project
    association :author, factory: :user
    association :assigned_to, factory: :user
  end
end
