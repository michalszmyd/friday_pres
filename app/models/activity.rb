# frozen_literal_string: true

class Activity
  attr_accessor :id, :user_id, :type, :description, :created_at, :user

  def initialize(id:, user_id:, type:, description:, created_at:, user: nil)
    @id          = id
    @user_id     = user_id
    @type        = type
    @description = description
    @created_at  = created_at
    @user        = user
  end

  def user
    @user ? @user : User.find(user_id)
  end
end
