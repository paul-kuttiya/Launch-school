class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Added category"
      redirect_to root_path
    else
      flash[:error] = @category.errors.full_messages
      redirect_to new_category_path
    end
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @posts = @category.posts
  end

  private
  def category_params
    # require {..., :category => {:name => "sports"}, ...}
    params.require(:category).permit(:name)
  end
end