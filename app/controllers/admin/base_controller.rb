module Admin
  class BaseController < ApplicationController
    # app/controllers/admin 아래 컨트롤러는 전부 관리자만 접근할 수 있습니다.
    before_action :require_admin
  end
end
