class ApplicationController < ActionController::Base
    def not_found
        raise ActionController::RoutingError.new('Not Found')
    end

    def redirect_login
        if !user_signed_in?
            redirect_to '/users/sign_in'
        end
    end

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password)}
    end
end
