class AnaconsController < ApplicationController
  # 아나콘은 디시콘처럼 게시글/댓글에 삽입해서 쓰는 이미지 묶음입니다.
  allow_unauthenticated_access only: %i[ index show ]
  before_action :ensure_not_blocked, only: %i[ new create ]
  before_action :set_anacon, only: %i[ show ]

  def index
    @anacons = Anacon.approved.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def show
    redirect_to anacons_path, alert: "승인된 아나콘만 볼 수 있습니다." unless visible_anacon?
  end

  def new
    @anacon = Current.user.anacons.build
  end

  def create
    @anacon = Current.user.anacons.build(anacon_params)
    @anacon.status = "pending"

    if @anacon.save
      redirect_to @anacon, notice: "아나콘을 등록했습니다. 관리자 승인 후 글/댓글에서 사용할 수 있습니다."
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def set_anacon
      @anacon = Anacon.includes(images_attachments: :blob).find(params.expect(:id))
    end

    def visible_anacon?
      @anacon.approved? || @anacon.user == Current.user || Current.user&.admin?
    end

    def anacon_params
      params.require(:anacon).permit(:title, :description, images: [])
    end
end
