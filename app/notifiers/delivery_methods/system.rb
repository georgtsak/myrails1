class DeliveryMethods::System < ApplicationDeliveryMethod
  # Specify the config options your delivery method requires in its config block
  required_options # :foo, :bar

  def deliver
    # Logic for sending the notification
    cable_ready[channel].notification(
      title: "My App",
      options: {
        body: notification.message
      }
    ).broadcast_to(recipient)
  end

  def channel
    @channel ||= begin
      value = options[:channel]
      case value
      when String
        value.constantize
      else
        Noticed::NotificationChannel
      end
    end
  end
end
