module Admin
  class SecurityEventsController < BaseController
    def index
      @security_events = SecurityEvent.includes(:user, :record).recent.limit(200)
    end
  end
end
