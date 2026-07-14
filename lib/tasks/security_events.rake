namespace :security_events do
  desc "Delete expired security event logs"
  task prune: :environment do
    deleted_count = SecurityEvent.expired.count
    SecurityEvent.prune_expired!
    puts "Deleted #{deleted_count} expired security event logs."
  end
end
