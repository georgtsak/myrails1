class MessagesController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            @elements = current_user.conversationuser.all
        end
    end

    def show
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else

        end
    end

    def createconv
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            initiate_user = current_user
            target_user = User.find(3)
            
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

        end
    end
end