require "test_helper"

module Admin
  class AnaconsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @anacon = anacons(:one)
      @anacon.images.attach(
        io: File.open(file_fixture("sample_anacon.png")),
        filename: "sample_anacon.png",
        content_type: "image/png"
      )
    end

    test "should redirect normal user" do
      sign_in_as users(:two)

      get admin_anacons_url
      assert_redirected_to root_url
    end

    test "should show anacons for admin" do
      sign_in_as users(:one)

      get admin_anacons_url
      assert_response :success
    end

    test "should approve anacon" do
      sign_in_as users(:one)

      patch admin_anacon_url(@anacon, status: "approved")
      assert_redirected_to admin_anacons_url
      assert_equal "approved", @anacon.reload.status
    end

    test "should destroy anacon" do
      sign_in_as users(:one)

      assert_difference("Anacon.count", -1) do
        delete admin_anacon_url(@anacon)
      end

      assert_redirected_to admin_anacons_url
    end
  end
end
