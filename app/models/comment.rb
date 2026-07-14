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
  has_many :security_events, as: :record, dependent: :nullify

  validates :body, presence: true
  validate :parent_must_belong_to_same_post
  validate :parent_must_be_top_level_comment

  private
    def parent_must_belong_to_same_post
      return if parent.blank? || post.blank?

      errors.add(:parent, "같은 게시글의 댓글에만 답글을 달 수 있습니다.") if parent.post_id != post_id
    end

    def parent_must_be_top_level_comment
      return if parent.blank?

      errors.add(:parent, "대댓글에는 다시 답글을 달 수 없습니다.") if parent.parent_id.present?
    end
end
