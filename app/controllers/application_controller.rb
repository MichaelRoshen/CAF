class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :except => [:index] 

  skip_before_filter :verify_authenticity_token
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit :name,:login, :email, :password, :password_confirmation
      end
      devise_parameter_sanitizer.for(:sign_in) do |u|
        u.permit :name,:login, :email, :password
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit :name, :location, :territory, :position, :career, :company, :bio, :current_password,:avatar
      end
  end
end
