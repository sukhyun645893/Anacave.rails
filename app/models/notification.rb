class Notification < ApplicationRecord
  # 상단 종 아이콘에 쌓이는 사용자 알림입니다.
  belongs_to :user

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  validates :title, presence: true

  def unread?
    read_at.nil?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end
end
