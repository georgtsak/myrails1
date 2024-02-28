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

    def read
        redirect_login

        @contacts = current_user.friends
        @conversation = Conversation.find(params[:id]) or not_found

        if @conversation.users.map(&:id).include? current_user.id
            @pagy, @messages = pagy_countless(@conversation.messages.order(created_at: :desc), items: 10)
            @users = @conversation.users
            @message = Message.new()

            if params[:page]
                render partial: "scrollable_list" 
            else
                respond_to do |format|
                    format.html
                    format.turbo_stream
                end
            end
        else
            redirect_to '/index/unauthorized'
        end
    end

    def create
        redirect_login

        @conversation = Conversation.build(uid: conversation_create_params[:uid])

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
        params.require(:conversation).permit(:uid, :users => [])
    end
end
