require "test_helper"

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should upload and show editor image from database" do
    assert_difference("UploadedImage.count") do
      post uploads_path, params: {
        image: fixture_file_upload("sample_anacon.png", "image/png")
      }
    end

    assert_response :success

    upload_url = JSON.parse(response.body).fetch("url")
    get upload_url

    assert_response :success
    assert_equal "image/png", response.media_type
    assert_equal UploadedImage.last.data, response.body.b
  end
end
