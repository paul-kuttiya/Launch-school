class PostsController < ApplicationController
  before_action :set_post, only: [:vote, :show, :edit, :update]
  before_action :require_user, except: [:index, :show]

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.js
    end
  end

  def index
    @posts = Post.all.sort_by{|x| x.votes.size}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    #if errors occurs when posted from create action
    #flash[:error] is equal to errors arrays which contains errors messages from action#create
    @post = Post.new
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:success] = "Post created!"
      redirect_to posts_path
    else
      #flash is rails way to pass primitive(String, array, hash) between action
      #assign flash[:error] to @post.errors.full_messages which contains errors array when POST
      flash[:error] = @post.errors.full_messages
      #Redirect back to form
      redirect_to new_post_path
    end
  end

  def edit; end

  def update
    #set @post to model with params[:id]
    # @post = Post.find(params[:id])

    #call update to update @post with updated attributes from the form; post_params
    #return true if success
    if @post.update(post_params)
      flash[:success] = "Post #{@post.id} updated!"
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages
      redirect_to edit_post_path
    end
  end

  private
  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def post_params
    params.require(:post).permit!
  end
end