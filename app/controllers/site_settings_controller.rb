class SiteSettingsController < ApplicationController
  def edit
    @site_setting = SiteSetting.current
  end

  def update
    @site_setting = SiteSetting.current

    if remove_background?
      @site_setting.background_image.purge
      redirect_to edit_site_setting_path, notice: "배경 이미지가 제거되었습니다."
    elsif @site_setting.update(site_setting_params)
      redirect_to edit_site_setting_path, notice: "설정이 저장되었습니다."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def site_setting_params
      params.expect(site_setting: [ :background_image, :dark_mode ])
    end

    def remove_background?
      params[:remove_background] == "1"
    end
end
