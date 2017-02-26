class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, if: :not_in_dev_mode

  def not_in_dev_mode
    # Always return true if in normal mode.
    return true

    return true unless Rails.env == 'development'
    if not user_signed_in?
      sign_in User.find_by_login('wayne.mitchell')
    end
    return false
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :username, :email, :password, :remember_me])
  end
end
