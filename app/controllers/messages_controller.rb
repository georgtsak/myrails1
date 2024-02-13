class MessagesController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @elements = current_user.conversationuser.all()
        end
    end

    def show
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @conversation = Conversation.find(params[:id]) or not_found
            conversation_messages = ConversationMessage.where(:conversation => @conversation.id)

            messages_to_find = []
            conversation_messages.each do |mess|
                messages_to_find.push(mess.message_id)
            end

            conversation_messages = Message.limit(10).find(messages_to_find)
            @messages = conversation_messages
            @users = ConversationUser.where(:conversation => @conversation.id)
        end
    end

    def createconv
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            initiate_user = current_user
            target_user = User.find(2)
            
            current_conversation = ConversationUser.find_by(user_id: initiate_user.id)
            conversation = nil
            if current_conversation
                render index
            else
                conversation = Conversation.new('uid' => 'test')
                conversation.save()

                conversation_1 = ConversationUser.new(:conversation_id => conversation.id, :user_id => initiate_user.id)
                conversation_1.save()
                conversation_2 = ConversationUser.new(:conversation_id => conversation.id, :user_id => target_user.id)
                conversation_2.save()
            end
        end
    end

    def create
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            message = Message.new({:content => message_params[:content], :users_id => current_user.id})
            if message.save
                convmessage = ConversationMessage.new({ :message => message, :conversation => Conversation.find(conversation_params[:id]) })
                if convmessage.save
                    render json: { message: 'Message sent successfully' }, status: :created
                else
                    message.delete
                    render json: { error: convmessage.errors.full_messages.join(', ') }, status: :unprocessable_entity
                end
            else
                render json: { error: message.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end

    def conversation_params
        params.require(:conversation).permit(:id)
    end
end