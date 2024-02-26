class Post < ApplicationRecord
  belongs_to :user
  has_many :posts_category, dependent: :destroy
  has_many :categories, through: :posts_category
end
