require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should create user without email address" do
    assert_difference("User.count") do
      post registration_path, params: {
        user: {
          username: "new_user",
          nickname: "newbie",
          password: "password",
          password_confirmation: "password"
        },
        terms_agreement: "1"
      }
    end

    assert_redirected_to root_path
    assert_nil User.last.email_address
  end

  test "should require terms agreement" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        user: {
          username: "no_terms",
          nickname: "termsless",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_response :unprocessable_content
  end
end
