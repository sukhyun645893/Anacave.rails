class Comment < ApplicationRecord
  # 댓글입니다. 게시글과 작성자에 속하고, 신고 대상이 될 수 있습니다.
  belongs_to :post
  belongs_to :user
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true
end
