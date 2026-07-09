class ProfilesController < ApplicationController
  def show
    @user = Current.user
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "프로필이 저장되었습니다."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def profile_params
      params.expect(user: [ :nickname, :bio, :avatar ])
    end
end
