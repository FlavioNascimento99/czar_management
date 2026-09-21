FactoryBot.define do
  factory :notification do
    association :user
    association :actor, factory: :user
    action { "task_assigned" }
  end
end
