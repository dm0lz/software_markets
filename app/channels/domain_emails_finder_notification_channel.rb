class DomainEmailsFinderNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "domain_emails_finder_#{session_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def notify
  end
end
