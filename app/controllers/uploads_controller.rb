class UploadsController < ApplicationController
  # Quill 에디터에서 이미지를 올릴 때 호출되는 업로드 전용 컨트롤러입니다.
  before_action :ensure_not_blocked

  MAX_IMAGE_SIZE = 5.megabytes
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp].freeze

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

    blob = ActiveStorage::Blob.create_and_upload!(
      io: image.open,
      filename: image.original_filename,
      content_type: image.content_type
    )

    render json: { url: rails_blob_path(blob, only_path: true) }
  end
end
