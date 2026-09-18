class Task < ApplicationRecord
  # Enums
  enum :status, { pendente: 0, em_andamento: 1, concluida: 2 }
  enum :priority, { baixa: 0, media: 1, alta: 2 }

  # Validações
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validate :assigned_to_must_be_project_member

  # Relacionamentos
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :assigned_to, class_name: "User"

  private

  def assigned_to_must_be_project_member
    return if project.nil? || assigned_to.nil?
    unless project.users.include?(assigned_to)
      errors.add(:assigned_to, "deve ser membro do projeto")
    end
  end
end
