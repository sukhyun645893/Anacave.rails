module Admin
  class ReportsController < BaseController
    # 신고 목록을 보여주고, 신고 상태를 처리 완료/문제 없음으로 바꿉니다.
    def index
      @reports = Report.includes(:user, :reportable).order(created_at: :desc)
    end

    def update
      @report = Report.find(params.expect(:id))
      @report.update!(report_params)
      notify_reporter

      redirect_to admin_root_path, notice: "신고 상태를 변경했습니다.", status: :see_other
    end

    private
      def report_params
        params.expect(report: [ :status ])
      end

      def notify_reporter
        return unless @report.status.in?(%w[resolved dismissed])

        @report.user.notifications.create!(
          title: "신고 처리 결과",
          body: "#{@report.reason_label} 신고가 '#{@report.status_label}' 상태로 변경되었습니다.",
          url: admin_root_path
        )
      end
  end
end
