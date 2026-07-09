class SiteSetting < ApplicationRecord
  # 사이트 전체 설정입니다. 배경 이미지와 다크 모드 같은 전역 옵션을 저장합니다.
  has_one_attached :background_image

  validates :name, presence: true, uniqueness: true
  validate :background_image_must_be_image

  def self.current
    first_or_create!(name: "default")
  end

  private
    # 커뮤니티 배경 이미지는 이미지 파일만 허용하고, 5MB 이하로 제한합니다.
    def background_image_must_be_image
      return unless background_image.attached?

      unless background_image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
        errors.add(:background_image, "이미지 파일만 사용할 수 있습니다.")
      end

      if background_image.blob.byte_size > 5.megabytes
        errors.add(:background_image, "5MB 이하 이미지만 사용할 수 있습니다.")
      end
    end
end
