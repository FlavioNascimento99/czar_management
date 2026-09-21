class Notification < ApplicationRecord
  ACTIONS = %w[task_assigned task_reassigned task_commented member_added due_soon overdue].freeze

  belongs_to :user
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :action, presence: true, inclusion: { in: ACTIONS }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def mark_read!
    update!(read_at: Time.current) unless read?
  end

  def self.notify!(user:, action:, actor: nil, notifiable: nil)
    return if user.nil? || user == actor
    create!(user: user, action: action, actor: actor, notifiable: notifiable)
  end
end
