class ConversationsController < ApplicationController
    def index
        redirect_login

        name_key = "%#{params[:name]}%"
  
        name_exists = !params[:name].blank?
  
        if name_exists
            conversations_scope = current_user.conversations.where("uid LIKE ?", name_key).all
        else
            conversations_scope = current_user.conversations.all
        end
  
        @search_name_value = params[:name]

        @pagy, @categories = pagy(conversations_scope.order(created_at: :desc), items: 10)
        @count = @categories.count
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
