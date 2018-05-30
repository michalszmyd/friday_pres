# frozen_literal_string: true

class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    like = post.likes.new(user_id: current_user.id)

    if like.save
      render json: {}, status: 200
    else
      render json: { errors: like.errors }, status: 422
    end
  end

  def destroy
    like = current_user.likes.find_by(post_id: params[:post_id])
    if like.destroy
      render json: {}, status: 200
    else
      render json: { errors: like.errors }, status: 422
    end
  end
end
