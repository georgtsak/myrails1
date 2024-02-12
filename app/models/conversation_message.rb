class ConversationMessage < ApplicationRecord
  has_many :message
  has_many :conversation
end
