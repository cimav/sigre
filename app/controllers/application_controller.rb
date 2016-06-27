class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticated?
    if session[:user_auth].blank?
      user = Usuario.where(:email => session[:user_email], :status => Usuario::STATUS_ACTIVO).first
      session[:user_auth] = user && user.email == session[:user_email]
      if session[:user_auth]
        session[:user_id] = user.id
      end
    else
      session[:user_auth]
    end
  end
  helper_method :authenticated?

  def auth_required
    redirect_to '/login' unless authenticated?
  end

  helper_method :current_user

  private
  def current_user
    @current_user ||= Usuario.find(session[:user_id]) if session[:user_id]
  end

end
