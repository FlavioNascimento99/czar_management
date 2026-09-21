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
  has_many :comments, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags
  has_many :task_docs, dependent: :destroy
  has_many :docs, through: :task_docs
  has_many :subtasks, dependent: :destroy
  has_many_attached :files

  validate :files_size_and_type

  scope :overdue, -> { where.not(status: statuses[:concluida]).where.not(due_date: nil).where("due_date < ?", Date.current) }
  scope :due_today, -> { where(due_date: Date.current) }
  scope :ordered_by_due, -> { order(Arel.sql("due_date IS NULL, due_date ASC, created_at DESC")) }

  def overdue?
    due_date.present? && !concluida? && due_date < Date.current
  end

  def due_today?
    due_date.present? && due_date == Date.current
  end

  def subtasks_progress
    return 0 if subtasks.empty?
    (subtasks.count(&:done) * 100 / subtasks.size)
  end

  private

  def assigned_to_must_be_project_member
    return if project.nil? || assigned_to.nil?
    unless project.users.include?(assigned_to)
      errors.add(:assigned_to, "deve ser membro do projeto")
    end
  end

  BLOCKED_EXTENSIONS = %w[.exe .bat .cmd .com .scr .msi .sh].freeze
  MAX_FILE_SIZE = 10.megabytes

  def files_size_and_type
    files.each do |file|
      if file.blob.byte_size > MAX_FILE_SIZE
        errors.add(:files, "#{file.filename} excede 10MB")
      end
      if BLOCKED_EXTENSIONS.include?(File.extname(file.filename.to_s).downcase)
        errors.add(:files, "#{file.filename} é um tipo bloqueado")
      end
    end
  end
end
