require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    sign_in_as users(:two)
  end

  test "should create report" do
    assert_difference("Report.count") do
      post reports_url, params: { report: { reportable_type: "Post", reportable_id: @post.id, reason: "spam" } }
    end

    assert_redirected_to root_url
  end

  test "should create anacon copyright report" do
    anacon = anacons(:one)

    assert_difference("Report.count") do
      post reports_url, params: { report: { reportable_type: "Anacon", reportable_id: anacon.id, reason: "copyright" } }
    end

    assert_redirected_to root_url
  end
end
