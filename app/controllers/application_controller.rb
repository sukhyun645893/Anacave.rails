class ApplicationController < ActionController::Base
  # 모든 컨트롤러가 공통으로 물려받는 기본 컨트롤러입니다.
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  private
    # 차단된 계정은 읽기 외 활동을 못 하게 막는 공통 보호 로직입니다.
    def ensure_not_blocked
      return unless Current.user&.blocked?

      redirect_to root_path, alert: "차단된 계정은 글쓰기, 댓글, 추천 같은 활동을 할 수 없습니다."
    end

    # 관리자 페이지에 일반 유저가 들어가지 못하게 막는 공통 보호 로직입니다.
    def require_admin
      redirect_to root_path, alert: "관리자만 접근할 수 있습니다." unless Current.user&.admin?
    end
end
