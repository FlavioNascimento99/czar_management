class User < ApplicationRecord
  has_secure_password

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Relacionamentos
  has_and_belongs_to_many :projects
  has_many :authored_tasks, class_name: 'Task', foreign_key: 'author_id', dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigned_to_id', dependent: :nullify
end
