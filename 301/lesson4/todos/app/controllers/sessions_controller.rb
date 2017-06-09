class SessionsController < ApplicationController
  before_action :same_user, except: [:destroy]

  def create
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}!"
      redirect_to user_path(current_user)
    else
      flash[:notice] = "Wrong username or password!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end