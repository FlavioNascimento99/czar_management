FactoryBot.define do
  factory :activity_log do
    association :project
    association :actor, factory: :user
    action { "task_created" }
  end
end
