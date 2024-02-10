class ConversationUser < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :conversation
end
