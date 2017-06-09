class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:notice] = "Please login or register"
      redirect_to login_path
    end
  end

  def same_user
    if (logged_in?)
      if params[:id].blank? || (params[:id] != current_user.id.to_s)
        flash[:notice] = "Cannot access!"
        redirect_to root_path
      end
    end
  end
end