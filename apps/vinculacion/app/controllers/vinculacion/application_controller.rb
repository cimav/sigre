module Vinculacion
  class ApplicationController < ActionController::Base

    before_filter :auth_required

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
      if !(request.env['PATH_INFO'].include? "descuento" or request.env['PATH_INFO'].include? "auth_outside")
        redirect_to '/login' unless authenticated?
      end
    end
    helper_method :current_user

    private
    def current_user
      @current_user ||= Usuario.find(session[:user_id]) if session[:user_id]
    end
  end
end
