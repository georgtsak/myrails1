class ConversationsController < ApplicationController
    def index
        redirect_login

        @user = current_user
        @elements = current_user.conversations.all
    end

    def read
        redirect_login

        @contacts = current_user.friends
        @conversation = Conversation.find(params[:id]) or not_found
        @messages = @conversation.messages
    end

    def create
        redirect_login

        @conversation = Conversation.new({ :uid => conversation_create_params[:name], :user_ids => user_params[:ids].push(current_user.id) })
        if @conversation.save
            render json: { message: 'Conversation created successfully' }, status: :created
        else
            render json: { error: @conversation.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def update
        redirect_login
    end

    def delete
        redirect_login
    end
end
