class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, :post_id, :body, presence: true

  def as_json(options = {})
    {
      id: id,
      body: body,
      user_email: user.email
    }
  end
end
