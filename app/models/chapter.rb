class Chapter < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  def to_param
    slug
  end

  private
    def set_slug
      self.slug = name.to_s.parameterize
    end
end
