class CommentsController < ApplicationController
  before_action :set_blog
  before_action :required_login

  def create
    @comment = @blog.comments.build(comment_params)

    if @comment.save
      flash[:notice] = "Comment added successfully."
    else
      flash[:alert] = "Failed to add comment."
    end
    redirect_to blog_path(@blog)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = "Comment deleted."
    else
      flash[:alert] = "Failed to delete comment."
    end
    redirect_to blog_path(@blog)
  end

  private

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:name, :email, :content)
  end
end
