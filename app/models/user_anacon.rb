class UserAnacon < ApplicationRecord
  # 사용자가 받은 아나콘 묶음입니다. 글/댓글 선택기에는 이 목록만 표시합니다.
  belongs_to :user
  belongs_to :anacon

  validates :anacon_id, uniqueness: { scope: :user_id }
  validate :anacon_must_be_approved

  private
    def anacon_must_be_approved
      errors.add(:anacon, "승인된 아나콘만 받을 수 있습니다.") unless anacon&.approved?
    end
end
