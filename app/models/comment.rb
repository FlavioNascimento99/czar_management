class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :author, class_name: "User"

  validates :body, presence: true
  validate :author_must_be_project_member

  private

  def author_must_be_project_member
    return if task.nil? || author.nil?
    unless task.project.users.include?(author)
      errors.add(:author, "deve ser membro do projeto")
    end
  end
end
