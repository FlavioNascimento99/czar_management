class Subtask < ApplicationRecord
  belongs_to :task

  validates :title, presence: true

  scope :ordered, -> { order(:position, :created_at) }

  before_create :set_position

  def toggle!
    update!(done: !done)
  end

  private

  def set_position
    self.position ||= (task.subtasks.maximum(:position) || -1) + 1
  end
end
