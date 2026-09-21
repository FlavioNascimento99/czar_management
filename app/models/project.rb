class Project < ApplicationRecord
  enum :kind, { equipe: 0, pessoal: 1 }, default: :equipe

  # Validações
  validates :name, presence: true
  validates :description, presence: true
  validates :kind, presence: true
  validate :personal_has_single_member

  # Relacionamentos
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy
  has_many :requirements, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :tags, dependent: :destroy

  def owned_by?(user)
    user.present? && owner_id == user.id
  end

  def member?(user)
    user.present? && users.exists?(user.id)
  end

  private

  def personal_has_single_member
    return unless pessoal? && users.size > 1
    errors.add(:kind, "pessoal aceita só você")
  end
end
