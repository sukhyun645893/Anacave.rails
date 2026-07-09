require "test_helper"

module Admin
  class ReportsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @report = reports(:one)
    end

    test "should redirect normal user" do
      sign_in_as users(:two)

      get admin_root_url
      assert_redirected_to root_url
    end

    test "should show reports for admin" do
      sign_in_as users(:one)

      get admin_root_url
      assert_response :success
    end

    test "should update report status for admin" do
      sign_in_as users(:one)

      patch admin_report_url(@report), params: { report: { status: "resolved" } }
      assert_redirected_to admin_root_url
      assert_equal "resolved", @report.reload.status
    end
  end
end
