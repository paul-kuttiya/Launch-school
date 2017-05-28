class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id]);
    @comment = @post.comments.build(params.require(:comment).permit(:body));

    #obj to obj, id to id
    #virtual attr creator to current_user obj
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Saved comment"
      redirect_to post_path(@post)
    else
      flash[:error] = @comment.errors.full_messages
      redirect_to post_path(@post)
    end
  end
end