class Task < ApplicationRecord
  # Enums
  enum :status, { pendente: 0, em_andamento: 1, concluida: 2 }
  enum :priority, { baixa: 0, media: 1, alta: 2 }

  # Validações
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  # Relacionamentos
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User'
end
