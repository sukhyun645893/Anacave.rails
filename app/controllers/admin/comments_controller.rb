module Admin
  class CommentsController < BaseController
    # 운영자가 규정 위반 댓글을 삭제할 때 사용합니다.
    def destroy
      comment = Comment.find(params.expect(:id))
      post = comment.post
      comment.destroy!

      redirect_back fallback_location: post_path(post), notice: "관리자 권한으로 댓글을 삭제했습니다.", status: :see_other
    end
  end
end
