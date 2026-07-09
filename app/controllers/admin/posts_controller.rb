module Admin
  class PostsController < BaseController
    # 운영자가 규정 위반 게시글을 삭제할 때 사용합니다.
    def destroy
      post = Post.find(params.expect(:id))
      chapter = post.chapter
      post.destroy!

      redirect_back fallback_location: chapter_path(chapter), notice: "관리자 권한으로 게시글을 삭제했습니다.", status: :see_other
    end
  end
end
