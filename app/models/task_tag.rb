class TaskTag < ApplicationRecord
  belongs_to :task
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :task_id }
  validate :same_project

  private

  def same_project
    return if task.nil? || tag.nil?
    errors.add(:tag, "deve ser do mesmo projeto") if task.project_id != tag.project_id
  end
end
