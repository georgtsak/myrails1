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

        @conversation = Conversation.build()
        @pagy, @conversations = pagy(conversations_scope.order(created_at: :desc), items: 10)
        @count = @conversations.count
    end

    def direct
        redirect_login

        name_key = "%#{params[:name]}%"
  
        name_exists = !params[:name].blank?
  
        if name_exists
            conversations_scope = current_user.conversations.direct.where("uid LIKE ?", name_key).all
        else
            conversations_scope = current_user.conversations.direct.all
        end
  
        @search_name_value = params[:name]

        @conversation = Conversation.build()
        @pagy, @conversations = pagy(conversations_scope.order(created_at: :desc), items: 10)
        @count = @conversations.count
    end

    def read
        redirect_login
        @user = current_user

        @conversation = Conversation.find(params[:id]) or not_found
        @current_user = current_user

        if @conversation.user_exists?(current_user)
            @pagy, @messages = pagy_countless(@conversation.messages.order(created_at: :desc), items: 10)
            @users = @conversation.users
            @message = Message.new()

            if params[:page]
                render partial: "scrollable_list" 
            else
                respond_to do |format|
                    format.html
                end
            end
        else
            redirect_to '/index/unauthorized'
        end
    end

    def create
        redirect_login

        @current_user = current_user
        @conversation = Conversation.build(uid: conversation_create_params[:uid])

        p conversation_create_params[:direct] == true

        if conversation_create_params[:direct]
            @conversation.direct = true
            direct_user = User.find(conversation_create_params[:users][0])
            @existing_conversation = current_user.find_direct_with(direct_user)[0]

            p direct_user

            if @existing_conversation
                redirect_to @existing_conversation
                return
            end

            @conversation.uid = "Direct messages with #{direct_user.last_name} #{direct_user.first_name}"
        end

        conversation_create_params[:users].each do |user|
            tempUser = User.find(user)
            @conversation.users << tempUser
        end
        @conversation.users << current_user

        if @conversation.save
            redirect_to @conversation
        else
            render turbo_stream: turbo_stream.replace("createconv_message", @conversation.errors.full_messages.join(', '))
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
        params.require(:conversation).permit(:uid, :direct, :users => [])
    end
end
