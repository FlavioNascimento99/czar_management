FactoryBot.define do
  factory :folder do
    sequence(:name) { |n| "Pasta #{n}" }
    association :user
    parent { nil }
  end

  factory :doc do
    sequence(:title) { |n| "Doc #{n}" }
    body { "# Olá\n\nTexto **markdown** de exemplo." }
    association :user
    folder { nil }
  end
end
