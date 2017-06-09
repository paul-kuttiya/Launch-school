class TodosController < ApplicationController
  before_action :get_todo, only: [:edit, :update, :destroy, :completed]
  before_action :require_user, except: [:index]
  def index
    @todos = Todo.all.order('created_at DESC')
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    current_user.todos << @todo
    
    if @todo.save
      flash[:notice] = "Successfully added #{@todo.title}."
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def update
    if @todo.update(todo_params)
      flash[:notice] = "Successfully update #{@todo.title}."
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    Todo.destroy(@todo)

    @notice = "Successfully delete #{@todo.title}."

    respond_to do |format|
      format.html do
        flash[:notice] = @notice
        redirect_to user_path(current_user)
      end

      format.js
    end
  end

  def completed
    @todo.update(completed: !@todo.completed)

    respond_to do |format|
      format.html do
        redirect_to user_path(current_user)
      end
      
      format.js
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:title, :description, :completed_at)
  end

  def get_todo
    @todo = Todo.find(params[:id])

    if @todo.user != current_user
      redirect_to user_path(current_user)
    end
  end
end
