FactoryBot.define do
  factory :comment do
    body { "Comentário de exemplo" }
    association :task
    association :author, factory: :user

    after(:build) do |comment|
      next unless comment.task&.project
      if comment.author && !comment.task.project.users.include?(comment.author)
        comment.task.project.users << comment.author
      end
    end
  end
end
