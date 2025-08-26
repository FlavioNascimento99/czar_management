FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Usuário #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
  end
end
