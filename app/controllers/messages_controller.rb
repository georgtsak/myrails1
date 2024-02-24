class MessagesController < ApplicationController
    def create
        redirect_login

        p message_params

        current_conversation = Conversation.find(message_params[:conversation_id])
        @message = current_conversation.messages.create({:content => message_params[:content], :users_id => current_user.id})

        if @message.save
            render turbo_stream: turbo_stream.prepend("messages", @message)

            current_conversation.users.each do |user|
                message_object = {
                    type: 'message',
                    conversation: current_conversation,
                    message: @message
                }

                if user.id != current_user.id
                    # NotificationsChannel.broadcast_to("notifications:" + user.id.to_s, message_object)
                end
            end
        else
            render json: { error: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def update
        redirect_login
    end

    def read
        redirect_login
    end

    def delete
        redirect_login
    end

    private

    def message_params
        params.require(:message).permit(:content, :conversation_id)
    end
end