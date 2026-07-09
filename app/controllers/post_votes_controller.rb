class PostVotesController < ApplicationController
  # 게시글 추천/비추천을 처리합니다.
  before_action :ensure_not_blocked

  def create
    # 추천은 1, 비추천은 -1로 저장하고 날짜를 함께 기록합니다.
    @post = Post.find(params[:post_id])
    vote = @post.post_votes.build(user: Current.user, value: vote_value, voted_on: Date.current)

    if vote.save
      redirect_to @post, notice: vote.value.positive? ? "추천했습니다." : "비추천했습니다."
    else
      redirect_to @post, alert: "이 게시글에는 오늘 같은 반응을 이미 눌렀습니다.", status: :see_other
    end
  end

  private
    def vote_value
      params[:value].to_s == "down" ? -1 : 1
    end
end
