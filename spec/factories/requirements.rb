FactoryBot.define do
  factory :requirement do
    sequence(:title) { |n| "Requisito #{n}" }
    description { "Descrição do requisito" }
    priority { "baixa" }

    association :project
  end
end
