class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies,
    class_name: "Comment",
    foreign_key: :parent_id,
    dependent: :destroy,
    inverse_of: :parent
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true
  validate :parent_must_belong_to_same_post

  private
    def parent_must_belong_to_same_post
      return if parent.blank? || post.blank?

      errors.add(:parent, "같은 게시글의 댓글에만 답글을 달 수 있습니다.") if parent.post_id != post_id
    end
end
