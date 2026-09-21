FactoryBot.define do
  factory :task_doc do
    association :task
    association :doc

    after(:build) do |link|
      if link.task&.project && link.doc
        link.task.project.users << link.doc.user unless link.task.project.users.include?(link.doc.user)
      end
    end
  end
end
