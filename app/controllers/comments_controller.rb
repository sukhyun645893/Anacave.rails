class CommentsController < ApplicationController
  before_action :ensure_not_blocked, except: %i[ index show ]
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :require_owner, only: %i[ edit update destroy ]

  def index
    @comments = Comment.all
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @post = Post.find(params[:post_id] || comment_params[:post_id])
    @comment = @post.comments.build(comment_params.except(:post_id, :parent_id))
    @comment.parent = parent_comment
    @comment.user = Current.user

    if @comment.save
      SecurityEvent.record!(action: "comment.create", user: Current.user, record: @comment, request: request)
      notify_comment_targets
      redirect_to @post, notice: "댓글을 등록했습니다."
    else
      redirect_to @post, alert: "댓글 내용을 입력해주세요.", status: :see_other
    end
  end

  def update
    if @comment.update(comment_params.except(:post_id, :parent_id))
      redirect_to @comment.post, notice: "댓글을 수정했습니다.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    post = @comment.post
    @comment.destroy!
    redirect_to post, notice: "댓글을 삭제했습니다.", status: :see_other
  end

  private
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    def require_owner
      redirect_to @comment.post, alert: "작성자만 수정할 수 있습니다." unless @comment.user == Current.user
    end

    def comment_params
      params.expect(comment: [ :body, :post_id, :parent_id ])
    end

    def parent_comment
      return if comment_params[:parent_id].blank?

      @post.comments.find(comment_params[:parent_id])
    end

    def notify_comment_targets
      notify_post_owner
      notify_parent_owner
    end

    def notify_post_owner
      return if @post.user == Current.user

      @post.user.notifications.create!(
        title: "새 댓글",
        body: "#{Current.user.display_name}님이 '#{@post.title}' 글에 댓글을 남겼습니다.",
        url: post_path(@post)
      )
    end

    def notify_parent_owner
      return if @comment.parent.blank? || @comment.parent.user == Current.user || @comment.parent.user == @post.user

      @comment.parent.user.notifications.create!(
        title: "새 답글",
        body: "#{Current.user.display_name}님이 내 댓글에 답글을 남겼습니다.",
        url: post_path(@post)
      )
    end
end
