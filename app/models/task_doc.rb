class TaskDoc < ApplicationRecord
  belongs_to :task
  belongs_to :doc

  validates :doc_id, uniqueness: { scope: :task_id }
  validate :doc_owner_is_project_member

  private

  def doc_owner_is_project_member
    return if task.nil? || doc.nil?
    unless task.project.users.include?(doc.user)
      errors.add(:doc, "deve ser de um membro do projeto")
    end
  end
end
