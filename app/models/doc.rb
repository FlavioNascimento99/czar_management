class Doc < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many_attached :files

  validates :title, presence: true
  validate :folder_belongs_to_same_user

  scope :recent, -> { order(updated_at: :desc) }
  scope :search, ->(term) {
    q = "%#{term.to_s.strip}%"
    where("docs.title LIKE ? OR docs.body LIKE ?", q, q)
  }

  def rendered_body
    html = Kramdown::Document.new(body.to_s).to_html
    ActionController::Base.helpers.sanitize(html, tags: %w[p h1 h2 h3 h4 h5 h6 ul ol li strong em a code pre blockquote hr br table thead tbody tr th td img del], attributes: %w[href src alt title])
  end

  private

  def folder_belongs_to_same_user
    return if folder.nil? || user.nil?
    errors.add(:folder, "deve ser sua") if folder.user_id != user_id
  end
end
