class Post < ApplicationRecord
  # 게시글입니다. 챕터와 작성자에 속하고, 댓글/추천/신고를 가집니다.
  belongs_to :chapter
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_votes, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :security_events, as: :record, dependent: :nullify

  validates :title, presence: true, length: { maximum: 120 }
  validates :body, presence: true

  # 추천/비추천 수는 매번 DB에서 계산합니다.
  def upvotes_count
    post_votes.where(value: 1).count
  end

  def downvotes_count
    post_votes.where(value: -1).count
  end

  def score
    upvotes_count - downvotes_count
  end

  def voted_today_by?(user, value = nil)
    return false unless user

    votes = post_votes.where(user: user, voted_on: Date.current)
    value.present? ? votes.exists?(value: value) : votes.exists?
  end

  def upvoted_today_by?(user)
    voted_today_by?(user, 1)
  end

  def downvoted_today_by?(user)
    voted_today_by?(user, -1)
  end
end
