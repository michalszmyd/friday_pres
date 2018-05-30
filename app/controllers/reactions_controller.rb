# frozen_literal_string: true

class ReactionsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    reaction = find_reaction(post)
    if reaction.new_record? ? reaction.save! : reaction.update!(reaction_params)
      render json: {}, status: 200
    else
      render json: { errors: reaction.errors }, status: 422
    end
  end

  private

  def find_reaction(post)
    post.reactions.find_by(user_id: current_user.id, post_id: post.id) ||
      post.reactions.new(reaction_params.merge(user_id: current_user.id))
  end

  def reaction_params
    params.require(:reaction).permit(:name)
  end
end
