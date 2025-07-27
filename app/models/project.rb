class Project < ApplicationRecord
  # Validações
  validates :name, presence: true
  validates :description, presence: true

  # Relacionamentos
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy
  has_many :requirements, dependent: :destroy
end
