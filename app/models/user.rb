class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  before_validation :normalize_email

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  # Relacionamentos
  has_and_belongs_to_many :projects
  has_many :owned_projects, class_name: "Project", foreign_key: "owner_id", dependent: :restrict_with_error
  has_many :authored_tasks, class_name: "Task", foreign_key: "author_id", dependent: :restrict_with_error
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_to_id", dependent: :restrict_with_error
  has_many :authored_comments, class_name: "Comment", foreign_key: "author_id", dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :docs, dependent: :destroy

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
