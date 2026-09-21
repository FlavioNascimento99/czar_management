class Tag < ApplicationRecord
  belongs_to :project
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: { scope: :project_id, case_sensitive: false }
  validates :color, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "deve ser hexadecimal como #0d6efd" }

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
