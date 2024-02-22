class MessagesController < ApplicationController
    def create
        redirect_login

        current_conversation = Conversation.find(conversation_params[:id])
        message = current_conversation.messages.create({ :content => message_params[:content], :users_id => current_user.id})

        if message.save
            render json: { message: 'Message sent successfully' }, status: :created
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

    def notify_recipient
        conv_users = ConversationUser.where(:conversation => @conversation.id)
        conv_users.each do |user|
            next if user.eql?(current_user)
            notification = NewMessageNotifier.with(message: @message.content, conversation: @message.conversation, type: "message")
            notification.deliver(user)
        end
    end
end