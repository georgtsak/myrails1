# To deliver this notification:
#
# NewMessage.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message

  deliver_by :action_cable do |config|
    config.channel = "Noticed::Messages"
    config.stream = ->{ recipient }
    config.message = ->{ params.merge( user_id: recipient.id) }
  end
 
  def message
    "A system notification"
  end
end
