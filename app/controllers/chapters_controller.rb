class ChaptersController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @chapters = Chapter
      .left_joins(:posts)
      .select("chapters.*, COUNT(posts.id) AS posts_count, MAX(posts.created_at) AS latest_post_at")
      .group("chapters.id")
      .order(Arel.sql("latest_post_at DESC NULLS LAST"), :name)
  end

  def show
    @chapter = Chapter.find_by!(slug: params[:id])
    @posts = @chapter.posts.includes(:user).order(created_at: :desc)
  end
end
