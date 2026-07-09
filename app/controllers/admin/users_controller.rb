module Admin
  class UsersController < BaseController
    # 운영자가 문제 계정을 차단하거나 차단 해제할 때 사용합니다.
    def block
      user = User.find(params.expect(:id))
      user.update!(blocked: true, blocked_at: Time.current)

      redirect_back fallback_location: admin_root_path, notice: "#{user.display_name} 계정을 차단했습니다.", status: :see_other
    end

    def unblock
      user = User.find(params.expect(:id))
      user.update!(blocked: false, blocked_at: nil)

      redirect_back fallback_location: admin_root_path, notice: "#{user.display_name} 계정 차단을 해제했습니다.", status: :see_other
    end
  end
end
