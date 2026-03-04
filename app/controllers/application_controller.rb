class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Redireciona para months_path após o login/sign up
  def after_sign_in_path_for(resource)
    months_path
  end

  def after_sign_up_path_for(resource)
    months_path
  end
end
