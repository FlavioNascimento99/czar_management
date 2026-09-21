class ActivityLog < ApplicationRecord
  ACTIONS = %w[task_created task_updated task_completed comment_created requirement_created member_added member_removed].freeze

  belongs_to :project
  belongs_to :actor, class_name: "User"
  belongs_to :trackable, polymorphic: true, optional: true

  validates :action, presence: true, inclusion: { in: ACTIONS }

  scope :recent, -> { order(created_at: :desc) }

  def self.log!(project:, actor:, action:, trackable: nil)
    create!(project: project, actor: actor, action: action, trackable: trackable)
  end
end
