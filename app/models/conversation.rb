class Conversation < ApplicationRecord
    has_many :users, class_name: 'User'
    has_many :messages, through: ConversationMessage
    has_many :conversation, through: ConversationUser
end