class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Redireciona para o dashboard_path após o login
  def after_sign_in_path_for(resource)
    months_path # Substitua pelo path desejado (ex: projects_path, root_path)
  end
end
