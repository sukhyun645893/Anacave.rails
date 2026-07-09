class NotificationsController < ApplicationController
  # 상단 종 아이콘에서 들어오는 알림함입니다.
  def index
    @notifications = Current.user.notifications.recent.limit(50)
    Current.user.notifications.unread.update_all(read_at: Time.current)
  end

  def mark_all
    Current.user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "알림을 모두 읽음 처리했습니다.", status: :see_other
  end
end
