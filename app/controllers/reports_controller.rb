class ReportsController < ApplicationController
  # 사용자가 게시글, 댓글, 아나콘을 신고할 때 쓰는 컨트롤러입니다.
  before_action :ensure_not_blocked

  def create
    reportable = find_reportable
    report = reportable.reports.build(report_params)
    report.user = Current.user

    if report.save
      redirect_back fallback_location: root_path, notice: "신고를 접수했습니다. 운영자가 확인할게요."
    else
      redirect_back fallback_location: root_path, alert: "신고를 접수하지 못했습니다.", status: :see_other
    end
  end

  private
    def find_reportable
      case report_params[:reportable_type]
      when "Post"
        Post.find(report_params[:reportable_id])
      when "Comment"
        Comment.find(report_params[:reportable_id])
      when "Anacon"
        Anacon.find(report_params[:reportable_id])
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def report_params
      params.expect(report: [ :reportable_type, :reportable_id, :reason, :details ])
    end
end
