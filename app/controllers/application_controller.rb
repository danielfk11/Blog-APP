class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery with: :exception
  
    protected
  
    def after_sign_in_path_for(resource)
      root_path
    end
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number])
      devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number])
    end
  end
  