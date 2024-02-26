class ConversationsController < ApplicationController
    def index
        redirect_login

        @user = current_user
        @elements = current_user.conversations.includes(:messages).order("messages.created_at desc")
    end

    def read
        redirect_login

        @contacts = current_user.friends
        @conversation = Conversation.find(params[:id]) or not_found

        if @conversation.users.map(&:id).include? current_user.id
            @pagy, @messages = pagy(@conversation.messages.order(created_at: :desc), items: 10)
            @users = @conversation.users
            @message = Message.new()

            render "scrollable_list" if params[:page]

            respond_to do |format|
                format.html
                format.turbo_stream
            end
        else
            redirect_to '/index/unauthorized'
        end
    end

    def create
        redirect_login

        @conversation = Conversation.new(uid: conversation_create_params[:name])
        current_conversation_users = user_params[:ids].push(current_user.id)

        current_conversation_users.each do |user|
            @conversation.users.create(user)
        end

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

    private

    def conversation_create_params
        params.require(:conversation).permit(:name)
    end

    def user_params
        params.require(:user).permit(:ids => [])
    end
end
