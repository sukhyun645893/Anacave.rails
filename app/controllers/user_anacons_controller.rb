class UserAnaconsController < ApplicationController
  # 승인된 아나콘을 내 보관함에 추가합니다.
  before_action :ensure_not_blocked

  def create
    anacon = Anacon.approved.find(params.expect(:anacon_id))
    user_anacon = Current.user.user_anacons.find_or_initialize_by(anacon: anacon)

    if user_anacon.persisted? || user_anacon.save
      redirect_to anacon, notice: "아나콘을 받았습니다. 이제 글/댓글에서 사용할 수 있습니다."
    else
      redirect_to anacon, alert: "아나콘을 받을 수 없습니다.", status: :see_other
    end
  end

  def destroy
    user_anacon = Current.user.user_anacons.find_by!(anacon_id: params.expect(:id))
    anacon = user_anacon.anacon
    user_anacon.destroy!

    redirect_to anacon, notice: "내 아나콘에서 제거했습니다.", status: :see_other
  end
end
