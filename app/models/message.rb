class Message < ApplicationRecord
  has_many :user
  has_many :conversation

  broadcasts_to :conversation

  validates :content, presence: true

  def edited?
    created_at != updated_at
  end
end