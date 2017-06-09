class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :same_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Hi #{@user.username}!"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find(current_user)
    @todos = @user.todos
    
    if params["completed"]
      completed = true if params["completed"] == "true"
      completed = false if params["completed"] == "false"
      @todos = @todos.where(completed: completed)
    end
  end

  def clear
    @user = User.find(current_user)
    todo = @user.todos.where(completed: true)
    
    Todo.delete(todo)
    @notice = "Clear completed todos!"
    
    respond_to do |format|
      format.html do
        flash[:notice] = @notice
        redirect_to user_path(current_user)
      end

      format.js
    end
    
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end