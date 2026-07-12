class UploadsController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]
  before_action :ensure_not_blocked, only: %i[ create ]

  MAX_IMAGE_SIZE = 5.megabytes
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

  def show
    uploaded_image = UploadedImage.find_signed!(params[:id], purpose: :uploaded_image)

    send_data uploaded_image.data,
      type: uploaded_image.content_type,
      filename: uploaded_image.filename,
      disposition: "inline"
  end

  def create
    image = params.require(:image)

    unless image.content_type.in?(ALLOWED_IMAGE_TYPES)
      render json: { error: "이미지 파일만 업로드할 수 있습니다." }, status: :unprocessable_content
      return
    end

    if image.size > MAX_IMAGE_SIZE
      render json: { error: "이미지는 5MB 이하만 업로드할 수 있습니다." }, status: :unprocessable_content
      return
    end

    uploaded_image = Current.user.uploaded_images.create!(
      data: image.read,
      filename: image.original_filename,
      content_type: image.content_type,
      byte_size: image.size
    )

    render json: { url: upload_path(uploaded_image.signed_id(purpose: :uploaded_image)) }
  end
end
