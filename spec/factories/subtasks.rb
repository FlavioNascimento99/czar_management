FactoryBot.define do
  factory :subtask do
    sequence(:title) { |n| "Passo #{n}" }
    done { false }
    association :task
  end
end
