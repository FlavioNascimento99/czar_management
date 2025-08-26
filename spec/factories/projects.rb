FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Projeto #{n}" }
    description { "Descrição do projeto #{name}" }

    after(:create) do |project|
      project.users << create(:user) if project.users.empty?
    end
  end
end
