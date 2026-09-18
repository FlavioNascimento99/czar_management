class Project < ApplicationRecord
  # Validações
  validates :name, presence: true
  validates :description, presence: true

  # Relacionamentos
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy
  has_many :requirements, dependent: :destroy

  def owned_by?(user)
    user.present? && owner_id == user.id
  end

  def member?(user)
    user.present? && users.exists?(user.id)
  end
end
