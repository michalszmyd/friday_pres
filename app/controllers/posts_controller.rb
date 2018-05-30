# frozen_literal_string: true

class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path @post.id
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description)
  end
end
