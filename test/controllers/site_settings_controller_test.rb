require "test_helper"

class SiteSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get edit" do
    get edit_site_setting_url
    assert_response :success
  end

  test "should remove background" do
    patch site_setting_url, params: { remove_background: "1" }
    assert_redirected_to edit_site_setting_url
  end

  test "should update dark mode" do
    patch site_setting_url, params: { site_setting: { dark_mode: "1" } }

    assert_redirected_to edit_site_setting_url
    assert SiteSetting.current.reload.dark_mode?
  end
end
