class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    unless params[:terms_agreement] == "1"
      @user.errors.add(:base, "이용약관과 개인정보처리방침에 동의해야 가입할 수 있습니다.")
      return render :new, status: :unprocessable_content
    end

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "회원가입이 완료되었습니다."
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def user_params
      params.expect(user: [ :username, :nickname, :password, :password_confirmation ])
    end
end
