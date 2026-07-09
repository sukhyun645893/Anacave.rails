module Admin
  class AnaconsController < BaseController
    # 등록된 아나콘을 검수하고 승인/반려/삭제합니다.
    def index
      @anacons = Anacon.includes(:user, images_attachments: :blob).order(created_at: :desc)
    end

    def update
      @anacon = Anacon.find(params.expect(:id))

      case params.expect(:status)
      when "approved"
        @anacon.update!(status: "approved", approved_by: Current.user, approved_at: Time.current)
        notify_owner("아나콘 승인", "'#{@anacon.title}' 아나콘이 승인되었습니다. 이제 글/댓글에서 사용할 수 있습니다.")
        notice = "아나콘을 승인했습니다."
      when "rejected"
        @anacon.update!(status: "rejected", approved_by: Current.user, approved_at: Time.current)
        notify_owner("아나콘 반려", "'#{@anacon.title}' 아나콘이 반려되었습니다. 저작권 또는 운영정책 위반 여부를 확인해주세요.")
        notice = "아나콘을 반려했습니다."
      else
        notice = "상태를 변경하지 않았습니다."
      end

      redirect_to admin_anacons_path, notice: notice, status: :see_other
    end

    def destroy
      anacon = Anacon.find(params.expect(:id))
      anacon.user.notifications.create!(
        title: "아나콘 삭제",
        body: "'#{anacon.title}' 아나콘이 운영정책 또는 권리침해 사유로 삭제되었습니다.",
        url: anacons_path
      )
      anacon.destroy!

      redirect_back fallback_location: admin_anacons_path, notice: "아나콘을 삭제했습니다.", status: :see_other
    end

    private
      def notify_owner(title, body)
        @anacon.user.notifications.create!(title: title, body: body, url: anacon_path(@anacon))
      end
  end
end
