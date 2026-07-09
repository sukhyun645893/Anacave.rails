class PostsController < ApplicationController
  # 게시글 보기/쓰기/수정/삭제를 담당합니다.
  allow_unauthenticated_access only: %i[ show ]
  before_action :ensure_not_blocked, except: %i[ show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :require_owner, only: %i[ edit update destroy ]
  before_action :set_chapters, only: %i[ new edit create update ]
  before_action :set_anacons, only: %i[ new edit create update ]

  def show
  end

  def new
    @post = Post.new(chapter: current_chapter)
  end

  def edit
  end

  def create
    # 현재 로그인한 유저를 작성자로 지정해서 게시글을 만듭니다.
    @post = Current.user.posts.build(post_params)
    @post.chapter ||= current_chapter

    if @post.save
      redirect_to @post, notice: "게시글을 등록했습니다."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "게시글을 수정했습니다.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    chapter = @post.chapter
    @post.destroy!
    redirect_to chapter_path(chapter), notice: "게시글을 삭제했습니다.", status: :see_other
  end

  private
    # URL의 id 값으로 게시글을 찾습니다.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    def require_owner
      redirect_to @post, alert: "작성자만 수정할 수 있습니다." unless @post.user == Current.user
    end

    def current_chapter
      # 챕터 안에서 글쓰기를 눌렀을 때 해당 챕터를 기본값으로 잡습니다.
      @current_chapter ||= Chapter.find_by(slug: params[:chapter_id])
    end

    def set_chapters
      @chapters = Chapter.order(:name)
    end

    def set_anacons
      @anacons = Current.user.downloaded_anacons.approved.includes(images_attachments: :blob).order("user_anacons.created_at DESC")
    end

    def post_params
      params.expect(post: [ :title, :body, :chapter_id ])
    end
end
