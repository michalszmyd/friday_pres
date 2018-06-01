# frozen_literal_string: true

class Activity
  attr_reader :id, :user_id, :type, :description, :created_at
  attr_accessor :user

  def initialize(id:, user_id:, type:, description:, created_at:)
    @id          = id
    @user_id     = user_id
    @type        = type
    @description = description
    @created_at  = created_at
  end

  def user
    @user ||= User.find(user_id)
  end
end
