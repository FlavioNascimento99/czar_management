FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Projeto #{n}" }
    description { "Descrição do projeto #{name}" }
    association :owner, factory: :user

    # No hidden side-effects: membership is explicit. Use the trait when
    # specs need the owner as a member (mirrors ProjectsController#create,
    # which adds current_user inside a transaction).
    trait :with_owner_as_member do
      after(:create) do |project|
        project.users << project.owner unless project.users.include?(project.owner)
      end
    end
  end
end
