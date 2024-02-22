class MessagesController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @user = current_user
            @elements = current_user.conversations.all
        end
    end

    def show
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @contacts = current_user.friends
            @conversation = Conversation.find(params[:id]) or not_found
            @messages = @conversation.messages
        end
    end

    def createconv
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @conversation = Conversation.new({ :uid => conversation_create_params[:name], :user_ids => user_params[:ids].push(current_user.id) })
            if @conversation.save
                render json: { message: 'Conversation created successfully' }, status: :created
            else
                render json: { error: @conversation.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
        end
    end

    def create
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            current_conversation = Conversation.find(conversation_params[:id])
            message = current_conversation.messages.create({ :content => message_params[:content], :users_id => current_user.id})

            if message.save
                render json: { message: 'Message sent successfully' }, status: :created
            else
                render json: { error: message.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
        end
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