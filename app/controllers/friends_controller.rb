class FriendsController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            first_name_key = "%#{params[:first_name]}%"
            last_name_key = "%#{params[:last_name]}%"
            email_key = "%#{params[:email]}%"

            post_scope = current_user.friends.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", first_name_key, last_name_key, email_key).all
      
            @search_first_name_value = params[:first_name]
            @search_last_name_value = params[:last_name]
            @search_email_value = params[:email]
      
            @pagy, @friends = pagy(post_scope.all.order(created_at: :desc), items: 10)
            @count = current_user.friends.all.count
        end
    end

    def new
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            friend_request = FriendRequest.new(user_id: current_user.id, friend_id: friend_request_params[:id])
            if friend_request.save
                message_object = {
                    type: 'friend',
                    subtype: 'create'
                }

                NotificationsChannel.broadcast_to("notifications:" + current_user.id.to_s, message_object)
            else
                render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
        end
    end

    def deny
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            friend_request = nil
            if FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id]).empty?
                friend_request = FriendRequest.where(user_id: friend_request_params[:id], friend_id: current_user.id)[0]
            else
                friend_request = FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id])[0]
            end

            if !friend_request
                message_object = {
                    type: 'friend',
                    subtype: 'not_exists'
                }

                NotificationsChannel.broadcast_to("notifications:" + current_user.id.to_s, message_object)
            else
                if friend_request.destroy
                    post_user = User.find(friend_request.user_id)
                    render turbo_stream: turbo_stream.remove(post_user)

                    message_object = {
                        type: 'friend',
                        subtype: 'deny'
                    }
    
                    NotificationsChannel.broadcast_to("notifications:" + current_user.id.to_s, message_object)
                else
                    render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
                end
            end
        end
    end

    def accept
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            friend_request = nil
            if FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id], accepted: true).empty?
                friend_request = FriendRequest.where(user_id: friend_request_params[:id], friend_id: current_user.id, accepted: false)[0]
            else
                friend_request = FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id], accepted: false)[0]
            end

            if !friend_request
                message_object = {
                    type: 'friend',
                    subtype: 'not_exists'
                }

                NotificationsChannel.broadcast_to("notifications:" + current_user.id.to_s, message_object)
            else
                if friend_request.update(accepted: true)
                    post_user = User.find(friend_request.user_id)
                    render turbo_stream: turbo_stream.remove(post_user)

                    message_object = {
                        type: 'friend',
                        subtype: 'accept'
                    }
    
                    NotificationsChannel.broadcast_to("notifications:" + current_user.id.to_s, message_object)
                else
                    render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
                end
            end
        end
    end

    def list
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            key = "%#{params[:search]}%"

            if params[:search]
                @friends = current_user.friends.where("email LIKE ?", key).limit(10)
            else
                @friends = current_user.friends
            end
            
            render json: { message: 'Success', data: @friends }, status: :ok
        end
    end

    def pending
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            first_name_key = "%#{params[:first_name]}%"
            last_name_key = "%#{params[:last_name]}%"
            email_key = "%#{params[:email]}%"

            post_scope = current_user.pending_received.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", first_name_key, last_name_key, email_key).all
      
            @search_first_name_value = params[:first_name]
            @search_last_name_value = params[:last_name]
            @search_email_value = params[:email]
      
            @pagy, @friends = pagy(post_scope.all.order(created_at: :desc), items: 10)
            @count = current_user.pending_received.all.count
        end
    end

    def sent
        if !user_signed_in?
            redirect_to '/users/sign_in'
        else
            first_name_key = "%#{params[:first_name]}%"
            last_name_key = "%#{params[:last_name]}%"
            email_key = "%#{params[:email]}%"

            post_scope = current_user.pending_sent.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", first_name_key, last_name_key, email_key).all
      
            @search_first_name_value = params[:first_name]
            @search_last_name_value = params[:last_name]
            @search_email_value = params[:email]
      
            @pagy, @friends = pagy(post_scope.all.order(created_at: :desc), items: 10)
            @count = current_user.pending_sent.all.count
        end
    end

    private

    def friend_request_params
        params.require(:user).permit(:id)
    end
end