FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
    color { "#0d6efd" }
    association :project
  end
end
