class Message < ApplicationRecord
  has_many :user
  has_many :conversation

  validates :content, presence: true

  def edited?
    created_at != updated_at
  end

  def user_element
    User.find(self.users_id)
  end

  after_create_commit { broadcast_prepend_to conversation }
  after_update_commit { broadcast_replace_to conversation }
end