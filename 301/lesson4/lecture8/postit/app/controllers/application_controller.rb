class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :is_admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end

  def require_new_user
    if logged_in?
      flash[:error] = 'already logged in'
      redirect_to root_path
    end
  end
  
  def require_user
    unless logged_in?
      flash[:error] = "need to be user"
      redirect_to root_url
    end
  end

  def require_admin
    unless logged_in? && current_user.role == 'admin'
      access_denied
    end
  end

  def access_denied
    flash[:error] = "not allowed"
    redirect_to root_url
  end
end
