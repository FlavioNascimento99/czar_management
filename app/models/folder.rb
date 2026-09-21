class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :subfolders, class_name: "Folder", foreign_key: "parent_id", dependent: :destroy
  has_many :docs, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: [ :user_id, :parent_id ], case_sensitive: false }
  validate :parent_belongs_to_same_user
  validate :no_circular_reference

  scope :roots, -> { where(parent_id: nil).order(:name) }
  scope :ordered, -> { order(:name) }

  def breadcrumb
    parent ? parent.breadcrumb + [ parent ] : []
  end

  private

  def parent_belongs_to_same_user
    return if parent.nil? || user.nil?
    errors.add(:parent, "deve ser sua") if parent.user_id != user_id
  end

  def no_circular_reference
    node = parent
    while node
      if node == self
        errors.add(:parent, "não pode criar ciclo")
        break
      end
      node = node.parent
    end
  end
end
