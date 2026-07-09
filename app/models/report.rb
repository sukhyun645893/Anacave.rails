class Report < ApplicationRecord
  # 사용자가 게시글/댓글/아나콘을 신고하면 저장되는 기록입니다.
  REASONS = {
    "spam" => "스팸/광고",
    "abuse" => "욕설/괴롭힘",
    "illegal" => "불법 정보",
    "privacy" => "개인정보 노출",
    "copyright" => "저작권 침해",
    "other" => "기타"
  }.freeze

  STATUSES = {
    "open" => "접수",
    "resolved" => "처리 완료",
    "dismissed" => "문제 없음"
  }.freeze

  belongs_to :user
  belongs_to :reportable, polymorphic: true

  validates :reason, presence: true, inclusion: { in: REASONS.keys }
  validates :status, presence: true, inclusion: { in: STATUSES.keys }

  def reason_label
    REASONS.fetch(reason, reason)
  end

  def status_label
    STATUSES.fetch(status, status)
  end
end
