FactoryBot.define do
  factory :task_tag do
    association :task
    association :tag

    after(:build) do |task_tag|
      if task_tag.task&.project && task_tag.tag
        task_tag.tag.project = task_tag.task.project
      end
    end
  end
end
