# To deliver this notification:
#
# MessageNotifier.with(record: @post, message: "New post").deliver(User.all)

class MessageNotifier < Noticed::Event
  required_params :message
  validates :record, presence: true

  deliver_by :action_cable do |config|
    config.channel = "Noticed::NotificationsChannel"
    config.stream = ->{ recipient }
    config.message = ->{ params.merge( user_id: recipient.id) }
  end

  notification_methods do
    def message
      "Message"
    end
  end
end
