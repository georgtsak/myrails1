class ConversationMessage < ApplicationRecord
  belongs_to :message
  belongs_to :conversation
end
