require "openssl"

class SecurityEvent < ApplicationRecord
  RETENTION_DAYS = Integer(ENV.fetch("SECURITY_EVENT_RETENTION_DAYS", "180"))

  belongs_to :user, optional: true
  belongs_to :record, polymorphic: true, optional: true

  validates :action, :ip_address_hash, :retained_until, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :expired, -> { where("retained_until < ?", Time.current) }

  def self.record!(action:, user:, record:, request:)
    ip_address = request.remote_ip.to_s.presence || "unknown"

    create!(
      action: action,
      user: user,
      record: record,
      ip_address: ip_address,
      ip_address_hash: hash_ip(ip_address),
      user_agent: request.user_agent.to_s.truncate(500),
      retained_until: RETENTION_DAYS.days.from_now
    )
  end

  def self.hash_ip(ip_address)
    OpenSSL::HMAC.hexdigest("SHA256", Rails.application.secret_key_base, ip_address.to_s)
  end

  def self.prune_expired!
    expired.delete_all
  end

  def record_label
    case record
    when Post
      "게시글 ##{record.id}"
    when Comment
      "댓글 ##{record.id}"
    else
      record ? "#{record.class.name} ##{record.id}" : "없음"
    end
  end
end
