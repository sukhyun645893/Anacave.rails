class PostVote < ApplicationRecord
  # 게시글 추천/비추천 기록입니다. value가 1이면 추천, -1이면 비추천입니다.
  belongs_to :post
  belongs_to :user

  # user_id + post_id + voted_on + value 조합으로 추천 1번, 비추천 1번을 각각 허용합니다.
  validates :value, inclusion: { in: [ -1, 1 ] }
  validates :voted_on, presence: true
  validates :user_id, uniqueness: { scope: [ :post_id, :voted_on, :value ], message: "하루에 같은 반응은 한 번만 할 수 있습니다." }
end
