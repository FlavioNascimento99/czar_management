class Requirement < ApplicationRecord
  # Enum
  enum :priority, { baixa: 0, media: 1, alta: 2 }

  # Validações
  validates :title, presence: true
  validates :description, presence: true
  validates :priority, presence: true

  # Relacionamentos
  belongs_to :project
end
