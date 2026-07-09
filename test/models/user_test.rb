require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes username" do
    user = User.new(username: " Test_User ", nickname: "Tester", password: "password")
    user.valid?

    assert_equal "test_user", user.username
  end

  test "does not require email address" do
    user = User.new(username: "privacy_user", nickname: "privacy", password: "password")

    assert user.valid?
  end
end
