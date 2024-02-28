class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "notifications:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
