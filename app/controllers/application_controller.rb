class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :set_locale

  before_filter :check_rack_attack
  
  before_action :set_paper_trail_whodunnit
    
  def info_for_paper_trail
    { :ip => IpAnonymizer.mask_ip( request.remote_ip), :user_agent => request.user_agent }
  end
    

  def check_super_user_role
    check_role('super user')
  end

  def check_administrator_role
    check_role("administrator")
  end
  
  def check_editor_role
    check_role("editor")
  end

  def check_developer_role
    check_role("developer")
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit :login, :description, :email, :password, :password_confirmation
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit :login, :description, :email, :password, :password_confirmation, :current_password
    end
  end

  def default_url_options(options={})
    I18n.locale == I18n.default_locale ? {} : { :locale => I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  rescue I18n::InvalidLocale
    I18n.locale = I18n.default_locale
  end
  
  def check_role(role)
    unless user_signed_in? && @current_user.has_role?(role)
      permission_denied
    end
  end

  def permission_denied
    flash[:error] = t('application.permission_denied')
    redirect_to root_path
  end

  def check_rack_attack
    if request.env['rack.attack.delay_request'] == true
      sleep(2)
      request.env['rack.attack.delay_request'] = nil
    end
  end


end
