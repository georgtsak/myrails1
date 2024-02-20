class ApplicationController < ActionController::Base
    def not_found
        raise ActionController::RoutingError.new('Not Found')
    end

    protected

    def configure_permitted_parameters
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}

         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password)}
    end
end
