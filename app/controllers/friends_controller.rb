class FriendsController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        @friends = current_user.friends
    end

    def new
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        friend_request = FriendRequest.new(user_id: current_user.id, friend_id: friend_request_params[:id])
        if friend_request.save
            render json: { message: 'Request created successfully' }, status: :created
        else
            render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def deny
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        friend_request = nil
        if FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id]).empty?
            friend_request = FriendRequest.where(user_id: friend_request_params[:id], friend_id: current_user.id, accepted: false)[0]
        else
            friend_request = FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id], accepted: false)[0]
        end

        if !friend_request
            render json: { error: 'Request does not exist' }, status: :not_found
        end
        
        if friend_request.destroy
            render json: { message: 'Request denied successfully' }, status: :ok
        else
            render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def accept
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        friend_request = nil
        if FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id], accepted: true).empty?
            friend_request = FriendRequest.where(user_id: friend_request_params[:id], friend_id: current_user.id, accepted: false)[0]
        else
            friend_request = FriendRequest.where(user_id: current_user.id, friend_id: friend_request_params[:id], accepted: false)[0]
        end

        if !friend_request
            render json: { error: 'Request does not exist' }, status: :not_found
        end
        
        if friend_request.update(accepted: true)
            render json: { message: 'Request denied successfully' }, status: :ok
        else
            render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def list
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        key = "%#{params[:search]}%"

        if params[:search]
            @friends = current_user.friends.where("email LIKE ?", key).limit(10)
        else
            @friends = current_user.friends
        end
        
        render json: { message: 'Success', data: @friends }, status: :ok
    end

    def pending
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        @friends = current_user.pending_received
    end

    private

    def friend_request_params
        params.require(:user).permit(:id)
    end
end