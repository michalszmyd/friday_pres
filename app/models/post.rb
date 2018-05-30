class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :desc) }, inverse_of: :post
  has_many :likes, -> { order(created_at: :desc) }, inverse_of: :post

  validates :title, :description, :user_id, presence: true
end
