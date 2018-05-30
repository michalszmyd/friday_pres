class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum name: {
    smile: 'smile',
    angry: 'angry',
    sad:   'sad'
  }

  validates :user_id, uniqueness: { scope: :post_id }
end
