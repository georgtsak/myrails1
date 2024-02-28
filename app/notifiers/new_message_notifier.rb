# To deliver this notification:
#
# NewMessage.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotifier < ApplicationNotifier
  required_params :message
  validates :record, presence: true

  deliver_by :action_cable do |config|
    config.channel = "NotificationsChannel"
    config.stream = ->{ recipient }
    config.message = ->{ params.merge( user_id: recipient.id) }
  end

  notification_methods do
    def message
      "Message"
    end
  end
end
