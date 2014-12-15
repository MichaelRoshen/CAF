class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :except => [:index] 

  skip_before_filter :verify_authenticity_token
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def require_user
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all { head(:unauthorized) }
      end
    end
  end

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    fname = %W(404 403 422 500).include?(status) ? status : 'unknown'
    render template: "/errors/#{fname}", format: [:html],
           handler: [:erb], status: status, layout: 'application'
  end
  
  def set_seo_meta(title = '', meta_keywords = '', meta_description = '')
    @page_title = "#{title}" if title.length > 0
    @meta_keywords = meta_keywords
    @meta_description = meta_description
  end

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
