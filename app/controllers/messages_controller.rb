class MessagesController < ApplicationController
    def create
        redirect_login

        current_conversation = Conversation.find(conversation_params[:id])
        message = current_conversation.messages.create({ :content => message_params[:content], :users_id => current_user.id})

        if message.save
            broadcast_to "conversation_messages:#{current_conversation.id}", partial: "messages/message", locals: { :element => message }, target: "messages"
            current_conversation.users.each do |user|
                message_object = {
                    type: 'message',
                    conversation: current_conversation,
                    message: message
                }

                if user.id != current_user.id
                    NotificationsChannel.broadcast_to("notifications:" + user.id.to_s, message_object)
                end
            end
        else
            render json: { error: message.errors.full_messages.join(', ') }, status: :unprocessable_entity
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

    def user_params
        params.require(:user).permit(:ids => [])
    end

    def conversation_create_params
        params.require(:conversation).permit(:name)
    end

    def conversation_params
        params.require(:conversation).permit(:id)
    end

    def message_params
        params.require(:message).permit(:content)
    end
end