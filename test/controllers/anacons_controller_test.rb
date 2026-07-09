require "test_helper"

class AnaconsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @anacon = anacons(:one)
  end

  test "should get index" do
    get anacons_url
    assert_response :success
  end

  test "should get new when signed in" do
    sign_in_as users(:one)

    get new_anacon_url
    assert_response :success
  end

  test "should create anacon" do
    sign_in_as users(:one)

    assert_difference("Anacon.count") do
      post anacons_url, params: {
        anacon: {
          title: "New Anacon",
          description: "A sticker image",
          images: [
            fixture_file_upload("sample_anacon.png", "image/png"),
            fixture_file_upload("sample_anacon.png", "image/png")
          ]
        }
      }
    end

    assert_redirected_to anacon_url(Anacon.last)
    assert_equal "pending", Anacon.last.status
  end
end
