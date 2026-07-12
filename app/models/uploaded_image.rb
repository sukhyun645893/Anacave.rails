class UploadedImage < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze
  MAX_BYTE_SIZE = 5.megabytes

  belongs_to :user

  validates :filename, :content_type, :byte_size, :data, presence: true
  validates :content_type, inclusion: { in: ALLOWED_CONTENT_TYPES }
  validates :byte_size, numericality: { less_than_or_equal_to: MAX_BYTE_SIZE }
end
