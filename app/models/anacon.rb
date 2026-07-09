class Anacon < ApplicationRecord
  # 디시콘처럼 쓰는 이미지 묶음입니다. 등록 후 관리자 승인을 받아야 글/댓글에서 사용할 수 있습니다.
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze
  STATUSES = %w[pending approved rejected].freeze

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true
  has_many_attached :images
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :user_anacons, dependent: :destroy
  has_many :downloaded_users, through: :user_anacons, source: :user

  scope :approved, -> { where(status: "approved") }
  scope :pending, -> { where(status: "pending") }

  validates :title, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 1_000 }
  validates :status, inclusion: { in: STATUSES }
  validate :images_must_be_valid

  def approved?
    status == "approved"
  end

  def pending?
    status == "pending"
  end

  def rejected?
    status == "rejected"
  end

  def status_label
    { "pending" => "승인 대기", "approved" => "승인됨", "rejected" => "반려됨" }.fetch(status, status)
  end

  def cover_image
    images.first
  end

  def downloaded_by?(user)
    user.present? && user_anacons.exists?(user: user)
  end

  private
    def images_must_be_valid
      if images.blank?
        errors.add(:images, "아나콘 이미지를 1개 이상 첨부해주세요.")
        return
      end

      if images.size > 20
        errors.add(:images, "한 묶음에는 최대 20개까지만 올릴 수 있습니다.")
      end

      images.each do |image|
        unless image.content_type.in?(ALLOWED_IMAGE_TYPES)
          errors.add(:images, "JPG, PNG, GIF, WebP 이미지만 올릴 수 있습니다.")
        end

        if image.blob.byte_size > 5.megabytes
          errors.add(:images, "각 이미지는 5MB 이하만 올릴 수 있습니다.")
        end
      end
    end
end
