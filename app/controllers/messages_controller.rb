class MessagesController < ApplicationController
    def create
        redirect_login

        @conversation = Conversation.find(message_params[:conversation_id])
        if @conversation.users.map(&:id).include? current_user.id
            @message = Message.build({:content => message_params[:content], :users_id => current_user.id})
            @conversation.messages << @message

            if @message.save
                render turbo_stream: turbo_stream.prepend("messages:#{@conversation.id}", @message)
    
                @conversation.users.each do |user|
                    message_object = {
                        type: 'message',
                        conversation: @conversation,
                        message: @message
                    }
    
                    NotificationsChannel.broadcast_to("notifications:" + user.id.to_s, message_object)
                end
            else
                render json: { error: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
        else
            render json: { error: @message.errors.full_messages.join(', ') }, status: :unauthorized
        end
    end

    def update
        redirect_login
    end

    def read
        redirect_login

        @message = Message.find(params[:id])
        message_conversation = ConversationMessage.find_by_message_id(@message.id)
        
        @conversation = Conversation.find(message_conversation.conversation_id)

        if @conversation.users.map(&:id).include? current_user.id
            if @message
                render turbo_stream: turbo_stream.prepend("messages:#{@conversation.id}", @message)
            end
        else
            render json: { error: @message.errors.full_messages.join(', ') }, status: :unauthorized
        end
    end

    def delete
        redirect_login
    end

    private

    def message_params
        params.require(:message).permit(:content, :conversation_id)
    end
end