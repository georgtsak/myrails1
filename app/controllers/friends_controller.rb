class FriendsController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        @elements = current_user.friends
    end

    def new
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        friend_request = FriendRequest.new(user_id: current_user, friend_id: friend_request)
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

        friend_request = FriendRequest.find_request(user_id: current_user, friend_id: friend_request)

        if friend_request?
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

        friend_request = FriendRequest.find_request(user_id: current_user, friend_id: friend_request)

        if friend_request?
            render json: { error: 'Request does not exist' }, status: :not_found
        end
        
        if friend_request.update(accepted: true)
            render json: { message: 'Request accepted successfully' }, status: :ok
        else
            render json: { error: friend_request.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def list
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        @friends = current_user.friends
        render json: { message: 'Success', data: @friends }, status: :ok
    end

    def pending
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end

        @friends = current_user.friends
    end

    private

    def friend_request
        params.require(:user).permit(:id)
    end
end