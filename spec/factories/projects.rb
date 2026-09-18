FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Projeto #{n}" }
    description { "Descrição do projeto #{name}" }
    association :owner, factory: :user

    after(:create) do |project|
      project.users << project.owner unless project.users.include?(project.owner)
    end
  end
end
